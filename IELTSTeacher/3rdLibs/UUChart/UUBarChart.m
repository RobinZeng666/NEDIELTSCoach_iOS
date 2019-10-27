//
//  UUBarChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBarChart.h"
#import "UUChartLabel.h"
#import "UUBar.h"


#define yCount 10
@interface UUBarChart ()
{
    UIScrollView *myScrollView;
    //提示
    UIImageView *popView;
    UILabel *disLabel;
}
@end

@implementation UUBarChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
        [self addSubview:myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < yCount) {
        max = yCount;
    }
    if (self.showRange) {
        _yValueMin = (int)min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    float level = (_yValueMax-_yValueMin) /(yCount-1);
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /(yCount-1);
    
    for (int i=0; i<yCount; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight)];
		label.text = [NSString stringWithFormat:@"%.1f",level * i+_yValueMin];
		[self addSubview:label];
    }
    
//    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, 1, chartCavanHeight)];
//    lineLabel.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:lineLabel];
}

-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xLabels = xLabels;
    NSInteger num ;
    if (xLabels.count>=8) {
        num = 8;
    }else if (xLabels.count<=4){
        num = 4;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = myScrollView.frame.size.width/num;
    
    for (int i=0; i<xLabels.count; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((i *  _xLabelWidth ), self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = xLabels[i];
        [myScrollView addSubview:label];
        
        [_chartLabelsForX addObject:label];
    }
    
    float max = (([xLabels count]-1)*_xLabelWidth + chartMargin)+_xLabelWidth;
    if (myScrollView.frame.size.width < max-10) {
        myScrollView.contentSize = CGSizeMake(max, self.frame.size.height);
    }
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

-(void)strokeChart
{
    
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
	
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
            
            UUBar * bar = [[UUBar alloc] initWithFrame:CGRectMake((j+0.35)*_xLabelWidth , UULabelHeight, _xLabelWidth * 0.3, chartCavanHeight)];
            bar.barColor = [_colors objectAtIndex:i];
            bar.grade = grade;
            bar.tag = j;
            [myScrollView addSubview:bar];
            
            bar.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTip:)];
            [bar addGestureRecognizer:tap];
        }
    }
    
    //PopView
    if (popView != nil) {
        [popView removeFromSuperview];
        popView = nil;
    }
    popView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 27*AUTO_SIZE_SCALE_X, 31*AUTO_SIZE_SCALE_X)];
    popView.image = [UIImage imageNamed:@"classDetail_qipao.png"];
    [popView setAlpha:0.0f];
    
    disLabel = [[UILabel alloc]initWithFrame:CGRectMake(popView.frame.origin.x, popView.frame.origin.y, 27*AUTO_SIZE_SCALE_X, 27*AUTO_SIZE_SCALE_X)];
    disLabel.font = [UIFont systemFontOfSize:16.0f*AUTO_SIZE_SCALE_X];
    [disLabel setTextAlignment:NSTextAlignmentCenter];
    [popView addSubview:disLabel];
    [self addSubview:popView];
    [disLabel setTextColor:[UIColor whiteColor]];

}

- (void)showTip:(UITapGestureRecognizer *)tap
{
    
    @try {
        

        
        UUBar *bar = (UUBar *)tap.view;
        NSLog(@"%ld",(long)bar.tag);
         NSUInteger tag = bar.tag;
        
        NSArray *childAry = _yValues[0];
        NSString *valueString = childAry[tag];
        float value = [valueString floatValue];
        float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        
        //        SHPlot *_plot = objc_getAssociatedObject(btn, kAssociatedPlotObject);
        //        NSString *text = [[_plot.plottingPointsLabels objectAtIndex:tag] stringValue];
        
        [disLabel setText:self.yValues[0][tag]];
        popView.frame = CGRectMake((tag+0.75)*_xLabelWidth,chartCavanHeight*(1-grade)-15, 27*AUTO_SIZE_SCALE_X, 31*AUTO_SIZE_SCALE_Y);
        [popView setAlpha:1.0f];
        
        [UIView animateWithDuration:1 animations:^{
            [popView setAlpha:0.0f];
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"plotting label is not available for this point");
    }
}




- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
