//
//  WillGroupListViewController.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

@interface WillGroupListViewController : BaseViewController

@property (nonatomic, copy) NSString *groupNum;
@property (nonatomic, copy) NSString *passCode;
@property (nonatomic, copy) NSString *activeClassId;

@property (nonatomic, copy) NSString *groupCnt;//分组数
@property (nonatomic, copy) NSString *groupMode;//分组规则

@property (nonatomic, assign) int indexRow;//某行

@end
