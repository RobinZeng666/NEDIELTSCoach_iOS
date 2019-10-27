//
//  IEPraticenameViewController.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//
#define k_rightColor RGBACOLOR(251, 49, 79, 1)
#define k_wrongColor RGBACOLOR(154, 154, 154, 1)

#import "IEPraticenameViewController.h"
#import "RFSegmentView.h"
#import "IEPracticeViewController.h"

//#import "MJExtension.h"
/*
 牛顿
 */
#import "ScorceModel.h"

#import "HeadModel.h"
#import "ScoreTableViewCell.h"
#import "PracticeHeadView.h"

#import "ReportTableViewCell.h"
#import "IDModel.h"

#define k_HEADViewHeight (61*AUTO_SIZE_SCALE_Y)
#define k_CellSigleHeight (40*AUTO_SIZE_SCALE_Y)
@interface IEPraticenameViewController ()<UITableViewDelegate,UITableViewDataSource,RFSegmentViewDelegate,ScoreTableViewCellDelegate>
{
    BOOL isOpen[500];
}
@property (nonatomic, strong) UIScrollView *viewScroll;
@property (nonatomic, strong) RFSegmentView *segmentedControl;
@property (nonatomic, strong) UITableView *tableView0;
@property (nonatomic, strong) UITableView *tableView1;
@property (nonatomic, strong) NSMutableArray *optionList;
@property (nonatomic, strong) NSMutableArray *studentChooseList;
@property (nonatomic, strong) NSMutableArray *accListAry;
@property (nonatomic, strong) NSMutableArray *agriculturalPriceArray;
@property (nonatomic, copy) NSString *QSValue;
/**
 *  列表数据
 */
@property (nonatomic, strong) NSMutableArray         *exercisesData;
@property (nonatomic, strong) NSMutableArray         *transcriptData;

/*
 李牛顿
 */
@property (nonatomic, strong) NSMutableArray *headerArray; //头部视图数据
@property (nonatomic, strong) NSMutableArray *dataSource; //内容数据
//@property (nonatomic, strong) UIScrollView   *bgScrollView; //个人成绩单背景滑动视图
@property (nonatomic, strong) NSIndexPath   *indexPath;  //记录当前的展开位置
//@property (nonatomic, assign) BOOL isReload; //有刷新


@end

@implementation IEPraticenameViewController
//懒加载
- (NSMutableArray *)agriculturalPriceArray{
    if (!_agriculturalPriceArray ) {
        _agriculturalPriceArray = [[NSMutableArray alloc]init];
    }
    return _agriculturalPriceArray;
}

-(void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self   addSub];
    [self  lodeData1];
    //加载tableView1的数据
    [self _initData];
}
- (void)addSub
{
    [self.navView  addSubview:self.segmentedControl];
    [self.view  addSubview:self.viewScroll];
    [self.viewScroll  addSubview:self.tableView0];//图表
    [self.viewScroll  addSubview:self.tableView1];//人物
}

- (void)_initData
{
    CHECK_STRING_IS_NULL(self.ccId);
    CHECK_STRING_IS_NULL(self.paperId);
    [[Service sharedInstance]findSingleSubmitModeStudentExamMark:self.ccId
                                                         paperId:self.paperId
                                                         success:^(NSDictionary *result) {
                                                             
             if (k_IsSuccess(result)) {
                 
                  NSArray *dataArray = [result objectForKey:@"Data"];
                 [self _dealtData:dataArray];
             }else
             {
                 if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                     [self showHint:[result objectForKey:@"Infomation"]];
                 }
             
             }
        
    } failure:^(NSError *error) {
         NDLog(@"%@",error);
        [self showHint:[error networkErrorInfo]];
    }];
    
    
}
//获取数据
- (void)lodeData1
{
    CHECK_STRING_IS_NULL(self.ccId);
    CHECK_STRING_IS_NULL(self.paperId);
    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service  sharedInstance]findSingleSubmitModeStudentExerciseReport:self.ccId paperId:self.paperId success:^(NSDictionary *result) {
        
        [self hideHud];
        if (k_IsSuccess(result)) {
            
            NSArray *data = [result objectForKey:@"Data"];
            if (data.count > 0) {
                for (NSDictionary *strDic in data) {
                    IDModel *idModel = [IDModel objectWithKeyValues:strDic];
                    [_agriculturalPriceArray addObject:idModel];
                }
                [self.tableView0  reloadData];
            }
        }else{
            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                [self showHint:[result objectForKey:@"Infomation"]];
            }
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:[error networkErrorInfo]];
    }];
    
}

