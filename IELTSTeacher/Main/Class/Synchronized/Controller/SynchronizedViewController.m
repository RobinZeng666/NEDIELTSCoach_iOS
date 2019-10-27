//
//  SynchronizedViewController.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "SynchronizedViewController.h"
#import "IECollectionViewCell.h"
#import "IEContentView.h"
#import "IEView.h"
#import "FDAlertView.h"
#import "IEPracticeViewController.h"
#import "ClassRoomViewController.h"
#import "IESynchronousModel.h"
#import "IESheetModel.h"
#import "CustomAlertView.h"
#import "GroupTestViewController.h"
#import "VoteViewController.h"
#import "BaseNavgationController.h"
#import "GroupViewController.h"

@interface SynchronizedViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,GroupViewControllerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *studentLabel;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIButton *overbtn;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) IEContentView *ctnView;

@property (nonatomic, assign) int sizeNum;//是否有分组 0没有 大于0有
@property (nonatomic, copy) NSString *groupMode;//分组规则
@property (nonatomic, copy) NSString *groupCnt;//分组数
@property (nonatomic, strong) NSMutableArray *groupInfos;//分组list

@end

@implementation SynchronizedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles = self.passCode;

    [self addSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isHere) {
        //获取最新在线学员
        [self _loadGetStudentOnLine];
    }
}

- (void)addSubviews
{
    WS(this_Syn);
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.ctnView];
    [self.contentView addSubview:self.studentLabel];
    [self.contentView addSubview:self.line];
    [self.view addSubview:self.overbtn];
    [self.contentView addSubview:self.collection];

    //父容器
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_Syn.view.mas_top).with.offset(kNavHeight+11*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(this_Syn.view);
        make.right.mas_equalTo(this_Syn.view);
        make.height.mas_equalTo(1061/3*AUTO_SIZE_SCALE_Y);
    }];
    //学员列表
    [self.studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_Syn.view.mas_left).with.offset(22*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_Syn.contentView.mas_top).with.offset(7*AUTO_SIZE_SCALE_Y);
        make.height.mas_equalTo(120/3*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(240*AUTO_SIZE_SCALE_X);
    }];
    //分割线
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(this_Syn.view);
        make.centerX.mas_equalTo(this_Syn.view);
        make.height.mas_equalTo(0.5*AUTO_SIZE_SCALE_Y);
        make.top.mas_equalTo(this_Syn.studentLabel.mas_bottom).with.offset(7*AUTO_SIZE_SCALE_Y);
        
    }];
    //下课
    [self.overbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(this_Syn.view.mas_right).with.offset(-7*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_Syn.studentLabel);
        make.width.mas_equalTo(120*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_Syn.contentView.mas_top).with.offset(5*AUTO_SIZE_SCALE_Y);
        make.bottom.mas_equalTo(this_Syn.line.mas_top).with.offset(-5*AUTO_SIZE_SCALE_Y);
    }];
    self.collection.frame = CGRectMake(0, (14.5+120/3)*AUTO_SIZE_SCALE_Y, kScreenWidth, (1061/3-14.5-120/3)*AUTO_SIZE_SCALE_Y);
    [self.collection registerClass:[IECollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.ctnView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_Syn.contentView.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(this_Syn.view);
        make.centerX.mas_equalTo(this_Syn.view);
        make.bottom.mas_equalTo(this_Syn.view.mas_bottom).with.offset(-29*AUTO_SIZE_SCALE_Y);
    }];
    
    self.studentLabel.text = [NSString stringWithFormat:@"学员列表 (%@/%@)",self.onLineCount,self.totalCount];
}

