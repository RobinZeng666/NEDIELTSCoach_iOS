//
//  WillGroupListViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "WillGroupListViewController.h"
#import "StudentListCollectionViewCell.h"
#import "IESynchronousModel.h"
#import "SynchronizedViewController.h"
#import "ManualNoneModel.h"
#import "BaseNavgationController.h"

#define k_cellWidth (kScreenWidth-2*60/3*AUTO_SIZE_SCALE_X)
#define k_cellHeight (411/3*AUTO_SIZE_SCALE_X)

@interface WillGroupListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

/**
 *  视图
 */
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *ensureBtn;

/**
 *  数值
 */
@property (nonatomic, strong) NSMutableArray *listArray;//存储未分组学员数据
@property (nonatomic, strong) NSMutableArray *uidArray;//存储选定学员数据

@end

@implementation WillGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"待分组学员";
    
    //获取手动未分组学生
    [self _initLoadNoGroupStudents];

    [self _initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - life cycle
- (void)_initViews
{
    [self.view addSubview:self.upView];
    [self.upView addSubview:self.collectionView];
    
    [self.view addSubview:self.ensureBtn];
    
    WS(this_view);
    [self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+12*AUTO_SIZE_SCALE_X);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 1199/3*AUTO_SIZE_SCALE_Y));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 1199/3*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.collectionView registerClass:[StudentListCollectionViewCell class] forCellWithReuseIdentifier:@"StudentListCollectionViewCell"];
    
    
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_view.view);
        make.bottom.mas_equalTo(this_view.view.mas_bottom).with.offset(-117/3*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-2*26*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_Y));
    }];
}

//获取手动未分组学生
- (void)_initLoadNoGroupStudents
{
    NSDictionary *dic = @{@"groupNum":self.groupNum,
                          @"passCode":self.passCode,
                          @"activeClassId":self.activeClassId};
    
    [self showHudInView:self.view hint:@"正在加载..."];
    self.ensureBtn.enabled = NO;

    [[Service sharedInstance]loadNoGroupStudentsWithPram:dic succcess:^(NSDictionary *result) {
        
        [self hideHud];
        self.ensureBtn.enabled = YES;
        
        if (k_IsSuccess(result)) {
            NDLog(@"获取手动未分组学生：%@", result);
            NSDictionary *dataDic = [result objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
            
            NSArray *studentList = [dataDic objectForKey:@"studentList"];
            CHECK_DATA_IS_NSNULL(studentList, NSArray);
            
            if (studentList.count > 0) {
                self.listArray = [[NSMutableArray alloc] initWithCapacity:studentList.count];
                for (NSDictionary *subDic in studentList) {
                    ManualNoneModel *manualModel = [[ManualNoneModel alloc] initWithDataDic:subDic];
                    [self.listArray addObject:manualModel];
                }
            }
            [self.collectionView reloadData];

        } else {
            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                [self showHint:[result objectForKey:@"Infomation"]];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        //失败
        [self showHint:[error networkErrorInfo]];
    }];
}

//字典NSDictionary转成Json字符串
- (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//手动分组
- (void)_handDivideIntoGroups
{
    NSMutableArray *muArr = [[NSMutableArray alloc] initWithCapacity:self.uidArray.count];
    for (int i=0; i<self.uidArray.count; i++) {
        ManualNoneModel *manualModel = (ManualNoneModel *)[self.uidArray objectAtIndex:i];

        NSDictionary *subDic = @{@"UID":manualModel.uid,
                                 @"groupOrder":[NSString stringWithFormat:@"%d",i+1]};
        [muArr addObject:subDic];
    }
    
    NSArray *groups = [NSArray arrayWithArray:muArr];
    NSDictionary *groupInfos = @{@"groupNum":self.groupNum,
                                 @"groups":groups};
    //将字典转成Json字符串
    NSString *groupTemp = [self dictionaryToJson:groupInfos];

    //需要传的参数
    NSDictionary *dic = @{@"groupInfos":groupTemp,
                          @"passCode":self.passCode,
                          @"activeClassId":self.activeClassId,
                          @"groupCnt":self.groupCnt};

    [[Service sharedInstance]handDivideIntoGroupsWithPram:dic
                                                 succcess:^(NSDictionary *result) {
        if (k_IsSuccess(result)) {
            
            NDLog(@"手动分组：%@", result);
            
            NSDictionary *dataDic = [result objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
            
            NSArray *groupInfosArr = [dataDic objectForKey:@"groupInfos"];
            CHECK_DATA_IS_NSNULL(groupInfosArr, NSArray);
            
            NSDictionary *userDic = @{@"groupArray":groupInfosArr,
                                      @"indexRow":[NSString stringWithFormat:@"%d", self.indexRow]};
            NDLog(@"userDic = %@", userDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Name_GroupData object:nil userInfo:userDic];
            
            [self.navigationController popViewControllerAnimated:YES];
            
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

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StudentListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudentListCollectionViewCell" forIndexPath:indexPath ];
    if (cell==nil) {
        cell = [[StudentListCollectionViewCell alloc]initWithFrame:CGRectZero];
    }
    [cell.flagButton addTarget:self action:@selector(flagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.flagButton.tag = 600+indexPath.row;
    
    if (self.listArray.count > 0) {
        cell.manualModel = self.listArray[indexPath.row];
    }
    return cell;
}

#pragma mark - event response
- (void)flagButtonAction:(UIButton *)button
{
    NSInteger indexRow = button.tag - 600;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:indexRow inSection:0];
    StudentListCollectionViewCell *tempCell = (StudentListCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (!button.selected) {
        tempCell.imgView.layer.borderColor = k_PinkColor.CGColor;
        tempCell.nameLabel.textColor = k_PinkColor;
        [self.uidArray addObject:tempCell.manualModel];
    } else {
        tempCell.imgView.layer.borderColor = [CommentMethod colorFromHexRGB:k_Color_6].CGColor;
        tempCell.nameLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        [self.uidArray removeObject:tempCell.manualModel];
    }
    
    button.selected = !button.selected;
}

-(void)ensureBtnClick:(UIButton *)button
{
    //调用手动分组接口
    [self _handDivideIntoGroups];
}

#pragma mark - private methods
#pragma mark - getters and setters
- (UIView *)upView
{
    if (!_upView) {
        _upView = [[UIView alloc] init];
        _upView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _upView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (kScreenWidth-116*AUTO_SIZE_SCALE_X)/5;
        CGFloat hight =(kScreenWidth-116*AUTO_SIZE_SCALE_Y)/5/0.725;
        flowLayout.itemSize = CGSizeMake(width, hight);
        flowLayout.minimumInteritemSpacing = 10*AUTO_SIZE_SCALE_X;
        flowLayout.minimumLineSpacing = 10*AUTO_SIZE_SCALE_Y;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(15*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIButton *)ensureBtn{
    if (!_ensureBtn) {
        _ensureBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(ensureBtnClick:) Title:@"确认学员"];
        [_ensureBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
        [_ensureBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji"] forState:UIControlStateHighlighted];
        _ensureBtn.tag = 101;
    }
    return _ensureBtn;
}

- (NSMutableArray *)uidArray
{
    if (!_uidArray) {
        _uidArray = [[NSMutableArray alloc] init];
    }
    return _uidArray;
}

@end
