//
//  GradeIConView.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/30.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeIConView.h"

#define iconWidth 57*AUTO_SIZE_SCALE_X
@interface GradeIConView()

@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel     *nickLabel;
//@property (nonatomic,strong) UILabel     *teachLabel;

@end

@implementation GradeIConView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    [self addSubview:self.iconImgView];
    [self addSubview:self.nickLabel];
//    [self addSubview:self.teachLabel];

    WS(this_gradeView);
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
        make.top.mas_equalTo(10*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_gradeView);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(iconWidth);
        make.top.mas_equalTo(this_gradeView.iconImgView.mas_bottom).with.offset(5*AUTO_SIZE_SCALE_X);
        make.centerX.mas_equalTo(this_gradeView);
    }];
    
//    [self.teachLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(iconWidth, 20*AUTO_SIZE_SCALE_X));
//        make.top.mas_equalTo(this_gradeView.nickLabel.mas_bottom);
//        make.centerX.mas_equalTo(this_gradeView);
//    }];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CHECK_STRING_IS_NULL(self.iconString);
    NSURL *url = [NSURL URLWithString:self.iconString];
    [self.iconImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    
    CHECK_STRING_IS_NULL(self.nickName);
    self.nickLabel.text = self.nickName;
    
//    CHECK_STRING_IS_NULL(self.teacherType);
//    self.teachLabel.text = self.teacherType;
    
}


#pragma mark - set or get
- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [CommentMethod createImageViewWithImageName:@"person_default.png"];
        _iconImgView.layer.cornerRadius = iconWidth/2;
        _iconImgView.layer.borderWidth = 1;
        _iconImgView.layer.borderColor = [UIColor clearColor].CGColor;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.font = [UIFont systemFontOfSize:14.0f*AUTO_SIZE_SCALE_X];
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        _nickLabel.textColor=[UIColor darkGrayColor];
    }
    return _nickLabel;
}

//- (UILabel *)teachLabel
//{
//    if (!_teachLabel) {
//        _teachLabel = [CommentMethod createLabelWithFont:13.0f Text:@"写作老师"];
//        _teachLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _teachLabel;
//}


@end