//发送请求
- (void)_loadGetStudentOnLine
{
    _onlineList = [[NSMutableArray alloc] init];
    
    CHECK_DATA_IS_NSNULL(self.passCode, NSString);
    [[Service sharedInstance]TeacherOrStudentGetStudentOnLinePassCode:self.passCode
                                                               RoleId:@"2"
                                                              success:^(NSDictionary *result) {
        if (k_IsSuccess(result)) {
            NSDictionary *data = [result objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(data, NSDictionary);
            
            NSNumber *studentOnLineNum = [data objectForKey:@"studentOnLineNum"];
            CHECK_DATA_IS_NSNULL(studentOnLineNum, NSNumber);
            self.onLineCount = studentOnLineNum;
            
            NSNumber *classStudentTotalNum = [data  objectForKey:@"classStudentTotalNum"];
            CHECK_DATA_IS_NSNULL(classStudentTotalNum, NSNumber);
            self.totalCount = classStudentTotalNum;
            
            self.studentLabel.text = [NSString stringWithFormat:@"学员列表 (%@/%@)",self.onLineCount,self.totalCount];
            NSArray *studentList = [data objectForKey:@"studentList"];
            CHECK_DATA_IS_NSNULL(studentList, NSArray);
            
            if (data.count > 0) {
                for (NSDictionary *dic in studentList) {
                    IESynchronousModel *model = [[IESynchronousModel alloc]initWithDataDic:dic];
                    
                    //在线学员数组
                    NSNumber *status2 = [NSNumber  numberWithLong:1];
                    if (model.studentloginstatus == status2){
                        [_onlineList addObject:model];
                    }
                }
            }
            [self.collection  reloadData];
        }else{
        }
    } failure:^(NSError *error) {
    }];
}

//获取课堂分组信息
- (void)_initLoadActiveClassGroup
{
    CHECK_DATA_IS_NSNULL(self.activeClassId, NSString);
    CHECK_STRING_IS_NULL(self.activeClassId);
    
    NSDictionary *dic = @{@"activeClassId":self.activeClassId};
    [[Service sharedInstance]loadActiveClassGroupWithPram:dic
                                                 succcess:^(NSDictionary *result) {
        if (k_IsSuccess(result)) {
            
            NDLog(@"获取分组信息：%@", result);
            
            NSDictionary *dataDic = [result objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
            
            NSNumber *sizeStr = [dataDic objectForKey:@"size"];
            CHECK_DATA_IS_NSNULL(sizeStr, NSNumber);
            self.sizeNum = [sizeStr intValue];
            //组数
            NSNumber *groupCntStr = [dataDic objectForKey:@"groupCnt"];
            CHECK_DATA_IS_NSNULL(groupCntStr, NSNumber);
            self.groupCnt = [groupCntStr stringValue];
            //分组类型
            NSString *groupModeStr = [dataDic objectForKey:@"groupMode"];
            CHECK_STRING_IS_NULL(groupModeStr);
            self.groupMode = groupModeStr;
            
            NSArray *groupInfosArr = [dataDic objectForKey:@"groupInfos"];
            CHECK_DATA_IS_NSNULL(groupInfosArr, NSArray);
            self.groupInfos = [[NSMutableArray alloc] initWithArray:groupInfosArr];
            
            //进入分组练习
            [self _intoGroup];
        } else {
            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                [self showHint:[result objectForKey:@"Infomation"]];
            }
        }
    } failure:^(NSError *error) {
        //失败
        [self showHint:[error networkErrorInfo]];
    }];
}

#pragma mark--点击事件
//答题卡按钮点击事件
- (void)sheetClick
{
    self.isHere = NO;
    
    IEPracticeViewController *ctr = [[IEPracticeViewController alloc]init];
    ctr.ccId = self.ccId; //[self.ccId  stringValue];
    ctr.passCode = self.passCode;
    [self.navigationController pushViewController:ctr animated:YES];
}

//分组练点击
- (void)practiceClick
{
    self.isHere = NO;

//    [[CustomAlertView sharedAlertView]creatAlertView];
//    [[CustomAlertView sharedAlertView]showAlert];

//    //获取课堂分组信息
    [self _initLoadActiveClassGroup];
}

//进入分组练习
- (void)_intoGroup
{
    self.isHere = NO;

    if (self.sizeNum == 0) {
        //没有分组
        GroupTestViewController *groupTest = [[GroupTestViewController alloc] init];
        groupTest.isModalButton = YES;
        groupTest.passCode = self.passCode;
        groupTest.activeClassId = self.activeClassId;
        
        BaseNavgationController *nav = [[BaseNavgationController alloc]initWithRootViewController:groupTest];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        //显示分组信息
        GroupViewController *groupVC = [[GroupViewController alloc] init];
        groupVC.isModalButton = YES;
        groupVC.passCode = self.passCode;
        groupVC.activeClassId = self.activeClassId;
        groupVC.groupCnt = self.groupCnt;
        groupVC.delegate = self;
        if ([self.groupMode isEqualToString:@"1"]) {
            //随机分组
            groupVC.groupMode = @"随机分组";
        } else {
            //手动分组
            groupVC.groupMode = @"手动分组";
        }
        groupVC.groupInfos = self.groupInfos;
        groupVC.isGetHistotyGroup = YES;
        
        BaseNavgationController *nav = [[BaseNavgationController alloc]initWithRootViewController:groupVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}


//投票的点击
- (void)voteClick
{
    self.isHere = NO;

    VoteViewController *vote = [[VoteViewController alloc]init];
    BaseNavgationController *nav = [[BaseNavgationController alloc]initWithRootViewController:vote];
    vote.isModalButton = YES;
    vote.activeClassId = self.activeClassId;
    [self presentViewController:nav animated:YES completion:nil];
    
//    [[CustomAlertView sharedAlertView]creatAlertView];
//    [[CustomAlertView sharedAlertView]showAlert];
}

//更多点击
- (void)moreClick
{
    self.isHere = NO;

    [[CustomAlertView sharedAlertView]creatAlertView];
    [[CustomAlertView sharedAlertView]showAlert];
}

//抢答题点击
- (void)buzzerClick
{
    self.isHere = NO;

    [[CustomAlertView sharedAlertView]creatAlertView];
    [[CustomAlertView sharedAlertView]showAlert];
}

#pragma mark--下课点击事件
- (void)overClick
{
    FDAlertView *alert = [[FDAlertView alloc]init];
    IEView *whiteView = [[IEView alloc]init];
    whiteView.frame = CGRectMake(0, 0, kScreenWidth-40*2*AUTO_SIZE_SCALE_X, kScreenHeight * 0.25);
    whiteView.titleLabel.text = @"确定下课吗？";
    whiteView.contentLabel.text = @"您是否已经完成所有课上同步练习?";
    whiteView.contentLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView.mainBtn  setTitle:@"确定" forState:UIControlStateNormal];
    [whiteView.mainBtn  addTarget:self action:@selector(mainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    alert.contentView = whiteView;
    [alert show];
    whiteView.block = ^(BOOL isShut){
        [alert hide];
    };
}

- (void)mainBtnClick{
    //网络请求，停止，下课
    [[Service sharedInstance]FinishActiveClassWithpassCode:self.passCode
                                                   success:^(NSDictionary *result) {
                                                       NDLog(@"%@",result);
                                                       if (k_IsSuccess(result)) {

                                                           //下课通知
                                                           [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Name_ClassOver object:nil];
                                                           [self.navigationController  popToRootViewControllerAnimated:YES];
                                                       }else{
                                                           if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                               [self showHint:[result objectForKey:@"Infomation"]];
                                                           }
                                                       }
                                                   }
                                                   failure:^(NSError *error) {
                                                       NDLog(@"%@",error);
                                                   }];
}

#pragma mark - 重新分组
- (void)againGroupView
{
    GroupTestViewController *groupTest = [[GroupTestViewController alloc] init];
    groupTest.isModalButton = YES;
    groupTest.passCode = self.passCode;
    groupTest.activeClassId = self.activeClassId;
    
    BaseNavgationController *nav = [[BaseNavgationController alloc]initWithRootViewController:groupTest];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark--collectionview的数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.onLineCount integerValue];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    IECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IECollectionViewCell alloc]init];
    }
    //给cell赋值
    if (self.onlineList.count > 0) {
        IESynchronousModel *model = self.onlineList[indexPath.row];
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, model.iconUrl];
        [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
        
        cell.nameString = model.studentname;
    }
    
    return cell;
}

