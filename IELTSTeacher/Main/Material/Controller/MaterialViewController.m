//
//  MaterialViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "MaterialViewController.h"
#import "FilterViewController.h"
#import "FileTableViewCell.h"
#import "WQAdView.h"
#import "BaseTableView.h"
#import "MaterialDetailViewController.h"
#import "StudyMaterialModel.h"
#import "AdvertiseViewController.h"
#import "AdvertiseModel.h"
#import "DefaultView.h"

#define kAdvertisHeight (483/3.0f*AUTO_SIZE_SCALE_Y)

@interface MaterialViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,WQAdViewDelagate>

@property (nonatomic, strong) UIButton          *filterButton;
@property (nonatomic, strong) WQAdView          *advertiseView;
@property (nonatomic, strong) BaseTableView     *fileTableView;
@property (nonatomic, strong) DefaultView       *defaultView;//默认视图
@property (nonatomic, strong) UIImageView       *adTipView;//广告提示视图

@property (nonatomic, strong) NSMutableArray    *advertiseArray;//广告数组
@property (nonatomic, strong) NSMutableArray    *materialArray;//资料数组
@property (nonatomic, assign) int               page;//页数

@property (nonatomic, copy)   NSString          *fileType;
@property (nonatomic, copy)   NSString          *nameCode;
@property (nonatomic, copy)   NSString          *roleId;
@property (nonatomic, copy)   NSString          *uploadYear;

@end

@implementation MaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"推荐资料";
    
    [self.view addSubview:self.filterButton];
    [self.view addSubview:self.adTipView];
    [self.view addSubview:self.advertiseView];
    [self.view addSubview:self.defaultView];
    [self.view addSubview:self.fileTableView];
    
    //筛选Button
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(44);
    }];
    
    [self.adTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+3);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kAdvertisHeight));
    }];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+3+kAdvertisHeight+(kScreenHeight-kNavHeight-TAB_BAR_HEIGHT-3-kAdvertisHeight-100*AUTO_SIZE_SCALE_Y)/2);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
    }];
    
    _fileType = @"0";
    _nameCode = @"0";
    _roleId = @"0";
    _uploadYear = @"0";
    
    //初始化广告位数据
    [self _initAdvertiseData];
    //开始刷新
    [self.fileTableView.head beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //初始化广告位数据
    if (self.advertiseArray.count == 0) {
        [self _initAdvertiseData];
    }
}

//初始化广告位数据
- (void)_initAdvertiseData
{
    //教师广告位信息
    NSDictionary *dic = @{@"type":@"1001"};
    [[Service sharedInstance]loadAdvertisementsWithPram:dic
                                                success:^(NSDictionary *result) {
                                                    //成功
                                                    if (k_IsSuccess(result)) {
                                                        NDLog(@"广告位 result = %@", result);
                                                        
                                                        NSDictionary *dataDic = [result objectForKey:@"Data"];
                                                        CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
                                                        NSArray *listArray = [dataDic objectForKey:@"list"];
                                                        CHECK_DATA_IS_NSNULL(listArray, NSArray);
                                                        if (listArray.count > 0) {
                                                            _advertiseArray = [[NSMutableArray alloc] initWithCapacity:listArray.count];
                                                            NSMutableArray *pictureArray = [[NSMutableArray alloc] initWithCapacity:listArray.count];
                                                            for (NSDictionary *subDic in listArray) {
                                                                AdvertiseModel *model = [[AdvertiseModel alloc] initWithDataDic:subDic];
                                                                model.Picture = [subDic objectForKey:@"Picture"];
                                                                CHECK_DATA_IS_NSNULL(model.Picture, NSString);
                                                                CHECK_STRING_IS_NULL(model.Picture);
                                                                if ([model.Picture isEqualToString:@""]) {
                                                                    model.Picture = @"Pic_Default.png";
                                                                }
                                                                [pictureArray addObject:model.Picture];
                                                                [_advertiseArray addObject:model];
                                                            }
                                                            //广告图片数组
                                                            self.advertiseView.adDataArray = pictureArray;
                                                            if (self.advertiseView.adDataArray.count > 0) {
                                                                
                                                                //加载
                                                                [self.advertiseView loadAdDataThenStart];
                                                            }
                                                        }
                                                        self.adTipView.hidden = YES;
                                                        self.advertiseView.hidden = NO;

                                                    } else {
                                                        if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                            [self showHint:[result objectForKey:@"Infomation"]];
                                                        }
                                                        
                                                        self.advertiseView.hidden = YES;
                                                        self.adTipView.hidden = NO;
                                                    }

                                                } failure:^(NSError *error) {
                                                    //提示失败信息
                                                    [self showHint:[error networkErrorInfo]];
                                                    
                                                    self.advertiseView.hidden = YES;
                                                    self.adTipView.hidden = NO;

    }];
}

