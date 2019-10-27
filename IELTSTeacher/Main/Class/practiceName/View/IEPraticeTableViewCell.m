//
//  IEStartTableViewCell.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/3.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IEPraticeTableViewCell.h"
@interface IEPraticeTableViewCell ()
@end
@implementation IEPraticeTableViewCell

+ (instancetype)cellWithstartTabelView:(UITableView *)tabelView{

    static NSString *ID = @"status";
    IEPraticeTableViewCell *cell = [tabelView  dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[IEPraticeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self  addSub];
    }
    return self;
}
#define marginX 10*AUTO_SIZE_SCALE_X
- (void)addSub{
    [self  addSubview:self.imgView];
    [self  addSubview:self.nameLabel];
    [self  addSubview:self.sexView];
    [self  addSubview:self.codeLabel];
    [self  addSubview:self.abCLabel];
    [self  addSubview:self.answerLabel];
    [self  addSubview:self.timeCode];
    [self  addSubview:self.timeLabel];
    [self  addSubview:self.countdown];
    [self  addSubview:self.line];
    
    WS(this_cell);
    [self.imgView  makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(marginX);
        make.centerY.mas_equalTo(this_cell);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_Y));
    }];
    [self.nameLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.imgView.mas_right).with.offset(marginX);
        make.top.mas_equalTo(this_cell.imgView.mas_top).with.offset(-5*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 23*AUTO_SIZE_SCALE_Y));
    }];
    [self.sexView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.nameLabel);
        make.left.mas_equalTo(this_cell.nameLabel.mas_right).with.offset(5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_Y));
    }];
    [self.codeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.nameLabel);
        make.size.mas_equalTo(CGSizeMake(120*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo(this_cell.nameLabel.mas_bottom);
    }];
    [self.countdown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.nameLabel);
        make.top.mas_equalTo(this_cell.codeLabel.mas_bottom);
        make.width.mas_equalTo(170*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(20*AUTO_SIZE_SCALE_Y);
    }];
    [self.abCLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.contentView.centerY).with.offset(-10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(this_cell.mas_left).with.offset(kScreenWidth * 0.6);
//        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_Y));
    }];
    [self.answerLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_cell.abCLabel.centerX);
        make.top.mas_equalTo(this_cell.abCLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_Y));
    }];
    [self.timeCode  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.contentView.centerY).with.offset(-10*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(this_cell.mas_right).with.offset(-67/3*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_Y));
    }];
    [self.timeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_cell.timeCode);
        make.top.mas_equalTo(this_cell.timeCode.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_Y));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_cell);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(1*AUTO_SIZE_SCALE_Y);
        make.bottom.mas_equalTo(this_cell);
    }];
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [CommentMethod createImageViewWithImageName:@""];
        _imgView.image = [UIImage imageNamed:@"person_default.png"];
        _imgView.layer.cornerRadius = 25*AUTO_SIZE_SCALE_X;
        _imgView.layer.masksToBounds = YES;
        
    }
    return _imgView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [CommentMethod  createLabelWithFont:15 Text:@""];
        _nameLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
//        _nameLabel.backgroundColor = [UIColor yellowColor];

        
    }
    return _nameLabel;
}
- (UIImageView *)sexView{
    if (!_sexView) {
        _sexView = [CommentMethod  createImageViewWithImageName:@""];
//        _sexView.backgroundColor = [UIColor blueColor];
    }
    return _sexView;
}
- (UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [CommentMethod  createLabelWithFont:13 Text:@""];
        _codeLabel.textColor = RGBACOLOR(200, 200, 200, 1);
//        _codeLabel.backgroundColor = [UIColor purpleColor];
    }
    return _codeLabel;
}
- (UILabel *)countdown{
    if (!_countdown) {
        _countdown = [[UILabel alloc]init];
        _countdown.textColor = RGBACOLOR(200, 200, 200, 1);
        _countdown.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
    }
    return _countdown;
}
- (UILabel *)abCLabel{
    if (!_abCLabel) {
        _abCLabel = [CommentMethod  createLabelWithFont:24 Text:@""];
        _abCLabel.textColor = k_PinkColor;
        _abCLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _abCLabel;
}
- (UILabel *)answerLabel{
    if (!_answerLabel) {
        _answerLabel = [CommentMethod  createLabelWithFont:13 Text:@"正确率"];
        _answerLabel.textColor = RGBACOLOR(200, 200, 200, 1);
        _answerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _answerLabel;
}
- (UILabel *)timeCode{
    if (!_timeCode) {
        _timeCode = [CommentMethod  createLabelWithFont:24 Text:@""];
        _timeCode.textColor = RGBACOLOR(200, 200, 200, 1);
        _timeCode.textAlignment = NSTextAlignmentCenter;
    }
    return _timeCode;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [CommentMethod  createLabelWithFont:13 Text:@"时间"];
        _timeLabel.textColor = RGBACOLOR(200, 200, 200, 1);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}
- (UIImageView *)line{
    if (!_line) {
        _line = [[UIImageView alloc]init];
        _line.backgroundColor = RGBACOLOR(200, 200, 200, 0.5);
    }
    return _line;
}
@end
