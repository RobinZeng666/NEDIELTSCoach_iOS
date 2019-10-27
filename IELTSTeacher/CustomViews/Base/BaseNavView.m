//
//  BaseNavView.m
//  newTestDemo
//
//  Created by Hello酷狗 on 15/5/22.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseNavView.h"

#define   kScreenHeight [UIScreen mainScreen].bounds.size.height
#define   kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface BaseNavView()

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation BaseNavView

- (instancetype)init
{
    if (self = [super init]) {
        //初始化视图
        [self _initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}

//初始化视图
- (void)_initView
{
   //创建标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_8];
    titleLabel.font = [UIFont boldSystemFontOfSize:k_Font_1*AUTO_SIZE_SCALE_X];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        [self setNeedsLayout];
    }
}
//
- (void)layoutSubviews
{
    [super layoutSubviews];

    self.titleLabel.frame = CGRectMake((kScreenWidth-220*AUTO_SIZE_SCALE_X)/2, 20, 220*AUTO_SIZE_SCALE_X, 44);
    self.titleLabel.text = _title;

}




@end
