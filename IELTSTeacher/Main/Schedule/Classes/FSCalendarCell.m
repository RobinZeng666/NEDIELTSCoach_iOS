//
//  FSCalendarCell.m
//  Pods
//
//  Created by Wenchao Ding on 12/3/15.
//
//

#import "FSCalendarCell.h"
#import "FSCalendar.h"
#import "UIView+FSExtension.h"
#import "NSDate+FSExtension.h"

#define kAnimationDuration 0.15

#define kScaleCount  8.0

@interface FSCalendarCell ()

@property (strong,   nonatomic) CAShapeLayer *backgroundLayer;
@property (strong,   nonatomic) CAShapeLayer *eventLayer1;
@property (strong,   nonatomic) CAShapeLayer *eventLayer2;
@property (strong,   nonatomic) CAShapeLayer *eventLayer3;
@property (strong,   nonatomic) CAShapeLayer *eventLayer4;
@property (strong,   nonatomic) CAShapeLayer *eventLayer5;
@property (strong,   nonatomic) CAShapeLayer *eventLayer6;
@property (readonly, nonatomic) BOOL         today;
@property (readonly, nonatomic) BOOL         weekend;


- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary;

@end

@implementation FSCalendarCell

#pragma mark - Init and life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.font = [UIFont systemFontOfSize:10];
        subtitleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:subtitleLabel];
        self.subtitleLabel = subtitleLabel;
        
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.backgroundColor = [UIColor clearColor].CGColor;
        _backgroundLayer.hidden = YES;
        [self.contentView.layer insertSublayer:_backgroundLayer atIndex:0];
        
        _bottomLine= [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = RGBACOLOR(200, 200, 200, 1);
        [self.contentView addSubview:_bottomLine];
        
        
        _eventLayer4 = [CAShapeLayer layer];
        _eventLayer4.backgroundColor = [UIColor clearColor].CGColor;
        _eventLayer4.fillColor = [UIColor cyanColor].CGColor;
        _eventLayer4.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer4.bounds].CGPath;
        _eventLayer4.hidden = YES;
        [self.contentView.layer addSublayer:_eventLayer4];
        
        _eventLayer5 = [CAShapeLayer layer];
        _eventLayer5.backgroundColor = [UIColor clearColor].CGColor;
        _eventLayer5.fillColor = [UIColor cyanColor].CGColor;
        _eventLayer5.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer5.bounds].CGPath;
        _eventLayer5.hidden = YES;
        [self.contentView.layer addSublayer:_eventLayer5];
        
        _eventLayer6 = [CAShapeLayer layer];
        _eventLayer6.backgroundColor = [UIColor clearColor].CGColor;
        _eventLayer6.fillColor = [UIColor cyanColor].CGColor;
        _eventLayer6.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer6.bounds].CGPath;
        _eventLayer6.hidden = YES;
        [self.contentView.layer addSublayer:_eventLayer6];



        
        _eventLayer1 = [CAShapeLayer layer];
        _eventLayer1.backgroundColor = [UIColor clearColor].CGColor;
        _eventLayer1.fillColor = [UIColor cyanColor].CGColor;
        _eventLayer1.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer1.bounds].CGPath;
        _eventLayer1.hidden = YES;
        [self.contentView.layer addSublayer:_eventLayer1];
        
        
        _eventLayer2 = [CAShapeLayer layer];
        _eventLayer2.backgroundColor = [UIColor clearColor].CGColor;
        _eventLayer2.fillColor = [UIColor cyanColor].CGColor;
        _eventLayer2.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer2.bounds].CGPath;
        _eventLayer2.hidden = YES;
        [self.contentView.layer addSublayer:_eventLayer2];
        
        _eventLayer3 = [CAShapeLayer layer];
        _eventLayer3.backgroundColor = [UIColor clearColor].CGColor;
        _eventLayer3.fillColor = [UIColor cyanColor].CGColor;
        _eventLayer3.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer3.bounds].CGPath;
        _eventLayer3.hidden = YES;
        [self.contentView.layer addSublayer:_eventLayer3];
        
        
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    CGFloat titleHeight = self.bounds.size.height*5.0/kScaleCount;
    CGFloat diameter = MIN(self.bounds.size.height*5.0/kScaleCount,self.bounds.size.width);
    _backgroundLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2,
                                        (titleHeight-diameter)/2,
                                        diameter,
                                        diameter);
