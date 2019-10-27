//
//  CollectTableViewCell.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "CollectTableViewCell.h"

@implementation CollectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    [self.contentView addSubview:self.lineImgView];
    
    WS(this_cell);
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell);
        make.left.mas_equalTo(63/3*AUTO_SIZE_SCALE_X);
    }];
    //标题
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell);
        make.left.mas_equalTo(this_cell.imgView.right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-80*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(this_cell.bottom);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //1、图片
    CHECK_DATA_IS_NSNULL(self.model.StorePoint, NSNumber);
    if ([[self.model.StorePoint stringValue] isEqualToString:@"1"]) {
        self.imgView.image = [UIImage imageNamed:@"personal_ziliao.png"];
    } else {
        self.imgView.image = [UIImage imageNamed:@"mycollection_shipin.png"];
    }
    
    //2、标题
    CHECK_STRING_IS_NULL(self.model.Name);
    self.titLabel.text = self.model.Name;
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
        _titLabel = [[UILabel alloc] init];
        _titLabel.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _titLabel;
}

- (UIImageView *)lineImgView
{
    if (!_lineImgView) {
        _lineImgView = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
    }
    return _lineImgView;
}

@end
