//
//  ReportTableViewCell.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDModel.h"

@interface ReportTableViewCell : UITableViewCell

@property (nonatomic,strong) IDModel *model;
@property (nonatomic,assign) NSInteger indexRow;

@end
