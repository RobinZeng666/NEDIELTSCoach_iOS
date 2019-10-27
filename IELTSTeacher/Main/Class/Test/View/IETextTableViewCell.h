//
//  IETextTableViewCell.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/29.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IETextTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) UIImage *renderedMark;
@property (nonatomic, strong) UIImageView *lineImgView;

@end
