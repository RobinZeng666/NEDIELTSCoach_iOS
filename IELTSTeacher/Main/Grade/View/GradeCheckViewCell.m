//
//  GradeCheckViewCell.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeCheckViewCell.h"

#define numberWidth (30*AUTO_SIZE_SCALE_X)
#define serialWidth (11*AUTO_SIZE_SCALE_X)
@interface GradeCheckViewCell()

@property (nonatomic,strong) UILabel     *serialLabel;
@property (nonatomic,strong) UILabel     *titleLabel;
@property (nonatomic,strong) UILabel     *timeLabel;
@property (nonatomic,strong) UILabel     *nickNameLabel;
@property (nonatomic,strong) UIImageView *sexImg;

@end

@implementation GradeCheckViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}
/**
 *  初始化视图
 */
- (void)_initView
{
    WS(this_GradeCheck);
    [self.contentView addSubview:self.serialLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.sexImg];
   
    
    CGFloat leftMargin = 20*AUTO_SIZE_SCALE_X;
    [self.serialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_GradeCheck.contentView);
        make.size.mas_equalTo(CGSizeMake(numberWidth, numberWidth));
        make.left.mas_equalTo(leftMargin);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_GradeCheck.serialLabel.mas_right).with.offset(leftMargin);
        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X));
        make.top.mas_equalTo(20*AUTO_SIZE_SCALE_X);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_GradeCheck.serialLabel.mas_right).with.offset(leftMargin);
        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X));
        make.top.mas_equalTo(this_GradeCheck.titleLabel.mas_bottom);
    }];
    
    [self.sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(serialWidth, serialWidth));
        make.centerY.mas_equalTo(this_GradeCheck.contentView);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(this_GradeCheck.sexImg.mas_left).with.offset(-5*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(200, serialWidth));
        make.height.mas_equalTo(serialWidth);
        make.centerY.mas_equalTo(this_GradeCheck.contentView);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
 

    /**
     *  列表序号
     */
    self.serialLabel.text = [NSString stringWithFormat:@"%ld",(long)self.serial];
    self.serialLabel.layer.cornerRadius = numberWidth/2;
    self.serialLabel.layer.masksToBounds = YES;
    self.serialLabel.layer.borderWidth = 1;
    self.serialLabel.layer.borderColor = [UIColor clearColor].CGColor;
    
    
    /**
     *  试卷名字
     */
    NSString *paperName = self.checkModel.paperName;
    CHECK_DATA_IS_NSNULL(paperName, NSString);
    CHECK_STRING_IS_NULL(paperName);
    self.titleLabel.text = paperName;
    
    /**
     *  性别
     */
    NSNumber *ngender = self.checkModel.nGender;
    CHECK_DATA_IS_NSNULL(ngender, NSNumber);
    if (![ngender  isEqual: @""]) {
        NSString *gender = [ngender stringValue];
        if ([gender isEqualToString:@"1"])//男 checkList_nan.png
        {
            self.sexImg.image = [UIImage imageNamed:@"checkList_nan.png"];
        }else if ([gender isEqualToString:@"2"]) //女 checkList_nv.png
        {
            self.sexImg.image = [UIImage imageNamed:@"checkList_nv.png"];
        }
    }
    /**
     *  昵称
     */
    NSString *uName = self.checkModel.uName;
    CHECK_DATA_IS_NSNULL(uName, NSString);
    CHECK_STRING_IS_NULL(uName);
    
//    CGSize  size = [CommentMethod widthForNickName:uName
//                                           testLablWidth:100
//                                           textLabelFont:k_Font_2];

//    self.nickNameLabel.frame = CGRectMake(kScreenWidth-200, (self.frame.size.height-30)/2, size.width, 30);
//    self.sexImg.frame = CGRectMake(self.nickNameLabel.frame.origin.x+self.nickNameLabel.frame.size.width, self.nickNameLabel.frame.origin.y, 30, 30);
    self.nickNameLabel.text = uName;
    /**
     *  时间
     */
    
    NSString *time = self.checkModel.taskSubmitTime;
    CHECK_DATA_IS_NSNULL(time, NSString);
    self.timeLabel.text = time;
}



#pragma mark - set or get
- (UILabel *)serialLabel
{
    if (!_serialLabel) {
        _serialLabel = [CommentMethod createLabelWithFont:15.0f Text:@""];
        _serialLabel.textColor = [UIColor whiteColor];
        _serialLabel.backgroundColor = k_PinkColor;
        _serialLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _serialLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f*AUTO_SIZE_SCALE_X];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [CommentMethod createLabelWithFont:15.0f Text:@""];
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}
- (UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _nickNameLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _nickNameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nickNameLabel;
}

- (UIImageView *)sexImg
{
    if (!_sexImg) {
        _sexImg = [CommentMethod createImageViewWithImageName:@""];
    }
    return _sexImg;
}



@end
