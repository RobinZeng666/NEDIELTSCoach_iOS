//
//  CBAccessoryView.m
//  customPickView
//
//  Created by citicbank on 14-10-1.
//  Copyright (c) 2014年 citicbank. All rights reserved.
//

#import "CBAccessoryView.h"
#define kToolBarHeight 44
#define kButtonWidth 50

@interface CBAccessoryView ()

@property (nonatomic, weak) id<CBAccessoryViewDelegate> accessoryDelegate;

@end

@implementation CBAccessoryView

- (id)initWithDelegate:(id<CBAccessoryViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        // Initialization code
        self.accessoryDelegate = delegate;
        self.frame = CGRectMake(0, 0, kScreenWidth, kToolBarHeight);
        self.backgroundColor = k_PinkColor;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(10, 0, 50, kToolBarHeight);
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(inputCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(kScreenWidth - 10 - kButtonWidth, 0, kButtonWidth, kToolBarHeight);
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(inputDone) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
    }
    return self;
}

- (void)inputCancel{
    if (_accessoryDelegate && [_accessoryDelegate respondsToSelector:@selector(accessoryViewDidPressedCancelButton:)]) {
        [_accessoryDelegate accessoryViewDidPressedCancelButton:self];
    }
}

- (void)inputDone{
    if (_accessoryDelegate && [_accessoryDelegate respondsToSelector:@selector(accessoryViewDidPressedDoneButton:)]) {
        [_accessoryDelegate accessoryViewDidPressedDoneButton:self];
    }
}
@end
