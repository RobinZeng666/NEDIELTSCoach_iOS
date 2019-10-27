//
//  VoteHistorySelectModel.h
//  IELTSTeacher
//
//  Created by Newton on 15/10/21.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"
/**
 *   {
 OptionDesc = A;
 OptionNum = 1;
 finishVote = 0;
 voteNum = 0;
 },
 {
 OptionDesc = B;
 OptionNum = 2;
 finishVote = 0;
 voteNum = 0;
 },
 {
 OptionDesc = C;
 OptionNum = 3;
 finishVote = 0;
 voteNum = 0;
 ownVote = 0;
 }
 */
@interface VoteHistorySelectModel : BaseModel

@property (nonatomic, copy) NSString *OptionDesc;
@property (nonatomic, strong) NSNumber *OptionNum;
@property (nonatomic, strong) NSNumber *voteNum;
@property (nonatomic, strong) NSNumber *ownVote;

@end
