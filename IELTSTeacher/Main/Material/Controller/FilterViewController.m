//
//  FilterViewController.m
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/16.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "FilterViewController.h"
#import "StudyMaterialModel.h"

@interface FilterViewController ()

@property (nonatomic, strong) UIButton      *ensureButton; //确定

@property (nonatomic, strong) NSArray       *formatArr;
@property (nonatomic, strong) NSArray       *attributeArr;
@property (nonatomic, strong) NSArray       *sourceArr;
@property (nonatomic, strong) NSArray       *timeArr;

@property (nonatomic, strong) UIScrollView *bjScrollView;

@property (nonatomic, strong) UIView        *formatView; //按格式筛选
@property (nonatomic, strong) UILabel       *formatLabel;
@property (nonatomic, strong) UIImageView   *lineImgView1;
@property (nonatomic, strong) UIButton      *formatButton;

@property (nonatomic, strong) UIView        *attributeView; //按属性筛选
@property (nonatomic, strong) UILabel       *attributeLabel;
@property (nonatomic, strong) UIImageView   *lineImgView2;
@property (nonatomic, strong) UIButton      *attributeButton;

@property (nonatomic, strong) UIView        *sourceView; //按来源筛选
@property (nonatomic, strong) UILabel       *sourceLabel;
@property (nonatomic, strong) UIImageView   *lineImgView3;
@property (nonatomic, strong) UIButton      *sourceButton;

@property (nonatomic, strong) UIView        *timeView; //按时间
@property (nonatomic, strong) UILabel       *timeLabel;
@property (nonatomic, strong) UIImageView   *lineImgView4;
@property (nonatomic, strong) UIButton      *timeButton;

@property (nonatomic, copy) NSString        *formatString;
@property (nonatomic, copy) NSString        *attributeString;
@property (nonatomic, copy) NSString        *sourceString;
@property (nonatomic, copy) NSString        *timeString;

@property (nonatomic, assign) NSInteger     tag1;
@property (nonatomic, assign) NSInteger     tag2;
@property (nonatomic, assign) NSInteger     tag3;
@property (nonatomic, assign) NSInteger     tag4;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"筛选";
    
    [self.view addSubview:self.ensureButton];
    [self.view addSubview:self.bjScrollView];
    [self.bjScrollView addSubview:self.formatView];
    [self.formatView addSubview:self.formatLabel];
    [self.formatView addSubview:self.lineImgView1];
    [self.formatView addSubview:self.formatButton];
    [self.bjScrollView addSubview:self.attributeView];
    [self.attributeView addSubview:self.attributeLabel];
    [self.attributeView addSubview:self.lineImgView2];
    [self.attributeView addSubview:self.attributeButton];
    [self.bjScrollView addSubview:self.sourceView];
    [self.sourceView addSubview:self.sourceLabel];
    [self.sourceView addSubview:self.lineImgView3];
    [self.sourceView addSubview:self.sourceButton];
    [self.bjScrollView addSubview:self.timeView];
    [self.timeView addSubview:self.timeLabel];
    [self.timeView addSubview:self.lineImgView4];
    [self.timeView addSubview:self.timeButton];

    
    //确定Button
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(44);
    }];
    
    //背景bjScrollView
    [self.bjScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+12*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y));
    }];
    
    //背景视图
    [self.formatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bjScrollView.top).with.offset(@0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 155*AUTO_SIZE_SCALE_Y));
    }];
    
    //格式Label
    [self.formatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(53/3);
    }];
    
    //灰线
    [self.lineImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.formatLabel.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.right.mas_equalTo(0);
    }];
    
    //属性背景视图
    [self.attributeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.formatView.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 155*AUTO_SIZE_SCALE_Y));
    }];
    
    //属性Label
    [self.attributeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(53/3);
    }];
    
    //灰线
    [self.lineImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.attributeLabel.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.right.mas_equalTo(0);
    }];
    
    //来源背景视图
    [self.sourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.attributeView.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 105*AUTO_SIZE_SCALE_Y));
    }];
    
    //来源Label
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(53/3);
    }];
    
    //灰线
    [self.lineImgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sourceLabel.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.right.mas_equalTo(0);
    }];

    //时间背景视图
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sourceView.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 155*AUTO_SIZE_SCALE_Y));
    }];
    
    //时间Label
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(53/3);
    }];
    
    //灰线
    [self.lineImgView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.right.mas_equalTo(0);
    }];
    
    CGFloat width = (kScreenWidth-40)/3;
