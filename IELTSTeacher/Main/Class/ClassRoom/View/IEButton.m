//
//  IEButton.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/20.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IEButton.h"
@implementation IEButton
//通过纯代码创建
- (instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
//通过xib或是storyboard创建
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    // 设置图片居中
    self.imageView.contentMode = UIViewContentModeCenter;
    // 设置标题居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 设置文字字体大小
    self.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    
    // 设置按钮标题颜色
    [self setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageX = 0;
    CGFloat imageY = contentRect.size.height * 0.2;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * 0.4;
    
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * 0.5;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height *0.4;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
