//
//  FileTableViewCell.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/18.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "FileTableViewCell.h"

@implementation FileTableViewCell

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
    self.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titLabel];
    [self.contentView addSubview:self.verImgView];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.lineImgView];
 
    WS(this_cell);
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(68/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(60/3*AUTO_SIZE_SCALE_X);
    }];
    
    [self.verImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_cell).with.offset(63/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.titLabel.right).with.offset(5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(4/3, 53/3*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.verImgView.right).with.offset(5*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_cell).with.offset(63/3*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(60*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(20*AUTO_SIZE_SCALE_Y);
    }];
    //日期
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titLabel.left);
        make.top.mas_equalTo(self.titLabel.bottom).with.offset(0);
        make.width.mas_equalTo(100*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(20*AUTO_SIZE_SCALE_Y);
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
    CHECK_STRING_IS_NULL(self.model.name);
    self.titLabel.text = self.model.name;
    
    CGSize titLabelSize = [CommentMethod widthForNickName:self.titLabel.text testLablWidth:860/3.0 textLabelFont:18.0];
    if (titLabelSize.width <= 265*AUTO_SIZE_SCALE_X) {
        self.titLabel.frame = CGRectMake(55*AUTO_SIZE_SCALE_X, 60/3*AUTO_SIZE_SCALE_Y, (titLabelSize.width+5), 20*AUTO_SIZE_SCALE_Y);
    } else {
        self.titLabel.frame = CGRectMake(55*AUTO_SIZE_SCALE_X, 60/3*AUTO_SIZE_SCALE_Y, 265*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y);
    }
    
    //3、个人/集团
    CHECK_DATA_IS_NSNULL(self.model.RoleID, NSNumber);
    if ([[self.model.RoleID stringValue] isEqualToString:@"1"]) {
        self.detailLabel.text = @"集团";
    } else {
        self.detailLabel.text = @"个人";
    }
    
    //4、创建时间
    CHECK_STRING_IS_NULL(self.model.createtime);
    self.dateLabel.text = self.model.createtime;
}

#pragma mark - setters and getters
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [CommentMethod createImageViewWithImageName:@"personal_ziliao.png"];
    }
    return _imgView;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [[UILabel alloc] init];
        _titLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
        _titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_8];
    }
    return _titLabel;
}

- (UIImageView *)verImgView
{
    if (!_verImgView) {
        _verImgView = [CommentMethod createImageViewWithImageName:@""];
        _verImgView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _verImgView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [CommentMethod createLabelWithFont:k_Font_2 Text:@""];
        _detailLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_8];
    }
    return _detailLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [CommentMethod createLabelWithFont:k_Font_6 Text:@""];
        _dateLabel.textColor = [CommentMethod colorFromHexRGB:@"acacac"];
    }
    return _dateLabel;
}

- (UIImageView *)lineImgView
{
    if (!_lineImgView) {
        _lineImgView = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
    }
    return _lineImgView;
}
@end
