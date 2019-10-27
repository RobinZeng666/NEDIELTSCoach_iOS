//
//  NewsTableViewCell.m
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/15.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

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
        //初始化视图
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    [self.contentView addSubview:self.titLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.lineImgView];
    
    WS(this_cell);
    
    //标题
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    //日期
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_cell.titLabel.bottom).with.offset(0);
        make.left.mas_equalTo(this_cell.titLabel.left);
        make.height.mas_equalTo(20*AUTO_SIZE_SCALE_Y);
    }];
    //线
    [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(this_cell.bottom);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /**
     *
     MI_ID =消息ID;
        Title =标题;
        Body =内容;
        CreateTime =创建时间;
        AssignRoleID =指派角色;
        MState =状态 0未发布1已发布;
        Account =账号名称
        MR_ID =已读信息ID
     */
    
    //标题
    CHECK_DATA_IS_NSNULL(self.model.Title, NSString);
    _titLabel.text = self.model.Title;

    //日期
    CHECK_DATA_IS_NSNULL(self.model.CreateTime, NSString);
    _dateLabel.text = self.model.CreateTime;
    
    //设置颜色
    CHECK_DATA_IS_NSNULL(self.model.MR_ID, NSNumber);
    int mr_ID = [self.model.MR_ID intValue];
    if (mr_ID == 0) {
        //空:未读
        _titLabel.textColor = k_PinkColor;
        _dateLabel.textColor = k_PinkColor;
    } else {
        //非空:已读
        _titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_4];
        _dateLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_4];
    }
}

#pragma mark - event response
#pragma mark - private methods
- (void)modifyButtonAction:(UIButton *)button
{
    NDLog(@"修改button");
}

#pragma mark - getters and setters
- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _titLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [CommentMethod createLabelWithFont:14.0f Text:@""];
        _dateLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_4];
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
