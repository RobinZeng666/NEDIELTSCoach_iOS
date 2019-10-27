//
//  IESynchronousModel.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/1.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IESynchronousModel.h"

@implementation IESynchronousModel
- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    self.ids = [dataDic objectForKey:@"id"];
    
}
@end
