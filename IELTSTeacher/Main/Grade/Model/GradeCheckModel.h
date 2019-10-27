//
//  GradeCheckModel.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/10.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

/**
 {
 CreateTime = "<null>";
 CreatedBy = "<null>";
 IsActive = "<null>";
 IsCorrected = 0;
 "LC_Code" = KY;
 ModifiedBy = "<null>";
 ModifyTime = "<null>";
 UID = 12;
 allCount = 2;
 examID = 126;
 id = 97;
 lcName = "\U53e3\U8bed";
 nGender = "";
 okCount = 0;
 paperId = 9635;
 paperName = "\U53e3\U8bed\U987a\U5e8ftest";
 sClassCode = YA15602;
 sClassName = "IELTS6\U5206\U5168\U65e5\U5236\U57fa\U7840\U5f3a\U5316\U8d70\U8bfb\U73edYA10113";
 sClassTypeCode = CTBJ001006003;
 sClassTypeName = "IELTS\U79cb\U5b63\U8d70\U8bfb";
 sName = "";
 taskSubmitTime = 1435026442000;
 taskType = 2;
 uName = "\U9648\U6d9b";
 }
 */

@interface GradeCheckModel : BaseModel


@property (nonatomic, copy) NSString *paperName;

@property (nonatomic, strong) NSNumber *nGender;

@property (nonatomic, strong) NSNumber *allCount;

@property (nonatomic, copy) NSString *taskSubmitTime;

@property (nonatomic, copy) NSString *lcName;

@property (nonatomic, strong) NSNumber *examID;

@property (nonatomic, copy) NSString *CreateTime;

@property (nonatomic, strong) NSNumber *IsCorrected;

@property (nonatomic, copy) NSString *CreatedBy;

@property (nonatomic, strong) NSNumber *paperId;

@property (nonatomic, copy) NSString *LC_Code;

//@property (nonatomic, copy) NSString *sClassCode;
@property (nonatomic, copy) NSString *sClassID;

@property (nonatomic, copy) NSString *taskType;

@property (nonatomic, strong) NSNumber *okCount;

@property (nonatomic, strong) NSNumber *UID;

//@property (nonatomic, copy) NSString *sClassTypeCode;

@property (nonatomic, copy) NSString *sClassTypeID;


@property (nonatomic, copy) NSString *sName;

@property (nonatomic, copy) NSString *sClassName;

@property (nonatomic, copy) NSString *sClassTypeName;

@property (nonatomic, strong) NSNumber *ids;

@property (nonatomic, copy) NSString *IsActive;

@property (nonatomic, copy) NSString *ModifiedBy;

@property (nonatomic, copy) NSString *ModifyTime;

@property (nonatomic, copy) NSString *uName;
@end
