//
//  studentChooseListModel.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/31.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "studentChooseListModel.h"

@implementation studentChooseListModel
- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    self.QSValues = [dataDic objectForKey:@"QSValue"];
    
}

@end
