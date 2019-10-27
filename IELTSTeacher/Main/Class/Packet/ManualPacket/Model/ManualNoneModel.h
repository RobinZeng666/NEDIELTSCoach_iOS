//
//  ManualNoneModel.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/23.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface ManualNoneModel : BaseModel

@property (nonatomic, strong) NSNumber *uid;//学生UID
@property (nonatomic, copy) NSString *iconUrl;//学生图像
@property (nonatomic, strong) NSNumber *studentloginno;//学生登录序号
@property (nonatomic, copy) NSString *studentname;//学生姓名
@property (nonatomic, strong) NSNumber *studentloginstatus;//学生在线状态 0离线1在线
@property (nonatomic, copy) NSString *studentlogintime;//学生第一次登录时间
@property (nonatomic, copy) NSString *studentlogofftime;//学生登出时间
@property (nonatomic, copy) NSString *studentloginlasttime;//学生最近一次在线时间
@property (nonatomic, strong) NSNumber *acId;//学生所在的课堂主表ActiveClass的主键ID
@property (nonatomic, strong) NSNumber *idStr;//课堂与学生的关系表的主键ID
@property (nonatomic, strong) NSNumber *check;

@end
