//
//  ConfigData.h
//  GreatWall
//
//  Created by Sidney on 13-3-20.
//  Copyright (c) 2013年 BH Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GlobalConfig.h"

@interface ConfigData : NSObject

@property (nonatomic , strong , setter=setUid: , getter=uid) NSString * uid; //用户ID

@property (nonatomic , strong) NSString * token;

@property (nonatomic , strong) NSString * sTeacherId;
//@property (nonatomic,strong)NSNumber * passCode;
@property (nonatomic, assign) BOOL isNeedDeviceRotation;

+ (instancetype)sharedInstance;


- (void)clearAllCaches;
/**
 是否登录
 */
- (BOOL)isLogined;

/**
 初始化Uid和Token
 */
- (void)initUidAndToken;

/**
 保存用户登录后信息
 */
- (void)saveUserLoginInfo:(NSDictionary *)data;

/**
 清除用户登录后信息
 */
- (void)clearUserLoginInfo;

/**
 保存用户个人信息,key value
 */
- (BOOL)saveUserConfigInfo:(id)infoValue withKey:(NSString *)key;

/**
 获取保存的用户个人信息by key
 */
- (id)getUserConfigInfowithKey:(NSString *)key;

/**
 删除保存的用户个人信息by key
 */
- (BOOL)removeUserConfigInfowithKey:(NSString *)key;

/**
 一次性删除所有配置信息
 */
- (void)removeAllUserConfigInfo;


/**
 是否第一次启动
 */
- (BOOL)isFirstLaunch;

/**
 遍历文件夹获得文件夹大小，返回多少M
 */
- (float)folderSizeAtPath:(NSString*)folderPath;

/**
 计算字符串长度
 */
- (int)textLength:(NSString *)text;

/**
 将获取的json数据写到沙盒中，方便查看数据。
 */
- (void)writeToPlist:(id)object fileName:(NSString *)fileName;


/**
 * 获取用户信息
 */
- (NSDictionary *)getUserInfoModel;

@end
