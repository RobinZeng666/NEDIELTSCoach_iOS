//
//  PracticeHeadView.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/5.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "PracticeHeadView.h"
#define k_IconWidth  (98/3*AUTO_SIZE_SCALE_X)
#define k_HEADViewHeight (61*AUTO_SIZE_SCALE_Y)
@interface PracticeHeadView()

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel     *nickName;
@property (nonatomic, strong) UIImageView *genderImgView;
@property (nonatomic, strong) UILabel     *sCodeString;
@property (nonatomic, strong) UILabel     *timeString;

@end

@implementation PracticeHeadView

- (instancetype)init
{
    if (self = [super init]) {
        [self _initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}


//初始化视图
- (void)_initView
{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.nickName];
    [self.bgView addSubview:self.genderImgView];
    [self.bgView addSubview:self.sCodeString];
    [self.bgView addSubview:self.timeString];
    
    WS(this_headview);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,k_HEADViewHeight-10*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo(10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(k_IconWidth, k_IconWidth));
        make.left.mas_equalTo(10*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_headview.bgView);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(this_headview.iconImgView.mas_right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_headview.bgView);
    }];
    
    [self.genderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_headview.nickName.mas_right).with.offset(5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(11*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_Y));
        make.centerY.mas_equalTo(this_headview.bgView);
    }];
    
    [self.sCodeString mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_headview.genderImgView.mas_right).with.offset(5*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
        make.centerY.mas_equalTo(this_headview.bgView);
    }];
    
    [self.timeString mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
        make.centerY.mas_equalTo(this_headview.bgView);
    }];

}
//更新数据
- (void)setHeaderModel:(HeadModel *)headerModel
{
    if (_headerModel != headerModel) {
        _headerModel = headerModel;
        //初始化数据
        [self _initDealData:headerModel];
    }

}

- (void)_initDealData:(HeadModel *)model
{
    //性别
    CHECK_DATA_IS_NSNULL(model.nGender, NSNumber);
    NSInteger ngender = [model.nGender integerValue];
    if (ngender == 1) {
        self.genderImgView.image = [UIImage imageNamed:@"checkList_nan.png"];
    }else if(ngender == 2) {
        self.genderImgView.image = [UIImage imageNamed:@"checkList_nv.png"];
    }
    CHECK_STRING_IS_NULL(model.sName);
    self.nickName.text = model.sName;
    
    CHECK_STRING_IS_NULL(model.sCode);
    self.sCodeString.text = model.sCode;
    
    CHECK_STRING_IS_NULL(model.CostTime);
    NSString *constTime = [NSString stringWithFormat:@"时间 %@",model.CostTime];
    self.timeString.text = constTime;
    CHECK_DATA_IS_NSNULL(self.headerModel.IconUrl, NSString);
    self.userIcon = self.headerModel.IconUrl;
    
    NSString *urlPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,self.userIcon];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:urlPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];

}

#pragma mark- set or get 
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [CommentMethod createImageViewWithImageName:@""];
        _iconImgView.layer.borderWidth = 1*AUTO_SIZE_SCALE_X;
        _iconImgView.layer.borderColor = [UIColor clearColor].CGColor;
        _iconImgView.layer.cornerRadius = k_IconWidth/2;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}
- (UIImageView *)genderImgView
{
    if (!_genderImgView) {
        _genderImgView = [CommentMethod createImageViewWithImageName:@""];
    }
    return _genderImgView;
}

- (UILabel *)nickName
{
    if (!_nickName) {
        _nickName = [CommentMethod createLabelWithFont:16.0f Text:@""];
    }
    return _nickName;
}
- (UILabel *)sCodeString
{
    if (!_sCodeString) {
        _sCodeString = [CommentMethod createLabelWithFont:15.0f Text:@""];
    }
    return _sCodeString;
}

- (UILabel *)timeString
{
    if (!_timeString) {
        _timeString = [CommentMethod createLabelWithFont:15.0f Text:@""];
    }
    return _timeString;
}



@end
