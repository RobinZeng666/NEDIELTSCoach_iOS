//
//  GradeCheckMarkView.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/10.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeCheckMarkView.h"
#import "SelectNumberView.h"

@interface GradeCheckMarkView()

@property (nonatomic,strong) UIView *contentViews;

@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,strong) UILabel *lineLabel;
@property (nonatomic,strong) UILabel *totalLabel;
@property (nonatomic,strong) UILabel *totalScoreLabel;

@property (nonatomic,copy) NSString *trScore;
@property (nonatomic,copy) NSString *ccScore;
@property (nonatomic,copy) NSString *lrScore;
@property (nonatomic,copy) NSString *graScore;

@end
@implementation GradeCheckMarkView

- (void)setFrame:(CGRect)frame
{
    CGRect currenFrame = CGRectMake(frame.origin.x, frame.origin.y, 300*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_Y);
    [super setFrame:currenFrame];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initView];
    }
    return self;
}
#pragma mark - view
- (void)_initView
{
    self.trScore = @"0";
    self.ccScore = @"0";
    self.lrScore = @"0";
    self.graScore = @"0";
    
//    NSArray *dataArray = @[@"TR",@"CC",@"LR",@"GRA"];
//    for (int i = 0; i<dataArray.count; i++) {
//        SelectNumberView *nuber = [[SelectNumberView alloc]initWithFrame:CGRectMake(10, 100+100*i, 300, 40)];
//        nuber.scoreType = dataArray[i];
//        nuber.numberData = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
//        [self addSubview:nuber];
//        
//        [nuber setBlock:^(NSString *scoreType,NSString *number) {
//            NDLog(@"%@____%@",scoreType,number);
//            
//            //计算总分
//            [self calculateCount:number type:scoreType];
//            
//            //将当前值传出
//            if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentScore:curentType:)]) {
//                [self.delegate getCurrentScore:number curentType:scoreType];
//            }
//        }];
//    }
}

//计算总分
- (void)calculateCount:(NSString *)score type:(NSString *)type
{
    if ([type isEqualToString:@"TR"]){
        self.trScore = score;
    }else if ([type isEqualToString:@"CC"])
    {
        self.ccScore = score;
    }else if ([type isEqualToString:@"LR"])
    {
        self.lrScore = score;
    }else if ([type isEqualToString:@"GRA"])
    {
        self.graScore = score;
    }

}


#pragma mark - set or get
- (UILabel *)topLabel
{
    if (!_topLabel) {
        _topLabel = [CommentMethod createLabelWithFont:20 Text:@"在线批改"];
    }
    return _topLabel;
}

- (UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [CommentMethod createLabelWithFont:0 Text:@""];
        _lineLabel.backgroundColor = RGBACOLOR(200, 200, 200, 1);
    }
    return _lineLabel;
}

- (UILabel *)totalLabel
{
    if (!_totalLabel) {
        _totalLabel = [CommentMethod createLabelWithFont:16.0f Text:@"总分"];
    }
    return _totalLabel;
}

- (UILabel *)totalScoreLabel
{
    if (!_totalScoreLabel) {
        _totalScoreLabel = [CommentMethod createLabelWithFont:28.0f Text:@""];
    }
    return _totalScoreLabel;
}

@end
