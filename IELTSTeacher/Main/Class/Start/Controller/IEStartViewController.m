//
//  IEStartViewController.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/2.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IEStartViewController.h"
#import "MZTimerLabel.h"
#import "IEView.h"
#import "FDAlertView.h"
#import "IEStartTableViewCell.h"
#import "IEPracticeNameController.h"
#import "IEPraticenameViewController.h"
#import "AllModel.h"
//#import "dataTestOne.h"
//#import "dataTestTwo.h"
#import "MJExtension.h"

//下拉的展开
#import "HeadModel.h"
//#import "ScoreTableViewCell.h"
//#import "PracticeHeadView.h"
#import "StartSingleCollectionViewCell.h"
#import "StartSingleCollectionReusableView.h"

#define k_HEADViewHeight (61*AUTO_SIZE_SCALE_Y)
#define k_CellSigleHeight (82*AUTO_SIZE_SCALE_Y)


@interface IEStartViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UIView       *ctnView;
@property (nonatomic,strong) UILabel      *ceshiLabel;
@property (nonatomic,strong) UIButton     *startBtn;
@property (nonatomic,strong) UILabel      *allTiJiao;
@property (nonatomic,strong) UILabel      *difLabel;
@property (nonatomic,strong) UILabel      *oneLabel;
@property (nonatomic,strong) UITableView  *tabelView;
@property (nonatomic,strong) UIView       *contentView;
@property (nonatomic,strong) UILabel      *timeLabel;
@property (nonatomic,strong) UILabel      *TimeLabel;
@property (nonatomic,strong) MZTimerLabel *timerExample11;
@property (nonatomic,strong) UIButton     *stpBtn;
@property (nonatomic,strong) NSMutableArray *dataArry;
//@property(nonatomic,strong)UITableView *tableView1;
//开启定时器
@property (nonatomic,strong) NSTimer        *myTimer;
@property (nonatomic,strong) NSMutableArray *dataMuttableArr;
@property (nonatomic,strong) NSMutableArray *dataMuttableArrTwo;
//下拉展开按钮
@property (nonatomic,strong) NSMutableArray *headerArray; //头部视图数据
@property (nonatomic,strong) NSMutableArray *dataSource; //内容数据
//@property (nonatomic,strong) UIScrollView *bgScrollView; //个人成绩单背景滑动视图
@property (nonatomic,strong) NSIndexPath    *indexPath;  //记录当前的展开位置
@property (nonatomic,assign) BOOL           isReload; //有刷新
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation IEStartViewController
//懒加载数组
- (NSMutableArray *)dataMuttableArr
{
    if (!_dataMuttableArr) {
        _dataMuttableArr = [NSMutableArray array];
    }
    return _dataMuttableArr;
}

- (NSMutableArray *)dataMuttableArrTwo{
    if (!_dataMuttableArrTwo) {
        _dataMuttableArrTwo = [NSMutableArray array];
    }
    return _dataMuttableArrTwo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titles = @"课堂练习";
    [self _initView];
}

