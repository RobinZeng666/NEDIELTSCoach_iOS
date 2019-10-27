//
//  ScoreTableViewCell.h
//  SingleDemo
//
//  Created by DevNiudun on 15/8/5.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScorceModel.h"

@protocol ScoreTableViewCellDelegate<NSObject>
- (void)filterHeaderViewMoreBtnClicked:(UIButton *)button;
@end
@interface ScoreTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *expansionButton; //展开按钮
@property (nonatomic, weak)   id<ScoreTableViewCellDelegate>delegate;
@property (nonatomic, strong) ScorceModel *scorModel;

@end
