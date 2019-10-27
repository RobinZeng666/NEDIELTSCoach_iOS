//
//  IEPracticeNameController.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/3.
//  Copyright (c) 2015年 xdf. All rights reserved.
//
#define k_rightColor RGBACOLOR(251, 49, 79, 1)
#define k_wrongColor RGBACOLOR(154, 154, 154, 1)
#import "IEPracticeNameController.h"
#import "RFSegmentView.h"
#import "IEPracticeViewController.h"
#import "IEPraticeTableViewCell.h"

#import "ReportTableViewCell.h"
#import "IDModel.h"
#import "AllModel.h"
//#import "DefaultView.h"

@interface IEPracticeNameController ()<UITableViewDelegate,UITableViewDataSource,RFSegmentViewDelegate>

@property (nonatomic,strong) UIScrollView * viewScroll;
@property (nonatomic,strong) RFSegmentView *segmentedControl;
@property (nonatomic,strong) UITableView *tableView0;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UIButton *btn;

@property (nonatomic, strong) NSMutableArray *agriculturalPriceArray;
@property (nonatomic,copy) NSString *QSValue;
@property (nonatomic,strong) NSMutableArray *dataArry;

@property (nonatomic,strong) IDModel *idModel;
@property (nonatomic,strong) OptionListModel *optionModel;
@property (nonatomic,strong) AccListModel *accModel;
@property (nonatomic,strong) studentChooseListModel *stuModel;
@property (nonatomic, strong) NSMutableArray *arry;

/**
 *  列表数据
 */
@property (nonatomic, strong) NSMutableArray         *exercisesData;
@property (nonatomic, strong) NSMutableArray         *transcriptData;

//@property (nonatomic,strong) DefaultView *reportDefaultView;
//@property (nonatomic,strong) DefaultView *scoreDefaultView;

@end

@implementation IEPracticeNameController
//懒加载
- (NSMutableArray *)agriculturalPriceArray{
    if (!_agriculturalPriceArray) {
        _agriculturalPriceArray = [NSMutableArray array];
    }
    return _agriculturalPriceArray;
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self   addSub];
    //请求数据
    [self  addData];
    [self  adddata1];
}

- (void)addSub
{
    [self.navView     addSubview:self.segmentedControl];
    [self.view        addSubview:self.viewScroll];
    [self.viewScroll  addSubview:self.tableView0];//图表
    [self.viewScroll  addSubview:self.tableView1];//人物
//    [self.tableView0  addSubview:self.reportDefaultView];
//    [self.tableView1  addSubview:self.scoreDefaultView];
//    
//    [self.reportDefaultView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo((kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y-100*AUTO_SIZE_SCALE_Y)/2);
//        make.left.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
//    }];
//    
//    [self.scoreDefaultView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo((kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y-100*AUTO_SIZE_SCALE_Y)/2);
//        make.left.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
//    }];
    
//    self.reportDefaultView.hidden = YES;
//    self.scoreDefaultView.hidden = YES;
}
#pragma mark--请求数据
- (void)addData
{
    NDLog(@"%@,%@",self.ccId,self.paperId);
    
    //整套提交的学生练习报告
    [[Service  sharedInstance]findWholeSubmitModeStudentExerciseReportWithccId:self.ccId
                                                                       paperId:self.paperId success:^(NSDictionary *result) {
        
        NDLog(@"%@",result);
        if (k_IsSuccess(result)) {
            NSArray *data = [result  objectForKey:@"Data"];
            if (data.count > 0) {
                for (NSDictionary *strDic in data) {
                    IDModel *idModel = [IDModel objectWithKeyValues:strDic];
                    [_agriculturalPriceArray addObject:idModel];
                }
//                self.reportDefaultView.hidden = YES;
            } else {
//                self.reportDefaultView.hidden = NO;
            }
            [self.tableView0  reloadData];
        }else{
            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                [self showHint:[result objectForKey:@"Infomation"]];
            }
//            self.reportDefaultView.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        
//        self.reportDefaultView.hidden = NO;
    }];
    
}

