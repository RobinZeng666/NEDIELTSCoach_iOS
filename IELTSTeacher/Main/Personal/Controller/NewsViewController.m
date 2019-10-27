//
//  NewsViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "NewsModel.h"
#import "NewsDetailViewController.h"
#import "DefaultView.h"

@interface NewsViewController () <UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,NewsDetailDelegate>

@property (nonatomic, strong) DefaultView    *defaultView;//默认视图
@property (nonatomic, strong) BaseTableView  *newsTableView;
@property (nonatomic, strong) NSMutableArray *listMutableArray;

@property (nonatomic, assign) int           page;//页数
@property (nonatomic, assign) int           pageNumber;//每页中的个数
@property (nonatomic, copy)   NSString      *typeString;//状态：阅读或删除
@property (nonatomic, assign) BOOL          isRead;//是否已读

@end

@implementation NewsViewController

/**
 *  我的消息主界面设计
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"我的消息";
    _isRead = NO;
    
    //初始化视图
    [self _initView];
    
    //开始刷新
    [self.newsTableView.head beginRefreshing];
}

- (void)dealloc
{
    [self.newsTableView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - life cycle
- (void)_initView
{
    [self.view addSubview:self.defaultView];
    [self.view addSubview:self.newsTableView];
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
    self.newsTableView.delegates = self;

    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y-100*AUTO_SIZE_SCALE_Y)/2);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.newsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+12*AUTO_SIZE_SCALE_Y);
        make.left.right.bottom.mas_equalTo(@0);
    }];
}

#pragma mark - <BaseTableViewDelegate>
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _page = 1;
        _listMutableArray = [[NSMutableArray alloc] init];
    } else {
        _page++;
    }
    
    //调用我的消息接口
    NSString *pageIndex = [NSString stringWithFormat:@"%d", _page];
    NSDictionary *dic = @{@"pageIndex":pageIndex};
    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service sharedInstance]loadMessagesWithPram:dic
                                          success:^(NSDictionary *result) {
                                              if (k_IsSuccess(result)) {
                                                  NDLog(@"消息列表 result = %@",result);
                                                  
                                                  //成功
                                                  NSDictionary *dataDic = [result objectForKey:@"Data"];
                                                  CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
                                                  
                                                  NSArray *listArray = [dataDic objectForKey:@"list"];
                                                  CHECK_DATA_IS_NSNULL(listArray, NSArray);
                                                  if (listArray.count > 0) {
                                                      
                                                      NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:listArray.count];
                                                      for (NSDictionary *dic in listArray) {
                                                          NewsModel *model = [[NewsModel alloc] initWithDataDic:dic];
                                                          [tempArray addObject:model];
                                                      }
                                                      [_listMutableArray addObjectsFromArray:tempArray];
                                                  }
                                                  
                                                  if (!_listMutableArray.count > 0) {
                                                      //显示提示视图
                                                      self.defaultView.hidden = NO;
                                                      self.newsTableView.hidden = YES;
                                                  } else {
                                                      //隐藏提示视图
                                                      self.defaultView.hidden = YES;
                                                      self.newsTableView.hidden = NO;
                                                  }
                                                  
                                                  [self.newsTableView reloadData];
                                                  [refreshView endRefreshing];
                                                  
                                                  //总信息数
                                                  NSNumber *totalCount = [dataDic objectForKey:@"totalCount"];
                                                  CHECK_DATA_IS_NSNULL(totalCount, NSNumber);
                                                  if (![totalCount isKindOfClass:[NSNull  class]]) {
                                                      if ([totalCount intValue] > _listMutableArray.count) {
                                                          [self.newsTableView.foot endRefreshing];
                                                      } else {
                                                          [self.newsTableView.foot finishRefreshing];
                                                      }
                                                  }
                                              } else {
                                                  //失败
                                                  if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                      [self showHint:[result objectForKey:@"Infomation"]];
                                                  }
                                                  
                                                  [refreshView endRefreshing];
                                                  //显示提示视图
                                                  self.defaultView.hidden = NO;
                                                  self.newsTableView.hidden = YES;
                                              }
                                              [self hideHud];
                                          } failure:^(NSError *error) {
                                              [self hideHud];
                                              //错误
                                              [self showHint:[error networkErrorInfo]];
                                              [refreshView endRefreshing];
                                              
                                              //显示提示视图
                                              self.defaultView.hidden = NO;
                                              self.newsTableView.hidden = YES;
                                          }];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"NewsTableViewCell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_listMutableArray.count > 0) {
        cell.model = _listMutableArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_listMutableArray.count > 0) {
        NewsModel *model = (NewsModel *)[_listMutableArray objectAtIndex:indexPath.row];
        _typeString = @"read";
        
        CHECK_DATA_IS_NSNULL(model.MR_ID, NSNumber);
        _isRead = [model.MR_ID intValue];
        
        NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
        CHECK_DATA_IS_NSNULL(model.Title, NSString);
        newsDetail.titleString = model.Title;
        CHECK_DATA_IS_NSNULL(model.Body, NSString);
        newsDetail.bodyString = model.Body;
        newsDetail.MI_ID = model.MI_ID;
        newsDetail.typeString = _typeString;
        newsDetail.myIndex = indexPath.row;
        newsDetail.newsDelegate = self;
        newsDetail.isRead = _isRead;
        [self.navigationController pushViewController:newsDetail animated:YES];
        
    }
}

//可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//设置删除文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleStr = @"删除";
    return titleStr;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        if (_listMutableArray.count > 0) {
            NewsModel *model = (NewsModel *)[_listMutableArray objectAtIndex:indexPath.row];
            _typeString = @"del";
            NSDictionary *dic = @{@"messageId":model.MI_ID, @"type":_typeString};
            [self showHudInView:self.view hint:@"正在删除..."];
            [[Service sharedInstance]readOrDelMessageWithPram:dic
                                                     succcess:^(NSDictionary *result) {
                                                         [self hideHud];
                                                         //成功
                                                         if (k_IsSuccess(result)) {
                                                             
                                                             //移除单元格
                                                             [_listMutableArray removeObjectAtIndex:indexPath.row];
                                                             [self.newsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                             //刷新
                                                             [self.newsTableView reloadData];
                                                             
                                                         } else {
                                                             //失败
                                                             if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                                 [self showHint:[result objectForKey:@"Infomation"]];
                                                             }
                                                         }
                                                } failure:^(NSError *error) {
                                                    [self hideHud];
                                                    //错误
                                                    [self showHint:[error networkErrorInfo]];
                                                }];
        }
    }
}

#pragma mark - <NewsDetailDelegate>
- (void)refreshNews:(NSInteger)indexRow
{
    NewsModel *model = (NewsModel *)[_listMutableArray objectAtIndex:indexRow];
    model.MR_ID = @1;
    //刷新数据
    [self.newsTableView reloadData];
}

#pragma mark - event response
- (void)tapOneAction
{
    //开始刷新
    [self.newsTableView.head beginRefreshing];
}

#pragma mark - getters and setters
- (DefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [DefaultView new];
        _defaultView.tipTitle = @"暂无消息";
        
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction)];
        [_defaultView addGestureRecognizer:tapOne];
    }
    return _defaultView;
}

- (BaseTableView *)newsTableView
{
    if (!_newsTableView) {
        _newsTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-12*AUTO_SIZE_SCALE_Y) style:UITableViewStylePlain];
        _newsTableView.tableFooterView = [[UIView alloc] init];
        _newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _newsTableView.rowHeight = 215/3*AUTO_SIZE_SCALE_Y;
    }
    return _newsTableView;
}

@end
