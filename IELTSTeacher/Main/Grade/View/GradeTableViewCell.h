//
//  GradeTableViewCell.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/23.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeViewModel.h"
@interface GradeTableViewCell : UITableViewCell


@property (nonatomic,strong) GradeViewModel *model;

@property (nonatomic,strong) UILabel *classNumber;//课次


@end