//    CGFloat height = width/72 * 26;
    
    NSInteger rowMax = 3;
    //循环创建格式筛选Button
    for (int i=0; i<self.formatArr.count; i++) {
        int row = i/rowMax;
        int column = i%rowMax;
        _formatButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(formatButtonAction:) Title:self.formatArr[i]];
        _formatButton.frame = CGRectMake(10+column*(width+10), 50*AUTO_SIZE_SCALE_Y+row*(width/3+10), width, width/3);
        [_formatButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_formatButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_9] forState:UIControlStateSelected];
        [_formatButton setBackgroundImage:[UIImage imageNamed:@"material_shaixuan_weixuanzhong.png"] forState:UIControlStateNormal];
        [_formatButton setBackgroundImage:[UIImage imageNamed:@"material_shaixuan_xuanzhong.png"] forState:UIControlStateSelected];
        
        _formatButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
        _formatButton.tag = 100+i;
        _formatButton.layer.cornerRadius = 2;
        _formatButton.layer.masksToBounds = YES;
        [self.formatView addSubview:_formatButton];
    }

    if ([_fileType isEqualToString:@"0"]) {
        _formatString = @"不限";
        _tag1 = 100;
    } else if ([_fileType isEqualToString:@"1"]) {
        _formatString = @"WORD";
        _tag1 = 101;
    } else if ([_fileType isEqualToString:@"2"]) {
        _formatString = @"EXCEL";
        _tag1 = 102;
    } else if ([_fileType isEqualToString:@"3"]) {
        _formatString = @"PPT";
        _tag1 = 103;
    } else if ([_fileType isEqualToString:@"4"]) {
        _formatString = @"PDF";
        _tag1 = 104;
    } else if ([_fileType isEqualToString:@"5"]) {
        _formatString = @"视频";
        _tag1 = 105;
    } else {
        _formatString = @"不限";
        _tag1 = 100;
    }
    _formatButton = (UIButton *)[self.formatView viewWithTag:_tag1];
    _formatButton.selected = YES;

    
    //循环创建属性筛选Button
    for (int i=0; i<self.attributeArr.count; i++) {
        int row = i/rowMax;
        int column = i%rowMax;
        _attributeButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(attributeButtonAction:) Title:self.attributeArr[i]];
        _attributeButton.frame = CGRectMake(10+column*(width+10), 50*AUTO_SIZE_SCALE_Y+row*(width/3+10), width, width/3);
        [_attributeButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_attributeButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_9] forState:UIControlStateSelected];
        [_attributeButton setBackgroundImage:[UIImage imageNamed:@"material_shaixuan_weixuanzhong.png"] forState:UIControlStateNormal];
        [_attributeButton setBackgroundImage:[UIImage imageNamed:@"material_shaixuan_xuanzhong.png"] forState:UIControlStateSelected];
        
        _attributeButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
        _attributeButton.tag = 200+i;
        _attributeButton.layer.cornerRadius = 2;
        _attributeButton.layer.masksToBounds = YES;
        [self.attributeView addSubview:_attributeButton];
    }
    
    if ([_nameCode isEqualToString:@"0"]) {
        _attributeString = @"不限";
        _tag2 = 200;
    } else if ([_nameCode isEqualToString:@"KY"]) {
        _attributeString = @"口语";
        _tag2 = 201;
    } else if ([_nameCode isEqualToString:@"YD"]) {
        _attributeString = @"阅读";
        _tag2 = 202;
    } else if ([_nameCode isEqualToString:@"XZ"]) {
        _attributeString = @"写作";
        _tag2 = 203;
    } else if ([_nameCode isEqualToString:@"TL"]) {
        _attributeString = @"听力";
        _tag2 = 204;
    } else {
        _attributeString = @"不限";
        _tag2 = 200;
    }
    _attributeButton = (UIButton *)[self.attributeView viewWithTag:_tag2];
    _attributeButton.selected = YES;

    
    //循环创建来源筛选Button
    for (int i=0; i<self.sourceArr.count; i++) {
        int row = i/rowMax;
        int column = i%rowMax;
        _sourceButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(sourceButtonAction:) Title:self.sourceArr[i]];
        _sourceButton.frame = CGRectMake(10+column*(width+10), 50*AUTO_SIZE_SCALE_Y+row*(width/3+10), width, width/3);
        [_sourceButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_sourceButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_9] forState:UIControlStateSelected];
        [_sourceButton setBackgroundImage:[UIImage imageNamed:@"material_shaixuan_weixuanzhong.png"] forState:UIControlStateNormal];
        [_sourceButton setBackgroundImage:[UIImage imageNamed:@"material_shaixuan_xuanzhong.png"] forState:UIControlStateSelected];
        
        _sourceButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
        _sourceButton.tag = 300+i;
        _sourceButton.layer.cornerRadius = 2;
        _sourceButton.layer.masksToBounds = YES;
        [self.sourceView addSubview:_sourceButton];
    }
    
    if ([_roleId isEqualToString:@"0"]) {
        _sourceString = @"不限";
        _tag3 = 300;
    } else if ([_roleId isEqualToString:@"1"]) {
        _sourceString = @"集团";
        _tag3 = 301;
    } else if ([_roleId isEqualToString:@"2"]) {
        _sourceString = @"个人";
        _tag3 = 302;
    } else {
        _sourceString = @"不限";
        _tag3 = 300;
    }
    _sourceButton = (UIButton *)[self.sourceView viewWithTag:_tag3];
    _sourceButton.selected = YES;

    //循环创建时间筛选Button
    for (int i=0; i<self.timeArr.count; i++) {
        int row = i/rowMax;
        int column = i%rowMax;
        _timeButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(timeButtonAction:) Title:self.timeArr[i]];
        _timeButton.frame = CGRectMake(10+column*(width+10), 50*AUTO_SIZE_SCALE_Y+row*(width/3+10), width, width/3);
        [_timeButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_timeButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_9] forState:UIControlStateSelected];
        [_timeButton setBackgroundImage:[UIImage imageNamed:@"material_shaixuan_weixuanzhong.png"] forState:UIControlStateNormal];
        [_timeButton setBackgroundImage:[UIImage imageNamed:@"material_shaixuan_xuanzhong.png"] forState:UIControlStateSelected];
        
        _timeButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
        _timeButton.tag = 400+i;
        _timeButton.layer.cornerRadius = 2;
        _timeButton.layer.masksToBounds = YES;
        [self.timeView addSubview:_timeButton];
    }
    
    NSString *nowString = [NSDate getCurrentYear];
    NSInteger nowYear = [nowString integerValue];//2015
    NSString *firstString = [NSString stringWithFormat:@"%ld", nowYear-1];
    NSString *secondString = [NSString stringWithFormat:@"%ld", nowYear-2];
    NSString *thirdString = [NSString stringWithFormat:@"%ld", nowYear-3];
    
    if ([_uploadYear isEqualToString:@"0"]) {
        _timeString = @"不限";
        _tag4 = 400;
    } else if ([_uploadYear isEqualToString:nowString]) {
        _timeString = nowString;
        _tag4 = 401;
    } else if ([_uploadYear isEqualToString:firstString]) {
        _timeString = firstString;
        _tag4 = 402;
    } else if ([_uploadYear isEqualToString:secondString]) {
        _timeString = secondString;
        _tag4 = 403;
    } else if ([_uploadYear isEqualToString:thirdString]) {
        _timeString = thirdString;
        _tag4 = 404;
    } else {
        _timeString = @"不限";
        _tag4 = 400;
    }
    _timeButton = (UIButton *)[self.timeView viewWithTag:_tag4];
    _timeButton.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initTeacherMaterialsFilterData
{
    if ([_formatString isEqualToString:@"不限"]) {
        _fileType = @"0";
    } else if ([_formatString isEqualToString:@"WORD"]) {
        _fileType = @"1";
    } else if ([_formatString isEqualToString:@"EXCEL"]) {
        _fileType = @"2";
    } else if ([_formatString isEqualToString:@"PPT"]) {
        _fileType = @"3";
    } else if ([_formatString isEqualToString:@"PDF"]) {
        _fileType = @"4";
    } else if ([_formatString isEqualToString:@"视频"]) {
        _fileType = @"5";
    } else {
        _fileType = @"0";
    }
    
    if ([_attributeString isEqualToString:@"不限"]) {
        _nameCode = @"0";
    } else if ([_attributeString isEqualToString:@"口语"]) {
        _nameCode = @"KY";
    } else if ([_attributeString isEqualToString:@"阅读"]) {
        _nameCode = @"YD";
    } else if ([_attributeString isEqualToString:@"写作"]) {
        _nameCode = @"XZ";
    } else if ([_attributeString isEqualToString:@"听力"]) {
        _nameCode = @"TL";
    } else {
        _nameCode = @"0";
    }
    
    if ([_sourceString isEqualToString:@"不限"]) {
        _roleId = @"0";
    } else if ([_sourceString isEqualToString:@"集团"]) {
        _roleId = @"1";
    } else if ([_sourceString isEqualToString:@"个人"]) {
        _roleId = @"2";
    } else {
        _roleId = @"0";
    }
    
    NSString *nowString = [NSDate getCurrentYear];
    NSInteger nowYear = [nowString integerValue];//2015
    NSString *firstString = [NSString stringWithFormat:@"%ld", nowYear-1];
    NSString *secondString = [NSString stringWithFormat:@"%ld", nowYear-2];
    NSString *thirdString = [NSString stringWithFormat:@"%ld", nowYear-3];

    if ([_timeString isEqualToString:@"不限"]) {
        _uploadYear = @"0";
    } else if ([_timeString isEqualToString:nowString]) {
        _uploadYear = nowString;
    } else if ([_timeString isEqualToString:firstString]) {
        _uploadYear = firstString;
    } else if ([_timeString isEqualToString:secondString]) {
        _uploadYear = secondString;
    } else if ([_timeString isEqualToString:thirdString]) {
        _uploadYear = thirdString;
    } else {
        _uploadYear = @"0";
    }
    
    if (self.block) {
        self.block(self, _fileType, _nameCode, _roleId, _uploadYear, 1);
    }
}

