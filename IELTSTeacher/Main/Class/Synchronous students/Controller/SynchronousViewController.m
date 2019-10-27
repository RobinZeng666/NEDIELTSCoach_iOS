

//
//  SynchronousViewController.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/23.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "SynchronousViewController.h"
#import "IEButton.h"
#import "IECollectionViewCell.h"
#import "SynchronizedViewController.h"
#import "IESynchronousModel.h"
@interface SynchronousViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
//课堂暗号
@property(nonatomic,strong)UILabel *titleLabel;

//说明
@property(nonatomic,strong)UILabel *stateLabel;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UILabel *studentLabel;
@property(nonatomic,strong)UIImageView *line;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)NSTimer * myTimer;
@property(nonatomic,strong)NSMutableArray *studentList;
@property(nonatomic,strong)NSMutableArray *onlineList;
@property(nonatomic,strong)NSNumber *totalCount;
@property(nonatomic,strong)NSNumber *onLineCount;

@property (nonatomic, copy) NSString *activeClassId;


@end

@implementation SynchronousViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(_loadGetStudentOnLine) userInfo:nil repeats:YES];
    self.myTimer = myTimer;
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(classOver) name:Notification_Name_ClassOver object:nil];

    self.titles = @"同步学员";
    //初始化视图
    [self addViews];
}


//下课
//- (void)classOver
//{
//    if (self.myTimer != nil) {
//        [self.myTimer invalidate];
//        self.myTimer = nil;
//    }
//}
/**
 *  @param animated 开启定时器
 */
