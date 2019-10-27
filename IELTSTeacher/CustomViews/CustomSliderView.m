//
//  CustomSliderView.m
//  SpeakDemo
//
//  Created by DevNiudun on 15/7/18.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import "CustomSliderView.h"


#define bottomBackColor RGBACOLOR(235.0, 235.0, 235.0, 1.0);
#define showBackColor   k_PinkColor

@interface CustomSliderView ()


@property (nonatomic,strong) UIImageView *bottomImage; //底部视图


@property (nonatomic,strong) UIView      *contenView; //俯视图

@property (nonatomic,assign) CGFloat selfWidth;
@property (nonatomic,assign) CGFloat selfHeight;

@end

@implementation CustomSliderView
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect cFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 8);
    self = [super initWithFrame:cFrame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        self.selfHeight = cFrame.size.height;
        self.selfWidth = cFrame.size.width;
        
        self.bottomImage.frame = self.bounds;
//        self.showImage.frame = self.bounds;
        
        self.volumeSlide.frame = CGRectMake(-5, 0, self.selfWidth+10, self.selfHeight);
        self.showImage.frame = CGRectMake(0, 0, self.selfWidth * self.volumeSlide.value, self.selfHeight);
        [self addSubview:self.bottomImage];
        [self addSubview:self.showImage];
        [self addSubview:self.volumeSlide];
        
        [self cicyImageView:self.bottomImage];
        [self cicyImageView:self.showImage];
    }
    return self;
}

- (void)cicyImageView:(UIView *)view
{
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 8/2;
}

#pragma mark - event response
- (void)valueChange:(UISlider *)slider
{
    self.showImage.frame = CGRectMake(0, 0, (self.selfWidth+5) * slider.value, self.selfHeight);
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChange:)]) {
        [self.delegate valueChange:slider.value];
    }
}

#pragma mark - set or get
- (UISlider *)volumeSlide
{
    if (!_volumeSlide) {
        _volumeSlide = [[UISlider alloc]init];
        [_volumeSlide setMaximumTrackImage:[UIImage imageNamed:@"checkList_clearBack.png"] forState:UIControlStateNormal];
        [_volumeSlide setMinimumTrackImage:[UIImage imageNamed:@"checkList_clearBack.png"] forState:UIControlStateNormal];
        [_volumeSlide setThumbImage:[UIImage imageNamed:@"checkList_PlayThumb.png"] forState:UIControlStateNormal];
        _volumeSlide.maximumValue = 1;
        _volumeSlide.minimumValue = 0;
//        _volumeSlide.value = 0;
        [_volumeSlide addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _volumeSlide;
}

- (UIImageView *)showImage
{
    if (!_showImage) {
        _showImage = [[UIImageView alloc]init];
        _showImage.backgroundColor = showBackColor;
    }
    return _showImage;
}

- (UIImageView *)bottomImage
{
    if (!_bottomImage) {
        _bottomImage = [[UIImageView alloc]init];
        _bottomImage.backgroundColor = bottomBackColor;
    }
    return _bottomImage;
}

@end
