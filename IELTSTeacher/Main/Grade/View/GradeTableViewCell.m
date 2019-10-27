//
//  GradeTableViewCell.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/23.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeTableViewCell.h"

@interface GradeTableViewCell()

@property (nonatomic,strong) UILabel *classTitle; //上课标题
@property (nonatomic,strong) UILabel *classCount; //上课次数
@property (nonatomic,strong) UILabel *classTime;  //上课时间
@property (nonatomic,strong) UIImageView *lineImgView;

@end

@implementation GradeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self _initView];
    }
    return self;
}

//初始化视图
- (void)_initView
{
    WS(this_GradeCell);

    [self.contentView addSubview:self.classCount];
    [self.contentView addSubview:self.classTitle];
    [self.contentView addSubview:self.classNumber];
    [self.contentView addSubview:self.classTime];
    [self.contentView addSubview:self.lineImgView];

    CGFloat topMargin = 20 * AUTO_SIZE_SCALE_Y;
    
    [self.classNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(topMargin);
        make.size.mas_equalTo(CGSizeMake(117*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    
//    [self.classTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(this_GradeCell.classNumber.mas_right);
//        make.top.mas_equalTo(topMargin);
//        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
//    }];
    
    [self.classTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_GradeCell.classTitle.mas_bottom);
        make.left.mas_equalTo(this_GradeCell.classNumber.mas_right);
        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.classCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(topMargin);
        make.right.mas_equalTo(-10*AUTO_SIZE_SCALE_X);
    }];
    [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(this_GradeCell.bottom);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /**
     {
     dtBeginDate = "2015-07-05";
     dtEndDate = "2015-07-20";
     nowLessonId = 2;
     sCode = YA15602;
     sName = "IELTS6\U5206\U73ed";
     stuNum = 27;
       }
     */
    CHECK_DATA_IS_NSNULL(self.model.stuNum, NSNumber);
    NSInteger stuNum = [self.model.stuNum integerValue];
    //班级人数
    NSString *people = [NSString stringWithFormat:@"%ld人班",(long)stuNum];
    self.classCount.text = people;
    
    //班级课次
    CHECK_DATA_IS_NSNULL(self.model.sCode, NSString);
    self.classNumber.text = self.model.sCode;
    
    //班级标题
    CHECK_DATA_IS_NSNULL(self.model.sName, NSString);
    CHECK_STRING_IS_NULL(self.model.sName);
    self.classTitle.text = self.model.sName;
    CGSize  size = [CommentMethod widthForNickName:self.model.sName testLablWidth:200 textLabelFont:18.0f];
    if (size.height > 20*AUTO_SIZE_SCALE_Y) {
        [self.classTitle updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.classNumber.mas_right);
            make.top.mas_equalTo(self.classNumber.mas_top);
            make.width.mas_equalTo(200*AUTO_SIZE_SCALE_X);
            make.height.mas_equalTo((size.height+10)*AUTO_SIZE_SCALE_Y);
        }];
    }else
    {
        [self.classTitle updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.classNumber.mas_right);
            make.top.mas_equalTo(self.classNumber.mas_top);
            make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
        }];
    }
    
    //上课时间
    CHECK_DATA_IS_NSNULL(self.model.dtBeginDate, NSString);
    CHECK_DATA_IS_NSNULL(self.model.dtEndDate, NSString);
    NSString *times = [NSString stringWithFormat:@"%@ - %@",self.model.dtBeginDate,self.model.dtEndDate];
    self.classTime.text = times;
}

#pragma mark - get and set
- (UILabel *)classCount
{
    if (!_classCount) {
        _classCount = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _classCount.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _classCount.textAlignment = NSTextAlignmentCenter;
    }
    return _classCount;
}

- (UILabel *)classNumber
{
    if (!_classNumber) {
        _classNumber = [CommentMethod createLabelWithFont:14.0f Text:@""];
        _classNumber.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _classNumber.textAlignment = NSTextAlignmentCenter;
    }
    return _classNumber;
}

- (UILabel *)classTime
{
    if (!_classTime) {
        _classTime = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _classTime.textColor = [UIColor lightGrayColor];
    }
    return _classTime;
}

- (UILabel *)classTitle
{
    if (!_classTitle) {
        _classTitle = [CommentMethod createLabelWithFont:18.0f Text:@""];
//        _classTitle = [[UILabel alloc]init];
//        _classTitle.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _classTitle.textColor = [UIColor darkGrayColor];
    }
    return _classTitle;
}

- (UIImageView *)lineImgView
{
    if (!_lineImgView) {
        _lineImgView = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
    }
    return _lineImgView;
}

@end