- (void)_initView
{
    [self.view     addSubview:self.ctnView];
    [self.view     addSubview:self.contentView];
    [self.ctnView  addSubview:self.ceshiLabel];
    [self.ctnView  addSubview:self.startBtn];
    [self.ctnView  addSubview:self.allTiJiao];
    [self.ctnView  addSubview:self.difLabel];
    [self.ctnView  addSubview:self.oneLabel];
    
    [self.contentView  addSubview:self.timeLabel];
    [self.contentView  addSubview:self.TimeLabel];
    
    WS(this_sub);
    [self.ctnView   mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+16*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_sub.view);
        make.left.mas_equalTo(this_sub.view);
        make.right.mas_equalTo(this_sub.view);
        make.height.mas_equalTo(213/3*AUTO_SIZE_SCALE_Y);
    }];
    
    [self.ceshiLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_sub.ctnView.mas_left).with.offset(25*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_sub.ctnView);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(40*AUTO_SIZE_SCALE_Y);
    }];
    
    [self.startBtn   mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(this_sub.ctnView.mas_right).with.offset(-10*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_sub.ctnView);
        make.height.mas_equalTo(40*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(380/3*AUTO_SIZE_SCALE_X);
        
    }];
    
    [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_sub.ctnView.mas_bottom);
        make.height.mas_equalTo(416/3*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(kScreenWidth);
    }];
    //时间数值
    [self.TimeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(this_sub.contentView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(100*AUTO_SIZE_SCALE_Y);
        
    }];
    //计时中
    [self.timeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_sub.ceshiLabel);
        make.top.mas_equalTo(this_sub.contentView.mas_top).with.offset(55/3*AUTO_SIZE_SCALE_Y);
        make.height.mas_equalTo(25*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(80*AUTO_SIZE_SCALE_X);
    }];
    
    if (self.isAll)
    {
        [self.view   addSubview:self.tabelView];
        //tabelView
        [self.tabelView   mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(this_sub.view);
            make.width.mas_equalTo(kScreenWidth);
            make.top.mas_equalTo(this_sub.contentView.bottom).with.offset(0);
            make.bottom.mas_equalTo(this_sub.view);
        }];
    }else
    {
        [self.view  addSubview:self.collectionView];
        [self.collectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth);
            make.centerX.mas_equalTo(this_sub.view);
            make.bottom.mas_equalTo(this_sub.view);
            make.top.mas_equalTo(this_sub.contentView.bottom).with.offset(0);
        }];
        
        [self.collectionView registerClass:[StartSingleCollectionViewCell class] forCellWithReuseIdentifier:@"StartSingleCollectionViewCell"];
        [self.collectionView registerClass:[StartSingleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionReusableView"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
}

#pragma mark--开始点击事件

- (void)startClick
{
    [self.timerExample11  start];
    self.backButton.hidden = YES;
    
    UIButton *stopBtn = [[UIButton alloc]init];
    stopBtn.frame = self.startBtn.frame;
    [stopBtn  setTitle:@"停止" forState:UIControlStateNormal];
    [stopBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stopBtn  setBackgroundImage:[UIImage  imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
    [stopBtn   setBackgroundImage:[UIImage  imageNamed:@"interation_anniu_dianji"] forState:UIControlStateHighlighted];
    stopBtn.titleLabel.font = [UIFont systemFontOfSize:18*AUTO_SIZE_SCALE_X];
    stopBtn.layer.cornerRadius = 3*AUTO_SIZE_SCALE_X;
    stopBtn.layer.masksToBounds = YES;
    self.stpBtn = stopBtn;
    [self.ctnView   addSubview:stopBtn];
    [self.startBtn removeFromSuperview];
    [self.timerExample11  start];
    [stopBtn  addTarget:self action:@selector(stopClick) forControlEvents:UIControlEventTouchUpInside];
    
    //1.网络请求向学生端发送保存的试题
    NSString *paperId = [self.paperId stringValue];
    NSString *type = @"1";
    [[Service sharedInstance]ActiveClassExerciseStartOrStopWithccId:self.ccId
                                                            paperId:paperId
                                                               type:type
                                                            success:^(NSDictionary *result) {
                                                                NDLog(@"%@",result);
                                                                if (k_IsSuccess(result)) {
//                                                                    [self.tabelView reloadData];
                                                                }else{
                                                                    if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                                        [self showHint:[result objectForKey:@"Infomation"]];
                                                                    }
                                                                }
                                                            }
                                                            failure:^(NSError *error) {
                                                                NDLog(@"%@",error);
                                                            }];
    //创建定时器
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startGetStundentAnswer) userInfo:nil repeats:YES];
    self.myTimer = myTimer;
    //2.开启定时器轮训学生的提交报告
    if ([self.paperSubmitMode isEqualToString:@"1"]) {
        [self.myTimer setFireDate:[NSDate distantPast]];
    }
}


