//
//  GradeExerciseViewController.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  课堂练习列表
 */
@interface IEPracticeViewController : BaseViewController

@property (nonatomic,copy) NSString *ccId;
@property (nonatomic,copy) NSString *passCode;
@property (nonatomic,strong) UITableView *tableView;

@end
