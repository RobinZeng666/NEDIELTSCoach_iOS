//
//  GradeCheckViewCell.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeCheckModel.h"

@interface GradeCheckViewCell : UITableViewCell

@property (nonatomic,strong) GradeCheckModel *checkModel;
@property (nonatomic,assign) NSInteger serial;

@end
