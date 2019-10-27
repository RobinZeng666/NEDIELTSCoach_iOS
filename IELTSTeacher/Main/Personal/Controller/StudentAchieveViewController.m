//
//  StudentAchieveViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "StudentAchieveViewController.h"
#import "StudentFileTableViewCell.h"
#import "StudentClassTableViewCell.h"
#import "StudentAchieveModel.h"
#import "TeacherInfoModel.h"
#import "DefaultView.h"

@interface StudentAchieveViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>

@property (nonatomic,strong) DefaultView   *defaultView;//默认视图
@property (nonatomic,strong) BaseTableView *studentTableView;
@property (nonatomic,strong) UITableView *titleTableView; //标题表视图
@property (nonatomic,strong) UIButton    *titleButton;
@property (nonatomic,strong) UILabel     *titleLabel;//标题
@property (nonatomic,strong) UIImageView *titleImgView;
@property (nonatomic,strong) NSArray     *titleArray;
@property (nonatomic,strong) UIControl   *fuzzyView;

@property (nonatomic,strong) NSMutableArray *muArray;

@property (nonatomic,copy) NSString *sCode;//班级编号
@property (nonatomic,copy) NSString *sName;//班级名称

@property (nonatomic,assign) NSInteger selectIndex;//选中索引
@property (nonatomic,assign) int pageIndex;//分页

@property (nonatomic,assign) CGFloat tempHeight;

@end

