//
//  ReportChooseTableViewCell.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ReportChooseTableViewCell.h"

@interface ReportChooseTableViewCell()

@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *sexView;
@property(nonatomic,strong)UILabel *codeLabel;
@property(nonatomic,strong)UILabel *countdown;
@property(nonatomic,strong)UILabel *abCLabel;
@property(nonatomic,strong)UILabel *answerLabel;
@property(nonatomic,strong)UIImageView *line;
@property(nonatomic,assign)CGFloat nameW;

@end

@implementation ReportChooseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}


#define marginX 10
- (void)_initView
{
    [self.contentView  addSubview:self.imgView];
    [self.contentView  addSubview:self.nameLabel];
    [self.contentView  addSubview:self.sexView];
    [self.contentView  addSubview:self.codeLabel];
    [self.contentView  addSubview:self.abCLabel];
    [self.contentView  addSubview:self.answerLabel];
    [self.contentView  addSubview:self.countdown];
    [self.contentView  addSubview:self.line];
    
    
    WS(this_cell);
    [self.imgView  makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(marginX);
        make.centerY.mas_equalTo(this_cell);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_Y));
    }];
    [self.nameLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.imgView.mas_right).with.offset(marginX);
        make.top.mas_equalTo(this_cell.imgView.mas_top).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 23*AUTO_SIZE_SCALE_Y));
    }];
    [self.sexView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.nameLabel);
        make.left.mas_equalTo(this_cell.nameLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    [self.codeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.nameLabel);
        make.size.mas_equalTo(CGSizeMake(120*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X));
        make.top.mas_equalTo(this_cell.nameLabel.mas_bottom);
    }];
    [self.countdown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.nameLabel);
        make.top.mas_equalTo(this_cell.codeLabel.mas_bottom);
        make.width.mas_equalTo(170*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(20*AUTO_SIZE_SCALE_X);
    }];
    [self.abCLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.contentView.centerY).with.offset(-5*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(-30*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_Y));
    }];
    [self.answerLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_cell.abCLabel);
        make.bottom.mas_equalTo(this_cell.countdown).with.offset(5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_cell);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(this_cell);
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //1.加载图像
    CHECK_DATA_IS_NSNULL(self.model.IconUrl, NSString);
    CHECK_STRING_IS_NULL(self.model.IconUrl);
    NSString *urlPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,self.model.IconUrl];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    //2.名字
    CHECK_DATA_IS_NSNULL(self.model.sName, NSString);
    self.nameLabel.text = self.model.sName;
    //3.学号
    CHECK_DATA_IS_NSNULL(self.model.sCode, NSString);
    self.codeLabel.text = self.model.sCode;
    //4.性别图标
    CHECK_DATA_IS_NSNULL(self.model.nGender, NSNumber);
    NSInteger ngender = [self.model.nGender integerValue];
    if (ngender == 1) {
        self.sexView.image = [UIImage imageNamed:@"checkList_nan.png"];
    }else if(ngender == 2) {
        self.sexView.image = [UIImage imageNamed:@"checkList_nv.png"];
    }
    //5.考试倒计时
    CHECK_DATA_IS_NSNULL(self.model.TargetDateDiff, NSNumber);
    NSInteger downTime = [self.model.TargetDateDiff integerValue];
    if (downTime < 0) {
        self.countdown.hidden = YES;
    }else{
        self.countdown.hidden = NO;
        self.countdown.text = [NSString stringWithFormat:@"雅思考试倒计时:%ld天",downTime];
    }
    
    //成绩
    CHECK_DATA_IS_NSNULL(self.model.AnswerContent, NSString);
    CHECK_STRING_IS_NULL(self.model.AnswerContent);
    
    CHECK_DATA_IS_NSNULL(self.model.QSValues,NSString);
    CHECK_STRING_IS_NULL(self.model.QSValues);
    
    NSInteger scoreCount = [self.model.ScoreCount integerValue];
    NSInteger rightCount =  [self.model.RightCount integerValue];
    if (rightCount - scoreCount >= 0) {//RightCount-ScoreCount<0，显示正确答案)
        self.abCLabel.text = self.model.AnswerContent;
        self.abCLabel.textColor = RGBACOLOR(39, 182, 149, 1);
    }else
    {
        self.abCLabel.text = self.model.AnswerContent;
        self.abCLabel.textColor = k_PinkColor;
    }
}


#pragma mark - set or get
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [CommentMethod createImageViewWithImageName:@""];
        _imgView.layer.cornerRadius = 25*AUTO_SIZE_SCALE_X;
        _imgView.layer.masksToBounds = YES;
        
    }
    return _imgView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [CommentMethod  createLabelWithFont:15 Text:@""];
        _nameLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _nameLabel;
}
- (UIImageView *)sexView{
    if (!_sexView) {
        _sexView = [CommentMethod  createImageViewWithImageName:@""];
    }
    return _sexView;
}
- (UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [CommentMethod  createLabelWithFont:13 Text:@""];
        _codeLabel.textColor = [UIColor lightGrayColor];
    }
    return _codeLabel;
}
- (UILabel *)countdown{
    if (!_countdown) {
        _countdown = [[UILabel alloc]init];
        _countdown.textColor = [UIColor lightGrayColor];
        _countdown.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
    }
    return _countdown;
}
- (UILabel *)abCLabel{
    if (!_abCLabel) {
        _abCLabel = [CommentMethod  createLabelWithFont:18 Text:@""];
        _abCLabel.textColor = k_PinkColor;
        _abCLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _abCLabel;
}
- (UILabel *)answerLabel{
    if (!_answerLabel) {
        _answerLabel = [CommentMethod  createLabelWithFont:13 Text:@"答案"];
        _answerLabel.textColor = [UIColor lightGrayColor];
        _answerLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _answerLabel;
}
- (UIImageView *)line{
    if (!_line) {
        _line = [[UIImageView alloc]init];
        _line.backgroundColor = RGBACOLOR(200, 200, 200, 1);
    }
    return _line;
}
@end
