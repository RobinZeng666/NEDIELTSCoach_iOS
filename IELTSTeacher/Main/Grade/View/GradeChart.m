//
//  GradeChart.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/30.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeChart.h"
#import "UUChart.h"

@interface GradeChart ()<UUChartDataSource>{
    UUChart *chartView;
}
@end


@implementation GradeChart

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        CGRect supFrame = CGRectMake(0, 0, kScreenWidth, 150);
//        self.frame = supFrame;
//        [self configUI];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self configUI];
    }
    return self;
}

- (void)setLineChatValueX:(NSArray *)lineChatValueX
{
    if (_lineChatValueX != lineChatValueX) {
        _lineChatValueX = lineChatValueX;
        [self configUI];
    }
}
- (void)setLineChatX:(NSArray *)lineChatX
{
    if (_lineChatX != lineChatX) {
        _lineChatX = lineChatX;
        [self configUI];
    }
}

- (void)setBarChatValueX:(NSArray *)barChatValueX
{
    if (_barChatValueX != barChatValueX) {
        _barChatValueX = barChatValueX;
        [self configUI];
    }
}


- (void)configUI
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }

    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(20, 10,kScreenWidth-40, self.frame.size.height-20)
                                              withSource:self
                                               withStyle:self.isLineChat?UUChartLineStyle:UUChartBarStyle];
    [chartView showInView:self];
    
//    chartView.backgroundColor = [UIColor orangeColor];
//    self.backgroundColor = [UIColor redColor];
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    if (self.isLineChat) {
        return self.lineChatX;
    }else{
        return @[@"总分",@"听力",@"口语",@"写作",@"阅读"];
    }
}


//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    if (self.isLineChat) {
        return @[self.lineChatValueX];
    }else{
        if (self.barChatValueX.count > 0) {
            return @[self.barChatValueX];
        }
    }
    return nil;
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[k_PinkColor];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    return CGRangeMake(9, 0);
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}



@end
