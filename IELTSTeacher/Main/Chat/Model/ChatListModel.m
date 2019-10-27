//
//  ChatListModel.m
//  IELTSStudent
//
//  Created by DevNiudun on 15/10/16.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ChatListModel.h"
#import "ChatListPersonModel.h"

@implementation ChatListModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"members":[ChatListPersonModel  class]};
}


@end
