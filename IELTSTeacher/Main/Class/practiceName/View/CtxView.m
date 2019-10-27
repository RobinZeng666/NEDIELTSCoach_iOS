//
//  CtxView.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/18.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "CtxView.h"

@implementation CtxView
#define k_wrongColor RGBACOLOR(154, 154, 154, 1)

- (void)drawRect:(CGRect)rect{
    
    for (int i = 0; i < 10; i++) {
        CGFloat margins = self.bounds.size.height/11;
        CGFloat subX = self.bounds.size.width;

        //1.获取图形上下文
        CGContextRef ctx1 = UIGraphicsGetCurrentContext();
        //2.绘图
        UIColor *aColor = [UIColor lightGrayColor];
        CGContextSetFillColorWithColor(ctx1, aColor.CGColor);//颜色
        CGContextSetLineWidth(ctx1, 0.5*AUTO_SIZE_SCALE_X);
        CGContextMoveToPoint(ctx1, subX -3, (i+1)*margins);
        CGContextAddLineToPoint(ctx1, subX ,(i+1)*margins);
        //3.渲染
        CGContextStrokePath(ctx1);
        [self addSub:i];
    }
    
}
- (void)addSub:(int)i{
    CGFloat margins = self.bounds.size.height/11;
    CGFloat subX = self.bounds.size.width;
    UILabel *perLabel = [[UILabel alloc]init];
    CGFloat X = 0;
    CGFloat W = subX - 5*AUTO_SIZE_SCALE_X;
    CGFloat Y = (i+1)*margins - margins/2;
    CGFloat H = margins;
    perLabel.frame = CGRectMake(X, Y, W, H);
    if (i == 0) {
       perLabel.text = @"100%";
    }else if (i == 1){
       perLabel.text = @"90%";
    }else if (i == 2){
       perLabel.text = @"80%";
    }else if (i == 3){
       perLabel.text = @"70%";
    }else if (i == 4){
       perLabel.text = @"60%";
    }else if (i == 5){
       perLabel.text = @"50%";
    }else if (i == 6){
       perLabel.text = @"40%";
    }else if (i == 7){
       perLabel.text = @"30%";
    }else if (i == 8){
       perLabel.text = @"20%";
    }else if (i == 9){
       perLabel.text = @"10%";
    }
    perLabel.textColor = k_wrongColor;
    perLabel.font = [UIFont systemFontOfSize:9*AUTO_SIZE_SCALE_X];
    perLabel.textAlignment = NSTextAlignmentCenter;
    [self  addSubview:perLabel];
}
@end
