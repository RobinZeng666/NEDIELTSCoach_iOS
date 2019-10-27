//
//  PlanTableViewCell.m
//  IELTSStudent
//
//  Created by DevNiudun on 15/7/1.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "PlanTableViewCell.h"

@interface PlanTableViewCell()

@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic,strong) UILabel     *startTimeLabel;
@property (nonatomic,strong) UILabel     *endTimeLabel;
@property (nonatomic,strong) UILabel     *titleLabel;
@property (nonatomic,strong) UILabel     *classCodeLabel;
@property (nonatomic,strong) UIImageView *addressImageView;
@property (nonatomic,strong) UILabel     *addressLabel;




@end
@implementation PlanTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}
#pragma mark - 初始化视图
- (void)_initView
{
    WS(this_planCell);
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.selectImageView];
    [self.bgImageView addSubview:self.startTimeLabel];
    [self.bgImageView addSubview:self.endTimeLabel];
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.classCodeLabel];
    [self.bgImageView addSubview:self.addressImageView];
    [self.bgImageView addSubview:self.addressLabel];
    
    [self.bgImageView addSubview:self.detailImageView];
    
    CGFloat bgImageHeight = 80*AUTO_SIZE_SCALE_Y;
    CGFloat bgImageWidth  = kScreenWidth-20*AUTO_SIZE_SCALE_X;
    CGFloat timeLabelHeight = 20*AUTO_SIZE_SCALE_Y;
    CGFloat timeLabelWeight = 40*AUTO_SIZE_SCALE_Y;
    CGFloat gapHeight = (bgImageHeight-2*timeLabelHeight)/3;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(bgImageWidth, bgImageHeight));
        make.centerY.mas_equalTo(this_planCell.contentView);
        make.centerX.mas_equalTo(this_planCell.contentView);
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10*AUTO_SIZE_SCALE_X, bgImageHeight));
        make.left.mas_equalTo(-5*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_planCell.bgImageView);
    }];
    
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(timeLabelWeight, timeLabelHeight));
        make.left.mas_equalTo(20*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_planCell.bgImageView).with.offset(gapHeight);
    }];
    
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(timeLabelWeight, timeLabelHeight));
        make.left.mas_equalTo(20*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_planCell.titleLabel.mas_bottom).with.offset(5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_planCell.startTimeLabel.mas_right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_planCell.startTimeLabel.mas_top);
    }];
    
    [self.classCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(this_planCell.titleLabel.mas_right).with.offset(24*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(-24*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_planCell.startTimeLabel.mas_top);
        make.height.mas_equalTo(20*AUTO_SIZE_SCALE_Y);
    }];
    
    [self.addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_planCell.endTimeLabel.mas_right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_planCell.endTimeLabel.mas_top).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_planCell.addressImageView.mas_right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_planCell.addressImageView.mas_top);
        make.width.mas_equalTo(280*AUTO_SIZE_SCALE_X);
    }];
    
    
    [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(25*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X));
        make.centerY.mas_equalTo(this_planCell.bgImageView);
    }];
}

#pragma mark - 赋值+布局
/**
 {
 SectBegin = 1435317000000;
 SectEnd = 1435322400000;
 nLessonNo = 6;
 sAddress = "\U5317\U4eac\U5e02\U6d77\U6dc0\U533a\U77e5\U6625\U8def17\U53f7\U96621-2\U5c42\U90e8\U5206";
 sCode = "<null>";
 sNameBc = "<null>";
 sNameBr = "\U6d77\U6dc0\U77e5\U6625\U8def\U6821\U533a209\U6559\U5ba4";
 }
 */

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //开始时间
    NSNumber *beginTime = self.planModel.SectBegin;
    CHECK_DATA_IS_NSNULL(beginTime, NSNumber);
    NSString *beginTimeString = [NSDate changeCreatTimeForHHMM:beginTime];
    self.startTimeLabel.text = beginTimeString;
    
    //结束时间
    NSNumber *endTime = self.planModel.SectEnd;
    CHECK_DATA_IS_NSNULL(endTime, NSNumber);
    NSString *endTimeString = [NSDate changeCreatTimeForHHMM:endTime];
    self.endTimeLabel.text = endTimeString;
    
    //标题
    NSString *nameBr =  self.planModel.sNameBc;
    CHECK_DATA_IS_NSNULL(nameBr, NSString);
//    NSString *nameBr = @"取消IELTS全日制托管班(VIP强化6人精品住宿班)";
    self.titleLabel.text = nameBr;
    CGSize laberSize = [CommentMethod widthForNickName:nameBr
                                         testLablWidth:234 * AUTO_SIZE_SCALE_X
                                         textLabelFont:18.0f];
    WS(this_planCell);
    if (laberSize.height > 30) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(this_planCell.startTimeLabel.right).with.offset(10*AUTO_SIZE_SCALE_Y);
            make.top.mas_equalTo(this_planCell.startTimeLabel.mas_top);
            make.width.mas_equalTo(230*AUTO_SIZE_SCALE_X);
        }];
    }
    //地址
