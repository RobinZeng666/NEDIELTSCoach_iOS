//
//  RemindViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "RemindViewController.h"
#import "RemindTableViewCell.h"
#import "AddRemindViewController.h"
#import "RemindModel.h"
#import "DefaultView.h"

@interface RemindViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton    *addButton;//添加
@property (nonatomic,strong) UITableView *remindTableView;
@property (nonatomic,strong) DefaultView *defaultView;//提示视图

@property (nonatomic,strong) NSArray     *titleArr;
@property (nonatomic,strong) NSArray     *detailArr;
@property (nonatomic,strong) NSArray     *dateArr;
@property (nonatomic,strong) NSArray     *timeArr;

@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSMutableArray *muArray;
@property (nonatomic,strong) NSMutableArray *tempArray;

@end

@implementation RemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"我的提醒";

    self.view.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
    
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.defaultView];
    [self.view addSubview:self.remindTableView];
    
    self.remindTableView.delegate = self;
    self.remindTableView.dataSource = self;
    
    self.titleArr = @[@"无", @"模拟考试", @"单词时间-100天改变计划"];
    self.detailArr = @[@"", @"新东方大厦北楼802", @"随意"];
    self.dateArr = @[@"", @"2015.5.20", @"2015.5.15"];
    self.timeArr = @[@"今日", @"am 9:00", @"am 8:30"];
    
    //添加Button
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(44);
    }];
    
    //提示视图
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y-100*AUTO_SIZE_SCALE_Y)/2);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
    }];
    
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Remind_addSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateRemindData) name:Remind_addSuccess object:nil];
    
    //初始化数据
    [self _initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.remindTableView removeFromSuperview];
}

//更新数据
- (void)UpdateRemindData
{
    //初始化数据
    [self _initData];
}

//初始化数据
- (void)_initData
{
    //从本地读取数据
    NSArray *dataArray = [[ConfigData sharedInstance]getUserConfigInfowithKey:k_addRemind];
    if (dataArray.count > 0) {
        //有提醒
        
        _muArray = [[NSMutableArray alloc] init];
        _tempArray = [NSMutableArray arrayWithArray:dataArray];
        for (NSDictionary *dic in dataArray) {
            RemindModel *model = [[RemindModel alloc] initWithDataDic:dic];
            [_muArray addObject:model];
        }
        //隐藏提示视图
        self.defaultView.hidden = YES;
        self.remindTableView.hidden = NO;
    } else {
        //显示提示视图
        self.defaultView.hidden = NO;
        self.remindTableView.hidden = YES;
    }
    [self.remindTableView reloadData];
}

#pragma mark - life cycle
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _muArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10*AUTO_SIZE_SCALE_Y;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_muArray.count > 0) {
        RemindModel *remindModel = (RemindModel *)_muArray[indexPath.section];

        CGFloat tempHeight = 0.0;
        //事件
        NSString *str = remindModel.Title;
        CGFloat titleHeight = [CommentMethod widthForNickName:str testLablWidth:200*AUTO_SIZE_SCALE_X textLabelFont:18.0].height;
        
        //位置
        NSString *localStr = remindModel.Location;
        CGFloat localHeight = [CommentMethod widthForNickName:localStr testLablWidth:200*AUTO_SIZE_SCALE_X textLabelFont:16.0].height;

        
        if (titleHeight > 30*AUTO_SIZE_SCALE_Y) {
            tempHeight = 100*AUTO_SIZE_SCALE_Y+titleHeight;
        } else {
            tempHeight = 100*AUTO_SIZE_SCALE_Y;
        }
        
        if (localHeight > 20*AUTO_SIZE_SCALE_Y) {
            return tempHeight+localHeight;
        } else {
            return tempHeight;
        }
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"RemindTableViewCell";
    RemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[RemindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_muArray.count > 0) {
        cell.model = _muArray[indexPath.section];
    }
    return cell;
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //1.删除数据
        NSMutableArray *allArray = [[ConfigData sharedInstance]getUserConfigInfowithKey:k_addRemind];
        NSDictionary *dic = [allArray objectAtIndex:indexPath.section];
        NSString *keyStr = [dic objectForKey:@"Title"];
        
        //4.删除通知
        [self cancelLocalNotification:keyStr];
        
        [_muArray removeObjectAtIndex:indexPath.section];
        [_tempArray removeObjectAtIndex:indexPath.section];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.remindTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        [[ConfigData sharedInstance]saveUserConfigInfo:_tempArray withKey:k_addRemind];
        //开启通知
        [[NSNotificationCenter defaultCenter]postNotificationName:Remind_addSuccess object:nil];
        
        [self.remindTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击进入提醒详情 可直接删除
    AddRemindViewController *addRemind = [[AddRemindViewController alloc] init];
//    addRemind.delegate = self;
    addRemind.isCheck = YES;
    addRemind.index = indexPath.section;
    addRemind.dataCurrent = _tempArray[indexPath.section];
    [self.navigationController pushViewController:addRemind animated:YES];
}

#pragma mark - <RemindViewControllerDelegate>
- (void)refreshRemindList
{
    //初始化
    [self _initData];
}

#pragma mark - event response
- (void)addButtonAction:(UIButton *)button
{
    NDLog(@"添加addButton响应");
    AddRemindViewController *addRemind = [[AddRemindViewController alloc] init];
    addRemind.muArray = _tempArray;
//    addRemind.delegate = self;
    addRemind.isCheck = NO;
    [self.navigationController pushViewController:addRemind animated:YES];
}

- (void)tapOneAction
{
    [self _initData];
}

//取消本地通知
- (void)cancelLocalNotification:(NSString *)key
{
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    UILocalNotification *localNoti;
    if (localArr) {
        for (UILocalNotification *noti in localArr) {
            NSDictionary *dict = noti.userInfo;
            if (dict){
                NSArray *allKeys =  [dict allKeys];
                if ([allKeys containsObject:key]) {
                    if (localNoti){
                        localNoti = nil;
                    }
                    localNoti = noti;
                    break;
                }
            }
        }
    }
    
    //判断是否找到已经存在的相同key的推送
    if (!localNoti) {
        //不存在 初始化
        localNoti = [[UILocalNotification alloc] init];
    }
    if (localNoti) {
        //不推送 取消推送
        [app cancelLocalNotification:localNoti];
        return;
    }
}

#pragma mark - private methods
#pragma mark - getters and setters
- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(addButtonAction:) Title:@"添加"];
        [_addButton setTitleColor:[CommentMethod colorFromHexRGB:@"818b8f"] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
    }
    return _addButton;
}

- (UITableView *)remindTableView
{
    if (!_remindTableView) {
        _remindTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y) style:UITableViewStyleGrouped];
        _remindTableView.backgroundColor = [UIColor clearColor];
        _remindTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _remindTableView.showsVerticalScrollIndicator = NO;
    }
    return _remindTableView;
}

- (DefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [DefaultView new];
        _defaultView.tipTitle = @"暂无提醒";

        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction)];
        [_defaultView addGestureRecognizer:tapOne];
    }
    return _defaultView;
}

@end