//    _backgroundLayer.backgroundColor = [UIColor redColor].CGColor;
//    NSLog(@"%ld_______setBounds______",(long)_hasEventCount);
    
    _bottomLine.frame = CGRectMake(0, -5, self.bounds.size.width, 0.5);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [CATransaction setDisableActions:YES];
}

#pragma mark - Public

- (void)showAnimation
{
    _backgroundLayer.hidden = NO;
    _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
    _backgroundLayer.fillColor = [self colorForCurrentStateInDictionary:_backgroundColors].CGColor;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.fromValue = @0.3;
    zoomOut.toValue = @1.2;
    zoomOut.duration = kAnimationDuration/4*3;
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomIn.fromValue = @1.2;
    zoomIn.toValue = @1.0;
    zoomIn.beginTime = kAnimationDuration/4*3;
    zoomIn.duration = kAnimationDuration/4;
    group.duration = kAnimationDuration;
    group.animations = @[zoomOut, zoomIn];
    [_backgroundLayer addAnimation:group forKey:@"bounce"];
    [self configureCell];
    
    
}

- (void)hideAnimation
{
    _backgroundLayer.hidden = YES;
    [self configureCell];
}

#pragma mark - Private

- (void)configureCell
{

    _titleLabel.text = [NSString stringWithFormat:@"%@",@(_date.fs_day)];
    _subtitleLabel.text = _subtitle;
    _titleLabel.textColor = [self colorForCurrentStateInDictionary:_titleColors];
    _subtitleLabel.textColor = [self colorForCurrentStateInDictionary:_subtitleColors];
    _backgroundLayer.fillColor = [self colorForCurrentStateInDictionary:_backgroundColors].CGColor;

    
    if (self.isToday) {
        if (self.isSelected) {
            _titleLabel.textColor = [UIColor whiteColor];
        }else
        {
            _titleLabel.textColor = [UIColor redColor];
            _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
        }
    }
    
    CGFloat titleHeight = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
    if (_subtitleLabel.text) {
        _subtitleLabel.hidden = NO;
        CGFloat subtitleHeight = [_subtitleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.subtitleLabel.font}].height;
        CGFloat height = titleHeight + subtitleHeight;
        _titleLabel.frame = CGRectMake(0,
                                       (self.contentView.fs_height*5.0/kScaleCount-height)*0.5,
                                       self.fs_width,
                                       titleHeight);
        
        _subtitleLabel.frame = CGRectMake(0,
                                          _titleLabel.fs_bottom - (_titleLabel.fs_height-_titleLabel.font.pointSize),
                                          self.fs_width,
                                          subtitleHeight);
    } else {
        _titleLabel.frame = CGRectMake(0, 0, self.fs_width, floor(self.contentView.fs_height*5.0/kScaleCount));
        _subtitleLabel.hidden = YES;
    }
    _backgroundLayer.hidden = !self.selected && !self.isToday && !self.hasEventCount;
    _backgroundLayer.path = _cellStyle == FSCalendarCellStyleCircle ?
    [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath :
    [UIBezierPath bezierPathWithRect:_backgroundLayer.bounds].CGPath;
    
    
    _eventLayer1.fillColor = _eventColor.CGColor;
    _eventLayer2.fillColor = _eventColor.CGColor;
    _eventLayer3.fillColor = _eventColor.CGColor;
    _eventLayer4.fillColor = _eventColor.CGColor;
    _eventLayer5.fillColor = _eventColor.CGColor;
    _eventLayer6.fillColor = _eventColor.CGColor;
    
//    NSLog(@"%ld_______configureCell______",(long)_hasEventCount);
}