#pragma mark--轮训
- (void)startGetStundentAnswer
{
    if (self.isAll) {
        [[Service  sharedInstance]findWholeSubmitModeStudentExamMarkWithccId:self.ccId
                                                                     paperId:[self.paperId stringValue]
                                                                     success:^(NSDictionary *result) {
                 NDLog(@"%@",result);
                 if (k_IsSuccess(result)) {
                     NSArray *data = [result objectForKey:@"Data"];
                     CHECK_DATA_IS_NSNULL(data, NSArray);
                     _dataArry = [NSMutableArray  arrayWithCapacity:data.count];
                     if (data.count > 0) {
                         for (NSDictionary *dic in data) {
                             AllModel *model = [[AllModel alloc]initWithDataDic:dic];
                             [_dataArry addObject:model];
                         }
                     }
                     [self.tabelView reloadData];
                 }
          } failure:^(NSError *error){}];
    }else if (self.isAlone){
        
        [[Service  sharedInstance]findSingleSubmitModeStudentExamMark:self.ccId
                                                              paperId:[self.paperId stringValue]
                                                              success:^(NSDictionary *result) {
            if (k_IsSuccess(result)) {
                NSArray *dataArry = [result objectForKey:@"Data"];
                [self _dealtData:dataArry];
            }
        } failure:^(NSError *error) {
            NDLog(@"%@",error);
        }];
    }
}
#pragma mark - 单题数据处理
//处理数据
- (void)_dealtData:(NSArray *)dataArray
{
    _headerArray = [[NSMutableArray alloc]initWithCapacity:dataArray.count];
    _dataSource = [[NSMutableArray alloc]initWithCapacity:dataArray.count];
    for (NSDictionary *dataDic in dataArray) {
        HeadModel *header = [[HeadModel alloc]initWithDataDic:dataDic];
        [_headerArray addObject:header];
        
        NSArray *examAnswerList = [dataDic objectForKey:@"examAnswerList"]; //考试答案
        NSMutableArray *scorceArray = [[NSMutableArray alloc]initWithCapacity:examAnswerList.count];
        for (NSDictionary *dic in examAnswerList) {
            ScorceModel *model = [[ScorceModel alloc]initWithDataDic:dic];
            [scorceArray addObject:model];
        }
        [_dataSource addObject:scorceArray];
    }
    [self.collectionView reloadData];
    
}
#pragma mark - 停止答题
- (void)stopClick
{
    FDAlertView *alert = [[FDAlertView alloc]init];
    IEView *whiteView = [[IEView alloc]init];
    [whiteView.cancleBtn  addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    whiteView.frame = CGRectMake(0, 0, kScreenWidth-40*2*AUTO_SIZE_SCALE_X, kScreenHeight * 0.28);
    [whiteView.mainBtn  setTitle:@"确定" forState:UIControlStateNormal];
    [whiteView.mainBtn addTarget:self action:@selector(mainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    whiteView.titleLabel.alpha = 0;
    UILabel  * ctnLabel = [[UILabel  alloc]init];
    ctnLabel.frame = whiteView.contentLabel.frame;
    [whiteView  addSubview:ctnLabel];
    whiteView.contentLabel.alpha  =  0 ;
    [ctnLabel  setText: @"是否终止当前课堂练习?"];
    ctnLabel.font = [UIFont  systemFontOfSize:18*AUTO_SIZE_SCALE_X];
    ctnLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    ctnLabel.textAlignment  = NSTextAlignmentCenter;
    alert.contentView = whiteView;
    [alert show];
    whiteView.block = ^(BOOL isShut){
        [alert hide];
    };
}

- (void)cancleBtnClick
{
    [self.timerExample11  start];
}

//确定点击事件
- (void)mainBtnClick:(UIButton *)button
{
    [self.timerExample11  pause];
    UIButton *completeBtn = [[UIButton alloc]init];
    completeBtn.frame = self.stpBtn.frame;
    [completeBtn  setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeBtn  setBackgroundImage:[UIImage  imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
    [completeBtn   setBackgroundImage:[UIImage  imageNamed:@"interation_anniu-dianji"] forState:UIControlStateHighlighted];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:18*AUTO_SIZE_SCALE_X];
    completeBtn.layer.cornerRadius = 3*AUTO_SIZE_SCALE_X;
    completeBtn.layer.masksToBounds = YES;
    completeBtn.tag = self.Btn.tag;
    [self.ctnView   addSubview:completeBtn];
    [self.stpBtn removeFromSuperview];
    [completeBtn  addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //网络请求
    NSString *paperId = [self.paperId  stringValue];
    NSString *type = @"2";
    [[Service  sharedInstance]ActiveClassExerciseStartOrStopWithccId:self.ccId
                                                             paperId:paperId
                                                                type:type
                                                             success:^(NSDictionary *result) {
                                                                 if (k_IsSuccess(result)) {
                                                                     NDLog(@"%@",result);
                                                                 }else{
                                                                     if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                                         [self showHint:[result objectForKey:@"Infomation"]];
                                                                     }
                                                                 }
                                                             }
                                                             failure:^(NSError *error) {
                                                                 NDLog(@"%@",error);
                                                             }];
//关闭定时器
    if ([self.paperSubmitMode isEqualToString:@"2"])
    {
        [self.myTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.myTimer != nil) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}


#pragma mark--完成点击事件
- (void)completeBtnClick:(UIButton *)button
{
    if (button.tag == 0) {
        //整套提交
        IEPracticeNameController *ctr = [[IEPracticeNameController alloc]init];
        ctr.ccId = self.ccId;
        ctr.paperId = [self.paperId stringValue];
        
        [self.navigationController  pushViewController:ctr animated:YES];
    }else if (button.tag == 1){
        //单套提交
        IEPraticenameViewController *ctr = [[IEPraticenameViewController alloc]init];
        ctr.ccId = self.ccId;
        ctr.paperId = [self.paperId stringValue];
        
        [self.navigationController  pushViewController:ctr animated:YES];
    }
}

#pragma mark--tabelView的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArry  count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSNumber *num1 = [NSNumber numberWithLong:1];
        NSNumber *num2 = [NSNumber numberWithLong:2];
        IEStartTableViewCell * cell = [IEStartTableViewCell cellWithstartTabelView:tableView];
        if (self.dataArry.count > 0) {

            AllModel *model = self.dataArry[indexPath.row];
            cell.nameLabel.text = model.sName;
            cell.abCLabel.text = model.Accuracy;
            cell.answerLabel.text = self.questionString;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([model.nGender isEqualToNumber: num1])
            {
                cell.sexView.image = [UIImage  imageNamed:@"nan"];
            }else if ([model.nGender isEqualToNumber: num2])
            {
                cell.sexView.image = [UIImage  imageNamed:@"nv"];
            }
            cell.timeCode.text = model.CostTime;

            NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, model.IconUrl];
            [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
            cell.codeLabel.text = model.sCode;
        }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265/3*AUTO_SIZE_SCALE_X;
}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_headerArray.count > 0) {
        return _headerArray.count;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataSource.count > 0) {
        NSArray *dataArray = _dataSource[section];
        return dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"StartSingleCollectionViewCell";
    StartSingleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[StartSingleCollectionViewCell alloc]init];
    }
    //给cell赋值
    if (_dataSource.count > 0) {        
        NSArray  *dataArray = _dataSource[indexPath.section];
        ScorceModel *model = dataArray[indexPath.row];
//        ScorceModel *model = [[ScorceModel alloc]initWithDataDic:dic];
        cell.scorModel = model;
    }
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        StartSingleCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionReusableView" forIndexPath:indexPath];
        HeadModel *header = self.headerArray[indexPath.section];
        headerView.headerModel = header;
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
        
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, k_HEADViewHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (kScreenWidth-(40*2+30)*AUTO_SIZE_SCALE_X);
    CGFloat hight = 40*AUTO_SIZE_SCALE_Y;
    if (_dataSource.count > 0) {
        NSArray  *dataArray = _dataSource[indexPath.section];
        ScorceModel *model = dataArray[indexPath.row];
//        ScorceModel *model = [[ScorceModel alloc]initWithDataDic:dic];
        CHECK_DATA_IS_NSNULL(model.AnswerContent, NSString);
        CHECK_STRING_IS_NULL(model.AnswerContent);
        CGFloat answerContentHeight = [CommentMethod  widthForNickName:model.AnswerContent
                                                         testLablWidth:width
                                                         textLabelFont:20.0f].height;
        if (answerContentHeight > hight) {
            return CGSizeMake(width, answerContentHeight+5*AUTO_SIZE_SCALE_Y);
        }else{
            return CGSizeMake(width, hight);
        }
    }
    return CGSizeZero;
}



#pragma mark--get方法
- (UIView *)ctnView
{
    if (!_ctnView)
    {
        _ctnView = [[UIView alloc]init];
        _ctnView.backgroundColor = [UIColor whiteColor];
    }
    return _ctnView;
}
- (UIButton *)Btn
{
    if (!_Btn)
    {
        _Btn = [[UIButton alloc]init];
    }
    return _Btn;
}
- (UILabel *)ceshiLabel
{
    if (!_ceshiLabel)
    {
        _ceshiLabel = [[UILabel alloc] init];
        _ceshiLabel.font = [UIFont systemFontOfSize:18*AUTO_SIZE_SCALE_X];
        _ceshiLabel.text = self.nameText;
        _ceshiLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _ceshiLabel;
}

- (UIButton *)startBtn
{
    if (!_startBtn)
    {
        _startBtn = [[UIButton alloc]init];
        [_startBtn  setBackgroundImage:[UIImage imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
        [_startBtn  setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji"] forState:UIControlStateSelected];
        [_startBtn  setTitle:@"开始" forState:UIControlStateNormal];
        [_startBtn  addTarget:self action:@selector(startClick)             forControlEvents:UIControlEventTouchUpInside];
        _startBtn.layer.cornerRadius = 3*AUTO_SIZE_SCALE_X;
        _startBtn.titleLabel.font = [UIFont systemFontOfSize:18*AUTO_SIZE_SCALE_X];
        _startBtn.layer.masksToBounds = YES;
    }
    return _startBtn;
}
- (UITableView *)tabelView
{
    if (!_tabelView){
        _tabelView = [[UITableView  alloc]init];
        _tabelView.backgroundColor = [UIColor  whiteColor];
//        _tabelView.alpha = 0;
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.showsVerticalScrollIndicator = NO;
        _tabelView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        
    }
    return _tabelView;
}


- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView  alloc]init];
        _contentView.backgroundColor =[UIColor  clearColor];
    }
    return _contentView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [CommentMethod  createLabelWithFont:16*AUTO_SIZE_SCALE_X Text:@"计时中"];
        _timeLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _timeLabel;
}
- (UILabel *)TimeLabel
{
    if (!_TimeLabel)
    {
        _TimeLabel = [[UILabel alloc]init];
        _TimeLabel.textColor = k_PinkColor;
        _TimeLabel.textAlignment = NSTextAlignmentCenter;
        _TimeLabel.font = [UIFont   systemFontOfSize:50*AUTO_SIZE_SCALE_X];
        MZTimerLabel *timerExample11 = [[MZTimerLabel alloc] initWithLabel:_TimeLabel andTimerType: MZTimerLabelTypeStopWatch];
        [timerExample11 setCountDownTime:0];
        self.timerExample11 = timerExample11;
        
    }
    return _TimeLabel;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

@end
