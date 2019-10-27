//
//  GradeCheckViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeCheckViewController.h"
#import "GradeCheckViewCell.h"
#import "GradeSpeakCheckViewController.h"
#import "GradeWriterCheckViewController.h"
#import "GradeCheckModel.h"
#import "GradeSpeakModelCheckController.h"


#import "DefaultView.h"

@interface GradeCheckViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>
{
    int _page;
}
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) DefaultView *defaultView;

@end

@implementation GradeCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"待批改列表";
    /*
     如果批改完成，此列表不做刷新。再次点击进入已批改的内容时，里面做控制不再做新的批改，下次进入本列表时会消失。
     */
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Notification_Name_ClassDetail object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_initData) name:Notification_Name_ClassDetail object:nil];
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
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.defaultView];
    self.defaultView.hidden = YES;
    CGFloat defauleHeight = (kScreenHeight-100*AUTO_SIZE_SCALE_Y-64)/2;
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(defauleHeight);
    }];
}

- (void)_initData
{
    [self.tableView.head beginRefreshing];
}

#pragma mark - delegate
#pragma mark - <UITabelViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78*AUTO_SIZE_SCALE_Y;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0) {
        GradeCheckModel *model =  _dataArray[indexPath.row];
        NSString *lcName =  model.lcName;
        if ([lcName isEqualToString:@"口语"]) {
            
           NSString *taskType = model.taskType;
            if ([taskType isEqualToString:@"1"]) { //模考
                GradeSpeakModelCheckController *speak = [[GradeSpeakModelCheckController alloc]init];
                speak.checkModel = model;
                [self.navigationController pushViewController:speak animated:YES];

            }else if ([taskType isEqualToString:@"2"]) //练习
            {
                GradeSpeakCheckViewController *speak = [[GradeSpeakCheckViewController alloc]init];
                speak.checkModel = model;
                [self.navigationController pushViewController:speak animated:YES];
            }
        }else if ([lcName isEqualToString:@"写作"])
        {
            GradeWriterCheckViewController *writer = [[GradeWriterCheckViewController alloc]init];
            writer.checkModel = model;
            [self.navigationController pushViewController:writer animated:YES];
        }
    }
}

#pragma mark - <UITabelViewDatasource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"GradeCheckViewControllerCell";
    GradeCheckViewCell *cell = (GradeCheckViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[GradeCheckViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_dataArray.count > 0) {
        GradeCheckModel *model =  _dataArray[indexPath.row];
        cell.checkModel = model;
        cell.serial = indexPath.row + 1;
    }
    return cell;
}

#pragma mark - <BaseTableViewDelegate>
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _dataArray = [[NSMutableArray alloc]init];
        _page = 1;
    }else
    {
        _page++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    CHECK_DATA_IS_NSNULL(self.ccId, NSString);
    CHECK_STRING_IS_NULL(self.ccId);
    [[Service sharedInstance]getCorrectListWithclassCode:self.ccId
                                               pageIndex:page
                                                succcess:^(NSDictionary *result) {
            if (k_IsSuccess(result)) {
                NSDictionary *data =  [result objectForKey:@"Data"];
                if (data.count > 0) {
                    NSNumber *count = [data objectForKey:@"count"];
                    NSArray *listArray = [data objectForKey:@"list"];
                    NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:listArray.count];
                    for (NSDictionary *dic  in listArray) {
                        GradeCheckModel *model = [[GradeCheckModel alloc]initWithDataDic:dic];
                       [dataArray addObject:model];
                    }
                    
                    [_dataArray addObjectsFromArray:dataArray];
                    
                    [refreshView endRefreshing];
                    if (_dataArray.count >= [count integerValue]) {
                        [self.tableView.foot finishRefreshing];
                    }else{
                        [self.tableView.foot endRefreshing];
                    }
                }
                
                if (_dataArray.count>0) {
                    self.tableView.hidden = NO;
                    self.defaultView.hidden = YES;
                }else
                {
                    self.tableView.hidden = YES;
                    self.defaultView.hidden = NO;
                }
                
                [self.tableView reloadData];
            }else
            {
                [result objectForKey:@"Infomation"];
                [refreshView endRefreshing];
            }
    } failure:^(NSError *error) {
        [self showHint:[error networkErrorInfo]];
        [refreshView endRefreshing];
    }];
}

#pragma mark - event response
- (void)tapOneAction
{
    //开始刷新
    [self.tableView.head beginRefreshing];
}

#pragma mark - set or get
- (BaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0,kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delegates = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (DefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [[DefaultView alloc]init];
        _defaultView.backgroundColor = [UIColor clearColor];
        _defaultView.tipTitle = @"暂无待批改";
        
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction)];
        [_defaultView addGestureRecognizer:tapOne];
    }
    return _defaultView;
}




@end
