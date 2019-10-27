//
//  CustomAlertView.h
//  IELTSStudent
//
//  Created by DevNiudun on 15/7/25.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ShowAlertBlock)();
typedef void(^ConfirmBlock)();

@interface CustomAlertView : NSObject
//创建
+ (instancetype)sharedAlertView;
//关闭和显示
- (void)showAlert;
- (void)shutAlert;

@property (nonatomic,copy) ShowAlertBlock showBlock; //显示
@property (nonatomic,copy) ConfirmBlock confirmBlock; //确定


/*
    创建正在建设中的alert
 */
- (void)creatAlertView;




@end
