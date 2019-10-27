//
//  VoteHistorySingleView.m
//  IELTSTeacher
//
//  Created by Newton on 15/9/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "VoteHistorySingleView.h"

#define kCellHeight (45*AUTO_SIZE_SCALE_Y)
@implementation VoteHistorySingleView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    [self addSubview:self.imgView];
    [self addSubview:self.titLabel];
    [self addSubview:self.percentLabel];
    
    self.backgroundColor = [UIColor whiteColor];
    
    WS(this_cell);
    
    //标题
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell);
        make.left.mas_equalTo(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-80*AUTO_SIZE_SCALE_X, kCellHeight));
    }];
    
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell);
        make.right.mas_equalTo(-8*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, kCellHeight));
    }];
    
}

- (void)setPercentString:(NSString *)percentString
{
    if (_percentString != percentString) {
        _percentString = percentString;
        
        [self _changePerCent];
    }
}

- (void)_changePerCent
{
    
    self.imgView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    [UIView animateWithDuration:0.35 animations:^{
        self.imgView.frame = CGRectMake(0, 0, [_percentString floatValue]*kScreenWidth/100, self.bounds.size.height);
    }];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imgView.bounds
                                                   byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(kCellHeight, kCellHeight)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.imgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.imgView.layer.mask = maskLayer;

    self.percentLabel.text = _percentString;
}


#pragma mark - setters and getters
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imgView;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [[UILabel alloc] init];//[CommentMethod createLabelWithFont:18.0f Text:@""];
        _titLabel.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _titLabel.numberOfLines = 2;
        _titLabel.textColor = [UIColor darkGrayColor];
        _titLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titLabel;
}

- (UILabel *)percentLabel
{
    if (!_percentLabel) {
        _percentLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _percentLabel.textAlignment = NSTextAlignmentRight;
        _percentLabel.textColor = [UIColor darkGrayColor];
    }
    return _percentLabel;
}




@end