- (void)adddata1
{
    [self showHudInView:self.view hint:@"正在加载..."];
    
    //整套提交的(考试当中(心跳)和考试结束后显示的)学生成绩单
    [[Service  sharedInstance]findWholeSubmitModeStudentExamMarkWithccId:self.ccId
                                                                 paperId:self.paperId
                                                                 success:^(NSDictionary *result) {
                 NDLog(@"%@",result);
                 [self hideHud];
                 if (k_IsSuccess(result)) {
                     NSArray *data = [result objectForKey:@"Data"];
                     CHECK_DATA_IS_NSNULL(data, NSArray);
                     _dataArry = [NSMutableArray  arrayWithCapacity:data.count];
                     if (data.count > 0) {
                         for (NSDictionary *dic in data) {
                             AllModel *model = [[AllModel alloc]initWithDataDic:dic];
                             [_dataArry addObject:model];   
                         }
                         NDLog(@"%@",_dataArry);
//                         self.scoreDefaultView.hidden = YES;
                     } else {
//                         self.scoreDefaultView.hidden = NO;
                     }
                     [self.tableView1 reloadData];
                 }else{
//                     self.scoreDefaultView.hidden = NO;
                 }
             } failure:^(NSError *error) {
                 [self hideHud];
//                 self.scoreDefaultView.hidden = NO;
             }];
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

#pragma mark--tabelview的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==self.tableView0) {
        
        return self.agriculturalPriceArray.count;
    }else if(tableView == self.tableView1){
        
        return self.dataArry.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.tableView0) {
        static NSString *identify = @"ReportViewController";
//        ReportTableViewCell *cell = (ReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify ];
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
        IEPraticeTableViewCell *cell = [IEPraticeTableViewCell cellWithstartTabelView:tableView];
        NSNumber *num1 = [NSNumber numberWithLong:1];
        NSNumber *num2 = [NSNumber numberWithLong:2];
        if (self.dataArry.count > 0) {
            
            AllModel *model = self.dataArry[indexPath.row];
            cell.nameLabel.text = model.sName;
            cell.abCLabel.text = model.Accuracy;
            
            if ([model.nGender isEqualToNumber: num1]) {
                
                cell.sexView.image = [UIImage  imageNamed:@"nan"];
            }else if ([model.nGender isEqualToNumber: num2]){
                
                cell.sexView.image = [UIImage  imageNamed:@"nv"];
            }
            cell.timeCode.text = model.CostTime;
            
            NSNumber *TargetDateDiff  = model.TargetDateDiff;
            CHECK_DATA_IS_NSNULL(TargetDateDiff , NSNumber);
            NSInteger dateCount = [TargetDateDiff integerValue];
            if (dateCount < 0 ) {
                cell.countdown.hidden = YES;
            }else
            {
                cell.countdown.hidden = NO;
                cell.countdown.text = [NSString stringWithFormat:@"雅思考试倒计时: %@天",model.TargetDateDiff];
            }
            NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, model.IconUrl];
            [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default"]];
            cell.codeLabel.text = model.sCode;
            
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
    if (tableView == self.tableView0)
    {
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
        
        return 268/3*AUTO_SIZE_SCALE_Y;
    }
    return 0;
}


#pragma mark--get方法
- (RFSegmentView *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[RFSegmentView alloc]initWithFrame:CGRectMake(75,20+(44-33)/2, kScreenWidth-150, 33)  items:@[@"练习报告",@"成绩单"]];
        _segmentedControl.tintColor = k_PinkColor;
        _segmentedControl.delegate = self;
    }
    return _segmentedControl;
}
- (UIScrollView *)viewScroll
{
    if (!_viewScroll) {
        _viewScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight+5*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-5*AUTO_SIZE_SCALE_Y)];
        _viewScroll.contentSize = CGSizeMake(kScreenWidth, 0);
        _viewScroll.showsHorizontalScrollIndicator = NO;
        _viewScroll.backgroundColor = [UIColor clearColor];
        _viewScroll.delegate = self;
        _viewScroll.pagingEnabled = YES;
    }
    return _viewScroll;
}

- (UITableView *)tableView0
{
    if (!_tableView0) {
        _tableView0 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-67-10*AUTO_SIZE_SCALE_X)];
        _tableView0.backgroundColor = [UIColor clearColor];
        _tableView0.dataSource = self;
        _tableView0.delegate = self;
        _tableView0.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView0.showsVerticalScrollIndicator = NO;
    }
    return _tableView0;
}

- (UITableView *)tableView1
{
    if (!_tableView1) {
        _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 10*AUTO_SIZE_SCALE_Y, self.view.frame.size.width, self.view.frame.size.height-64-10*AUTO_SIZE_SCALE_Y)];
        _tableView1.backgroundColor = [UIColor clearColor];
        _tableView1.dataSource = self;
        _tableView1.delegate = self;
        _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView1.showsVerticalScrollIndicator = NO;
        
    }
    return _tableView1;
}

//- (DefaultView *)reportDefaultView
//{
//    if (!_reportDefaultView) {
//        _reportDefaultView = [DefaultView new];
//        _reportDefaultView.tipTitle = @"暂无练习报告";
//    }
//    return _reportDefaultView;
//}
//
//- (DefaultView *)scoreDefaultView
//{
//    if (!_scoreDefaultView) {
//        _scoreDefaultView = [DefaultView new];
//        _scoreDefaultView.tipTitle = @"暂无成绩单";
//    }
//    return _scoreDefaultView;
//}

@end
