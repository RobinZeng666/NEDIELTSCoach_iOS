//
//  GradeChart.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/30.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeChart : UIView

@property (nonatomic,assign) BOOL isLineChat; //为真，折线图，假，柱状图

@property (nonatomic,strong) NSArray *lineChatX;    //折线横坐标
@property (nonatomic,strong) NSArray *lineChatValueX;//折现图
@property (nonatomic,strong) NSArray *barChatValueX; //柱状图

@end
