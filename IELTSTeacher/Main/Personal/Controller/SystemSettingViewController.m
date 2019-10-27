//
//  SystemSettingViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "SystemSettingTableViewCell.h"

@interface SystemSettingViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *sysTableView;
@property (nonatomic,strong) NSArray     *titArray;
@property (nonatomic,assign) float      cacheSize;

@end

@implementation SystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"系统设置";
    
    _cacheSize = 0.0;
    
    NSString *path = NSHomeDirectory();
    NDLog(@"沙盒 %@", path);
    
    //计算缓存大小
    [self getCacheSize];
    
    [self.view addSubview:self.sysTableView];
    
    //表视图
    [self.sysTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+12*AUTO_SIZE_SCALE_Y);
        make.left.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCacheSize
{
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    float tempSize = size/(1024.0*1024);
    _cacheSize = tempSize;
    NDLog(@"_cacheSize = %.1fM", _cacheSize);
}

#pragma mark - life cycle
#pragma mark - xxxDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"SystemSettingTableViewCell";
    SystemSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[SystemSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titLabel.text = self.titArray[indexPath.row];
    if (indexPath.row == 0) {
        float size = _cacheSize;
        NSString *str = [NSString stringWithFormat:@"%.1fM",size];
        cell.detailLabel.text = str;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清除缓存"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];

    } else {
        //安全退出
        [[Service sharedInstance]AppLogoffUserWithPram:nil success:^(NSDictionary *result) {
            //成功
            if (k_IsSuccess(result)) {
                //移除密码
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault removeObjectForKey:k_SAVEUserPWD];
                [userDefault synchronize];
                //删除个人信息
                [[ConfigData sharedInstance] clearUserLoginInfo];
                
                //发送退出通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
            } else {
                if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                    [self showHint:[result objectForKey:@"Infomation"]];
                }
            }
        } failure:^(NSError *error) {
            //失败
            [self showHint:[error networkErrorInfo]];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //确定
        //清除图片缓存
        [[ConfigData sharedInstance]clearAllCaches];
        //清除内存图片
        [[SDImageCache sharedImageCache] clearMemory];
        
        //清除网页缓存
        [self showHint:@"清除成功"];
        
        //重新计算缓存大小
        [self getCacheSize];
        //刷新数据
        [self.sysTableView reloadData];
    }

}

#pragma mark - event response
#pragma mark - private methods
#pragma mark - getters and setters
- (UITableView *)sysTableView
{
    if (!_sysTableView) {
        _sysTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _sysTableView.delegate = self;
        _sysTableView.dataSource = self;
        _sysTableView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
        _sysTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sysTableView.tableFooterView = [[UIView alloc] init];
        _sysTableView.rowHeight = 203/3*AUTO_SIZE_SCALE_Y;
    }
    return _sysTableView;
}

- (NSArray *)titArray
{
    if (!_titArray) {
        _titArray = @[@"清除缓存", @"安全退出"];
    }
    return _titArray;
}

@end
