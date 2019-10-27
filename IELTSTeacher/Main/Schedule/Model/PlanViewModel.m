//
//  PlanViewModel.m
//  IELTSStudent
//
//  Created by DevNiudun on 15/6/22.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "PlanViewModel.h"

@implementation PlanViewModel

- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    
    self.ids = [dataDic objectForKey:@"id"];
}

@end
