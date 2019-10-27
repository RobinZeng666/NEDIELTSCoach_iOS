//
//  GradeTaskModel.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/7.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

/**
   ST_ID = 任务主键;
   Name = 任务名称;
   TaskType = 任务类型 1:模考; 2:练习; 3:资料;
   RefID = 引用关联的ID[资料ID或模考、练习ID];
   CreateTime = 创建时间;
   checkFinish = 是否完成 0=未完成；1=已完成;
   StorePoint = 存储点[只针对任务类型为3，如果任务类型为1或2，默认为0， 1:够快网盘; 2:CC视频]
    checkRemind = 是否完成 0=未提醒；1=已提醒;<br/>
 */
@interface GradeTaskModel : BaseModel

@property (nonatomic,strong) NSNumber *ST_ID;
@property (nonatomic,strong) NSNumber *TaskType;
@property (nonatomic,strong) NSNumber *RefID;
@property (nonatomic,strong) NSNumber *CreateTime;
@property (nonatomic,strong) NSNumber *checkFinish;
@property (nonatomic,strong) NSNumber *StorePoint;
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSNumber *checkRemind;



@end
