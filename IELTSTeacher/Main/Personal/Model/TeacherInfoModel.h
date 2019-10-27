//
//  TeacherInfoModel.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/11.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface TeacherInfoModel : BaseModel

/**
 *
    sCode =班级编号;
    sName =班级名称;
 */

@property (nonatomic,copy) NSString *sName;
@property (nonatomic,copy) NSString *sCode;
@property (nonatomic,copy) NSString *ID;

@end
