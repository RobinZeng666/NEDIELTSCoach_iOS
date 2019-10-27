//
//  IESynchronousModel.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/1.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface IESynchronousModel : BaseModel

@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *iconUrl;
@property(nonatomic,copy)NSNumber *studentloginno;
@property(nonatomic,copy)NSString *studentname;
@property(nonatomic,copy)NSNumber *studentloginstatus;
@property(nonatomic,copy)NSString *studentlogintime;
@property(nonatomic,copy)NSString *studentlogofftime;
@property(nonatomic,copy)NSString *studentloginlasttime;
@property(nonatomic,copy)NSNumber *acId;
@property(nonatomic,copy)NSNumber *ids;

@end
