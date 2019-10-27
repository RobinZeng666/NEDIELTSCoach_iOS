//
//  GradeClassViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeClassViewController.h"
#import "GradeClassViewCell.h"
#import "GradeClassModel.h"
@interface GradeClassViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tabelView;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation GradeClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"学员列表";
    /**
     初始化视图
     */
    [self _initView];
    /**
     初始化数据
     */
    [self _initData];
}

- (void)_initView
{
    [self.view addSubview:self.tabelView];
}

- (void)_initData
{
    //self.classCode
    CHECK_STRING_IS_NULL(self.classCode);
    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service sharedInstance]getClassStusWithClassCode:self.classCode
                                              succcess:^(NSDictionary *result) {
      if (k_IsSuccess(result)) {
          NSDictionary *dataDic = [result objectForKey:@"Data"];
          CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
          NSArray *dataArray = [dataDic objectForKey:@"list"];
          CHECK_DATA_IS_NSNULL(dataArray, NSArray);
          if (dataArray.count > 0) {
              _dataArray = [[NSMutableArray alloc]initWithCapacity:dataArray.count];
              for (NSDictionary *dic in dataArray) {
                  GradeClassModel *classModel = [[GradeClassModel alloc]initWithDataDic:dic];
                  [_dataArray addObject:classModel];
              }
          }
          [self.tabelView reloadData];
      }else{
          if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
              [self showHint:[result objectForKey:@"Infomation"]];
          }
      }
        [self hideHud];
    } failure:^(NSError *error) {
        NSString *err = [error networkErrorInfo];
        [self showHint:err];
        [self hideHud];
    }];

}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"GradeClassViewControllerCell";
    GradeClassViewCell  *cell = (GradeClassViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell  = [[GradeClassViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_dataArray.count > 0) {
        GradeClassModel *model = _dataArray[indexPath.row];
        cell.classModel = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97*AUTO_SIZE_SCALE_Y;
}

#pragma mark - set or get 
- (BaseTableView *)tabelView
{
    if (!_tabelView) {
        _tabelView  = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y) style:UITableViewStylePlain];
        _tabelView.delegate  = self;
        _tabelView.dataSource = self;
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tabelView.tableFooterView = [[UIView alloc]init];
        [_tabelView.head removeFromSuperview];
        [_tabelView.foot removeFromSuperview];
    }
    return _tabelView;
}



@end
