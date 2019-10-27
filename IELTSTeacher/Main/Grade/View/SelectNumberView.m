//
//  SelectNumberView.m
//  PointBt
//
//  Created by DevNiudun on 15/7/9.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import "SelectNumberView.h"

#define kTags 100
#define kLabelWidth (35*AUTO_SIZE_SCALE_Y)
#define kLabelHeight (45*AUTO_SIZE_SCALE_Y)
#define kNormalFont   18.0f*AUTO_SIZE_SCALE_X
#define kSelectFont   35.0f*AUTO_SIZE_SCALE_Y
#define kNormalTextColor   [UIColor darkGrayColor]
#define kSelectTextColor   [UIColor redColor]
#define kBackViewColor     [UIColor colorWithRed:230.0/255.0 green:230.0/255.0f blue:230.0/255.0 alpha:1.0]

@interface SelectNumberView()
@property (nonatomic,strong) UILabel      *typeLabel;
@property (nonatomic,strong) UIView       *backView;
@property (nonatomic,strong) UILabel      *numberLabel;

@property (nonatomic,assign) NSInteger curentPage;
@property (nonatomic,copy) NSString *curentText;

@end

@implementation SelectNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self _initView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGRect rect  = CGRectMake(frame.origin.x, frame.origin.y, kLabelWidth*9+kLabelHeight, kLabelHeight);
    [super setFrame:rect];
}


#pragma mark - 初始化视图
- (void)_initView
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.typeLabel];
    self.curentPage = 1;
    self.backgroundColor = kBackViewColor;
    
    self.layer.cornerRadius = kLabelHeight/2;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    
}

- (void)setScoreType:(NSString *)scoreType
{
    if (_scoreType != scoreType) {
        _scoreType = scoreType;
        self.typeLabel.text = scoreType;
    }
}

- (void)setNumberData:(NSArray *)numberData
{
    if (_numberData != numberData) {
        _numberData = numberData;
        [self createrLabel:numberData];
    }
}

- (void)setCurentScore:(NSInteger)curentScore
{
//    if (_curentScore != curentScore) {
        _curentScore = curentScore;
        //初始化成绩
        [self changeBigLabel:curentScore];
//    }
}

//创建label
- (void)createrLabel:(NSArray *)numberArray
{
    if (numberArray.count > 0) {
        for (int i = 0; i<numberArray.count; i++) {
            _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLabelWidth*(i+1)+5, 0, kLabelWidth, kLabelHeight)];
            _numberLabel.textAlignment = NSTextAlignmentCenter;
            _numberLabel.backgroundColor = [UIColor clearColor];
            _numberLabel.textColor = kNormalTextColor;
            _numberLabel.text = numberArray[i];
            _numberLabel.tag = i+kTags;
            _numberLabel.font = [UIFont systemFontOfSize:kNormalFont*AUTO_SIZE_SCALE_X];
            [self.backView addSubview:self.numberLabel];
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];

   
}


//2.计算坐标
-(void)touchFace:(CGPoint)point
{
    //1.计算页数
    NSInteger page = (NSInteger)point.x/ (NSInteger)kLabelWidth;
    if (page > _numberData.count || page == 0) {
        return;
    }
    
    NSString *data = [_numberData objectAtIndex:page-1];
    self.curentText = data;
    //放大效果
    [self changeBigLabel:page];
}

- (void)changeBigLabel:(NSInteger)page
{
    UILabel *label = (UILabel *)[self.backView viewWithTag:self.curentPage];
    if (label) {
        label.textColor = kNormalTextColor;
        label.font = [UIFont systemFontOfSize:kNormalFont*AUTO_SIZE_SCALE_X];
    }
    
    self.curentPage = page-1+kTags;
    UILabel *numberLabel =  (UILabel *)[self.backView viewWithTag:page-1+kTags];
    numberLabel.textColor = kSelectTextColor;
    numberLabel.font = [UIFont systemFontOfSize:kSelectFont*AUTO_SIZE_SCALE_X];
}


#pragma mark - touches actions
//touch开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
}
//开始移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
    
}
//touch结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //回调block
    if (self.block != nil) {
        self.block(self.scoreType,self.curentText,self.curentTag);
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //回调block
    if (self.block != nil) {
        self.block(self.scoreType,self.curentText,self.curentTag);
    }
}
#pragma mark - set or get
- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kLabelHeight, kLabelHeight)];
        _typeLabel.backgroundColor = k_PinkColor;//[UIColor redColor];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.cornerRadius = kLabelHeight/2;
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _typeLabel.layer.borderWidth = 1;
        _typeLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _typeLabel;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:self.bounds];
    }
    return _backView;
}


@end
