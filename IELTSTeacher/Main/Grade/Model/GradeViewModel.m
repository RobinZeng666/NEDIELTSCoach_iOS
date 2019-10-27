//
//  GradeViewModel.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/7.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeViewModel.h"

@implementation GradeViewModel

- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    self.ids = [dataDic objectForKey:@"id"];
}

@end
