//
//  GradeCheckSpeakModel.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"
/*
 {
 Account = xdf0050050206;
 AnswerContent = "http://testielts2.staff.xdf.cn/IELTS_2/fileupload/1429174420652614.mp3";
 "EXA_ID" = 250;
 "Ex_ID" = 104;
 IsCorrected = 0;
 Name = "ft_\U6a21\U8003\U8bd5\U5377_004";
 RoleID = 3;
 TotalScore = 0;
 UID = 38;
 questionType = "\U53e3\U8bed";
 type2 = "\U6a21\U8003";
 }
 */

@interface GradeCheckSpeakModel : BaseModel

@property (nonatomic,strong) NSNumber *EXA_ID;
@property (nonatomic,strong) NSNumber *UID;
@property (nonatomic,strong) NSNumber *IsCorrected;
@property (nonatomic,strong) NSNumber *RoleID;
@property (nonatomic,strong) NSNumber *Ex_ID;
@property (nonatomic,strong) NSNumber *TotalScore;
@property (nonatomic,copy) NSString *type2;
@property (nonatomic,copy) NSString *Account;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *AnswerContent;
@property (nonatomic,copy) NSString *questionType;


@end
