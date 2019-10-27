//
//  SelectNumberView.h
//  PointBt
//
//  Created by DevNiudun on 15/7/9.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString *scoreType,NSString *number,NSString *curentTag);

@interface SelectNumberView : UIView

@property (nonatomic,copy) NSString *scoreType; //当前类型
@property (nonatomic,copy) NSString *curentTag; //表示当前tag
@property (nonatomic,strong) NSArray *numberData; //分数数组

@property (nonatomic, copy)SelectedBlock block;

@property (nonatomic, assign) NSInteger curentScore; //当前成绩


@end