//处理数据
- (void)_dealtData:(NSArray *)dataArray
{
    _headerArray = [[NSMutableArray alloc]initWithCapacity:dataArray.count];
    _dataSource = [[NSMutableArray alloc]initWithCapacity:dataArray.count];
    for (NSDictionary *dataDic in dataArray) {
        HeadModel *header = [[HeadModel alloc]initWithDataDic:dataDic];
        [_headerArray addObject:header];

        NSArray *examAnswerList = [dataDic objectForKey:@"examAnswerList"]; //考试答案
        [_dataSource addObject:examAnswerList];
    }
    [self.tableView1 reloadData];
}

#pragma mark -segment代理方法
- (void)segmentViewSelectIndex:(NSInteger)index
{
    if (index == 0) {
        _viewScroll.contentOffset = CGPointMake(0, 0);
    } else if (index == 1) {
        _viewScroll.contentOffset = CGPointMake(kScreenWidth, 0);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tableView1){
        return _headerArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==self.tableView0) {
        return self.agriculturalPriceArray.count;
    }else if(tableView == self.tableView1){
        BOOL  isColse = isOpen[section];
        if (isColse) {
            //获取区的字典
            NSArray *data = _dataSource[section];
            return data.count;
        }
        return 1;
    }
    return 0;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView0) {
        static NSString *identify = @"ReportViewController";
//        ReportTableViewCell *cell = (ReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
//        if (!cell) {
//            cell = [[ReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
        
        ReportTableViewCell *cell = [[ReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_agriculturalPriceArray.count > 0) {
            IDModel *model = _agriculturalPriceArray[indexPath.row];
            cell.model = model;
            cell.indexRow = indexPath.row + 1;
        }
        return cell;
        
    }else if (tableView == self.tableView1){
        static NSString *identify = @"CollectionViewController";
        ScoreTableViewCell *cell = (ScoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[ScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        if (_dataSource.count > 0) {
            NSArray *dataArray = _dataSource[indexPath.section];
            if (dataArray.count > 0) {
                NSDictionary *dataDic = dataArray[indexPath.row];
                ScorceModel *model = [[ScorceModel alloc]initWithDataDic:dataDic];
                cell.expansionButton.tag =  indexPath.section;
                cell.scorModel = model;
                
                if (dataArray.count > 2){  //超过两个，
                    if (isOpen[indexPath.section]) {  //如果展开，按钮只显示在最后一个数据上
                        NDLog(@"expansionButton__%ld",cell.expansionButton.tag);
                        NDLog(@"expansionButton__%ld",dataArray.count - 1);
                        if (indexPath.row == dataArray.count - 1)
                        {
                            cell.expansionButton.hidden = NO;
                        }else
                        {
                            cell.expansionButton.hidden = YES;
                        }
                        cell.expansionButton.selected = YES;
                    }else  ////如果收起，按钮只显示在第一个数据上
                    {
                        if (indexPath.row == 0)
                        {
                            cell.expansionButton.hidden = NO;
                        }else
                        {
                            cell.expansionButton.hidden = YES;
                        }
                        cell.expansionButton.selected = NO;
                    }
                }else{ //其余的只做隐藏
                    cell.expansionButton.hidden = YES;
                }

            }
        }
        return cell;
    }
    return nil;
}


#define k_TopViewHeight (90*AUTO_SIZE_SCALE_X)
#define k_ChooseAndDisPuteHeight (213*AUTO_SIZE_SCALE_Y)
#define k_FillingHeight (120*AUTO_SIZE_SCALE_Y)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView0) {
        if (_agriculturalPriceArray.count > 0) {
            IDModel *model = _agriculturalPriceArray[indexPath.row];
            CHECK_DATA_IS_NSNULL(model.QuestionType, NSNumber);
            NSInteger questionType = [model.QuestionType integerValue];
            //1选择题2是非选择题3填空题,
            if (questionType == 1 || questionType == 2) {
                return k_TopViewHeight+k_ChooseAndDisPuteHeight+10*AUTO_SIZE_SCALE_X;
            }else if (questionType == 3){
                return k_TopViewHeight+k_FillingHeight+10*AUTO_SIZE_SCALE_X;;
            }
        }
    }else if (tableView == self.tableView1){
        
        NSArray *data = _dataSource[indexPath.section];
        NSDictionary *dataDic =  data[indexPath.row];
        ScorceModel *model = [[ScorceModel alloc]initWithDataDic:dataDic];
        CGFloat height =[CommentMethod widthForNickName:model.AnswerContent testLablWidth:(kScreenWidth-(40*2+30)*AUTO_SIZE_SCALE_X)/AUTO_SIZE_SCALE_X textLabelFont:20.f].height;
        if (height > k_CellSigleHeight) {
            return height+10;
        }
        return k_CellSigleHeight;
    }
    return 0;
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PracticeHeadView *view = [[PracticeHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, k_HEADViewHeight)];
    view.backgroundColor = [UIColor clearColor];
    HeadModel *header = self.headerArray[section];
    view.headerModel = header;
    
    UIView *label = [[UIView alloc]init];
    label.frame = CGRectMake(0, k_HEADViewHeight-0.5, kScreenWidth, 0.5);
    label.backgroundColor = RGBACOLOR(230, 230, 230, 1.0);
    [view addSubview:label];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView1) {
        return k_HEADViewHeight;
    }
    return 0;
}

