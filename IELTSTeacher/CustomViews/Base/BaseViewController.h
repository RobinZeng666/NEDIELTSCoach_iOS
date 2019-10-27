//
//  BaseViewController.h
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/4.
//  Copyright (c) 2015年 xdf. All rights reserved.
//


/**
 *  描述:UIViewController的基类
 */
#import <UIKit/UIKit.h>
#import "BaseNavView.h"

@interface BaseViewController : UIViewController

@property(nonatomic,assign)BOOL isBackButton; //push
@property(nonatomic,assign)BOOL isModalButton;//present
@property (nonatomic,copy) NSString *titles;  //标题
@property (nonatomic,strong) BaseNavView *navView;

@property (nonatomic,strong)UIButton *backButton;
- (void)backAction;


@end
