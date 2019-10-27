//
//  GradeClassModel.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/26.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"
/**
 {
 DateDiff = "<null>";/
 IconUrl = "";/
 UID = 39;/
 avgScore = 0;/
 finishTask = 33;
 nGender = 2;
 sCode = BJ1937729;
 sName = "\U4e8e\U529b\U822a";
 },
 */
@interface GradeClassModel : BaseModel

@property (nonatomic,copy) NSString *DateDiff;
@property (nonatomic,copy) NSString *IconUrl;
@property (nonatomic,copy) NSString *sName;
@property (nonatomic,copy) NSString *UID;
@property (nonatomic,copy) NSString *avgScore;
@property (nonatomic,copy) NSString *finishTask;
@property (nonatomic,strong) NSNumber *nGender; //1 男  2 女

@property (nonatomic,copy) NSString *sCode;
//@property (nonatomic,copy) NSString *sStudentID;


@end