#pragma mark - ScoreTableViewCellDelegate
- (void)filterHeaderViewMoreBtnClicked:(UIButton *)button
{
    NSUInteger section = button.tag;
    isOpen[section] = !isOpen[section];
//    [self.tableView1 reloadData];
    NSIndexSet *set2 = [NSIndexSet indexSetWithIndex:section];
    [self.tableView1 reloadSections:set2 withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark--get方法

- (RFSegmentView *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[RFSegmentView alloc]initWithFrame:CGRectMake(75*AUTO_SIZE_SCALE_X,20+(44-33*AUTO_SIZE_SCALE_X)/2, kScreenWidth-150*AUTO_SIZE_SCALE_X, 33*AUTO_SIZE_SCALE_X)  items:@[@"练习报告",@"成绩单"]];
        _segmentedControl.tintColor = k_PinkColor;
        _segmentedControl.delegate = self;
    }
    return _segmentedControl;
}
- (UIScrollView *)viewScroll{
    if (!_viewScroll) {
        _viewScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight+4, kScreenWidth, kScreenHeight-kNavHeight)];
        _viewScroll.contentSize = CGSizeMake(kScreenWidth, 0);
        _viewScroll.showsHorizontalScrollIndicator = NO;
        _viewScroll.backgroundColor = [UIColor clearColor];
        _viewScroll.delegate = self;
        _viewScroll.pagingEnabled = YES;
    }
    return _viewScroll;
}

- (UITableView *)tableView0{
    if (!_tableView0) {
        _tableView0 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-67)];
        _tableView0.backgroundColor = [UIColor  clearColor];
        _tableView0.dataSource = self;
        _tableView0.delegate = self;
        _tableView0.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView0.showsVerticalScrollIndicator = NO;
    }
    return _tableView0;
}
- (UITableView *)tableView1{
    if (!_tableView1) {
        _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-67)style:UITableViewStyleGrouped];
        _tableView1.backgroundColor = [UIColor clearColor];
        _tableView1.dataSource = self;
        _tableView1.delegate = self;
        _tableView1.rowHeight = k_CellSigleHeight;
        _tableView1.sectionFooterHeight = 0;
        _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView1.showsVerticalScrollIndicator = NO;
    }
    return _tableView1;
}

@end
