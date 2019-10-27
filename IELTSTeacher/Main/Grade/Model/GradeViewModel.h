//
//  GradeViewModel.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/7.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

/**
 {
 dtBeginDate = "2015-07-05";
 dtEndDate = "2015-07-20";
 nowLessonId = 2;  //课次的Id
 sCode = YA15602;
 sName = "IELTS6\U5206\U73ed";
 stuNum = 27;
 id = 22898;   班级的id
   }
 */

@interface GradeViewModel : BaseModel

@property (nonatomic,copy) NSString *sCode;
@property (nonatomic,copy) NSString *sName;
@property (nonatomic,copy) NSString *dtBeginDate;
@property (nonatomic,copy) NSString *dtEndDate;
@property (nonatomic,strong) NSNumber *stuNum;
@property (nonatomic,strong) NSString *nowLessonId;
@property (nonatomic,strong) NSString *ids;

//@property (nonatomic,copy) NSString *sClassId;

@end
