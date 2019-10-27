//
//  IEClassModel.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/1.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"
/**
 *  {
 SectBegin = 1435489800000;
 SectEnd = 1435495200000;
 diff = 240254;
 dtDate = 1406995200000;
 id = 14221389;
 nLessonNo = 6;
 nSchoolId = 1;
 sClassCode = YA10113;
 sOperateDate = 1399186387000;
 sRoomCode = RMBJ68012;
 sTeacherCode = TCGZ0010092;
 sWeek = "\U661f\U671f\U4e94";
 }
 */
@interface IEClassModel : BaseModel
//@property(nonatomic,copy)NSString *lesson;
//@property(nonatomic,strong)NSNumber *lessonType;
//@property(nonatomic,strong)NSArray *listLessons;
//@property(nonatomic,strong)NSNumber *passCode;
@property(nonatomic,strong)NSNumber *SectBegin;
@property(nonatomic,strong)NSNumber *SectEnd;
//@property(nonatomic,strong)NSNumber *diff;
//@property(nonatomic,strong)NSNumber *dtDate;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSNumber *nSchoolId;
@property(nonatomic,strong)NSNumber *nLessonNo;
@property(nonatomic,strong)NSString *className;
//@property(nonatomic,strong)NSNumber *sOperateDate;

@property(nonatomic,copy)NSString *sClassCode;
//@property(nonatomic,copy)NSString *sRoomCode;
//@property(nonatomic,copy)NSString *sTeacherCode;

@property(nonatomic,copy)NSString *sClassID;
@property(nonatomic,copy)NSString *sRoomID;
@property(nonatomic,copy)NSString *sTeacherID;

@property(nonatomic,copy)NSString *sWeek;
@end
