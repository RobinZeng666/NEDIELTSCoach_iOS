//
//  ReportChoseView.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 选择题
 */
@interface ReportChoseView : UIView

@property (nonatomic,strong) NSArray *optionArray;//
@property (nonatomic,assign) CGFloat stuAnswerTotalCount;//学生答案总数
@property (nonatomic,assign) NSInteger questionType; //类型

@property (nonatomic,copy) NSString *qsValue; //正确答案

@end
