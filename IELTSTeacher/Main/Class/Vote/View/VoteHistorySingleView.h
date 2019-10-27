//
//  VoteHistorySingleView.h
//  IELTSTeacher
//
//  Created by Newton on 15/9/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteHistorySingleView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *titLabel;
@property (nonatomic, strong) UILabel     *percentLabel;

@property (nonatomic, copy) NSString *percentString;

@end
