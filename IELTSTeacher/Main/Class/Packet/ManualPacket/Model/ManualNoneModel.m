//
//  ManualNoneModel.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/23.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ManualNoneModel.h"

@implementation ManualNoneModel

- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    
    self.idStr = [dataDic objectForKey:@"id"];
}

@end
