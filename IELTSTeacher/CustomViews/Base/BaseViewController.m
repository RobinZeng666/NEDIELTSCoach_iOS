//
//  BaseViewController.m
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/4.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

-(instancetype)init
{
    if (self = [super init]) {
        [self _initParam];
    }
    return self;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _initParam];
    }
    return self;
}
/**
 *  初始化参数
 */
- (void)_initParam
{
    self.hidesBottomBarWhenPushed = YES;
    self.isModalButton = NO;
    self.isBackButton = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //设置背景
    self.view.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
    
    BaseNavView *navView = [[BaseNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    self.navView = navView;
    [self.view addSubview:navView];
    
    
    //创建装饰线
    UIImageView *lineImg = [CommentMethod createImageViewWithImageName:@"mainTab_navLine.png"];
    [self.navView addSubview:lineImg];
    
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@kNavHeight);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
    }];
    

    
    if (self.navigationController.viewControllers.count > 1 || self.isModalButton) {
        //创建返回的按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.showsTouchWhenHighlighted = YES;
//        [button setImage:[UIImage imageNamed:@"maintab_back.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"maintab_backdianjih.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(5, 20, 44, 44);  //125 × 49
        
        [navView addSubview:button];
        self.backButton = button;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hideHud];
}


#pragma mark - Set
- (void)setTitles:(NSString *)titles
{
    if (_titles != titles) {
        _titles = titles;
        self.navView.title = titles;
    }
}


#pragma mark - 返回事件
- (void)backAction
{
    if (self.isModalButton) //present弹出视图的返回
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
        
    }else //push的返回
    {
        [self.navigationController popViewControllerAnimated:YES];
    }


}

@end
