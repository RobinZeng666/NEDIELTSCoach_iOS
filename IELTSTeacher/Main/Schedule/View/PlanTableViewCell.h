//
//  PlanTableViewCell.h
//  IELTSStudent
//
//  Created by DevNiudun on 15/7/1.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanViewModel.h"
@interface PlanTableViewCell : UITableViewCell

@property (nonatomic,strong) PlanViewModel *planModel;

@property (nonatomic,assign) BOOL isCurrentDate;

@property (nonatomic,strong) UIImageView *selectImageView;
@property (nonatomic,strong) UIImageView *detailImageView;

@end
