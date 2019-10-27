//
//  IEPraTableViewCell.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/29.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IEPraTableViewCell.h"
@interface IEPraTableViewCell ()
@property (nonatomic,strong) UIImageView *lineImgView;

@end

@implementation IEPraTableViewCell

//通过纯代码创建
- (instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
//通过xib或是storyboard创建
- (id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [self.contentView addSubview:self.ctnLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.lineImgView];
}

- (void)layoutSubviews
{
    if (!_isFirst) {
        [self  addSub];
        _isFirst = YES;
    }
}

- (void)addSub{
    WS(this_cell);
    
    [self.ctnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.mas_left).with.offset(75/3*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(kScreenWidth-150*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_cell.contentView);
    }];
    //题目数量
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.contentView).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(-140/3*AUTO_SIZE_SCALE_X);
    }];
    //数值
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.contentView).with.offset(-10*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_cell.countLabel.centerX);
    }];

    [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(this_cell.bottom);
        make.left.right.mas_equalTo(0);
    }];
}

#pragma mark - setters and getters
- (UILabel *)ctnLabel{
    if (!_ctnLabel) {
        _ctnLabel = [[UILabel alloc]init];//[CommentMethod createLabelWithFont:16*AUTO_SIZE_SCALE_X Text:@""];
        _ctnLabel.font = [UIFont systemFontOfSize:16.0*AUTO_SIZE_SCALE_X];
        _ctnLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _ctnLabel;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [CommentMethod createLabelWithFont:22 Text:@""];
        _numberLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}
- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [CommentMethod createLabelWithFont:13 Text:@"题目数量"];
        _countLabel.textColor = [CommentMethod colorFromHexRGB:@"a9a9a9"];
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

- (UIImageView *)lineImgView
{
    if (!_lineImgView) {
        _lineImgView = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
    }
    return _lineImgView;
}

@end