- (void)returnResult:(MaterialFilter)block
{
    self.block = block;
}

#pragma mark - event response
- (void)ensureButtonAction:(UIButton *)button
{
    //请求数据
    [self _initTeacherMaterialsFilterData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)formatButtonAction:(UIButton *)button
{
    if (_formatButton.tag != button.tag) {
        _formatButton.selected = NO;
        button.selected = YES;
        _formatButton = button;
    } else {
        _formatButton.selected = YES;
    }
    _formatString = _formatButton.titleLabel.text;
}

- (void)attributeButtonAction:(UIButton *)button
{
    if (_attributeButton.tag != button.tag) {
        _attributeButton.selected = NO;
        button.selected = YES;
        _attributeButton = button;
    } else {
        _attributeButton.selected = YES;
    }
    _attributeString = _attributeButton.titleLabel.text;
}

- (void)sourceButtonAction:(UIButton *)button
{
    if (_sourceButton.tag != button.tag) {
        _sourceButton.selected = NO;
        button.selected = YES;
        _sourceButton = button;
    } else {
        _sourceButton.selected = YES;
    }
    _sourceString = _sourceButton.titleLabel.text;
}

- (void)timeButtonAction:(UIButton *)button
{
    if (_timeButton.tag != button.tag) {
        _timeButton.selected = NO;
        button.selected = YES;
        _timeButton = button;
    } else {
        _timeButton.selected = YES;
    }
    _timeString = _timeButton.titleLabel.text;
}

#pragma mark - getters and setters
- (UIButton *)ensureButton
{
    if (!_ensureButton) {
        _ensureButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(ensureButtonAction:) Title:@"确定"];
        [_ensureButton setTitleColor:[CommentMethod colorFromHexRGB:@"818b8f"] forState:UIControlStateNormal];
        _ensureButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
    }
    return _ensureButton;
}

