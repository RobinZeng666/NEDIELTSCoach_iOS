//
//  GradeExerciseViewCell.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/27.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeExerciseViewCell.h"

#define serialWidth 30
@interface GradeExerciseViewCell()

@property (nonatomic,strong) UILabel *serialLabel;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation GradeExerciseViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}
- (void)_initView
{
    [self.contentView addSubview:self.serialLabel];
    [self.contentView addSubview:self.titleLabel];

    WS(this_Exercise);
    
    [self.serialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_Exercise.contentView);
        make.size.mas_equalTo(CGSizeMake(serialWidth, serialWidth));
        make.left.mas_equalTo(20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_Exercise.contentView);
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.left.mas_equalTo(this_Exercise.serialLabel.mas_right).with.offset(20);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.serialLabel.text = [NSString stringWithFormat:@"%ld",(long)self.serial];
    self.serialLabel.layer.cornerRadius = serialWidth/2;
    self.serialLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.serialLabel.layer.borderWidth = 1;
    self.serialLabel.layer.masksToBounds = YES;
    
    /**
     *  测试名称
     */
    self.titleLabel.text = self.testName;
}




#pragma mark - set or get
- (UILabel *)serialLabel
{
    if (!_serialLabel) {
        _serialLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
        _serialLabel.textAlignment = NSTextAlignmentCenter;
        _serialLabel.textColor = [UIColor whiteColor];
        _serialLabel.backgroundColor = k_PinkColor;
    }
    return _serialLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
    }
    return _titleLabel;
}

@end