@implementation StudentAchieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"";
    
    WS(this_Achieve);
    [self.navView addSubview:self.titleButton];
    [self.titleButton addSubview:self.titleLabel];
    [self.titleButton addSubview:self.titleImgView];
    [self.view addSubview:self.defaultView];
    [self.view addSubview:self.studentTableView];
    [self.view addSubview:self.titleTableView];
    [self.view insertSubview:self.fuzzyView belowSubview:self.titleTableView];
    
    self.titleTableView.hidden = YES;
    self.fuzzyView.hidden = YES;
    
    if (_listArray.count > 0) {
        
        _tempHeight = kScreenHeight/2;// _listArray.count * 32*AUTO_SIZE_SCALE_Y+12*AUTO_SIZE_SCALE_Y;
        
        [self.titleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-_tempHeight+kNavHeight+3);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, _tempHeight));
        }];
    }
    
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.centerX.mas_equalTo(this_Achieve.navView);
        make.size.mas_equalTo(CGSizeMake(220*AUTO_SIZE_SCALE_X, 30));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(203*AUTO_SIZE_SCALE_X, 30));
    }];
    [self.titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((30-9)/2);
        make.left.mas_equalTo(self.titleLabel.right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(17, 9));
    }];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+3+(kScreenHeight-kNavHeight-3-100*AUTO_SIZE_SCALE_Y)/2);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
    }];
    
    //模糊视图
    [self.fuzzyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+3);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-kNavHeight));
    }];
    
    //头部刷新
    [self showHudInView:self.view hint:@"正在加载..."];
    [self.studentTableView.head beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - life cycle
#pragma mark - <BaseTableViewDelegate>
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    //请求数据
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _pageIndex = 1;
        _muArray = [[NSMutableArray alloc] init];
    } else {
        _pageIndex++;
    }
    
    //多个班 显示第一个班
    if (_listArray.count > 0) {
        
        NSDictionary *firstDic = [_listArray objectAtIndex:_selectIndex];
        TeacherInfoModel *infoModel = [[TeacherInfoModel alloc] initWithDataDic:firstDic];
        //班级编号
        _sCode = infoModel.sCode;
        
        CHECK_DATA_IS_NSNULL(_sCode, NSString);
        CHECK_STRING_IS_NULL(_sCode);
        //班级名称
        NSString *sName = [infoModel.sName isKindOfClass:[NSNull class]]?@"":infoModel.sName;
        //设置标题
        NDLog(@"%@",sName);
        self.titleLabel.text = sName;
        NDLog(@"%@",self.titleLabel.text);
        self.titleLabel.textColor = k_PinkColor;
        
        CGSize countSize = [CommentMethod widthForNickName:self.titleLabel.text testLablWidth:220*AUTO_SIZE_SCALE_X textLabelFont:k_Font_2];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(countSize.width+15, 30));
        }];
        [self.titleButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(countSize.width+34, 30));
        }];
        
        NSString *pageIndex = [NSString stringWithFormat:@"%d", _pageIndex];
        NSString *ids = infoModel.ID;
        CHECK_DATA_IS_NSNULL(ids, NSString);
        CHECK_STRING_IS_NULL(ids);
        NSDictionary *dic = @{@"sClassId":ids,
                              @"pageIndex":pageIndex};
        //调用学员成绩接口
        [[Service sharedInstance]loadStuInfosByClassWithPram:dic success:^(NSDictionary *result) {
            //成功
            if (k_IsSuccess(result)) {
                NDLog(@"学员成绩 接口 result = %@", result);
                
                NSDictionary *dataDic = [result objectForKey:@"Data"];
                CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
                NSArray *listArray = [dataDic objectForKey:@"list"];
                CHECK_DATA_IS_NSNULL(listArray, NSArray);
                if (listArray.count > 0) {
                    for (NSDictionary *listDic in listArray) {
                        StudentAchieveModel *model = [[StudentAchieveModel alloc] initWithDataDic:listDic];
                        [_muArray addObject:model];
                    }
                    //隐藏提示视图
                    self.defaultView.hidden = YES;
                    self.studentTableView.hidden = NO;
                } else {
                    //显示提示视图
                    self.defaultView.hidden = NO;
                    self.studentTableView.hidden = YES;
                }
                
                [self hideHud];
                //刷新表格
                [self.studentTableView reloadData];
                
                //(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [refreshView endRefreshing];
                
                //是否完成刷新
                if (listArray.count < 10) {
                    //(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [self.studentTableView.foot finishRefreshing];
                } else {
                    //完成刷新
                    [self.studentTableView.foot endRefreshing];
                }
                
            } else {
                if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                    [self showHint:[result objectForKey:@"Infomation"]];
                }
                [self hideHud];
                //结束刷新
                [refreshView endRefreshing];
                
                //显示提示视图
                self.defaultView.hidden = NO;
                self.studentTableView.hidden = YES;
            }
        } failure:^(NSError *error) {
            //失败
            [self hideHud];
            [self showHint:[error networkErrorInfo]];
            //结束刷新
            [refreshView endRefreshing];
            
            //显示提示视图
            self.defaultView.hidden = NO;
            self.studentTableView.hidden = YES;
        }];
    } else {
        NDLog(@"班级数小于或等于0");
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.titleTableView) {
        return 1;
    }
    return _muArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.titleTableView) {
        return _listArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1*AUTO_SIZE_SCALE_Y;
    } else {
        return 10*AUTO_SIZE_SCALE_Y;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1*AUTO_SIZE_SCALE_Y)];
        view.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10*AUTO_SIZE_SCALE_Y)];
        view.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.studentTableView) {
        static NSString *identify = @"StudentFileTableViewCell";
        StudentFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[StudentFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_muArray.count > 0) {
            cell.studentModel = _muArray[indexPath.section];
        }
        return cell;

    } else {
        //标题单元格
        static NSString *identify = @"StudentClassTableViewCell";
        StudentClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[StudentClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dic = self.listArray[indexPath.row];
        TeacherInfoModel *model = [[TeacherInfoModel alloc] initWithDataDic:dic];
        
        CHECK_DATA_IS_NSNULL(model.sName, NSString);
        CHECK_STRING_IS_NULL(model.sName);
        cell.titLabel.text = model.sName;
        
        CHECK_DATA_IS_NSNULL(model.sCode, NSString);
        CHECK_STRING_IS_NULL(model.sCode);
        if ([model.sCode isEqualToString:_sCode]) {
            cell.titLabel.textColor = k_PinkColor;
        } else {
            cell.titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_8];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.titleTableView) {
        //点击，刷新studentTableView表视图
        
        NSDictionary *dic = self.listArray[indexPath.row];
        TeacherInfoModel *model = [[TeacherInfoModel alloc] initWithDataDic:dic];
        NSString *sName = model.sName;
        CHECK_STRING_IS_NULL(sName);
        //1、设置标题
//        [self.titleButton setTitle:sName forState:UIControlStateNormal];
        self.titleLabel.text = sName;
        //2、隐藏表视图
        [self hiddenTitleTableView];
        
        //3、刷新视图
        _sCode = model.sCode;
        _selectIndex = indexPath.row;
        
        //请求数据
        [self.studentTableView.head beginRefreshing];
        [self.studentTableView reloadData];
    }
}