#pragma mark - <BaseTableViewDelegate>
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        //头部刷新
        _page = 1;
        _materialArray = [[NSMutableArray alloc] init];
    } else {
        _page++;
    }
    
    //提示加载
    [self showHudInView:self.view hint:@"正在加载..."];
    NSString *pageIndex = [NSString stringWithFormat:@"%ld", (long)_page];

    CHECK_STRING_IS_NULL(_fileType);
    CHECK_STRING_IS_NULL(_nameCode);
    CHECK_STRING_IS_NULL(_roleId);
    CHECK_STRING_IS_NULL(_uploadYear);
    NSDictionary *dic = @{@"fileType":_fileType,
                          @"nameCode":_nameCode,
                          @"roleId":_roleId,
                          @"uploadYear":_uploadYear,
                          @"pageIndex":pageIndex};
    
    [[Service sharedInstance]teacherMaterialsFilterWithPram:dic
                                                    success:^(NSDictionary *result) {
                                                        //成功
                                                        if (k_IsSuccess(result)) {
                                                            
                                                            NSArray *dataArray = [result objectForKey:@"Data"];
                                                            CHECK_DATA_IS_NSNULL(dataArray, NSArray);
                                                            if (dataArray.count > 0) {
                                                                
                                                                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:dataArray.count];
                                                                for (NSDictionary *dic in dataArray) {
                                                                    StudyMaterialModel *model = [[StudyMaterialModel alloc] initWithDataDic:dic];
                                                                    [tempArray addObject:model];
                                                                }
                                                                //添加最新数据
                                                                [_materialArray addObjectsFromArray:tempArray];
                                                            }
                                                            
                                                            if (!_materialArray.count > 0) {
                                                                //显示提示视图
                                                                self.defaultView.hidden = NO;
                                                                self.fileTableView.hidden = YES;
                                                            } else {
                                                                //隐藏提示视图
                                                                self.defaultView.hidden = YES;
                                                                self.fileTableView.hidden = NO;
                                                            }
                                                            
                                                            //刷新数据
                                                            [self.fileTableView reloadData];
                                                            //结束刷新
                                                            [refreshView endRefreshing];
                                                            
                                                            if (dataArray.count < 10) {
                                                                [self.fileTableView.foot finishRefreshing];
                                                            } else {
                                                                [self.fileTableView.foot endRefreshing];
                                                            }
                                                            
                                                        } else {
                                                            //结束刷新
                                                            [refreshView endRefreshing];
                                                            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                                [self showHint:[result objectForKey:@"Infomation"]];
                                                            }
                                                            //显示提示视图
                                                            self.defaultView.hidden = NO;
                                                            self.fileTableView.hidden = YES;
                                                        }
                                                        //隐藏加载
                                                        [self hideHud];
                                                        
                                                    } failure:^(NSError *error) {
                                                        //隐藏加载
                                                        [self hideHud];

                                                        //提示失败信息
                                                        [self showHint:[error networkErrorInfo]];
                                                        //结束刷新
                                                        [refreshView endRefreshing];
                                                        //显示提示视图
                                                        self.defaultView.hidden = NO;
                                                        self.fileTableView.hidden = YES;
                                                    }];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _materialArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"FileTableViewCell";
    FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[FileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_materialArray.count > 0) {
        cell.model = _materialArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_materialArray.count > 0) {
        StudyMaterialModel *model = _materialArray[indexPath.row];
        MaterialDetailViewController *material = [[MaterialDetailViewController alloc] init];
        
        CHECK_DATA_IS_NSNULL(model.mate_id, NSNumber);
        material.mid = [model.mate_id stringValue];
        
        CHECK_DATA_IS_NSNULL(model.StorePoint, NSNumber);
        material.StorePoint = [model.StorePoint stringValue];

        CHECK_DATA_IS_NSNULL(model.name, NSString);
        CHECK_STRING_IS_NULL(model.name);
        material.titleString = model.name;
        
        material.detailMutableArray = _materialArray;
        material.indexPathRow = indexPath.row;
        
        material.isStudy = YES;
        [self.navigationController pushViewController:material animated:YES];
    }
}

