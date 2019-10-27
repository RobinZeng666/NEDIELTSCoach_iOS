//
//  CustomSliderView.h
//  SpeakDemo
//
//  Created by DevNiudun on 15/7/18.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSliderViewDelegate  <NSObject>
- (void)valueChange:(float)value;
@end

@interface CustomSliderView : UIView

@property (nonatomic,assign) id<CustomSliderViewDelegate>delegate;
@property (nonatomic,strong) UISlider    *volumeSlide; //滑动视图
@property (nonatomic,strong) UIImageView *showImage;   //显示视图
@end
