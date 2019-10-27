//
//  ReportViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportTableViewCell.h"
#import "IDModel.h"
@interface ReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tabelView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tabelView];
    self.titles = self.titleName;
    
    [self _initData];
}

- (void)_initData
{
    [self showHudInView:self.view hint:@"正在加载..."];
    _dataArray = [[NSMutableArray alloc]init];
    [[Service sharedInstance]findWholeSubmitModeStudentExerciseReportWithccId:self.ccId
                                                                      paperId:self.paperId
                                                                      success:^(NSDictionary *result) {
         [self hideHud];
          if (k_IsSuccess(result)) {
              NSArray  *data = [result  objectForKey:@"Data"];
              if (data.count > 0) {
                  for (NSDictionary *strDic in data) {
                      IDModel *idModel = [IDModel objectWithKeyValues:strDic];
                      [_dataArray addObject:idModel];
                  }
                  [self.tabelView  reloadData];
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


#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ReportViewController";
//    ReportTableViewCell *cell = (ReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify ];
    ReportTableViewCell *cell = [[ReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (!cell) {
//    }

    if (_dataArray.count > 0) {
        IDModel *model = _dataArray[indexPath.row];
        cell.model = model;
        cell.indexRow = indexPath.row + 1;
    }
    return cell;
}

#define k_TopViewHeight (90*AUTO_SIZE_SCALE_X)
#define k_ChooseAndDisPuteHeight (213*AUTO_SIZE_SCALE_Y)
#define k_FillingHeight (120*AUTO_SIZE_SCALE_Y)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0) {
        IDModel *model = _dataArray[indexPath.row];
         CHECK_DATA_IS_NSNULL(model.QuestionType, NSNumber);
        NSInteger questionType = [model.QuestionType integerValue];
        //1选择题2是非选择题3填空题,
        if (questionType == 1 || questionType == 2) {
            return k_TopViewHeight+k_ChooseAndDisPuteHeight+10*AUTO_SIZE_SCALE_X;
        }else if (questionType == 3){
            return k_TopViewHeight+k_FillingHeight+10*AUTO_SIZE_SCALE_X;;
        }
    }
    return 0;
}


#pragma mark - set or get
- (UITableView *)tabelView
{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight+5*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kNavHeight-5*AUTO_SIZE_SCALE_X) style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.tableFooterView = [[UIView alloc]init];
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabelView.backgroundColor = [UIColor clearColor];
    }
    return _tabelView;
}



@end