#pragma mark - <WQAdViewDelagate>
-(void)adView:(WQAdView *)adView didDeselectAdAtNum:(NSInteger)num
{
    AdvertiseModel *model = _advertiseArray[num];
    AdvertiseViewController *advertise = [[AdvertiseViewController alloc] init];
    CHECK_DATA_IS_NSNULL(model.Title, NSString);
    CHECK_STRING_IS_NULL(model.Title);
    if ([model.Title isEqualToString:@""]) {
        advertise.titleString = @"广告详情";
    } else {
        advertise.titleString = model.Title;
    }
    
    CHECK_DATA_IS_NSNULL(model.Link, NSString);
    CHECK_STRING_IS_NULL(model.Link);
    CHECK_DATA_IS_NSNULL(model.Content, NSString);
    CHECK_STRING_IS_NULL(model.Content);
    if (![model.Link isEqualToString:@""]) {
        advertise.Link = model.Link;
    } else {
        advertise.Content = model.Content;
    }
    [self.navigationController pushViewController:advertise animated:YES];
}

#pragma mark - <CollectDetailViewControllerDelegate>
- (void)refreshMethod
{
    //刷新
    [self.fileTableView.head beginRefreshing];
}

#pragma mark - event response
- (void)filterButtonAction:(UIButton *)button
{
    FilterViewController *filterViewCtrl = [[FilterViewController alloc] init];
    
    [filterViewCtrl returnResult:^(FilterViewController *viewController, NSString *fileType, NSString *nameCode, NSString *roleId, NSString *uploadYear, int page) {
        
        _fileType = fileType;
        _nameCode = nameCode;
        _roleId = roleId;
        _uploadYear = uploadYear,
        _page = page;
        
        //刷新视图
        [self.fileTableView reloadData];
        //开始刷新
        [self.fileTableView.head beginRefreshing];
    }];
    
    filterViewCtrl.fileType = _fileType;
    filterViewCtrl.nameCode = _nameCode;
    filterViewCtrl.roleId = _roleId;
    filterViewCtrl.uploadYear = _uploadYear;
    [self.navigationController pushViewController:filterViewCtrl animated:YES];
}

- (void)adTapAction
{
    [self _initAdvertiseData];
}

- (void)tapOneAction
{
    //开始刷新
    [self.fileTableView.head beginRefreshing];
}

#pragma mark - getters and setters
- (UIButton *)filterButton
{
    if (!_filterButton) {
        _filterButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(filterButtonAction:) Title:@"筛选"];
        [_filterButton setTitleColor:[CommentMethod colorFromHexRGB:@"818b8f"] forState:UIControlStateNormal];
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
    }
    return _filterButton;
}

- (UIImageView *)adTipView
{
    if(!_adTipView) {
        _adTipView = [CommentMethod createImageViewWithImageName:@"Pic_Default.png"];
    }
    return _adTipView;
}

- (WQAdView *)advertiseView
{
    if (!_advertiseView) {
        _advertiseView = [[WQAdView  alloc] initWithFrame:CGRectMake(0, kNavHeight+3, kScreenWidth, kAdvertisHeight)];
        _advertiseView.delegate = self;
        
        UITapGestureRecognizer *adTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTapAction)];
        [_adTipView addGestureRecognizer:adTapOne];
    }
    return _advertiseView;
}

- (BaseTableView *)fileTableView
{
    if (!_fileTableView) {
        _fileTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+3+kAdvertisHeight, kScreenWidth, kScreenHeight-kNavHeight-3-kAdvertisHeight-TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _fileTableView.delegate = self;
        _fileTableView.dataSource = self;
        _fileTableView.delegates = self;
        _fileTableView.tableFooterView = [[UIView alloc] init];
        _fileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _fileTableView.rowHeight = 232/3*AUTO_SIZE_SCALE_Y;
        _fileTableView.backgroundColor = [UIColor clearColor];
    }
    return _fileTableView;
}

- (DefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [DefaultView new];
        _defaultView.tipTitle = @"暂无资料";
        
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction)];
        [_defaultView addGestureRecognizer:tapOne];
    }
    return _defaultView;
}

@end
