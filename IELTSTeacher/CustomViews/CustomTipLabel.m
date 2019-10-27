//
//  CustomTipLabel.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/12.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "CustomTipLabel.h"

#define TIP_LABEL_TAG 0x00ff
@implementation CustomTipLabel

- (id)init
{
    self = [super initWithFrame:CGRectMake(kScreenWidth / 2, kScreenHeight - 200, 100, 35)];
    if (self) {
        // Initialization code
        self.numberOfLines = 8;
    }
    return self;
}

- (CGSize)getSizeOfStr:(NSString *)str font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth - 40 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    
    //    CGSize size = [str sizeWithFont:font
    //                  constrainedToSize:CGSizeMake(280 , MAXFLOAT)];
    return rect.size;
}


- (void)showToastWithMessage:(NSString *)message showTime:(float)time
{
    UILabel * label = (UILabel *)[APP_DELEGATE.window viewWithTag:TIP_LABEL_TAG];
    [label removeFromSuperview];
    
    self.tag = TIP_LABEL_TAG;
    CGSize size = [self getSizeOfStr:message font:[UIFont systemFontOfSize:16.0f*AUTO_SIZE_SCALE_X]];
    
//    self.font = [UIFont systemFontOfSize:16.0f*AUTO_SIZE_SCALE_X];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9f];
//    self.textAlignment = NSTextAlignmentLeft;
//    self.textColor = [UIColor whiteColor];
    
    self.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.layer.shadowOpacity = 4.0;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    float width = (size.width + 20);
    float height = (size.height + 12);
    float offsetY = 100;
    width = (width > (kScreenWidth-40)) ? (kScreenWidth - 40) : width;
    
    self.frame = CGRectMake((kScreenWidth - width) / 2, kScreenHeight - offsetY - height, width, height);
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, self.frame.size.width-20*AUTO_SIZE_SCALE_X, height)];
    messageLabel.text = message;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:16.0f*AUTO_SIZE_SCALE_X];
    messageLabel.numberOfLines = 8;
    [self addSubview:messageLabel];
//    self.text = message;
    
    //        [APP_DELEGATE.window.rootViewController.view addSubview:self];
    
    if (IS_IOS_8) {
        NSArray *arr = [UIApplication sharedApplication].windows;
        if(arr.count > 1){
            UIWindow *win = [arr objectAtIndex:1];
            [win addSubview:self];
        }
        else if(arr.count > 0){
            UIWindow *win = [arr objectAtIndex:0];
            [win addSubview:self];
        }
        else{
            [APP_DELEGATE.window addSubview:self];
            [APP_DELEGATE.window bringSubviewToFront:self];
        }
    }else{
        [APP_DELEGATE.window addSubview:self];
        [APP_DELEGATE.window bringSubviewToFront:self];
    }
    
    [self performSelector:@selector(removeTipMessageLabel) withObject:nil afterDelay:time];
}

- (void)removeTipMessageLabel
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         self.alpha = 1;
                     }];
}


@end