- (UIScrollView *)bjScrollView
{
    if (!_bjScrollView) {
        _bjScrollView = [UIScrollView new];
        _bjScrollView.showsHorizontalScrollIndicator = NO;
        _bjScrollView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
        _bjScrollView.contentSize = CGSizeMake(0, kScreenHeight);
        _bjScrollView.showsVerticalScrollIndicator = NO;
        _bjScrollView.bounces = NO;
    }
    return _bjScrollView;
}

- (UIView *)formatView
{
    if (!_formatView) {
        _formatView = [UIView new];
        _formatView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
        
    }
    return _formatView;
}

- (UIView *)attributeView
{
    if (!_attributeView) {
        _attributeView = [UIView new];
        _attributeView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _attributeView;
}

- (UIView *)sourceView
{
    if (!_sourceView) {
        _sourceView = [UIView new];
        _sourceView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _sourceView;
}

- (UIView *)timeView
{
    if (!_timeView) {
        _timeView = [UIView new];
        _timeView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _timeView;
}

- (NSArray *)formatArr
{
    if (!_formatArr) {
        _formatArr = @[@"不限",@"WORD",@"EXCEL",@"PPT",@"PDF",@"视频"];
    }
    return _formatArr;
}

- (NSArray *)attributeArr
{
    if (!_attributeArr) {
        _attributeArr = @[@"不限",@"口语",@"阅读",@"写作",@"听力"];
    }
    return _attributeArr;
}

- (NSArray *)sourceArr
{
    if (!_sourceArr) {
        _sourceArr = @[@"不限",@"集团",@"个人"];
    }
    return _sourceArr;
}

- (NSArray *)timeArr
{
    if (!_timeArr) {
        _timeArr = @[@"不限",@"2015",@"2014",@"2013",@"2012"];
    }
    return _timeArr;
}

- (UILabel *)formatLabel
{
    if (!_formatLabel) {
        _formatLabel = [CommentMethod createLabelWithFont:k_Font_2 Text:@"按格式"];
        _formatLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _formatLabel;
}

- (UIImageView *)lineImgView1
{
    if (!_lineImgView1) {
        _lineImgView1 = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
        _lineImgView1.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _lineImgView1;
}

- (UILabel *)attributeLabel
{
    if (!_attributeLabel) {
        _attributeLabel = [CommentMethod createLabelWithFont:k_Font_2 Text:@"按属性"];
        _attributeLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _attributeLabel;
}

- (UIImageView *)lineImgView2
{
    if (!_lineImgView2) {
        _lineImgView2 = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
        _lineImgView2.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _lineImgView2;
}

- (UILabel *)sourceLabel
{
    if (!_sourceLabel) {
        _sourceLabel = [CommentMethod createLabelWithFont:k_Font_2 Text:@"按来源"];
        _sourceLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _sourceLabel;
}

- (UIImageView *)lineImgView3
{
    if (!_lineImgView3) {
        _lineImgView3 = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
        _lineImgView3.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _lineImgView3;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [CommentMethod createLabelWithFont:k_Font_2 Text:@"按时间"];
        _timeLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _timeLabel;
}

- (UIImageView *)lineImgView4
{
    if (!_lineImgView4) {
        _lineImgView4 = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
        _lineImgView4.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _lineImgView4;
}

@end
