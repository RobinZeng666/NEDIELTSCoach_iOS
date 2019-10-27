//
//  AccListModel.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/8/7.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "AccListModel.h"

@implementation AccListModel
- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    self.QSValues = [dataDic objectForKey:@"QSValue"];
    
}

@end
