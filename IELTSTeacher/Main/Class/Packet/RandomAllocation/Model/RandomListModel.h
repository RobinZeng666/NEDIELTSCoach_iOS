//
//  RandomListModel.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/23.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface RandomListModel : BaseModel

@property (nonatomic, strong) NSNumber *ActiveClassGroupID;//分组ID
@property (nonatomic, strong) NSNumber *StudentID;//学生ID
@property (nonatomic, strong) NSNumber *GroupNum;//组号
@property (nonatomic, copy) NSString *sName;//学生姓名
@property (nonatomic, copy) NSString *IconUrl;//学生头像
@property (nonatomic, strong) NSNumber *GroupOrder;//组内顺序号

@end
