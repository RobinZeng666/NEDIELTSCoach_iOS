//
//  GlobalConfig.h
//  Forum
//
//  Created by Lei Zhu on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "AppDelegate.h"

#ifndef GLOBAL_CONFIG
#define GLOBAL_CONFIG

//请求基本链接
//////////////////////////////////////////////////////////////////
//开发
//#define  BaseURLString          @"http://testielts2.staff.xdf.cn/IELTS_2_DEV/api"
//#define  BaseVideoMaterialsPath @"http://testielts2.staff.xdf.cn/IELTS_2_DEV/materials/selectVideoMaterialsById"
//#define  BaseUserIconPath       @"http://testielts2.staff.xdf.cn/upload_dev/userImage"

////准生产
#define  BaseURLString          @"http://ilearning.staff.xdf.cn/IELTS/api"
#define  BaseVideoMaterialsPath @"http://ilearning.staff.xdf.cn/IELTS/materials/selectVideoMaterialsById"
#define  BaseUserIconPath       @"http://ilearning.staff.xdf.cn/upload/userImage"


//#define   BaseURLString @"http://10.62.50.99:8080/IELTS_2/api"  //蓝健
//#define   BaseURLString @"http://10.62.0.212:8080/IELTS_2/api"  //靳京
//#define   BaseURLString @"http://10.62.49.51:8080/IELTS_2/api"  //永新
//#define   BaseURLString @"http://10.62.3.94:8080/IELTS_2/api"  //金龙

//U2登录
/////////////////////////////////////////////////////////////////
//#define  BaseU2LoginURLString    @"http://testu2.staff.xdf.cn/apis/usersv2.ashx" //测试环境
//#define  BaseU2LoginURLString    @"http://passport.xdf.cn/apis/usersv2.ashx"// 正式环境
//
////测试环境
//#define  U2AppId  @"90101"
//#define  U2AppKey @"u2testAppKey#$vs"
//正式环境
//#define  U2AppId  @"90120"
//#define  U2AppKey @"u2ys#vskvqy*@%!vs15v"

//网络请求
//////////////////////////////////////////////////////////////////
#import "AFNetworking.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "Service.h"
#import "UIImage+category.h"
#import "NSString+category.h"
#import "NSError+category.h"
#import "UIViewController+DismissKeyboard.h"
#import "UIViewController+HUD.h"
#import "UIView+ViewController.h"
//#import "PureLayout.h"
#import "CommentMethod.h"
#import "NSDate+category.h"
#import "UIDevice+category.h"
#import "CommonFunc.h"

#import "UserInfoModel.h"

#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

//Debug调试模式
//////////////////////////////////////////////////////////////////
#define NDDEBUG 0

#if NDDEBUG
#define NDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NDLog(xx, ...)  ((void)0)
#endif


//尺寸适配
//////////////////////////////////////////////////////////////////
#define IS_4_INCH_SCREEN  (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define IS_3_5_INCH_SCREEN  (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)
#define IS_IOS_7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ? YES : NO)
#define IS_IOS_8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) ? YES : NO)
#define STATUS_HIGHT   (IS_IOS_7) ? 20 : 0//状态栏高度
#define NAV_BAR_HEIGHT (IS_IOS_7 ? 64 : 44)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kNavHeight  64
#define TAB_BAR_HEIGHT 49

////等比例缩放 此处以 640*1136为标准
//#define AUTO_SIZE_SCALE_X (kScreenHeight > 480 ? (kScreenWidth / 320.0) : 1.0)
//#define AUTO_SIZE_SCALE_Y (kScreenHeight > 480 ? (kScreenHeight / 568.0) : 1.0)

#define kHeight  ((IS_3_5_INCH_SCREEN)? 568:kScreenHeight)

#define AUTO_SIZE_SCALE_X (kScreenHeight < 736 ? (kScreenWidth/414.0) : 1.0)
#define AUTO_SIZE_SCALE_Y (kScreenHeight < 736 ? (kHeight/736.0) : 1.0)


//////////////////////////////////////////////////////////////////
#define   k_UIFont(font)  [UIFont systemFontOfSize:font]


//////////////////////////////////////////////////////////////////
#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define DOCUMENT_DIRECTORY_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define BUNDLE_IDENTIFIER [[NSBundle mainBundle] bundleIdentifier]

#define BUNDLE_DISPLAY_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#define BUNDLE_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define DB_PATH [DOCUMENT_DIRECTORY_PATH stringByAppendingPathComponent:@"listeningDatabase.db"]

