//
//  StartSingleCollectionReusableView.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/18.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadModel.h"
@interface StartSingleCollectionReusableView : UICollectionReusableView

@property (nonatomic,strong)HeadModel *headerModel;
@property (nonatomic,copy) NSString *userIcon;


@end
