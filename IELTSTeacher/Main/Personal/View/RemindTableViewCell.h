//
//  RemindTableViewCell.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RemindModel.h"

@interface RemindTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel     *titLabel;
@property (nonatomic,strong) UIImageView *localImgView;
@property (nonatomic,strong) UILabel     *detailLabel;
@property (nonatomic,strong) UILabel     *dateLabel;
@property (nonatomic,strong) UILabel     *timeLabel;

@property (nonatomic,strong) RemindModel *model;

@end
