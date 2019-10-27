//
//  RemindCell.h
//  IELTSStudent
//
//  Created by DevNiudun on 15/6/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel     *titLabel;
@property (nonatomic,strong) UILabel     *detailLabel;
//@property (nonatomic,strong) UIImageView *lineImgView;
@property (nonatomic,strong) UIImageView *accessoryImgView;
@property (nonatomic,copy) NSString      *imgName;
@property (nonatomic,copy) NSString      *titleStr;

@end
