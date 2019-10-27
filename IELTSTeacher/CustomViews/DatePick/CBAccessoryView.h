//
//  CBAccessoryView.h
//  customPickView
//
//  Created by citicbank on 14-10-1.
//  Copyright (c) 2014年 citicbank. All rights reserved.
//
//  时间辅助视图
#import <UIKit/UIKit.h>
@protocol CBAccessoryViewDelegate;

@interface CBAccessoryView : UIView
- (id)initWithDelegate:(id<CBAccessoryViewDelegate>)delegate;
@end


@protocol CBAccessoryViewDelegate <NSObject>

@optional
- (void)accessoryViewDidPressedCancelButton:(CBAccessoryView *)view;
- (void)accessoryViewDidPressedDoneButton:(CBAccessoryView *)view;

@end