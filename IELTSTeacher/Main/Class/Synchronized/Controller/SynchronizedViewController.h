//
//  SynchronizedViewController.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  同步学员完成页
 */
@interface SynchronizedViewController : BaseViewController

@property (nonatomic, copy)   NSString          *passCode;
@property (nonatomic, strong) NSString          *ccId;

@property (nonatomic, strong) NSMutableArray    *onlineList;
@property (nonatomic, strong) NSNumber          *totalCount;
@property (nonatomic, strong) NSNumber          *onLineCount;

@property (nonatomic, copy)   NSString          *activeClassId;

@property (nonatomic, assign) BOOL              isHere;//是否从同步学员界面进入
@end
