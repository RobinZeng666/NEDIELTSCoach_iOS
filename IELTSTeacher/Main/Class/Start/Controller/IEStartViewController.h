//
//  IEStartViewController.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/2.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  开始答题页面
 */
@interface IEStartViewController : BaseViewController

@property (nonatomic,copy) NSString *questionString;
@property (nonatomic,strong) UIButton *Btn;
//@property (nonatomic,copy) NSString *str;
@property (nonatomic,assign) BOOL isAll;
@property (nonatomic,assign) BOOL isAlone;
/**
 *  课次ID
 */
@property (nonatomic,copy) NSString *ccId;
//试卷id
@property (nonatomic,strong) NSNumber *paperId;
@property (nonatomic,copy) NSString *paperSubmitMode;
//教师选中的试题id集合
@property (nonatomic,strong) NSMutableArray *qids;
@property (nonatomic,copy) NSString *nameText;
@end
