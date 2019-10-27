//
//  ReportVerticalView.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ReportVerticalView.h"

#define k_wrongColor RGBACOLOR(154, 154, 154, 1)
@implementation ReportVerticalView

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
    perLabel.text = [NSString stringWithFormat:@"%d%%",100-i*10];
    perLabel.textColor = k_wrongColor;
    perLabel.font = [UIFont systemFontOfSize:9*AUTO_SIZE_SCALE_X];
    perLabel.textAlignment = NSTextAlignmentCenter;
    [self  addSubview:perLabel];
}@end