- (BOOL)isPlaceholder
{
    return ![_date fs_isEqualToDateForMonth:_month];
}

- (BOOL)isToday
{
    return [_date fs_isEqualToDateForDay:_currentDate];
}

- (BOOL)isWeekend
{
    return self.date.fs_weekday == 1 || self.date.fs_weekday == 7;
}

- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary
{
    if (self.isSelected) {
        return dictionary[@(FSCalendarCellStateSelected)];
    }
//    if (self.isToday) {
//        return dictionary[@(FSCalendarCellStateToday)];
//    }
    if (self.isPlaceholder) {
        return dictionary[@(FSCalendarCellStatePlaceholder)];
    }
    if (self.isWeekend && [[dictionary allKeys] containsObject:@(FSCalendarCellStateWeekend)]) {
        return dictionary[@(FSCalendarCellStateWeekend)];
    }
    
    if (self.hasEventCount) {
        return dictionary[@(FSCalendarCellStateHasEvent)];
    }
    
    return dictionary[@(FSCalendarCellStateNormal)];
}


- (void)setHasEventCount:(NSInteger)hasEventCount
{
    if (_hasEventCount != hasEventCount) {
        _hasEventCount = hasEventCount;
        [self _changeEventFrame:_hasEventCount];
    }
}

- (void)_changeEventFrame:(NSInteger)eventCount
{
    
    CGFloat backgroundWith = _backgroundLayer.frame.size.width;
    CGFloat backgroundX = _backgroundLayer.frame.origin.x;
    CGFloat eventSize = _backgroundLayer.frame.size.height/kScaleCount;
    CGFloat selfWidth = self.frame.size.width;
//    NDLog(@"%f",self.frame.size.width);
//    NDLog(@"%f",backgroundWith);
    if (eventCount == 0) {
        _eventLayer1.hidden = YES;
        _eventLayer2.hidden = YES;
        _eventLayer3.hidden = YES;
        _eventLayer4.hidden = YES;
        _eventLayer5.hidden = YES;
        _eventLayer6.hidden = YES;

    }else if (eventCount == 1)
    {
        _eventLayer1.frame = CGRectMake(
                                        (selfWidth-eventSize)/2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer1.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer1.bounds].CGPath;
        _eventLayer1.hidden = NO;
        _eventLayer2.hidden = YES;
        _eventLayer3.hidden = YES;
        _eventLayer4.hidden = YES;
        _eventLayer5.hidden = YES;
        _eventLayer6.hidden = YES;
        
    }else if (eventCount == 2)
    {
        CGFloat gapWidth = (backgroundWith-eventSize*2)/3;
        _eventLayer1.frame = CGRectMake(gapWidth+backgroundX+eventSize/2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer1.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer1.bounds].CGPath;
        
        _eventLayer2.frame = CGRectMake(
                                        gapWidth*2+eventSize+backgroundX-eventSize/2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer2.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer2.bounds].CGPath;
        
        _eventLayer1.hidden = NO;
        _eventLayer2.hidden = NO;
        _eventLayer3.hidden = YES;
        _eventLayer4.hidden = YES;
        _eventLayer5.hidden = YES;
        _eventLayer6.hidden = YES;

    
    }else if (eventCount == 3)
    {
        CGFloat gapWidth = (backgroundWith-eventSize*3)/4;
        _eventLayer1.frame = CGRectMake(
                                        gapWidth+backgroundX,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer1.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer1.bounds].CGPath;
        
        _eventLayer2.frame = CGRectMake(
                                        gapWidth*2+backgroundX+eventSize,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer2.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer2.bounds].CGPath;
        
        _eventLayer3.frame = CGRectMake(
                                         gapWidth*3+backgroundX+eventSize*2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer3.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer3.bounds].CGPath;
        
        _eventLayer1.hidden = NO;
        _eventLayer2.hidden = NO;
        _eventLayer3.hidden = NO;
        _eventLayer4.hidden = YES;
        _eventLayer5.hidden = YES;
        _eventLayer6.hidden = YES;
    
    }else if (eventCount == 4)
    {
        CGFloat gapWidth = (backgroundWith-eventSize*3)/4;
        _eventLayer1.frame = CGRectMake(
                                        gapWidth+backgroundX,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize/2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer1.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer1.bounds].CGPath;
        
        _eventLayer2.frame = CGRectMake(
                                        gapWidth*2+backgroundX+eventSize,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize/2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer2.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer2.bounds].CGPath;
        
        _eventLayer3.frame = CGRectMake(
                                        gapWidth*3+backgroundX+eventSize*2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize/2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer3.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer3.bounds].CGPath;
        
        
        
        _eventLayer4.frame = CGRectMake(
                                        (selfWidth-eventSize)/2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize*2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer4.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer4.bounds].CGPath;
        
        _eventLayer1.hidden = NO;
        _eventLayer2.hidden = NO;
        _eventLayer3.hidden = NO;
        _eventLayer4.hidden = NO;
        _eventLayer5.hidden = YES;
        _eventLayer6.hidden = YES;

    
    }else if (eventCount == 5)
    {
        CGFloat gapWidth = (backgroundWith-eventSize*3)/4;
        _eventLayer1.frame = CGRectMake(
                                        gapWidth+backgroundX,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize/2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer1.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer1.bounds].CGPath;
        
        _eventLayer2.frame = CGRectMake(
                                        gapWidth*2+backgroundX+eventSize,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize/2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer2.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer2.bounds].CGPath;
        
        _eventLayer3.frame = CGRectMake(
                                        gapWidth*3+backgroundX+eventSize*2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize/2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer3.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer3.bounds].CGPath;
        
        
        
        CGFloat gapWidth2 = (backgroundWith-eventSize*2)/3;
        _eventLayer4.frame = CGRectMake(gapWidth2+backgroundX+eventSize/2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize*2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer4.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer4.bounds].CGPath;
        
        _eventLayer5.frame = CGRectMake(
                                        gapWidth2*2+eventSize+backgroundX-eventSize/2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize*2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer5.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer5.bounds].CGPath;
        
        
        _eventLayer1.hidden = NO;
        _eventLayer2.hidden = NO;
        _eventLayer3.hidden = NO;
        _eventLayer4.hidden = NO;
        _eventLayer5.hidden = NO;
        _eventLayer6.hidden = YES;
    
    }else if (eventCount >= 6)
    {
        CGFloat gapWidth = (backgroundWith-eventSize*3)/4;
        _eventLayer1.frame = CGRectMake(
                                        gapWidth+backgroundX,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize/2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer1.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer1.bounds].CGPath;
        
        _eventLayer2.frame = CGRectMake(
                                        gapWidth*2+backgroundX+eventSize,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize/2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer2.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer2.bounds].CGPath;
        
        _eventLayer3.frame = CGRectMake(
                                        gapWidth*3+backgroundX+eventSize*2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize/2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer3.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer3.bounds].CGPath;
        

        _eventLayer4.frame = CGRectMake(
                                        gapWidth+backgroundX,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize*2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer4.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer4.bounds].CGPath;
        
        _eventLayer5.frame = CGRectMake(
                                        gapWidth*2+backgroundX+eventSize,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize*2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer5.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer5.bounds].CGPath;
        
        _eventLayer6.frame = CGRectMake(
                                        gapWidth*3+backgroundX+eventSize*2,
                                        CGRectGetMaxY(_backgroundLayer.frame)+eventSize*2,
                                        eventSize,
                                        eventSize
                                        );
        _eventLayer6.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer6.bounds].CGPath;

        _eventLayer1.hidden = NO;
        _eventLayer2.hidden = NO;
        _eventLayer3.hidden = NO;
        _eventLayer4.hidden = NO;
        _eventLayer5.hidden = NO;
        _eventLayer6.hidden = NO;

    }
}


@end
