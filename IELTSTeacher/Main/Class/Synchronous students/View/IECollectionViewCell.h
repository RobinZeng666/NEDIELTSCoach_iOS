//
//  IECollectionViewCell.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IECollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, copy) NSString      *imgString;
@property (nonatomic, copy) NSString      *nameString;

@end
