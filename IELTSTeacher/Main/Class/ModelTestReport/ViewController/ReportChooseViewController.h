//
//  ReportChooseViewController.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"
/**
 *  选择某个选项列表页
 */
@interface ReportChooseViewController : BaseViewController

@property (nonatomic,strong) NSArray *studentChooseList;//选择答案的学员列表
@property (nonatomic,copy) NSString *titleChoose; //标题

@end
