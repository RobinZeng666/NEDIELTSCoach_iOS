//
//  ChatImageViewController.m
//  IELTSStudent
//
//  Created by Newton on 15/9/1.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ChatImageViewController.h"
#import "BaseNavView.h"

@interface ChatImageViewController ()

@end

@implementation ChatImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
    [self.view addGestureRecognizer:tap];
    self.view.userInteractionEnabled = YES;
}


#pragma mark - 返回事件
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
