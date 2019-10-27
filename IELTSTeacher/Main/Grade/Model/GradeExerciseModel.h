//
//  GradeExerciseModel.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/7.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

/**
  {
    P_ID = 试卷ID,
    Name = 试卷名称,
    PaperNumber = 试卷编号,
    QuestionCount = 试题数量,
    ST_ID = 随堂任务ID
   }
 */
@interface GradeExerciseModel : BaseModel

@property (nonatomic,copy) NSString *P_ID;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *PaperNumber;
@property (nonatomic,copy) NSString *QuestionCount;
@property (nonatomic,copy) NSString *ST_ID;

@end
