//
//  StudentListCollectionViewCell.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManualNoneModel.h"

@interface StudentListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, copy) NSString *imgString;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, strong) UIButton *flagButton;

@property (nonatomic, strong) ManualNoneModel *manualModel;

@end
