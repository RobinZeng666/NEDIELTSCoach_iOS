//
//  ManualGroupModel.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/10/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface ManualGroupModel : BaseModel

@property (nonatomic, strong) NSNumber *GroupMethod;//分组规则
@property (nonatomic, strong) NSNumber *GroupCnt;//分组数
@property (nonatomic, strong) NSNumber *GroupNum;//组号
@property (nonatomic, copy) NSString *sName;//学生姓名
@property (nonatomic, copy) NSString *IconUrl;//学生头像
@property (nonatomic, strong) NSNumber *GroupOrder;//组内顺序号

@end
