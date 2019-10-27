//
//  CollectViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectTableViewCell.h"
#import "BaseTableView.h"
#import "CollectMaterialModel.h"
#import "MaterialDetailViewController.h"
#import "DefaultView.h"

@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,MaterialDetailViewControllerDelegate>

@property (nonatomic,strong) BaseTableView  *collectTableView;
@property (nonatomic,strong) DefaultView    *defaultView;//默认视图

@property (nonatomic,strong) NSMutableArray *collectMutableArray;
@property (nonatomic,assign) int            page; //收藏页数

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"我的收藏";
    
    [self.view addSubview:self.defaultView];
    [self.view addSubview:self.collectTableView];
    
    self.collectTableView.delegate = self;
    self.collectTableView.dataSource = self;
    self.collectTableView.delegates = self;
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y-100*AUTO_SIZE_SCALE_Y)/2);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
    }];
    
    //开始刷新
    [self.collectTableView.head beginRefreshing];
}

- (void)dealloc
{
    [self.collectTableView removeFromSuperview];
}

#pragma mark - <BaseTableViewDelegate>
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _page = 1;
        _collectMutableArray = [[NSMutableArray alloc] init];
    } else {
        _page++;
    }
    
    NSString *pageIndex = [NSString stringWithFormat:@"%d",_page];
    //请求数据
    NSDictionary *dic = @{@"pageIndex":pageIndex};
    //调用资料收藏接口
    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service sharedInstance]myMaterialsFavoriteListWithPram:dic
                                                     success:^(NSDictionary *result) {
        
                                                        if (k_IsSuccess(result)) {
                                                            NSArray *dataArray = [result objectForKey:@"Data"];
                                                            CHECK_DATA_IS_NSNULL(dataArray, NSArray);
                                                            if (dataArray.count > 0) {
                                                                
                                                                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:dataArray.count];
                                                                for (NSDictionary *subDic in dataArray) {
                                                                    CollectMaterialModel *model = [[CollectMaterialModel alloc] initWithDataDic:subDic];
                                                                    [tempArray addObject:model];
                                                                }
                                                                [_collectMutableArray addObjectsFromArray:tempArray];
                                                            }
                                                            
                                                            if (_collectMutableArray.count > 0) {
                                                                //隐藏提示视图
                                                                self.defaultView.hidden = YES;
                                                                self.collectTableView.hidden = NO;
                                                            } else {
                                                                //显示提示视图
                                                                self.defaultView.hidden = NO;
                                                                self.collectTableView.hidden = YES;
                                                            }
                                                            
                                                            //刷新视图
                                                            [self.collectTableView reloadData];
                                                            [refreshView endRefreshing];
                                                            
                                                            if (dataArray.count < 10) {
                                                                [self.collectTableView.foot finishRefreshing];
                                                            } else {
                                                                [self.collectTableView.foot endRefreshing];
                                                            }
                                                            
                                                        } else {
                                                            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                                [self showHint:[result objectForKey:@"Infomation"]];
                                                            }
                                                            
                                                            [refreshView endRefreshing];

                                                            //显示提示视图
                                                            self.defaultView.hidden = NO;
                                                            self.collectTableView.hidden = YES;
                                                        }
                                                         [self hideHud];
                                                    } failure:^(NSError *error) {
                                                        [self hideHud];

                                                        //显示失败信息
                                                        [self showHint:[error networkErrorInfo]];
                                                        [refreshView endRefreshing];
                                                        
                                                        //显示提示视图
                                                        self.defaultView.hidden = NO;
                                                        self.collectTableView.hidden = YES;
                                                    }];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collectMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CollectTableViewCell";
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[CollectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_collectMutableArray.count > 0) {
        cell.model = _collectMutableArray[indexPath.row];        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取数据Url
    if (_collectMutableArray.count > 0) {
        CollectMaterialModel *model = _collectMutableArray[indexPath.row];
        MaterialDetailViewController *material = [[MaterialDetailViewController alloc] init];
//        if ([model.Url isKindOfClass:[NSNull class]] || model.Url.length == 0) {
//            material.urlString = @"http://testu2.staff.xdf.cn/index.aspx?client_id=95436&response_type=code&redirect_uri=http%3A%2F%2Ftestielts2.staff.xdf.cn%2FIELTS_2%2Fcallback_login&scope=login&state=0b737221-9c4b-44f7-b886-f0c88893cc65";
//        } else {
//            
//            material.urlString = model.Url;
//        }
        
        CHECK_DATA_IS_NSNULL(model.Mate_ID, NSNumber);
        material.mid = [model.Mate_ID stringValue];

        CHECK_DATA_IS_NSNULL(model.StorePoint, NSNumber);
        material.StorePoint = [model.StorePoint stringValue];
        
        CHECK_DATA_IS_NSNULL(model.Name, NSString);
        CHECK_STRING_IS_NULL(model.Name);
        material.titleString = model.Name;
        
        material.detailMutableArray = _collectMutableArray;
        material.indexPathRow = indexPath.row;
        material.delegate = self;
        
        material.isStudy = YES;
        [self.navigationController pushViewController:material animated:YES];
    }

}

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
    //删除我的收藏
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //请求数据
        if (_collectMutableArray.count > 0) {
            CollectMaterialModel *model = [_collectMutableArray objectAtIndex:indexPath.row];
            //资料主键
            NSNumber *Mate_ID = model.Mate_ID;
            CHECK_DATA_IS_NSNULL(Mate_ID, NSNumber);
            NSDictionary *dic = @{@"mid":Mate_ID};
            //调用添加、取消收藏接口
            [[Service sharedInstance]deleteMyMaterialsFavoriteWithPram:dic succcess:^(NSDictionary *result) {
                //刷新
                [self.collectTableView.head beginRefreshing];
            } failure:^(NSError *error) {
                [self showHint:[error networkErrorInfo]];
            }];
        }
        
        [_collectMutableArray removeObjectAtIndex:indexPath.row];
        [self.collectTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self.collectTableView reloadData];
    }
}

#pragma mark - <CollectMaterialViewControllerDelegate>
- (void)MaterialRefreshMethod
{
    //开始刷新
    [self.collectTableView.head beginRefreshing];
}

#pragma mark - event response
- (void)tapOneAction
{
    //开始刷新
    [self.collectTableView.head beginRefreshing];
}
#pragma mark - getters and setters
- (DefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [DefaultView new];
        _defaultView.tipTitle = @"暂无收藏";
        
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction)];
        [_defaultView addGestureRecognizer:tapOne];
    }
    return _defaultView;
}

- (UITableView *)collectTableView
{
    if (!_collectTableView) {
        _collectTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y) style:UITableViewStylePlain];
        _collectTableView.rowHeight = 80*AUTO_SIZE_SCALE_Y;
        _collectTableView.tableFooterView = [[UIView alloc] init];
        _collectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _collectTableView;
}

@end
