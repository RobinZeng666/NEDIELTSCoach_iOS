//
//  FileTableViewCell.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/18.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyMaterialModel.h"

@interface FileTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView   *imgView;
@property (nonatomic, strong) UILabel       *titLabel;
@property (nonatomic, strong) UIImageView   *verImgView;
@property (nonatomic, strong) UILabel       *detailLabel;
@property (nonatomic, strong) UILabel       *dateLabel;
@property (nonatomic, strong) UIImageView   *lineImgView;

@property (nonatomic, strong) StudyMaterialModel *model;

@end
