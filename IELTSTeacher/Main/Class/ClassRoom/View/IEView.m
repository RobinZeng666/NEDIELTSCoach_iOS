//
//  IEView.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/26.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IEView.h"
#import "FDAlertView.h"
#import "OHASBasicHTMLParser.h"
@interface IEView ()

@end
@implementation IEView
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
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, kScreenWidth-AUTO_SIZE_SCALE_X*40*2, kScreenHeight * 0.3);
    self.layer.cornerRadius = 3*AUTO_SIZE_SCALE_X;
    self.layer.masksToBounds = YES;
    [self  addSubview:self.cancleBtn];
    [self  addSubview:self.titleLabel];
    [self  addSubview:self.contentLabel];
    [self  addSubview:self.mainBtn];
    
    
    WS(this_view);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(this_view);
        make.height.mas_equalTo(25*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_view);
    }];
    
    [self.mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(-25*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(40*AUTO_SIZE_SCALE_Y);
        make.bottom.mas_equalTo(this_view.mas_bottom).with.offset(-25*AUTO_SIZE_SCALE_X);
    }];
    [self.cancleBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(this_view.mainBtn);
        make.top.mas_equalTo(this_view);
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(20*AUTO_SIZE_SCALE_X);
    }];

}
#define marginWh 25*AUTO_SIZE_SCALE_X
#define ctnHight 55*AUTO_SIZE_SCALE_Y
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [CommentMethod createLabelWithFont:18.0 Text:@"请先同步到课堂"];//[[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*AUTO_SIZE_SCALE_X, ctnHight,  kScreenWidth-AUTO_SIZE_SCALE_X*40*2-30*2*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_Y)];
        _contentLabel.text = @"选择答题形式前，请先同步到所在课堂再选择练习形式";
        _contentLabel.font = [UIFont  systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        _contentLabel.numberOfLines = 0;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:k_PinkColor range:NSMakeRange(10,7)];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5*AUTO_SIZE_SCALE_Y];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_contentLabel.text length])];
        [_contentLabel setAttributedText:str];
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}
- (UIButton *)cancleBtn
{
    if (!_cancleBtn)
    {
        _cancleBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(didClick) Title:@""];
        [_cancleBtn setImage:[UIImage imageNamed:@"classRoom_guanbi_dianji"] forState:UIControlStateNormal];
    }
    return _cancleBtn;
}
- (UIButton *)mainBtn
{
    if (!_mainBtn)
    {
        _mainBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(shureClick) Title:@""];
        _mainBtn.titleLabel.font = [UIFont systemFontOfSize:18*AUTO_SIZE_SCALE_X];
        [_mainBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
        [_mainBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji"] forState:UIControlStateHighlighted];
        [_mainBtn setTitle:@"确认" forState:UIControlStateNormal];
        _mainBtn.layer.cornerRadius = 3*AUTO_SIZE_SCALE_X;
        _mainBtn.layer.masksToBounds = YES;
    }
    return _mainBtn;
}

- (void)setTitleString:(NSString *)titleString
{
    if (_titleString != titleString) {
        _titleString = titleString;
    }
}

#pragma mark--取消
- (void)didClick{
    if (self.block) {
        self.block(YES);
    }
}
//确定
- (void)shureClick{
    if (self.block) {
        self.block(NO);
    }
}
@end
