//
//  IETextContentView.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/29.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IETextContentView.h"

@implementation IETextContentView
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
- (void)setUp{
    self.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
    [self  addSubview:self.modelLabel];
    [self  addSubview:self.allBtn];
    [self  addSubview:self.eachBtn];
    [self  addSubview:self.timeLabel];
    [self  addSubview:self.timeText];
    [self  addSubview:self.minuteLabe];
    [self  addSubview:self.completionLabel];
    [self  addSubview:self.completionText];
}
- (void)layoutSubviews{
    if (!_isFirst) {
        [self addSub];
        _isFirst = YES;
    }
}

- (void)addSub{
    WS(this_test);
    //答题模式
    [self.modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(115/3*AUTO_SIZE_SCALE_Y);
    }];
    //整套提交
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_test.modelLabel.mas_right).with.offset(57/3*AUTO_SIZE_SCALE_Y);
        make.top.mas_equalTo(85/3*AUTO_SIZE_SCALE_Y);
        make.height.mas_equalTo(40*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(127*AUTO_SIZE_SCALE_Y);
    }];
    //单题提交
    [self.eachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(85/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(this_test.allBtn.mas_right).with.offset(64/3*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(40*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(127*AUTO_SIZE_SCALE_Y);
    }];
    //答题时间
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_test.modelLabel);
        make.top.mas_equalTo(this_test.modelLabel.mas_bottom).with.offset(114/3*AUTO_SIZE_SCALE_Y);
    }];
    //时间
    [self.timeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_test.modelLabel.mas_right).with.offset(57/3*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_test.allBtn.bottom).with.offset(50/3*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(682/3*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_Y));
    }];
    //分钟
    [self.minuteLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_test.timeLabel);
        make.left.mas_equalTo(this_test.timeText.mas_right).with.offset(52/3*AUTO_SIZE_SCALE_X);
    }];
    //完成率
    [self.completionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_test.modelLabel);
        make.top.mas_equalTo(this_test.modelLabel.mas_bottom).with.offset(114/3*AUTO_SIZE_SCALE_Y);
    }];
    //数值
    [self.completionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_test.modelLabel.mas_right).with.offset(57/3*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_test.allBtn.bottom).with.offset(50/3*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(682/3*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_Y));
    }];

}
- (UILabel *)modelLabel{
    if (!_modelLabel) {
        _modelLabel = [CommentMethod createLabelWithFont:17*AUTO_SIZE_SCALE_X Text:@"答题模式"];
        _modelLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _modelLabel;
}
- (UIButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:nil Title:@"整套提交"];
        _allBtn.tag = 0;
        _allBtn.selected = YES;
        [_allBtn setTitleColor:k_PinkColor forState:UIControlStateNormal];
        [_allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_allBtn setBackgroundImage:[UIImage imageNamed:@"allSubmit_anniu_select.png"] forState:UIControlStateNormal];
        [_allBtn setBackgroundImage:[UIImage imageNamed:@"allSubmit_anniiu_xuanzhong.png"] forState:UIControlStateSelected];
        _allBtn.layer.cornerRadius = 3*AUTO_SIZE_SCALE_X;
        _allBtn.layer.masksToBounds = YES;
        _allBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f*AUTO_SIZE_SCALE_X];
    }
    return _allBtn;
}
- (UIButton *)eachBtn{
    if (!_eachBtn) {
        _eachBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:nil Title:@"单题提交"];
       
        _eachBtn.tag = 1;
       [_eachBtn setTitleColor:k_PinkColor forState:UIControlStateNormal];
        [_eachBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_eachBtn setBackgroundImage:[UIImage imageNamed:@"allSubmit_anniu_select.png"] forState:UIControlStateNormal];
        [_eachBtn setBackgroundImage:[UIImage imageNamed:@"allSubmit_anniiu_xuanzhong.png"] forState:UIControlStateSelected];
        _eachBtn.layer.cornerRadius = 3*AUTO_SIZE_SCALE_X;
        _eachBtn.layer.masksToBounds = YES;
        _eachBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f*AUTO_SIZE_SCALE_X];
    }
    return _eachBtn;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [CommentMethod createLabelWithFont:17*AUTO_SIZE_SCALE_X Text:@"答题时间"];
        _timeLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _timeLabel;
}
- (UITextField *)timeText{
    if (!_timeText) {
        _timeText = [[UITextField alloc]init];
        [_timeText setBorderStyle:UITextBorderStyleRoundedRect];
        _timeText.keyboardType = UIKeyboardTypeNumberPad;
        _timeText.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _timeText.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        _timeText.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        
    }
    return _timeText;
}
- (UILabel *)minuteLabe{
    if (!_minuteLabe) {
        _minuteLabe = [CommentMethod createLabelWithFont:17*AUTO_SIZE_SCALE_X Text:@"分钟"];
        _minuteLabe.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _minuteLabe.textAlignment = NSTextAlignmentLeft;
    }
    return _minuteLabe;
}
- (UILabel *)completionLabel{
    if (!_completionLabel) {
        _completionLabel = [CommentMethod createLabelWithFont:17*AUTO_SIZE_SCALE_X Text:@"完 成 率"];
        _completionLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        
        _completionLabel.alpha = 0;
    }
    return _completionLabel;
}
- (UITextField *)completionText{
    if (!_completionText) {
        _completionText = [[UITextField alloc]init];
        [_completionText setBorderStyle:UITextBorderStyleRoundedRect];
        _completionText.keyboardType = UIKeyboardTypeNumberPad;
        _completionText.textColor = [CommentMethod colorFromHexRGB:k_Color_2];

        _completionText.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        _completionText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _completionText.alpha = 0;
    }
    return _completionText;
}
@end
