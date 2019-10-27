//
//  VoteStartViewController.h
//  IELTSTeacher
//
//  Created by Newton on 15/9/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
/**
 *  开始投票
 */
@interface VoteStartViewController : BaseViewController

@property (nonatomic, copy) NSString *activeClassId; //互动课堂ID
@property (nonatomic, copy) NSString *voteDesc;//投票内容
@property (nonatomic, copy) NSString *voteId;//投票Id

@end
