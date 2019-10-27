//
//  ScoreTableViewCell.m
//  SingleDemo
//
//  Created by DevNiudun on 15/8/5.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import "ScoreTableViewCell.h"

#define k_HEADViewHeight (61*AUTO_SIZE_SCALE_Y)
#define k_CellSigleHeight (82*AUTO_SIZE_SCALE_Y)

@interface ScoreTableViewCell()

@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UILabel *qNumberLabel;


@end

@implementation ScoreTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initButton];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initButton];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initButton];
    }
    return self;
}



- (void)_initButton
{
    
    UILabel *answerLabel  = [CommentMethod createLabelWithFont:20.0f Text:@""];
    self.answerLabel = answerLabel;
    [self addSubview:answerLabel];
    
    UILabel *qNumberLabel = [CommentMethod createLabelWithFont:0.f Text:@""];
    self.qNumberLabel = qNumberLabel;
    qNumberLabel.textAlignment = NSTextAlignmentCenter;
    qNumberLabel.font = [UIFont boldSystemFontOfSize:20.f*AUTO_SIZE_SCALE_X];
    [self addSubview:qNumberLabel];
    
    
    self.expansionButton = [[UIButton alloc] initWithFrame:CGRectZero];
    //仅修改self.moreButton的x,ywh值不变  //13*8
    [self.expansionButton setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    [self.expansionButton setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateSelected];
    [self.expansionButton addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.expansionButton];
    
}

- (void)setScorModel:(ScorceModel *)scorModel
{
    if (_scorModel != scorModel) {
        _scorModel = scorModel;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //添加约束
    [self.qNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5*AUTO_SIZE_SCALE_X);
        make.left.mas_equalTo(40*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(30*AUTO_SIZE_SCALE_X);
    }];
    [self.answerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth-(40*2+30)*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(self.qNumberLabel.top);
        make.left.mas_equalTo(self.qNumberLabel.right);
    }];
    
    [self.expansionButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X));
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.answerLabel.right).with.offset(5*AUTO_SIZE_SCALE_X);
    }];
    
    CHECK_DATA_IS_NSNULL(self.scorModel.AnswerContent, NSString);
    CHECK_STRING_IS_NULL(self.scorModel.AnswerContent);
    
    CHECK_DATA_IS_NSNULL(self.scorModel.QNumber, NSNumber);
    
    
    CHECK_DATA_IS_NSNULL(self.scorModel.RightCount, NSNumber);
    CHECK_DATA_IS_NSNULL(self.scorModel.ScoreCount, NSNumber);
    NSInteger num1 = [self.scorModel.RightCount integerValue];
    NSInteger num2 = [self.scorModel.ScoreCount integerValue];
    if ((num1 - num2)<0 ) {
        self.answerLabel.textColor = k_PinkColor;
    }else{
        self.answerLabel.textColor = RGBACOLOR(39, 182, 149, 1);
    }
    
    
    NSString *answer = [self.scorModel.AnswerContent stringByReplacingOccurrencesOfString:@"[" withString:@""];
    self.answerLabel.text = answer;
    CHECK_DATA_IS_NSNULL(self.scorModel.QNumber, NSNumber);
    self.qNumberLabel.text = [NSString stringWithFormat:@"%@.", [self.scorModel.QNumber stringValue]];
    
}


#pragma mark - delegate
- (void)moreBtnClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(filterHeaderViewMoreBtnClicked:)]) {
        [self.delegate filterHeaderViewMoreBtnClicked:sender];
    }
}


@end
