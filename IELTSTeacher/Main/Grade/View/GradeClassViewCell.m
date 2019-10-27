//
//  GradeClassViewCell.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeClassViewCell.h"

#define leftMargin 12*AUTO_SIZE_SCALE_X
#define iconWidth  57*AUTO_SIZE_SCALE_X
@interface GradeClassViewCell()

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel     *nickLabel;
@property (nonatomic,strong) UILabel     *classLabel;
@property (nonatomic,strong) UILabel     *testTimeLabel;
@property (nonatomic,strong) UILabel     *scoreLabel;
@property (nonatomic,strong) UILabel     *scoreTitleLabel;
@property (nonatomic,strong) UIImageView *sexIcon;

@end

@implementation GradeClassViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.nickLabel];
    [self.contentView addSubview:self.classLabel];
    [self.contentView addSubview:self.testTimeLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.scoreTitleLabel];
    [self.contentView addSubview:self.sexIcon];
    
    /**
     *  添加约束
     */
    WS(this_GradeClassCell);
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_GradeClassCell.contentView);
        make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
        make.left.mas_equalTo(leftMargin);
    }];
    
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo(this_GradeClassCell.nickLabel.mas_bottom).with.offset(-5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(this_GradeClassCell.iconView.mas_right).with.offset(leftMargin);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_GradeClassCell.contentView).with.offset(-15*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_Y));
        make.right.mas_equalTo(-25*AUTO_SIZE_SCALE_X);
    }];
    
    [self.scoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_GradeClassCell.scoreLabel.mas_bottom).with.offset(5*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
        make.right.mas_equalTo(-25*AUTO_SIZE_SCALE_X);
    }];
}

#pragma mark -
- (void)layoutSubviews
{
    [super layoutSubviews];

    WS(this_GradeClassCell);
    /**
     *  没有模考成绩时，显示任务完成率。
     *  倒计时没有，本行不显示。
     */
    
    /**
     {
         DateDiff = "<null>";
         IconUrl = "";
         UID = 39;
         avgScore = 0;
         finishTask = 33;
         nGender = 2;
         sCode = BJ1937729;
         sName = "\U4e8e\U529b\U822a";
     },
     */

    NSString *sName = self.classModel.sName;
//    if (![sName isKindOfClass:[NSNull class]]) {
        CHECK_STRING_IS_NULL(sName);
        CGFloat nickNamewidth = [CommentMethod widthForNickName:sName
                                                  testLablWidth:200
                                                  textLabelFont:k_Font_2].width;
        self.nickLabel.frame = CGRectMake(iconWidth+2*leftMargin, (self.frame.size.height-iconWidth)/2-5, nickNamewidth, 30*AUTO_SIZE_SCALE_Y);
        self.nickLabel.text= sName;
//    }

    self.sexIcon.frame = CGRectMake(self.nickLabel.frame.origin.x+self.nickLabel.frame.size.width+5, self.nickLabel.frame.origin.y+(30*AUTO_SIZE_SCALE_Y-11*AUTO_SIZE_SCALE_Y)/2, 11*AUTO_SIZE_SCALE_Y, 11*AUTO_SIZE_SCALE_Y);
    CHECK_DATA_IS_NSNULL(self.classModel.nGender, NSNumber);
    NSInteger ngender = [self.classModel.nGender integerValue];
    
    if (ngender == 1) {
        self.sexIcon.image = [UIImage imageNamed:@"checkList_nan.png"];
        self.sexIcon.hidden = NO;
    }else if(ngender == 2) {
        self.sexIcon.image = [UIImage imageNamed:@"checkList_nv.png"];
        self.sexIcon.hidden = NO;
    }else {
        self.sexIcon.image = [UIImage imageNamed:@"checkList_nan.png"];
        self.sexIcon.hidden = YES;
    }
    CHECK_DATA_IS_NSNULL(self.classModel.sCode, NSString);
    self.classLabel.text = self.classModel.sCode;
    
    if (![self.classModel.DateDiff isKindOfClass:[NSNull class]] &&
        ([self.classModel.DateDiff integerValue] > 0)) {
        self.testTimeLabel.text = [NSString stringWithFormat:@"雅思考试倒计时:%@天",self.classModel.DateDiff];
        self.testTimeLabel.hidden = NO;
        
        [self.classLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(180*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
            make.top.mas_equalTo(this_GradeClassCell.nickLabel.mas_bottom).with.offset(-5*AUTO_SIZE_SCALE_Y);
            make.left.mas_equalTo(this_GradeClassCell.iconView.mas_right).with.offset(leftMargin);
        }];
        
        [self.testTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(180*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
            make.top.mas_equalTo(this_GradeClassCell.classLabel.mas_bottom);
            make.left.mas_equalTo(this_GradeClassCell.iconView.mas_right).with.offset(leftMargin);
        }];

    }else{
        [self.classLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(180*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
            make.top.mas_equalTo(this_GradeClassCell.nickLabel.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
            make.left.mas_equalTo(this_GradeClassCell.iconView.mas_right).with.offset(leftMargin);
        }];

        self.testTimeLabel.hidden = YES;
    }
    CHECK_STRING_IS_NULL(self.classModel.avgScore);
    if ([self.classModel.avgScore floatValue] > 0) {
        self.scoreTitleLabel.text = @"模考平均分";
        self.scoreLabel.text = self.classModel.avgScore;
    }else
    {
        self.scoreTitleLabel.text = @"任务完成率";
        CHECK_STRING_IS_NULL(self.classModel.finishTask);
        self.scoreLabel.text = [NSString stringWithFormat:@"%@%%",self.classModel.finishTask];
    }
    
    CHECK_DATA_IS_NSNULL(self.classModel.IconUrl, NSString);
    CHECK_STRING_IS_NULL(self.classModel.IconUrl);
    
    NSString *urlPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,self.classModel.IconUrl];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:urlPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    
}