#pragma mark - event response
- (void)titleButtonAction:(UIButton *)button
{
    NDLog(@"Button响应");
    if (!button.selected) {
        [self showTitleTableView];
        //刷新数据
        [self.titleTableView reloadData];
    }else
    {
        [self hiddenTitleTableView];
    }
    
    //显示
}

- (void)fuzzyAction:(UIControl *)button
{
    NDLog(@"Button响应");
    //隐藏
    [self hiddenTitleTableView];
}

- (void)tapOneAction
{
    //开始刷新
    [self.studentTableView.head beginRefreshing];
}

#pragma mark - private methods
- (void)showTitleTableView
{
    self.titleTableView.hidden = NO;
    self.fuzzyView.hidden = NO;
    
    self.titleImgView.transform =  CGAffineTransformMakeRotation(M_PI);
    
    [UIView animateWithDuration:1.0 animations:^{
        //显示
        [self.titleTableView updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kNavHeight+3);
            make.left.right.mas_equalTo(@0);
            //        make.bottom.mas_equalTo(kNavHeight);
            make.height.mas_equalTo(_tempHeight);
        }];
    }];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:100];
    button.selected = !button.selected;
}

- (void)hiddenTitleTableView
{
    self.titleTableView.hidden = YES;
    self.fuzzyView.hidden = YES;

    self.titleImgView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:1.0 animations:^{
        //隐藏
        [self.titleTableView updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-_tempHeight+kNavHeight);
            make.left.right.mas_equalTo(@0);
            //        make.bottom.mas_equalTo(kNavHeight);
            make.height.mas_equalTo(_tempHeight);
        }];
    }];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:100];
    button.selected = !button.selected;
}

#pragma mark - getters and setters
- (DefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [DefaultView new];
        _defaultView.tipTitle = @"暂无学员";

        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction)];
        [_defaultView addGestureRecognizer:tapOne];
    }
    return _defaultView;
}

- (BaseTableView *)studentTableView
{
    if (!_studentTableView) {
        _studentTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y) style:UITableViewStyleGrouped];
        _studentTableView.delegate = self;
        _studentTableView.dataSource = self;
        _studentTableView.delegates = self;
        _studentTableView.rowHeight = 700/3*AUTO_SIZE_SCALE_Y;
        _studentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _studentTableView.tableFooterView = [[UIView alloc] init];
        _studentTableView.showsVerticalScrollIndicator = NO;
    }
    return _studentTableView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [CommentMethod colorFromHexRGB:@"818b8f"];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
    }
    return _titleLabel;
}

- (UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(titleButtonAction:) Title:@""];
//        [_titleButton setTitleColor:[CommentMethod colorFromHexRGB:@"818b8f"] forState:UIControlStateNormal];
//        _titleButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
        _titleButton.tag = 100;
    }
    return _titleButton;
}

- (UIImageView *)titleImgView
{
    if (!_titleImgView) {
        _titleImgView = [CommentMethod createImageViewWithImageName:@"score_xila.png"];
        _titleImgView.userInteractionEnabled = YES;
    }
    return _titleImgView;
}

- (UITableView *)titleTableView
{
    if (!_titleTableView) {
        _titleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _titleTableView.delegate = self;
        _titleTableView.dataSource = self;
        _titleTableView.rowHeight = 32*AUTO_SIZE_SCALE_Y;
        _titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _titleTableView.tableFooterView = [[UIView alloc] init];
        _titleTableView.showsVerticalScrollIndicator = NO;
    }
    return _titleTableView;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"2015年春季口语6.5分班", @"2015年春季口语6.5分班", @"2015年春季口语6.5分班", @"2015年春季口语6.5分班", @"2015年春季口语6.5分班", @"2015年春季口语6.5分班"];
    }
    return _titleArray;
}

- (UIControl *)fuzzyView
{
    if (!_fuzzyView) {
        _fuzzyView = [UIControl new];
        _fuzzyView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
        [_fuzzyView addTarget:self action:@selector(fuzzyAction:) forControlEvents:UIControlEventTouchUpInside];
        _fuzzyView.alpha = 0.8;
    }
    return _fuzzyView;
}

@end
