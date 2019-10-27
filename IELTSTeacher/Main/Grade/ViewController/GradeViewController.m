//
//  GradeViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeViewController.h"
#import "RFSegmentView.h"
#import "BaseTableView.h"
#import "GradeTableViewCell.h"
#import "GradeDetailViewController.h"
#import "GradeViewModel.h"
#import "DefaultView.h"

#define  DELEAYTIME_ 0.35
@interface GradeViewController ()<RFSegmentViewDelegate,UIScrollViewDelegate,BaseTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int _inClassPage;
    int _futurePage;
    int _outClassPage;
}

@property (nonatomic, strong) UIScrollView           *bjScroll;
@property (nonatomic, strong) RFSegmentView          *segmentedControl;
@property (nonatomic, assign) NSInteger              offset;

@property (nonatomic, strong) BaseTableView          *inClassTabel;      //上课中
@property (nonatomic, strong) BaseTableView          *futureClassTabel; //未开课
@property (nonatomic, strong) BaseTableView          *outClassTabel;    //已结课

/**
 *  列表数据
 */
@property (nonatomic, strong) NSMutableArray         *inClassData;
@property (nonatomic, strong) NSMutableArray         *futureClassData;
@property (nonatomic, strong) NSMutableArray         *outClassData;

/*
 无数据视图
 */
@property (nonatomic,strong) DefaultView *defaultView1;
@property (nonatomic,strong) DefaultView *defaultView2;
@property (nonatomic,strong) DefaultView *defaultView3;


@end

@implementation GradeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @"班级";
    
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
    [self.view addSubview:self.bjScroll];
    [self.navView addSubview:self.segmentedControl];
    [self.bjScroll addSubview:self.inClassTabel];
    [self.bjScroll addSubview:self.futureClassTabel];
    [self.bjScroll addSubview:self.outClassTabel];
    
    [self.bjScroll addSubview:self.defaultView1];
    [self.bjScroll addSubview:self.defaultView2];
    [self.bjScroll addSubview:self.defaultView3];
    self.defaultView1.hidden = YES;
    self.defaultView2.hidden = YES;
    self.defaultView3.hidden = YES;
    
    CGFloat defauleHeight = (kScreenHeight-100*AUTO_SIZE_SCALE_Y-69-44)/2;
    [self.defaultView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(defauleHeight);
    }];
    
    [self.defaultView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
        make.left.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(defauleHeight);
    }];
    
    [self.defaultView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
        make.left.mas_equalTo(kScreenWidth*2);
        make.top.mas_equalTo(defauleHeight);
        
    }];
}

- (void)_initData
{
    [self showHudInView:self.view hint:@"正在加载..."];
    [self.inClassTabel.head beginRefreshing];
    [self.outClassTabel.head beginRefreshing];
    [self.futureClassTabel.head beginRefreshing];
}


#pragma mark - delegate
#pragma mark - RFSegmentViewDelegate
- (void)segmentViewSelectIndex:(NSInteger)index
{
    if (index == 0) {
        _bjScroll.contentOffset = CGPointMake(0, 0);
        if (_inClassData.count == 0) {
            [self showHudInView:self.view hint:@"正在加载..."];
            _inClassTabel.hidden = YES;
            [_inClassTabel.head beginRefreshing];
        }
    } else if (index == 1) {
        _bjScroll.contentOffset = CGPointMake(kScreenWidth, 0);
        if (_futureClassData.count == 0) {
            [self showHudInView:self.view hint:@"正在加载..."];
            _futureClassTabel.hidden = YES;
            [_futureClassTabel.head beginRefreshing];
        }
        
    } else {
        _bjScroll.contentOffset = CGPointMake(kScreenWidth*2, 0);
        if (_outClassData.count == 0 ) {
           [self showHudInView:self.view hint:@"正在加载..."];
            _outClassTabel.hidden = YES;
            [_outClassTabel.head beginRefreshing];
        }
    }
    _offset = index;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int offset = _bjScroll.contentOffset.x/_bjScroll.bounds.size.width;
    [_segmentedControl moveToIndex:offset];
    if (_offset != offset) {
        if (offset == 0 ) {
            if (_inClassData.count == 0) {
                [self showHudInView:self.view hint:@"正在加载..."];
                _inClassTabel.hidden = YES;
                [_inClassTabel.head beginRefreshing];
            }
        }else if (offset == 1){
            if (_futureClassData.count == 0) {
               [self showHudInView:self.view hint:@"正在加载..."];
                _futureClassTabel.hidden = YES;
                [_futureClassTabel.head beginRefreshing];
            }
        }else if (offset == 2){
            if (_outClassData.count == 0 ) {
                [self showHudInView:self.view hint:@"正在加载..."];
                _outClassTabel.hidden = YES;
                [_outClassTabel.head beginRefreshing];
            }
        }
        _offset = offset;
    }
}

