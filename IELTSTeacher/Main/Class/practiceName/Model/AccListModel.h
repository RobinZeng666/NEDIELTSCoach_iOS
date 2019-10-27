//
//  AccListModel.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/8/7.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface AccListModel :  BaseModel

@property(nonatomic,copy)NSString *sCode;
@property(nonatomic,strong)NSNumber *nGender;
@property(nonatomic,strong)NSNumber *UID;
@property(nonatomic,copy)NSString *sName;
@property(nonatomic,copy)NSString *AnswerContent;
@property(nonatomic,copy)NSString *QSValues;
@property(nonatomic,copy)NSString *IconUrl;
@property(nonatomic,strong)NSNumber *RightCount;
@property(nonatomic,strong)NSNumber *TargetDateDiff;
@property(nonatomic,strong)NSNumber *ScoreCount;
@property(nonatomic,strong)NSNumber *sqId;
@property(nonatomic,copy)NSString *Title;
@property(nonatomic,strong)NSNumber *Code;
@end
