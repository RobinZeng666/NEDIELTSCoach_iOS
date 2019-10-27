//
//  RemindCell.m
//  IELTSStudent
//
//  Created by DevNiudun on 15/6/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "RemindCell.h"

@implementation RemindCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titLabel];
    [self.contentView addSubview:self.detailLabel];
    //    [self.contentView addSubview:self.lineImgView];
    [self.contentView addSubview:self.accessoryImgView];
    
    WS(this_cell);
    
    //图片
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell);
        make.left.mas_equalTo(18*AUTO_SIZE_SCALE_X);
    }];
    //标题
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell);
        make.left.mas_equalTo(this_cell.imgView.right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
    }];
    //副标题
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-30*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(200*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
        make.centerY.equalTo(this_cell);
    }];
    
    //右侧accessory
    [self.accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell);
        make.right.mas_equalTo(-10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(8*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_Y));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - setters and getters
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [CommentMethod createImageViewWithImageName:@""];
    }
    return _imgView;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
        _titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _titLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _detailLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}

- (UIImageView *)accessoryImgView
{
    if (!_accessoryImgView) {
        _accessoryImgView = [CommentMethod createImageViewWithImageName:@"Student_jiantou.png"];
    }
    return _accessoryImgView;
}

@end
