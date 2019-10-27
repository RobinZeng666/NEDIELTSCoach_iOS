//
//  GradeCheckModel.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/10.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeCheckModel.h"

@implementation GradeCheckModel

- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    
    self.ids = [dataDic objectForKey:@"id"];
}

@end
