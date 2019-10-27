//
//  ManualDetailCollectionViewCell.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/10/26.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManualGroupModel.h"

@interface ManualDetailCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) ManualGroupModel *manualModel;

@end
