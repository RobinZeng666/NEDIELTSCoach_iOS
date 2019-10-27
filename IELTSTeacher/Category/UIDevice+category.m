//
//  UIDevice+category.m
//  iLearning
//
//  Created by Sidney on 13-8-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UIDevice+category.h"
#import <AdSupport/ASIdentifierManager.h>
#include <sys/sysctl.h>
#include <mach/mach.h>


@implementation UIDevice (category)

- (double)availableMemory
{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) {
		return NSNotFound;
	}
	return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}


- (NSString *)getDeviceUniqueID
{
    NSString * bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString * uniqueID = [SFHFKeychainUtils getPasswordForUsername:@"uniqueID" andServiceName:bundleIdentifier error:NULL];
    
    if (!uniqueID) {
        uniqueID = [NSString stringWithFormat:@"%@%@",bundleIdentifier,[self stringWithUUID]];
        NSString * md5ID = [uniqueID stringFromMD5];
        [SFHFKeychainUtils storeUsername:@"uniqueID" andPassword:md5ID forServiceName:bundleIdentifier updateExisting:YES error:NULL];
        return md5ID;
    }
    return uniqueID;
}

- (NSString *)stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
    NSString * uuidString = [NSString stringWithString:(__bridge NSString*)strRef];
    CFRelease(strRef);
    CFRelease(uuidObj);
    return uuidString;
}

- (NSString *)getIDFAString
{
    NSString * adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId;
}

@end