#define BUNDLE_FILE_PATH(filename)  [[NSBundle mainBundle] pathForAuxiliaryExecutable:filename]


//颜色值
//////////////////////////////////////////////////////////////////
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]
#define COLOR_FROM_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define k_Color_1  @"e84d60"  //小面积使用，用于特别需要强调和突出的文字、按钮
#define k_Color_2  @"565a5c"  //用户重要级文字信息，内页标题
#define k_Color_3  @"838a8e"  //用于普通级段落信息和一道操作按钮
#define k_Color_4  @"aaaaaa"  //用于辅助，次要的文字信息，普通按钮描边
#define k_Color_5  @"d2d2d2"  //用于分割线
#define k_Color_6  @"efefef"  //用于分割模块底色
#define k_Color_7  @"f8f8f8"  //用于阅读性内容区域底色
#define k_Color_8  @"545a5c"  //用于标题
#define k_Color_9  @"ffffff"  //用于留白

#define k_Font_0 28   //72px
#define k_Font_1 20   //54px  //如导航标题，测验报告名称
#define k_Font_2 18   //48  //成绩单学生名，课程名
#define k_Font_3 17   //45  //适合大段文字
#define k_Font_4 16   //42  //用于大多数文字，适合小标题，模块描述
#define k_Font_5 15   //39  //用于辅助性文字
#define k_Font_6 14   //36  //用于辅助性文字
#define k_Font_7 12   //32          //用于辅助性文字
#define k_Font_8 13
#define k_Font_9 38   //100

#define k_PinkColor   RGBACOLOR(255.0,76.0,97.0,1.0)
#define K_VotePickColor RGBACOLOR(255, 232, 236, 1.0)
//#define k_PinkColor RGBACOLOR(252.0,49.0,79.0,1.0)
//#define k_PinkColor RGBACOLOR(232.0,77.0,96.0,1.0)

#define kIndicatorColor     RGBACOLOR(240.0,240.0,240.0,1.0)

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//常用判断
//////////////////////////////////////////////////////////////////
//int类型转string类型
#define INT_TO_STRING(x)  [NSString stringWithFormat:@"%d",x]
//id类型转string类型
#define OBJ_TO_STRING(obj) [NSString stringWithFormat:@"%@",obj]
//判断字符串是否为nil,如果是nil则设置为空字符串
#define CHECK_STRING_IS_NULL(txt) txt = !txt ? @"" : txt

//判断Server返回数据是否为NSNull 类型 txt为参数 type为类型,like NSString,NSArray,NSDictionary
#define CHECK_DATA_IS_NSNULL(param,type) param = [param isKindOfClass:[NSNull class]] ? [type new] : param


#define k_IsSuccess(result) [[result objectForKey:@"Result"] boolValue]

//输入限制
//////////////////////////////////////////////////////////////////
#define NUMBERS         @"0123456789\n"
#define DECIMAL_NUMBERS @"0123456789,.\n"
#define ALPHA           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM        @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"


//////////////////////////////////////////////////////////////////
#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"
#define LAST_ENTERINTO_ROOTVIEW_VERSION_KEY @"last_enterinto_rootview_version"


//通知
//////////////////////////////////////////////////////////////////
#define NOTIFICATION_NAME_LOGIN_SUCCESS             @"loginSuccess"     //登录成功
#define NOTIFICATION_NAME_USER_LOGOUT               @"userLogout"       //退出登录
//#define NOTIFICATION_NAME_RESET_PSWD_OTHER_PHONE    @"resetPasswordOtherPhone" //其他手机修改密码
//#define Notification_Name_ClassRoom                 @"ClassRoom"  //课堂互动
#define  k_SAVEUserName                             @"k_SAVEUserName"   //保存用户名
#define  k_SAVEUserPWD                              @"k_SAVEUserPWD"    //保存用户密码

//班级详情
#define Notification_Name_ClassDetail               @"ClassDetail"

#define Notification_Name_ClassOver                 @"ClassOver"        //下课

//分组
#define Notification_Name_GroupData                 @"GroupData"

//缓存key
//////////////////////////////////////////////////////////////////

#define  k_addRemind                                @"k_addRemind"
#define  Remind_addSuccess                          @"Remind_addSuccess"
#define  News_UnRead                                @"News_isUnread"

#define  Schedule_Data                              @"Schedule_Data"

#endif