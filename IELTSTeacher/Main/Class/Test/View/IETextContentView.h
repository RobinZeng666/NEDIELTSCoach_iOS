//
//  IETextContentView.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/29.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IETextContentView : UIView
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UILabel *modelLabel;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *eachBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UITextField *timeText;
@property (nonatomic, strong) UILabel *completionLabel;
@property (nonatomic, strong) UITextField *completionText;

@property (nonatomic, strong) UILabel *minuteLabe;

@end