//    NSString *addressString = self.planModel.sAddress;
    
    NSString *sAddre = self.planModel.sAddress;
    CHECK_DATA_IS_NSNULL(sAddre, NSString);
    CHECK_STRING_IS_NULL(sAddre);
    NSString *sNameBr = self.planModel.sNameBr;
    CHECK_DATA_IS_NSNULL(sNameBr, NSString);
    CHECK_STRING_IS_NULL(sNameBr);
    NSString *addressString = [NSString stringWithFormat:@"%@%@",sAddre,sNameBr];
    CHECK_DATA_IS_NSNULL(addressString, NSString);
    
    self.addressLabel.text = addressString;
    
//    NSString *addressString = @"北京市海淀黄庄中关村地铁站科贸电子大厦10层1021室，北京市海淀黄庄中关村地铁站科贸电子大厦10层1021室北京市海淀黄庄中关村地铁站科贸电子大厦10层1021室";
//    self.addressLabel.text = addressString;
    
    CGFloat  addressHeight =  [CommentMethod widthForNickName:addressString
                                                testLablWidth:280 * AUTO_SIZE_SCALE_X
                                                textLabelFont:16.0f].height;
    CGFloat addTit = 0;
    if (laberSize.height > 25*AUTO_SIZE_SCALE_Y) {
        addTit =  laberSize.height - 25*AUTO_SIZE_SCALE_Y;
    }
    CGFloat addAdd = 0;
    if (addressHeight > 25*AUTO_SIZE_SCALE_Y) {
        addAdd =  addressHeight -25*AUTO_SIZE_SCALE_Y;
    }
    //更新背景图的高度
    CGFloat newHeight = 90*AUTO_SIZE_SCALE_Y+addAdd+addTit;
    CGFloat bgImageWidth  = kScreenWidth-20*AUTO_SIZE_SCALE_X;
    
//    NSLog(@"_____newHeight_%f",newHeight);
    
    [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(bgImageWidth, newHeight));
        make.centerY.mas_equalTo(this_planCell.contentView);
        make.centerX.mas_equalTo(this_planCell.contentView);
    }];
    
    [self.selectImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, newHeight));
        make.left.mas_equalTo(-5);
        make.centerY.mas_equalTo(this_planCell.bgImageView);
    }];

    //课次
    CHECK_DATA_IS_NSNULL(self.planModel.nLessonNo, NSNumber);
    NSString *lessonNo = [self.planModel.nLessonNo stringValue];
    self.classCodeLabel.text = [NSString stringWithFormat:@"第%@次课",lessonNo];
    
    CHECK_DATA_IS_NSNULL(self.planModel.ids, NSString);
    CHECK_DATA_IS_NSNULL(self.planModel.nowLessonId, NSString);
    CHECK_STRING_IS_NULL(self.planModel.ids);
    CHECK_STRING_IS_NULL(self.planModel.nowLessonId);
    //是当天才显示当前课次
    if (self.isCurrentDate) {
        if ([self.planModel.ids isEqualToString:self.planModel.nowLessonId]) {
            self.selectImageView.hidden = NO;
        }else{
            self.selectImageView.hidden = YES;
        }
    }else
    {
       self.selectImageView.hidden = YES;
    }
    
    
}

#pragma mark - set or getbeginTimeString
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [CommentMethod createImageViewWithImageName:@"schedule_bg_liebiao.png"];
    }
    return _bgImageView;
}

- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = [CommentMethod createImageViewWithImageName:@"schedule_liebiao_xuanzhong.png"];
    }
    return _selectImageView;
}


- (UILabel *)startTimeLabel
{
    if (!_startTimeLabel) {
        _startTimeLabel = [CommentMethod createLabelWithFont:14.0f Text:@""];
        _startTimeLabel.textColor = [CommentMethod colorFromHexRGB:@"818b8f"];
        _startTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _startTimeLabel;
}

- (UILabel *)endTimeLabel
{
    if (!_endTimeLabel) {
        _endTimeLabel = [CommentMethod createLabelWithFont:14.0f Text:@""];
        _endTimeLabel.textColor = [CommentMethod colorFromHexRGB:@"818b8f"];
        _endTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _endTimeLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
//        _titleLabel.textColor = [CommentMethod colorFromHexRGB:@"545a5c"];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UILabel *)classCodeLabel
{
    if (!_classCodeLabel) {
        _classCodeLabel = [CommentMethod createLabelWithFont:14.0f Text:@""];
        _classCodeLabel.textColor = [CommentMethod colorFromHexRGB:@"acacac"];
        _classCodeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _classCodeLabel;
}

- (UIImageView *)addressImageView
{
    if (!_addressImageView) {
        _addressImageView = [CommentMethod createImageViewWithImageName:@"personal_planList_dizhi.png"];
    }
    return _addressImageView;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [CommentMethod createLabelWithFont:k_Font_4 Text:@""];
        _addressLabel.textColor = [CommentMethod colorFromHexRGB:@"818b8f"];
    }
    return _addressLabel;
}

- (UIImageView *)detailImageView
{
    if (!_detailImageView) {
        _detailImageView = [CommentMethod createImageViewWithImageName:@"schedule_liebiao_jiantou.png"];
    }
    return _detailImageView;
}





@end
