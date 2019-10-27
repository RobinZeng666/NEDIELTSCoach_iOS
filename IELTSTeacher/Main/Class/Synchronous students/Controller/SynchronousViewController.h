//
//  SynchronousViewController.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/23.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  同步学员首页
 */
@interface SynchronousViewController : BaseViewController

@property(nonatomic,strong)NSString *ccId;
//暗号
@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,strong)NSNumber *passCode;
@end
