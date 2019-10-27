//
//  StudentClassTableViewCell.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/23.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "StudentClassTableViewCell.h"

@implementation StudentClassTableViewCell

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
    
    WS(this_cell);
    
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_cell);
//        make.centerY.mas_equalTo(this_cell);
        make.top.mas_equalTo(12*AUTO_SIZE_SCALE_Y);
        make.height.mas_equalTo(20*AUTO_SIZE_SCALE_Y);
    }];
}

#pragma mark - event response
#pragma mark - private methods
#pragma mark - getters and setters
- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [CommentMethod createLabelWithFont:17.0f Text:@""];
        _titLabel.textColor = [CommentMethod colorFromHexRGB:@"c4c4c4"];
    }
    return _titLabel;
}

@end
