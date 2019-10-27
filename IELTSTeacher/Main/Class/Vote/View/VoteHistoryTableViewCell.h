//
//  VoteHistoryTableViewCell.h
//  IELTSTeacher
//
//  Created by Newton on 15/9/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoteHistoryModel.h"

@interface VoteHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) VoteHistoryModel *model;
@property (nonatomic, assign) NSInteger indexRow;

@property (nonatomic, strong) UITableView *voteTableView;

@end