- (void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [self.myTimer setFireDate:[NSDate distantPast]];
}
/**
 *  关闭定时器
 *
 *  @param animated
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.myTimer setFireDate:[NSDate distantFuture]];
}

-(void)addViews
{
    WS(this_stu);
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.numLabel];
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.studentLabel];
    [self.contentView addSubview:self.line];
    [self.view addSubview:self.nextBtn];
    //标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_stu.view);
        make.top.mas_equalTo(kNavHeight+3+65/3*AUTO_SIZE_SCALE_Y);
    }];
    //暗码
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_stu.view);
        make.top.mas_equalTo(this_stu.titleLabel.mas_bottom).with.offset(60/3*AUTO_SIZE_SCALE_Y);
        make.height.mas_equalTo(158/3*AUTO_SIZE_SCALE_Y );
        make.width.mas_equalTo(1010/3*AUTO_SIZE_SCALE_X);
    }];
    //说明
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_stu.view);
        make.top.mas_equalTo(this_stu.numLabel.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(800/3*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(60/3*AUTO_SIZE_SCALE_Y);
    }];
    //父容器
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_stu.view);
        make.top.mas_equalTo(this_stu.stateLabel.mas_bottom).with.offset(80/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1199/3*AUTO_SIZE_SCALE_Y);
    }];
    //下一步
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_stu.view);
        make.bottom.mas_equalTo(this_stu.view.mas_bottom).with.offset(-90/3*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(this_stu.numLabel.mas_width);
        make.height.mas_equalTo(45*AUTO_SIZE_SCALE_Y);
    }];
    //学员列表
    [self.studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_stu.view.mas_left).with.offset(62/3*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_stu.contentView.mas_top).with.offset(10*AUTO_SIZE_SCALE_Y);
    }];
    //分割线
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(this_stu.view);
        make.bottom.mas_equalTo(this_stu.studentLabel.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_stu.view);
        make.height.mas_equalTo(0.5*AUTO_SIZE_SCALE_Y);
    }];
//collectionView
    self.collectionView.frame = CGRectMake(0, 120.5/3*AUTO_SIZE_SCALE_Y, kScreenWidth, (1199/3-120.5/3)*AUTO_SIZE_SCALE_Y);
    [self.collectionView registerClass:[IECollectionViewCell class] forCellWithReuseIdentifier:@"IECollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.contentView addSubview:self.collectionView];
}

//发送请求
- (void)_loadGetStudentOnLine
{
    _onlineList = [[NSMutableArray alloc] init];
    
    NSString *passCode = self.numLabel.text;
    CHECK_DATA_IS_NSNULL(passCode, NSString);
    [[Service sharedInstance]TeacherOrStudentGetStudentOnLinePassCode:passCode RoleId:@"2" success:^(NSDictionary *result) {
        if (k_IsSuccess(result)) {
            NSDictionary *data = [result objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(data, NSDictionary);
            NSNumber *studentOnLineNum = [data objectForKey:@"studentOnLineNum"];
            CHECK_DATA_IS_NSNULL(studentOnLineNum, NSNumber);
            self.onLineCount = studentOnLineNum;
            NSNumber *classStudentTotalNum = [data  objectForKey:@"classStudentTotalNum"];
            CHECK_DATA_IS_NSNULL(classStudentTotalNum, NSNumber);
            self.totalCount = classStudentTotalNum;
            _studentLabel.text = [NSString stringWithFormat:@"学员列表 (%@/%@)",self.onLineCount,self.totalCount];
            NSArray *studentList = [data objectForKey:@"studentList"];
            CHECK_DATA_IS_NSNULL(studentList, NSArray);
            _studentList = [[NSMutableArray  alloc]initWithCapacity:studentList.count];
            if (data.count > 0) {
                for (NSDictionary *dic in studentList) {
                    IESynchronousModel *model = [[IESynchronousModel alloc]initWithDataDic:dic];
                    [_studentList  addObject:model];
                    
                    //在线学员数组
                    NSNumber *status2 = [NSNumber  numberWithLong:1];
                    if (model.studentloginstatus == status2){
                        [_onlineList addObject:model];
                    }
                }
            }
            [self.collectionView  reloadData];
        }else{
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark--collection的数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.studentList.count ;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"IECollectionViewCell";
    IECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath ];
    if (cell==nil) {
        cell = [[IECollectionViewCell alloc]init];
    }
    
        IESynchronousModel *model = self.studentList[indexPath.row];
        NDLog(@"%@",model);
        cell.nameString = model.studentname;
        NSNumber *status1 = [NSNumber  numberWithLong:0];
        NSNumber *status2 = [NSNumber  numberWithLong:1];
        
        if (model.studentloginstatus == status1) {
            NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, model.iconUrl];
            [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
            cell.alpha = 0.5;
        }else if (model.studentloginstatus == status2){
            NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, model.iconUrl];
            [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
            cell.alpha = 1;
        
    }
    
    return cell;
}

#pragma mark--collection的代理方法
#pragma mark--点击事件
-(void)nextClick:(UIButton *)button
{
    CHECK_DATA_IS_NSNULL(self.numLabel.text, NSString);
    CHECK_STRING_IS_NULL(self.numLabel.text);
    NSDictionary *dic = @{@"passCode":self.numLabel.text};
    
    [self showHudInView:self.view hint:@"正在加载..."];
    button.enabled = NO;
    [[Service sharedInstance]getIdByPassCodeWithPram:dic
                                            succcess:^(NSDictionary *result) {
                                                [self hideHud];
                                                button.enabled = YES;
                                                if (k_IsSuccess(result)) {
                                                    //
                                                    NSDictionary *dataDic = [result objectForKey:@"Data"];
                                                    CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
                                                    
                                                    NSNumber *activeClassIdNum = [dataDic objectForKey:@"activeClassId"];
                                                    CHECK_DATA_IS_NSNULL(activeClassIdNum, NSNumber);
                                                    
                                                    self.activeClassId = [activeClassIdNum stringValue];
                                                    
                                                    //进入下一步
                                                    [self _intoNext];
                                                } else {
                                                    if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                        [self showHint:[result objectForKey:@"Infomation"]];
                                                    }
                                                }
                                            } failure:^(NSError *error) {
                                                button.enabled = YES;
                                                [self hideHud];
                                                //失败
                                                [self showHint:[error networkErrorInfo]];
                                            }];

    
}

- (void)_intoNext
{
    SynchronizedViewController *controller = [[SynchronizedViewController alloc]init];
    controller.passCode = self.numLabel.text;
    controller.ccId = self.ccId;
    controller.totalCount = self.totalCount;
    controller.onLineCount = self.onLineCount;
    controller.onlineList = self.onlineList;
    
    controller.activeClassId = self.activeClassId;
    controller.isHere = YES;
    [self.navigationController  pushViewController:controller animated:YES];
}



#pragma mark--GET方法实现
//标题内容
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [CommentMethod createLabelWithFont:17 Text:@"课堂暗号"];
        _titleLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    };
    return _titleLabel;
}
//暗码
- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]init];
        _numLabel.font = [UIFont  systemFontOfSize:28*AUTO_SIZE_SCALE_X];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.backgroundColor = RGBACOLOR(155.0, 155.0, 155.0, 1.0);
        _numLabel.layer.cornerRadius  = 2*AUTO_SIZE_SCALE_X;
        _numLabel.layer.masksToBounds = YES;
        _numLabel.textColor = [UIColor whiteColor];
    };
    return _numLabel;
}
//说明
- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [CommentMethod createLabelWithFont:14 Text:@"把这组数字发送给学员,同步到课堂"];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _stateLabel;
}
//父容器
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [CommentMethod createImageViewWithImageName:@""];
        _contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return _contentView;
}
//下一步
- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(nextClick:) Title:@"下一步"];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji"] forState:UIControlStateHighlighted];
        
    }
    return _nextBtn;
}

//学员列表
- (UILabel *)studentLabel{
    if (!_studentLabel) {
        _studentLabel = [[UILabel alloc]init];
        //        NSLog(@"%@,%@",self.onLineCount,self.totalCount);
        _studentLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        _studentLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _studentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _studentLabel;
}
//分割线
- (UIImageView *)line{
    if (!_line) {
        _line = [CommentMethod createImageViewWithImageName:@""];
        _line.backgroundColor = RGBACOLOR(200.0, 200.0, 200.0, 1.0);
    }
    return _line;
}
//collectionView
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (kScreenWidth-138*AUTO_SIZE_SCALE_X)/5;
        CGFloat hight =(kScreenWidth-138*AUTO_SIZE_SCALE_Y)/5/0.725;
        flowLayout.itemSize = CGSizeMake(width, hight);
        flowLayout.minimumInteritemSpacing = 10*AUTO_SIZE_SCALE_X;
        flowLayout.minimumLineSpacing = 10*AUTO_SIZE_SCALE_Y;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(15*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (void)dealloc
{
    if (self.myTimer != nil) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}



@end
