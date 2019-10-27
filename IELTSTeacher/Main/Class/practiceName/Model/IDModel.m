//
//  IDModel.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/31.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IDModel.h"

@implementation IDModel
//告诉框架 AccuracyStudentChooseList这个数组存放什么模型
+ (NSDictionary *)objectClassInArray{
    
    return @{@"AccuracyStudentChooseList":[AccListModel  class],@"optionList":[OptionListModel class]};
    
}

@end
