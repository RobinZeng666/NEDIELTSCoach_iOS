//
//  IEPlusView.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/30.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IEPlusView.h"

@implementation IEPlusView
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

-(void)setUp{
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.code];
    [self addSubview:self.numberLabel];
    [self addSubview:self.questionLabel];
    [self addSubview:self.ansLabel];
    [self addSubview:self.qcountLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.instructLabel];
}
- (void)layoutSubviews{
    if (!_isFist) {
        [self  addSub];
        _isFist = YES;
    }
}
#define marginY
- (void)addSub{
    WS(this_code);
    [self.code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_code);
        make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_Y));
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_code.code);
        make.left.mas_equalTo(this_code.code.mas_right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-40*AUTO_SIZE_SCALE_X*2-60*AUTO_SIZE_SCALE_X-40*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_Y));
      }];
    [self.questionLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_code.code.mas_left);
        make.height.mas_equalTo(this_code.code.mas_height);
        make.width.mas_equalTo(50);
        make.top.mas_equalTo(this_code.code.mas_bottom).with.offset(3*AUTO_SIZE_SCALE_Y);
    }];
    [self.ansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_code.questionLabel.mas_top);
        make.left.mas_equalTo(this_code.numberLabel.mas_left);
        make.width.mas_equalTo(this_code.numberLabel.mas_width);
        make.height.mas_equalTo(this_code.questionLabel.mas_height);
    }];
    [self.qcountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_code.code.mas_left);
        make.width.mas_equalTo(80*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_code.questionLabel.mas_bottom).with.offset(3*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(this_code.code.mas_height);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_code.qcountLabel.mas_top);
        make.left.mas_equalTo(this_code.qcountLabel.mas_right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(100*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(this_code.code.mas_height);
    }];
    [self.instructLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_code.qcountLabel.mas_bottom).with.offset(5*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(kScreenWidth-40*AUTO_SIZE_SCALE_X*2-50*AUTO_SIZE_SCALE_X);
        make.left.mas_equalTo(this_code.code.mas_left);
        make.height.mas_equalTo(this_code.code.mas_height);
    }];

}
- (UILabel *)code{
    if (!_code) {
        _code = [CommentMethod  createLabelWithFont:16 Text:@"编号:"];
        _code.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _code;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [CommentMethod createLabelWithFont:16 Text:@"123456789"];
        _numberLabel.textColor = k_PinkColor;
    }
    return _numberLabel;
}
- (UILabel *)questionLabel{
    if (!_questionLabel) {
        _questionLabel = [CommentMethod  createLabelWithFont:16 Text:@"试题:"];
        _questionLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _questionLabel;
}
- (UILabel *)ansLabel{
    if (!_ansLabel) {
        _ansLabel= [CommentMethod createLabelWithFont:16 Text:@"雅思口语阶段测验试卷"];
        _ansLabel.textColor = k_PinkColor;
    }
    return _ansLabel;
}
- (UILabel *)qcountLabel{
    if (!_qcountLabel) {
        _qcountLabel = [CommentMethod createLabelWithFont:16 Text:@"题目数量:"];
        _qcountLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _qcountLabel;
}
- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [CommentMethod  createLabelWithFont:16 Text:@"5"];
        _countLabel.textColor = k_PinkColor;
    }
    return _countLabel;
}
- (UILabel *)instructLabel{
    if (!_instructLabel) {
        _instructLabel = [CommentMethod createLabelWithFont:15 Text:@"是否添加到您本次的课堂练习中"];
        _instructLabel.textColor = RGBACOLOR(200, 200, 200, 1);
    }
    return _instructLabel;
}

@end