#pragma mark - BaseTableViewDelegate
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView
{    
    UITableView *tableView = (UITableView *)[refreshView superview];
    if (tableView == self.inClassTabel) {
        
        if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
            _inClassData = [[NSMutableArray alloc]init];
            _inClassPage = 1;
        }else
        {
            _inClassPage++;
        }
        NSString *classPage = [NSString stringWithFormat:@"%d",_inClassPage];
        NSDictionary *dic = @{@"pageIndex":classPage,
                              @"type":@"0"};
        
        [[Service sharedInstance]loadClasses:dic
                                    succcess:^(NSDictionary *result) {
                                        
                if (k_IsSuccess(result)) {
                    
                    NSDictionary *dic = [result objectForKey:@"Data"];
                    CHECK_DATA_IS_NSNULL(dic, NSDictionary);
                    NSNumber *count = [dic objectForKey:@"count"];
                    CHECK_DATA_IS_NSNULL(count, NSNumber);
                    if ([count integerValue] > 0) {
                        NSArray *listCount = [dic objectForKey:@"list"];
                        NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:listCount.count];
                        if (listCount.count > 0) {
                            for (NSDictionary *dataDic in listCount) {
                                GradeViewModel *model = [[GradeViewModel alloc]initWithDataDic:dataDic];
                                [dataArray addObject:model];
                            }
                            [_inClassData addObjectsFromArray:dataArray];
                        }
                        
                        [refreshView endRefreshing];
                        if (_inClassData.count >= [count integerValue]){
                            [_inClassTabel.foot finishRefreshing];
                        }else{
                            [_inClassTabel.foot endRefreshing];
                        }
                    }else
                    {
                       [refreshView endRefreshing];
                    }
                    [self hideHud];
                    [self.inClassTabel reloadData];
                    
                    if (_inClassData.count > 0) {
                        self.defaultView1.hidden = YES;
                        self.inClassTabel.hidden = NO;
                    }else{
                        self.defaultView1.hidden = NO;
                        self.inClassTabel.hidden = YES;
                    }

                }else
                {
                    NDLog(@"获取上课中得课表失败");
                    [refreshView endRefreshing];
                    [self hideHud];
                }
            } failure:^(NSError *error) {
                NDLog(@"获取上课中的课表失败");
                [self hideHud];
                NSString *er =  [error networkErrorInfo];
                [self showHint:er];
                [refreshView endRefreshing];

            }];
    }else if (tableView == self.futureClassTabel)
    {
        if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
            _futureClassData = [[NSMutableArray alloc]init];
            _futurePage = 1;
        }else
        {
            _futurePage++;
        }
        NSString *classPage = [NSString stringWithFormat:@"%d",_futurePage];
        NSDictionary *dic = @{@"pageIndex":classPage,
                              @"type":@"1"};
        
        [[Service sharedInstance]loadClasses:dic
                                    succcess:^(NSDictionary *result) {
                if (k_IsSuccess(result)) {
                    NSDictionary *dic = [result objectForKey:@"Data"];
                    CHECK_DATA_IS_NSNULL(dic, NSDictionary);
                    NSNumber *count = [dic objectForKey:@"count"];
                    CHECK_DATA_IS_NSNULL(count, NSNumber);
                    if ([count integerValue] > 0) {
                        NSArray *listCount = [dic objectForKey:@"list"];
                        NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:listCount.count];
                        if (listCount.count > 0) {
                            for (NSDictionary *dataDic in listCount) {
                                GradeViewModel *model = [[GradeViewModel alloc]initWithDataDic:dataDic];
                                [dataArray addObject:model];
                            }
                            [_futureClassData addObjectsFromArray:dataArray];
                        }
                        
                        [refreshView endRefreshing];
                        if (_futureClassData.count >= [count integerValue]) {
                            [_futureClassTabel.foot finishRefreshing];
                        }else{
                            [_futureClassTabel.foot endRefreshing];
                        }
                    }else
                    {
                        [refreshView endRefreshing];
                    }
                    [self.futureClassTabel reloadData];
                    
                    if (_futureClassData.count > 0) {
                        self.defaultView2.hidden = YES;
                        self.futureClassTabel.hidden = NO;
                    }else{
                        self.defaultView2.hidden = NO;
                        self.futureClassTabel.hidden = YES;
                    }
                    
                }else
                {
                    NDLog(@"获取上课中得课表失败");
                    [refreshView endRefreshing];
                }
                [self hideHud];
            } failure:^(NSError *error) {
                NDLog(@"获取上课中的课表失败");
                [self hideHud];
                NSString *er =  [error networkErrorInfo];
                [self showHint:er];
                [refreshView endRefreshing];
            }];
    
    }else if (tableView == self.outClassTabel)
    {
        if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
            _outClassData = [[NSMutableArray alloc]init];
            _outClassPage = 1;
        }else
        {
            _outClassPage++;
        }
        NSString *classPage = [NSString stringWithFormat:@"%d",_outClassPage];
        NSDictionary *dic = @{@"pageIndex":classPage,
                              @"type":@"2"};
        
        [[Service sharedInstance]loadClasses:dic
                                    succcess:^(NSDictionary *result) {
                                        if (k_IsSuccess(result)) {
                                            NSDictionary *dic = [result objectForKey:@"Data"];
                                            CHECK_DATA_IS_NSNULL(dic, NSDictionary);
                                            NSNumber *count = [dic objectForKey:@"count"];
                                            CHECK_DATA_IS_NSNULL(count, NSNumber);
                                            if ([count integerValue] > 0) {
                                                NSArray *listCount = [dic objectForKey:@"list"];
                                                NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:listCount.count];
                                                if (listCount.count > 0) {
                                                    for (NSDictionary *dataDic in listCount) {
                                                        GradeViewModel *model = [[GradeViewModel alloc]initWithDataDic:dataDic];
                                                        [dataArray addObject:model];
                                                    }
                                                    [_outClassData addObjectsFromArray:dataArray];
                                                }
                                                
                                                [refreshView endRefreshing];
                                                if (_outClassData.count >= [count integerValue]) {
                                                    [_outClassTabel.foot finishRefreshing];
                                                }else{
                                                    [_outClassTabel.foot endRefreshing];
                                                }
                                            }else
                                            {
                                                [refreshView endRefreshing];
                                            }
                                            [self.outClassTabel reloadData];
                                           
                                            if (_outClassData.count > 0) {
                                                self.defaultView3.hidden = YES;
                                                self.outClassTabel.hidden = NO;
                                            }else{
                                                self.defaultView3.hidden = NO;
                                                self.outClassTabel.hidden = YES;
                                            }
                                            
                                        }else
                                        {
                                            NDLog(@"获取上课中得课表失败");
                                            [refreshView endRefreshing];
                                        }
                                        [self hideHud];
                                    } failure:^(NSError *error) {
                                        NDLog(@"获取上课中的课表失败");
                                        [refreshView endRefreshing];
                                        [self hideHud];
                                        
                                        NSString *er =  [error networkErrorInfo];
                                        [self showHint:er];
                                    }];
    }
}

