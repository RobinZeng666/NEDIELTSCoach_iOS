//
//  StartSingleCollectionViewCell.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/18.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "StartSingleCollectionViewCell.h"

@interface StartSingleCollectionViewCell()

@property (nonatomic,strong) UILabel *answerLabel;
@property (nonatomic,strong) UILabel *qNumberLabel;


@end

@implementation StartSingleCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    UILabel *answerLabel  = [CommentMethod createLabelWithFont:20.0f Text:@""];
    self.answerLabel = answerLabel;
    [self addSubview:answerLabel];
    
    UILabel *qNumberLabel = [CommentMethod createLabelWithFont:0.f Text:@""];
    self.qNumberLabel = qNumberLabel;
    qNumberLabel.textAlignment = NSTextAlignmentCenter;
    qNumberLabel.font = [UIFont boldSystemFontOfSize:20.f*AUTO_SIZE_SCALE_X];
    [self addSubview:qNumberLabel];
    
    //添加约束
    [self.qNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5*AUTO_SIZE_SCALE_X);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(30*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(40*AUTO_SIZE_SCALE_Y);
    }];
    
//    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kScreenWidth-(40*2+30)*AUTO_SIZE_SCALE_X);
//        make.top.mas_equalTo(self.qNumberLabel.top);
//        make.left.mas_equalTo(self.qNumberLabel.right);
//    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CHECK_DATA_IS_NSNULL(self.scorModel.RightCount, NSNumber);
    CHECK_DATA_IS_NSNULL(self.scorModel.ScoreCount, NSNumber);
    NSInteger num1 = [self.scorModel.RightCount integerValue];
    NSInteger num2 = [self.scorModel.ScoreCount integerValue];
    if ((num1 - num2)<0 ) {
        self.answerLabel.textColor = k_PinkColor;
    }else{
        self.answerLabel.textColor = RGBACOLOR(39, 182, 149, 1);
    }
    
    CHECK_DATA_IS_NSNULL(self.scorModel.AnswerContent, NSString);
    CHECK_STRING_IS_NULL(self.scorModel.AnswerContent);
    
    CGFloat width = (kScreenWidth-(40*2+30)*AUTO_SIZE_SCALE_X);
    CGFloat hight = 40*AUTO_SIZE_SCALE_Y;
    CGFloat answerContentHeight = [CommentMethod  widthForNickName:self.scorModel.AnswerContent
                                                     testLablWidth:width
                                                     textLabelFont:20.0f].height;
    if (answerContentHeight > hight) {
        self.answerLabel.frame = CGRectMake(30*AUTO_SIZE_SCALE_X, 5*AUTO_SIZE_SCALE_X,width, answerContentHeight);
    }else {
        self.answerLabel.frame = CGRectMake(30*AUTO_SIZE_SCALE_X, 5*AUTO_SIZE_SCALE_X,width, 40*AUTO_SIZE_SCALE_Y);
    }

    
    NSString *answer = [self.scorModel.AnswerContent stringByReplacingOccurrencesOfString:@"[" withString:@""];
    self.answerLabel.text = answer;
    CHECK_DATA_IS_NSNULL(self.scorModel.QNumber, NSNumber);
    self.qNumberLabel.text = [NSString stringWithFormat:@"%@.", [self.scorModel.QNumber stringValue]];
}



@end
