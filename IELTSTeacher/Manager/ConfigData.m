//
//  ConfigData.m
//  GreatWall
//
//  Created by Sidney on 13-3-20.
//  Copyright (c) 2013年 BH Technology Co., Ltd. All rights reserved.
//

#import "ConfigData.h"

@implementation ConfigData


+ (instancetype)sharedInstance
{
    static ConfigData *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[ConfigData alloc] init];
    });
    return instance;
}

- (BOOL)isFirstLaunch
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL lastRunVersion = [defaults boolForKey:LAST_RUN_VERSION_KEY];
    if (!lastRunVersion) {
        //为第一次登录
        [defaults setBool:YES forKey:LAST_RUN_VERSION_KEY];
        [defaults synchronize];
        return YES;
    }
    return NO;
}

//单个文件的大小
- (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
-  (float)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        NSLog(@"fileAbsolutePath:%@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1000.0*1000.0);
}

//计算字符串长度
- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        //一个汉字两个字节，应是+2.项目中数据库使用的mysql-utf8 一个汉字是3个字节，改成+3
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3){
            number += 3;
        }else{
            number ++;
        }
    }
    return ceil(number);
}

- (void)clearAllCaches
{
    //    头像什么的都缓存在Caches目录下fsCachedData目录里
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //清除物理缓存
    [[SDImageCache sharedImageCache] clearDisk];
    //清除过期物理缓存
    [[SDImageCache sharedImageCache] cleanDisk];
}

//将获取的json数据写到沙盒中，方便查看数据
- (void)writeToPlist:(id)object fileName:(NSString *)fileName
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * path = [paths  objectAtIndex:0];
    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    //    NSData * arrayAsData = [NSKeyedArchiver archivedDataWithRootObject:object];
    //    object = [NSKeyedUnarchiver unarchiveObjectWithData:arrayAsData];
    
    NSLog(@"filePath:%@",filePath);
    [object writeToFile:filePath atomically:YES];
}

/**
 保存用户个人信息
 */
- (BOOL)saveUserConfigInfo:(id)infoValue withKey:(NSString *)key
{
    if (!infoValue) {
        return NO;
    }
    if (!key || [key isEqualToString:@""]) {
        return NO;
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * uid = [[ConfigData sharedInstance] uid];
    CHECK_STRING_IS_NULL(uid);
    
    NSString * ukey = [NSString stringWithFormat:@"uinfo_%@",uid];
    
    NSDictionary * configInfo = [userDefaults objectForKey:ukey];
    NSMutableDictionary * userConfigInfo;
    if (configInfo) {
        userConfigInfo = [NSMutableDictionary dictionaryWithDictionary:configInfo];
    }else{
        userConfigInfo = [NSMutableDictionary new];
    }
    
    NSData * infoData = [NSKeyedArchiver archivedDataWithRootObject:infoValue];
    
    [userConfigInfo setObject:infoData forKey:key];
    [userDefaults setObject:userConfigInfo forKey:ukey];
    [userDefaults synchronize];
    return YES;
}

/**
 获取保存的用户个人信息by key
 */
- (id)getUserConfigInfowithKey:(NSString *)key
{
    if (!key || [key isEqualToString:@""]) {
        return @"";
    }
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * uid = [[ConfigData sharedInstance] uid];
    CHECK_STRING_IS_NULL(uid);
    NSString * ukey = [NSString stringWithFormat:@"uinfo_%@",uid];

    NSDictionary * configInfo = [userDefaults objectForKey:ukey];
    NSData * infoData = [configInfo objectForKey:key];
    id value = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];

    return value;
}

/**
 删除保存的用户个人信息by key
 */
- (BOOL)removeUserConfigInfowithKey:(NSString *)key
{
    if (!key || [key isEqualToString:@""]) {
        return NO;
    }
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * uid = [[ConfigData sharedInstance] uid];
    CHECK_STRING_IS_NULL(uid);
    NSString * ukey = [NSString stringWithFormat:@"uinfo_%@",uid];
    NSMutableDictionary * configInfo = [userDefaults objectForKey:ukey];

    NSMutableDictionary * userConfigInfo = [NSMutableDictionary dictionaryWithDictionary:configInfo];
    [userConfigInfo removeObjectForKey:key];
    [userDefaults setObject:userConfigInfo forKey:ukey];
    [userDefaults synchronize];

    return YES;
}

/**
 一次性删除所有配置信息
 */
- (void)removeAllUserConfigInfo
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * uid = [[ConfigData sharedInstance] uid];
    CHECK_STRING_IS_NULL(uid);
    NSString * ukey = [NSString stringWithFormat:@"uinfo_%@",uid];
    [userDefaults removeObjectForKey:ukey];
    [userDefaults synchronize];
}

/**
 保存用户登录后信息
 */
- (void)saveUserLoginInfo:(NSDictionary *)data
{
    if (data && [data count] > 0) {
        NSString * token = [data objectForKey:@"Token"];
        NSDictionary *userInfo = [data objectForKey:@"UserInfo"];
        NSString *uid = @"";
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:token forKey:@"Token"];

        if (userInfo && userInfo.count > 0) {
            UserInfoModel *infoModel = [[UserInfoModel alloc]initWithDataDic:userInfo];
            uid = [infoModel.UID stringValue];
            [userDefaults setObject:uid forKey:@"UID"];
            NSData * infoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
            [userDefaults setObject:infoData forKey:@"userInfo"];
            
            CHECK_DATA_IS_NSNULL(infoModel.sTeacherID, NSString);
            [userDefaults setObject:infoModel.sTeacherID forKey:@"sTeacherID"];
        }
        [userDefaults synchronize];
        
        [self initUidAndToken];
    }
}

- (void)initUidAndToken
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"Token"];
    NSString * uid = [userDefaults objectForKey:@"UID"];
    NSString * sTeacherId =[userDefaults objectForKey:@"sTeacherID"];
    [ConfigData sharedInstance].token = token;
    [ConfigData sharedInstance].uid = uid;
    [ConfigData sharedInstance].sTeacherId = sTeacherId;;
}

- (NSDictionary *)getUserInfoModel
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"userInfo"];
    CHECK_DATA_IS_NSNULL(data, NSData);
    NSDictionary *value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (value.count > 0) {
        return value;
    }
    return nil;
}

/**
 清除用户登录后信息
 */
- (void)clearUserLoginInfo;
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"Token"];
    [userDefaults removeObjectForKey:@"UID"];
    [userDefaults removeObjectForKey:@"sTeacherID"];
    [userDefaults removeObjectForKey:@"userInfo"];
    [userDefaults synchronize];
    [ConfigData sharedInstance].token = @"";
    [ConfigData sharedInstance].uid = @"";
    [ConfigData sharedInstance].sTeacherId = @"";

}

- (BOOL)isLogined
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * ut = [userDefaults objectForKey:@"Token"];
    if (ut && [ut length] > 0) {
        return YES;
    }
    return NO;
}

@end