//- (void)delayRefresh:(UITableView *)tabelView
//{
//    
//    if (tabelView == self.inClassTabel) {
//        [_inClassTabel.head endRefreshing];
//        [_inClassTabel.foot endRefreshing];
//        _inClassTabel.hidden = NO;
//         [self hideHud];
//    }else if(tabelView == self.futureClassTabel)
//    {
//        [_futureClassTabel.head endRefreshing];
//        [_futureClassTabel.foot endRefreshing];
//        _futureClassTabel.hidden = NO;
//        [self hideHud];
//    }else if (tabelView == self.outClassTabel)
//    {
//        [_outClassTabel.head endRefreshing];
//        [_outClassTabel.foot endRefreshing];
//         _outClassTabel.hidden = NO;
//        [self hideHud];
//    }
//}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.inClassTabel)
    {
        return _inClassData.count;
        
    }else if (tableView == self.futureClassTabel)
    {
        return _futureClassData.count;
        
    }else if (tableView == self.outClassTabel)
    {
        return _outClassData.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.inClassTabel) {
        
        static NSString *identify = @"inClassTabel";
        GradeTableViewCell *cell = (GradeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[GradeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_inClassData.count > 0) {
            cell.model = _inClassData[indexPath.row];
            cell.classNumber.textColor = k_PinkColor;
        }
        return cell;

    }else if (tableView == self.futureClassTabel)
    {
        static NSString *identify = @"futureClassTabel";
        GradeTableViewCell *cell = (GradeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[GradeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_futureClassData.count > 0) {
            cell.model = _futureClassData[indexPath.row];
            cell.classNumber.textColor = [UIColor darkGrayColor];
        }
        return cell;

        
    }else if (tableView == self.outClassTabel)
    {
        
        static NSString *identify = @"outClassTabel";
        GradeTableViewCell *cell = (GradeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[GradeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        if (_outClassData.count > 0) {
            cell.model = _outClassData[indexPath.row];
            cell.classNumber.textColor = [UIColor lightGrayColor];
        }
        return cell;
    }
    return nil;
}

#pragma mark -  UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.outClassTabel){
        
        [self showHint:@"已结课班级无法查看"];
        
    }else if(tableView == self.inClassTabel)    //已开课
    {
        if (_inClassData.count > 0) {
            GradeDetailViewController *detail = [[GradeDetailViewController alloc]init];
            GradeViewModel *model = _inClassData[indexPath.row];
            CHECK_DATA_IS_NSNULL(model.sCode, NSString);
            detail.sCode = model.sCode;
            CHECK_DATA_IS_NSNULL(model.ids, NSString);
            detail.classCode = model.ids;

            CHECK_DATA_IS_NSNULL(model.nowLessonId, NSString);
            detail.lessonId =  model.nowLessonId; //[model.nowLessonId stringValue];
            
            detail.ids = model.ids;
            CHECK_DATA_IS_NSNULL(model.sName, NSString);
            detail.classTitle = model.sName;
            
            //已开课
            detail.isFutureClass = NO;
            
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }else if (tableView == self.futureClassTabel) //未开课
    {
        if (_futureClassData.count > 0) {
            GradeDetailViewController *detail = [[GradeDetailViewController alloc]init];
            GradeViewModel *model = _futureClassData[indexPath.row];
            CHECK_DATA_IS_NSNULL(model.sCode, NSString);
            detail.sCode = model.sCode;
            
            CHECK_DATA_IS_NSNULL(model.ids, NSString);
            detail.classCode = model.ids;

            CHECK_DATA_IS_NSNULL(model.nowLessonId, NSString);
            detail.lessonId = model.nowLessonId;//[model.nowLessonId stringValue];
            
            CHECK_DATA_IS_NSNULL(model.sName, NSString);
            detail.classTitle = model.sName;
            
            detail.ids = model.ids;
            
            //未开课
            detail.isFutureClass = YES;

            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.outClassTabel){
        if (_outClassData.count > 0) {
            GradeViewModel *model =_outClassData[indexPath.row];
            CHECK_DATA_IS_NSNULL(model.sName, NSString);
            CHECK_STRING_IS_NULL(model.sName);
            CGSize  size = [CommentMethod widthForNickName:model.sName testLablWidth:200 textLabelFont:18.0f];
            if (size.height > 20*AUTO_SIZE_SCALE_Y) {
                return 277/3*AUTO_SIZE_SCALE_Y + size.height - 20*AUTO_SIZE_SCALE_Y;
            }else
            {
                return 277/3*AUTO_SIZE_SCALE_Y;
            }
        }
        
    }else if(tableView == self.inClassTabel)    //已开课
    {
        if (_inClassData.count > 0) {
            GradeViewModel *model = _inClassData[indexPath.row];
            CHECK_DATA_IS_NSNULL(model.sName, NSString);
            CGSize  size = [CommentMethod widthForNickName:model.sName testLablWidth:200 textLabelFont:18.0f];
            if (size.height > 20*AUTO_SIZE_SCALE_Y) {
                return 277/3*AUTO_SIZE_SCALE_Y + size.height - 20*AUTO_SIZE_SCALE_Y;
            }else
            {
                return 277/3*AUTO_SIZE_SCALE_Y;
            }
        }
        
    }else if (tableView == self.futureClassTabel) //未开课
    {
        if (_futureClassData.count > 0) {
            GradeViewModel *model = _futureClassData[indexPath.row];
            CHECK_DATA_IS_NSNULL(model.sName, NSString);
            CGSize  size = [CommentMethod widthForNickName:model.sName testLablWidth:200 textLabelFont:18.0f];
            if (size.height > 20*AUTO_SIZE_SCALE_Y) {
                return 277/3*AUTO_SIZE_SCALE_Y + size.height - 20*AUTO_SIZE_SCALE_Y;
            }else
            {
                return 277/3*AUTO_SIZE_SCALE_Y;
            }
        }
    }
    return 0;
}


#pragma mark - event response
- (void)tapOneAction
{
    [self.inClassTabel.head beginRefreshing];
}
- (void)tapTwoAction
{
    [self.futureClassTabel.head beginRefreshing];
}
- (void)tapThreeAction
{
    [self.outClassTabel.head beginRefreshing];
}

#pragma mark - private metaods
#pragma mark - getters and setters
- (UIScrollView *)bjScroll
{
    if (!_bjScroll) {
        _bjScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight+3, kScreenWidth, kScreenHeight-kNavHeight-3-TAB_BAR_HEIGHT)];
        _bjScroll.contentSize = CGSizeMake(kScreenWidth*3, 0);
        _bjScroll.showsHorizontalScrollIndicator = NO;
        _bjScroll.backgroundColor = [UIColor clearColor];
        _bjScroll.delegate = self;
        _bjScroll.pagingEnabled = YES;
    }
    return _bjScroll;
}
- (RFSegmentView *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[RFSegmentView alloc] initWithFrame:CGRectMake(50,20+(44-33)/2, kScreenWidth-100, 33) items:@[@"上课中",@"未开课",@"已结课"]];
        _segmentedControl.tintColor = k_PinkColor;
        _segmentedControl.delegate = self;
    }
    return _segmentedControl;
}

