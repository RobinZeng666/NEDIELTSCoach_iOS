//
//  NewsTableViewCell.h
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/15.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel     *titLabel;
@property (nonatomic,strong) UILabel     *dateLabel;
@property (nonatomic,strong) UIImageView *lineImgView;

@property (nonatomic,strong) NewsModel   *model;

@end
