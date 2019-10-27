//
//  IEClassTableViewCell.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/6.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IEClassTableViewCell.h"

@implementation IEClassTableViewCell
+ (instancetype)cellWithClass:(UITableView *)tabelView{
static NSString * ID = @"cell";
    IEClassTableViewCell * cell = [tabelView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[IEClassTableViewCell  alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super  initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSub];
    }
    return self;
}

- (void)addSub{
    [self addSubview:self.didButton];
    [self addSubview:self.contentLabel];
    [self addSubview:self.codeLabel];
    [self addSubview:self.classCodeLabel];
    WS(this_cell);
    [self.didButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.mas_left).with.offset(25*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_cell);
        make.width.mas_equalTo(25*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(25*AUTO_SIZE_SCALE_X);
        
    }];
    [self.codeLabel   mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.didButton.mas_right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_cell.mas_centerY).with.offset(-10*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(this_cell.classCodeLabel.mas_left);
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.mas_centerY).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(this_cell.codeLabel);
        make.right.mas_equalTo(this_cell.classCodeLabel.mas_left);
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
    }];
    [self.classCodeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(this_cell.mas_right).with.offset(-20*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_cell.codeLabel.top);
        make.width.mas_equalTo(60*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
    }];

}
#pragma mark--get方法
- (UIButton *)didButton
{
    if (!_didButton) {
        _didButton = [[UIButton  alloc]init];
        [_didButton  setImage:[UIImage imageNamed:@"buttonnomal"] forState:UIControlStateNormal];
        [_didButton  setImage:[UIImage imageNamed:@"buttonselect"] forState:UIControlStateSelected];
        _didButton.layer.cornerRadius = 25*AUTO_SIZE_SCALE_X/2;
        _didButton.layer.masksToBounds = YES;
    }
    return _didButton;
}
- (UILabel *)codeLabel
{
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc]init];
        _codeLabel.font = [UIFont  systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        _codeLabel.numberOfLines = 0;
        _codeLabel.textColor = [UIColor darkGrayColor];
    }
    return _codeLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel  alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor darkGrayColor];
    }
    return _contentLabel;
}
- (UILabel *)classCodeLabel{
    if (!_classCodeLabel) {
        _classCodeLabel = [[UILabel alloc]init];
        _classCodeLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        _classCodeLabel.textColor = [UIColor darkGrayColor];
    }
    return _classCodeLabel;
}
@end
