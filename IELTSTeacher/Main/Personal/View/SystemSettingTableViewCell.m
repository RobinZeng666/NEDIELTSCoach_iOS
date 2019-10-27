//
//  SystemSettingTableViewCell.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/23.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "SystemSettingTableViewCell.h"

@implementation SystemSettingTableViewCell

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
    [self.contentView addSubview:self.titLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.lineImgView];
    
    WS(this_cell);
    
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell);
        make.left.mas_equalTo(20*AUTO_SIZE_SCALE_X);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell);
        make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
    }];
    
    [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(this_cell.bottom);
        make.left.right.mas_equalTo(0);
    }];
}

#pragma mark - event response
#pragma mark - private methods
#pragma mark - getters and setters
- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_8];
    }
    return _titLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [CommentMethod createLabelWithFont:k_Font_2 Text:@""];
        _detailLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_8];
    }
    return _detailLabel;
}

- (UIImageView *)lineImgView
{
    if (!_lineImgView) {
        _lineImgView = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
    }
    return _lineImgView;
}

@end