- (BaseTableView *)inClassTabel
{
    if (!_inClassTabel) {
        _inClassTabel= [[BaseTableView alloc]initWithFrame:CGRectMake(0, 12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-TAB_BAR_HEIGHT-12*AUTO_SIZE_SCALE_Y) style:UITableViewStylePlain];
        _inClassTabel.delegate = self;
        _inClassTabel.dataSource = self;
        _inClassTabel.delegates = self;
        _inClassTabel.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _inClassTabel.tableFooterView = [[UIView alloc]init];
        _inClassTabel.rowHeight = 277/3*AUTO_SIZE_SCALE_Y;
    }
    return _inClassTabel;
}

- (BaseTableView *)futureClassTabel
{
    if (!_futureClassTabel) {
        
        _futureClassTabel= [[BaseTableView alloc]initWithFrame:CGRectMake(kScreenWidth, 12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-TAB_BAR_HEIGHT-12*AUTO_SIZE_SCALE_Y) style:UITableViewStylePlain];
        _futureClassTabel.delegate = self;
        _futureClassTabel.dataSource = self;
        _futureClassTabel.delegates = self;
        _futureClassTabel.tableFooterView = [[UIView alloc]init];
        _futureClassTabel.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _futureClassTabel.rowHeight = 277/3*AUTO_SIZE_SCALE_Y;
    }
    return _futureClassTabel;
}