#pragma mark - set and get
//父容器
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

//学员列表
- (UILabel *)studentLabel{
    if (!_studentLabel) {
        _studentLabel = [[UILabel alloc]init];
        _studentLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _studentLabel.textAlignment = NSTextAlignmentLeft;
        _studentLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_Y];
        
    }
    return _studentLabel;
}

//分割线
- (UIImageView *)line{
    if (!_line) {
        _line = [CommentMethod createImageViewWithImageName:@""];
        _line.image = [UIImage imageNamed:@"material_huixian"];
    }
    return _line;
}

//下课按钮
- (UIButton *)overbtn{
    if (!_overbtn) {
        _overbtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(overClick) Title:@"下课"];
        [_overbtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
        [_overbtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji"] forState:UIControlStateHighlighted];
        _overbtn.layer.cornerRadius = 2*AUTO_SIZE_SCALE_X;
        _overbtn.layer.masksToBounds = YES;
    }
    return _overbtn;
}

- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (kScreenWidth-138*AUTO_SIZE_SCALE_X)/5;
        CGFloat hight =(kScreenWidth-138*AUTO_SIZE_SCALE_Y)/5/0.725;
        flowLayout.itemSize = CGSizeMake(width, hight);
        flowLayout.minimumInteritemSpacing = 10*AUTO_SIZE_SCALE_X;
        flowLayout.minimumLineSpacing = 10*AUTO_SIZE_SCALE_Y;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(20*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X);
        _collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.showsVerticalScrollIndicator = NO;
    }
    return _collection;
}

//按钮父容器
- (IEContentView *)ctnView
{
    if (!_ctnView) {
        _ctnView = [[IEContentView alloc]init];
        UIButton *btn = [[UIButton alloc]init];
        btn =(UIButton *) _ctnView.sheetButton;
        UIButton *btn1 = [[UIButton alloc]init];
        btn1 =(UIButton *) _ctnView.voteButton;
        UIButton *btn2 = [[UIButton alloc]init];
        btn2 =(UIButton *) _ctnView.practiceButton;
        UIButton *btn3 = [[UIButton alloc]init];
        btn3 =(UIButton *) _ctnView.buzzerButton;
        UIButton *btn4 = [[UIButton alloc]init];
        btn4 =(UIButton *) _ctnView.moreButton;
        
        [btn addTarget:self action:@selector(sheetClick) forControlEvents:UIControlEventTouchUpInside];
        [btn1 addTarget:self action:@selector(voteClick) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(practiceClick) forControlEvents:UIControlEventTouchUpInside];
        [btn3 addTarget:self action:@selector(buzzerClick) forControlEvents:UIControlEventTouchUpInside];
        [btn4 addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ctnView;
}

@end
