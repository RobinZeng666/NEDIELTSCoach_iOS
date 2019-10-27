//
//  CustomTipLabel.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/12.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTipLabel : UILabel
- (id)init;
- (void)showToastWithMessage:(NSString *)message showTime:(float)time;
@end
