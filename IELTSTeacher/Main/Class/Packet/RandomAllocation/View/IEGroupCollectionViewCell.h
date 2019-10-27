//
//  IEGroupCollectionViewCell.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/2.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomListModel.h"

@interface IEGroupCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) RandomListModel *randomModel;

@end
