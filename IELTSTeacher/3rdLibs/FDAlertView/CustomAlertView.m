//
//  CustomAlertView.m
//  IELTSStudent
//
//  Created by DevNiudun on 15/7/25.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "CustomAlertView.h"
#import "FDAlertView.h"

#define k_AlertWidth  310*AUTO_SIZE_SCALE_X
#define k_AlertHeight 250*AUTO_SIZE_SCALE_X

@interface CustomAlertView()

@property (nonatomic,strong) FDAlertView *alertView; //弹出框
@property (nonatomic,strong) UIView       *bgView; //背景视图

@end

@implementation CustomAlertView

+ (instancetype)sharedAlertView
{
    static CustomAlertView *alert = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        alert = [[CustomAlertView alloc] init];
    });
    return alert;
}

#pragma mark - 创建类型类型
//关闭按钮的位置
- (void)_initView
{
    UIButton *shutBt = [CommentMethod createButtonWithImageName:@"classRoom_guanbi_dianji.png" Target:self Action:@selector(shutAlertView) Title:@""];
    shutBt.frame = CGRectMake(k_AlertWidth-(24+21)*AUTO_SIZE_SCALE_X, 0, 21*AUTO_SIZE_SCALE_X, 33*AUTO_SIZE_SCALE_X);
    [self.bgView addSubview:shutBt];
}
//创建弹出视图
- (void)creatAlertView
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"building_default.png"]];
    imageView.frame = CGRectMake(0, 0, k_AlertWidth, k_AlertHeight);
    [self.bgView addSubview:imageView];
    
    UILabel *label = [CommentMethod createLabelWithFont:18.0f Text:@"正在建设中..."];
    label.frame = CGRectMake(20, k_AlertHeight-50, 150, 30);
    label.textColor = k_PinkColor;
    [self.bgView addSubview:label];
    //创建关闭按钮
    [self _initView];
    
    self.alertView.contentView = self.bgView;
}

#pragma mark - event response
- (void)shutAlertView
{
    [self.alertView hide];
    self.bgView.hidden = YES;
    [self.bgView removeFromSuperview];
    self.bgView = nil;

}



#pragma mark - 显示和关闭
- (void)showAlert
{
    [self.alertView show];
}
- (void)shutAlert
{
    [self.alertView hide];
    self.bgView.hidden = YES;
    [self.bgView removeFromSuperview];
    self.bgView = nil;
}




#pragma mark - set or get 
- (FDAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[FDAlertView alloc]init]; //311*250
        _alertView.frame = CGRectMake(0,0 , kScreenWidth, kScreenHeight);
    }
    return _alertView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.frame = CGRectMake((kScreenWidth-k_AlertWidth)/2,(kScreenHeight-k_AlertHeight)/2 , k_AlertWidth, k_AlertHeight);
        _bgView.backgroundColor = [UIColor clearColor];

    }
    return _bgView;
}



@end
