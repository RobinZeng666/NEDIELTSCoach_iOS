//
//  RemindTableViewCell.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "RemindTableViewCell.h"

@implementation RemindTableViewCell

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
    [self.contentView addSubview:self.localImgView];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.timeLabel];
    
    WS(this_cell);
    
    //添加约束
    //小圆圈
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((100-7)/2*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(7, 7));
    }];
    //标题
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(this_cell.imgView.right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
    }];
    //位置视图
    [self.localImgView updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titLabel.bottom).with.offset(5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(this_cell.imgView.right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9, 13));
    }];
    //位置
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titLabel.bottom).with.offset(5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(this_cell.localImgView.right).with.offset(5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    //日期
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(84/3*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    //具体时间
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.bottom).with.offset(0);
        make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //红圈
    CHECK_DATA_IS_NSNULL(self.model.ImgString, NSString);
    CHECK_STRING_IS_NULL(self.model.ImgString);
    self.imgView.image = [UIImage imageNamed:self.model.ImgString];

    //标题
    CHECK_STRING_IS_NULL(self.model.Title);
    self.titLabel.text = self.model.Title;
    CGFloat titleHeight = [CommentMethod widthForNickName:self.titLabel.text testLablWidth:200*AUTO_SIZE_SCALE_X textLabelFont:18.0].height;
    if (titleHeight > 30*AUTO_SIZE_SCALE_Y) {
        [self.titLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, titleHeight));
        }];
    } else {
        [self.titLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
        }];
    }
    
    //地点图片
    CHECK_DATA_IS_NSNULL(self.model.LocalImgName, NSString);
    CHECK_STRING_IS_NULL(self.model.LocalImgName);
    self.localImgView.image = [UIImage imageNamed:self.model.LocalImgName];
    
    //地点
    CHECK_DATA_IS_NSNULL(self.model.Location, NSString);
    CHECK_STRING_IS_NULL(self.model.Location);
    self.detailLabel.text = self.model.Location;
    
    CGFloat detailHeight = [CommentMethod widthForNickName:self.detailLabel.text testLablWidth:200*AUTO_SIZE_SCALE_X textLabelFont:16.0].height;
    if (detailHeight > 20*AUTO_SIZE_SCALE_Y) {
        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, detailHeight+20*AUTO_SIZE_SCALE_Y));
        }];
    } else {
        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
        }];
    }
    
    //2015-07-01
    CHECK_DATA_IS_NSNULL(self.model.dateTime, NSString);
    CHECK_STRING_IS_NULL(self.model.dateTime);
    self.dateLabel.text = self.model.dateTime;
    
    //am 9:00
    CHECK_DATA_IS_NSNULL(self.model.hourTime, NSString);
    CHECK_STRING_IS_NULL(self.model.hourTime);
    self.timeLabel.text = self.model.hourTime;
}

#pragma mark - setters and getters
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [CommentMethod createImageViewWithImageName:@"remind_hongdian.png"];
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

- (UIImageView *)localImgView
{
    if (!_localImgView) {
        _localImgView = [CommentMethod createImageViewWithImageName:@""];
    }
    return _localImgView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _detailLabel.textColor = [UIColor grayColor];
    }
    return _detailLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
        _dateLabel.textColor = k_PinkColor;
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
        _timeLabel.textColor = k_PinkColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

@end
