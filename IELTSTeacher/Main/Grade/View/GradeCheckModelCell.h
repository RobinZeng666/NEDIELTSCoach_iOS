//
//  GradeCheckModelCell.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/21.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSliderView.h"
#import "CCAudioPlayer.h"

@protocol GradeCheckModelCellDelegate <NSObject>

- (void)selectPlay:(UIButton *)button curentCell:(UITableViewCell *)cell;
//- (void)valueChanges:(float)value curentTableViewCell:(UITableViewCell *)viewCell;

@end

@interface GradeCheckModelCell : UITableViewCell


@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,assign)long index;
@property (nonatomic,assign)id<GradeCheckModelCellDelegate>delegate;

@property (nonatomic,strong) CCAudioPlayer *audioPlayer;

@property (nonatomic,copy) NSString *urlString;

@end
