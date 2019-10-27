//
//  VoteHistoryModel.h
//  IELTSTeacher
//
//  Created by Newton on 15/10/21.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"
/*
 {
 ActiveClassID = 9;
 ID = 42;
 Subject = "The new one ";
 opts =                 (
 );
 }
 */
@interface VoteHistoryModel : BaseModel

@property (nonatomic, strong) NSNumber *ActiveClassID;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *Subject;
@property (nonatomic, strong) NSArray *opts;


@end
