//
//  CollectTableViewCell.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectMaterialModel.h"

@interface CollectTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel     *titLabel;
@property (nonatomic,strong) UIImageView *lineImgView;

@property (nonatomic,strong) CollectMaterialModel *model;

@end
