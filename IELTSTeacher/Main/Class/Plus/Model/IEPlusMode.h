//
//  IEPlusMode.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface IEPlusMode : BaseModel

@property(nonatomic,copy)NSString *Name;
@property(nonatomic,copy)NSString *PaperNumber;
@property(nonatomic,strong)NSNumber *P_ID;
@property(nonatomic,strong)NSNumber *QuestionCount;

@end
