//
//  VoteHistoryModel.m
//  IELTSTeacher
//
//  Created by Newton on 15/10/21.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "VoteHistoryModel.h"
#import "VoteHistorySelectModel.h"
@implementation VoteHistoryModel

//告诉框架 AccuracyStudentChooseList这个数组存放什么模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"opts":[VoteHistorySelectModel  class]};
}


@end
