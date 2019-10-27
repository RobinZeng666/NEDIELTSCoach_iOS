//
//  HeadModel.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/5.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface HeadModel : BaseModel
// "sName": "学生姓名",
//   "nGender": 学生性别(1男2女),
//   "sCode": "学生编号",
//   "IconUrl": "学生图像",
//   "CostTime": "时间",
@property (nonatomic,copy) NSString *CostTime;
@property (nonatomic,strong) NSNumber *nGender;
@property (nonatomic,copy) NSString *sName;
@property (nonatomic,copy) NSString *sCode;
@property (nonatomic,copy)NSString *IconUrl;
@end
