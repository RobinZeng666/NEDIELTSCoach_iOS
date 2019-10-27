//
//  DefaultView.m
//  IELTSStudent
//
//  Created by DevNiudun on 15/7/30.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "DefaultView.h"
@interface DefaultView()

@property (nonatomic,strong) UIImageView *iconView;//默认图
@property (nonatomic,strong) UILabel *titleLabel; //文字提示

@end

@implementation DefaultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGRect supFrame = CGRectMake(frame.origin.x, frame.origin.y, kScreenWidth, 100*AUTO_SIZE_SCALE_Y);
    [super setFrame:supFrame];
}


//初始化视图
-(void)_initView
{
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
    WS(this_defaultView); //80 × 60
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_defaultView);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo(20*AUTO_SIZE_SCALE_Y).with.offset(-10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_defaultView);
        make.top.mas_equalTo(this_defaultView.iconView.mas_bottom).with.offset(5);
    }];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CHECK_STRING_IS_NULL(self.tipTitle);
    if (![self.tipTitle isEqualToString:@""]) {
        self.titleLabel.text = self.tipTitle;
    }
}

#pragma mark - set or get
- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [CommentMethod createImageViewWithImageName:@"none_moren.png"];
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}



@end
