//
//  UIDevice+category.h
//  iLearning
//
//  Created by Sidney on 13-8-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFHFKeychainUtils.h"
#import "NSString+category.h"

@interface UIDevice (category)


/*
 * Available device memory in MB
 */
@property(readonly) double availableMemory;

//生成可变唯一ID
- (NSString *)stringWithUUID;

//设备唯一ID（生成UUID，保存在钥匙串）
- (NSString *)getDeviceUniqueID;

/**
 identifier for advertisers(广告主识别码)
 */
- (NSString *)getIDFAString;


@end
