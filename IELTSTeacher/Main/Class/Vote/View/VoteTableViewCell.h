//
//  VoteTableViewCell.h
//  IELTSTeacher
//
//  Created by Newton on 15/9/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VoteTableViewCellDelegate <NSObject>

- (void)changeCurrentCellRowHeght:(CGFloat)rowHeight  indexRow:(NSInteger)indexRow;

@optional
- (void)curentTextField:(NSInteger)indexRow;

@end
@interface VoteTableViewCell : UITableViewCell

@property (nonatomic,weak) id <VoteTableViewCellDelegate>delegate;

@property (nonatomic, strong) UITextField *textField;

@end
