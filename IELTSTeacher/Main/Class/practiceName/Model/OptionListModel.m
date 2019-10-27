//
//  OptionListModel.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/31.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "OptionListModel.h"

@implementation OptionListModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"studentChooseList":[studentChooseListModel class]};
    
}

@end