#pragma mark - get or set
- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [CommentMethod createImageViewWithImageName:@"person_default.png"];
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.borderColor = [UIColor clearColor].CGColor;
        _iconView.layer.borderWidth = 1;
        _iconView.layer.cornerRadius = iconWidth/2;
        _iconView.layer.shouldRasterize = YES;
    }
    return _iconView;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [CommentMethod createLabelWithFont:k_Font_2 Text:@""];
        _nickLabel.font = [UIFont boldSystemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _nickLabel.textColor = [UIColor darkGrayColor];
    }
    return _nickLabel;
}

- (UILabel *)classLabel
{
    if (!_classLabel) {
        _classLabel = [CommentMethod createLabelWithFont:k_Font_5 Text:@""];
        _classLabel.textColor = [UIColor lightGrayColor];
    }
    return _classLabel;
}

- (UILabel *)testTimeLabel
{
    if (!_testTimeLabel) {
        _testTimeLabel = [CommentMethod createLabelWithFont:k_Font_5 Text:@""];
        _testTimeLabel.textColor = [UIColor lightGrayColor];
    }
    return _testTimeLabel;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [CommentMethod createLabelWithFont:k_Font_0 Text:@""];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.textColor = k_PinkColor;
    }
    return _scoreLabel;
}

- (UILabel *)scoreTitleLabel
{
    if (!_scoreTitleLabel) {
        _scoreTitleLabel = [CommentMethod createLabelWithFont:k_Font_6 Text:@""];
        _scoreTitleLabel.textAlignment = NSTextAlignmentCenter;
        _scoreTitleLabel.textColor = [UIColor lightGrayColor];
    }
    return _scoreTitleLabel;
}

- (UIImageView *)sexIcon
{
    if (!_sexIcon) {
        _sexIcon = [CommentMethod createImageViewWithImageName:@""];  //nv.png
    }
    return _sexIcon;
}


@end
