//
//  IETextTableViewCell.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/29.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IETextTableViewCell.h"

@implementation IETextTableViewCell
@synthesize renderedMark = _renderedMark;
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

- (void)setUp{

    [self.contentView  addSubview:self.label];
    [self.contentView  addSubview:self.selectImage];
    [self.contentView addSubview:self.lineImgView];
}

- (void)layoutSubviews{
    if (!_isFirst) {
        [self  addSub];
        
        _isFirst = YES;
    }
}
- (void)addSub{
    WS(this_cell);
    [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(69/3*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_cell);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.selectImage.right).with.offset(9*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(kScreenWidth-80*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_cell);
    }];
    [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(this_cell.bottom);
        make.left.mas_equalTo(22/3*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(-22/3*AUTO_SIZE_SCALE_X);
    }];
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.selectImage.image = (isSelected)?_renderedMark : nil;
    if (isSelected) {
        self.selectImage.image = [UIImage imageNamed:@"allSubmit_xuanzgibf.png"];
    }else{
        self.selectImage.image = [UIImage imageNamed:@"allSubmit_hongquan.png"];
    }
}

#pragma mark - getters and setters
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _label.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
    }
    return _label;
}

- (UIImageView *)selectImage{
    if (!_selectImage) {
        _selectImage = [[UIImageView alloc]init];
        _selectImage = [CommentMethod createImageViewWithImageName:@"allSubmit_hongquan.png"];
    }
    return _selectImage;
}

- (UIImageView *)lineImgView
{
    if (!_lineImgView) {
        _lineImgView = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
    }
    return _lineImgView;
}

@end