- (BaseTableView *)outClassTabel
{
    if (!_outClassTabel) {
        _outClassTabel= [[BaseTableView alloc]initWithFrame:CGRectMake(kScreenWidth*2, 12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-TAB_BAR_HEIGHT-12*AUTO_SIZE_SCALE_Y) style:UITableViewStylePlain];
        _outClassTabel.delegate = self;
        _outClassTabel.dataSource = self;
        _outClassTabel.delegates = self;
        _outClassTabel.tableFooterView = [[UIView alloc]init];
        _outClassTabel.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _outClassTabel.rowHeight = 277/3*AUTO_SIZE_SCALE_Y;
    }
    return _outClassTabel;
}

- (DefaultView *)defaultView1
{
    if (!_defaultView1) {
        _defaultView1 = [[DefaultView alloc]init];
        _defaultView1.backgroundColor = [UIColor clearColor];
        _defaultView1.tipTitle = @"暂无课程信息";
        
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction)];
        [_defaultView1 addGestureRecognizer:tapOne];
    }
    return _defaultView1;
}
- (DefaultView *)defaultView2
{
    if (!_defaultView2) {
        _defaultView2 = [[DefaultView alloc]init];
        _defaultView2.backgroundColor = [UIColor clearColor];
        _defaultView2.tipTitle = @"暂无课程信息";
        
        UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwoAction)];
        [_defaultView2 addGestureRecognizer:tapTwo];
    }
    return _defaultView2;
}

- (DefaultView *)defaultView3
{
    if (!_defaultView3) {
        _defaultView3 = [[DefaultView alloc]init];
        _defaultView3.backgroundColor = [UIColor clearColor];
        _defaultView3.tipTitle = @"暂无课程信息";
        
        UITapGestureRecognizer *tapThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapThreeAction)];
        [_defaultView3 addGestureRecognizer:tapThree];
    }
    return _defaultView3;
}



@end
