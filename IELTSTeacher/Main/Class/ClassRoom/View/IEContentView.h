//
//  IEContentView.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/25.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IEButton;
@interface IEContentView : UIView
/**
 *  答题卡按钮
 */
@property(nonatomic,strong)IEButton * sheetButton;
/**
 *  分组练按钮
 */
@property(nonatomic,strong)IEButton * practiceButton;
/**
 *  投票题按钮
 */
@property(nonatomic,strong)IEButton * voteButton;
/**
 *  抢答题按钮
 */
@property(nonatomic,strong)IEButton * buzzerButton;
/**
 *  更多按钮
 */
@property(nonatomic,strong)IEButton * moreButton;



@end
