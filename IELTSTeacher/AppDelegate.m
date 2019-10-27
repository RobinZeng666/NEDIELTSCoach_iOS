//
//  AppDelegate.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/4.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "AppDelegate.h"
#import "LogonViewController.h"
#import "GuidViewController.h"
#import "MainViewController.h"
#import "BaseNavgationController.h"

#import <AudioToolbox/AudioToolbox.h>

#import <RongIMKit/RongIMKit.h>

#define RYAppKey    @"p5tvi9dst30x4"
//#import "VoteViewController.h"

@interface AppDelegate ()<RCIMConnectionStatusDelegate,UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //登录成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_intoHomeViewController) name:NOTIFICATION_NAME_LOGIN_SUCCESS object:nil];
    //退出成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_intoLogonViewController) name:NOTIFICATION_NAME_USER_LOGOUT object:nil];
    

    BOOL isLaunch = [[ConfigData sharedInstance]isFirstLaunch];
    if (isLaunch) {
        [self _intoGuidViewController];
    }else
    {
        [self _intoLogonViewController];
    }
    
    //初始化融云
    [[RCIM sharedRCIM]initWithAppKey:RYAppKey];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

/*
   进入登录页
 */
- (void)_intoLogonViewController
{
    //断开融云
    [[RCIM sharedRCIM] disconnect];
    [[RCIM sharedRCIM] clearUserInfoCache];

    LogonViewController *logon = [[LogonViewController alloc]init];
    self.window.rootViewController = logon;
}
/*
    进入引导页
 */
- (void)_intoGuidViewController
{
    GuidViewController *guid = [[GuidViewController alloc]init];
    self.window.rootViewController = guid;
}
/*
    进入首页
 */
- (void)_intoHomeViewController
{
    MainViewController *home = [[MainViewController alloc]init];
    BaseNavgationController *nav = [[BaseNavgationController alloc]initWithRootViewController:home];
    self.window.rootViewController = nav;
    
    //登录融云
    [self logonRYIM:NO];
}


#pragma mark - 融云登录
- (void)logonRYIM:(BOOL)checkUpdate
{
    NSDictionary *dataDic;
    if (checkUpdate) {
        dataDic = @{@"checkUpdate":@1};
    }else{
        dataDic = @{@"checkUpdate":@0};
    }
    [[Service sharedInstance]getChatTokenWithPram:dataDic
                                         succcess:^(NSDictionary *result) {
                                             if (k_IsSuccess(result)) {
                                                 NSDictionary *data = [result objectForKey:@"Data"];
                                                 CHECK_DATA_IS_NSNULL(data, NSDictionary);
                                                 if (data.count > 0) {
                                                     NSString *chatToken = [data objectForKey:@"chatToken"];
                                                     if (![chatToken isEqualToString:@""]) {
                                                         [self _longinRCIM:chatToken];
                                                     }else{
                                                         //服务器没有存储token,重新获取token
                                                         [self logonRYIM:YES];
                                                     }
                                                 }
                                             }
                                         } failure:^(NSError *error) {
                                             
                                         }];
}

- (void)_longinRCIM:(NSString *)token
{
    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
        NDLog(@"登录成功");
//        监听
        [RCIM sharedRCIM].connectionStatusDelegate = self;
        
    } error:^(RCConnectErrorCode status) {
    } tokenIncorrect:^{  //token失效的状态处理
        //服务器token已过期,重新获取token
        [self logonRYIM:YES];
    }];
}

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    switch (status) {
        case ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT://在其他设备登录
        case ConnectionStatus_LOGIN_ON_WEB: //在web端登录
        {
            NDLog(@"在其他设备或者web端登录");
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"您的账号在其他设备登录,请注意账号安全!"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles: nil];
            [alertView show];
            
        }
            break;
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //移除密码
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:k_SAVEUserPWD];
    [userDefault synchronize];
    
    //断开连接
    [[RCIM sharedRCIM] disconnect];
    [[RCIM sharedRCIM] clearUserInfoCache];
    //删除个人信息
    [[ConfigData sharedInstance] clearUserLoginInfo];
    
    //安全退出
    [[Service sharedInstance]AppLogoffUserWithPram:nil
                                           success:^(NSDictionary *result){} failure:^(NSError *error) {}];
    
    //发送退出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //在后台收到提醒
//    if ([[notification.userInfo objectForKey:@"key"] isEqualToString:@"name"]) {
//        //判断应用程序当前的运行状态，如果是激活状态，则进行提醒，否则不提醒
//        if (application.applicationState == UIApplicationStateActive) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:notification.alertBody message:notification.alertBody delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:notification.alertAction, nil];
//            [alertView show];
//            
//            application.applicationIconBadgeNumber -= 1;
//        }
//    }
    NDLog(@"________%@",notification.soundName);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"我的提醒"
                                                    message:notification.alertBody
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];

    if ([notification.soundName isEqualToString:UILocalNotificationDefaultSoundName]) {
        
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"in.caf" withExtension:nil];
        if (fileURL != nil)
        {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError){
                AudioServicesPlaySystemSound(theSoundID);
            }else {
                NDLog(@"Failed to create sound ");
            }
        }
    }
    
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (![[ConfigData sharedInstance]isNeedDeviceRotation]) {
        return  UIInterfaceOrientationMaskPortrait;
    }else
    {
        return  UIInterfaceOrientationMaskAll;
    }
}


@end
