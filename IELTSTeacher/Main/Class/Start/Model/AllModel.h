//
//  AllModel.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/25.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface AllModel : BaseModel
// sName = 学生姓名,
//   IconUrl = 学生图像,
//   nGender = 性别(1男2女),
//   sCode = 学员号,
//   Accuracy = 正确率,
//   CostTime = 时间,
//   UID = 学生ID,
//   EX_ID = 试卷考试ID
@property(nonatomic,copy)NSString *sName;
@property(nonatomic,copy)NSString *IconUrl;
@property(nonatomic,strong)NSNumber *nGender;
@property(nonatomic,copy)NSString *sCode;
@property(nonatomic,copy)NSString *Accuracy;
@property(nonatomic,copy)NSString *CostTime;
@property(nonatomic,strong)NSNumber *UID;
@property(nonatomic,strong)NSNumber *EX_ID;
@property(nonatomic,strong)NSNumber *TargetDateDiff;

@end
