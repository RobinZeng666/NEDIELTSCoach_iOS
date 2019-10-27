//
//  GradeCheckWriterModel.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/15.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

/*
 {
 Account = xdf0050050206;
 AnswerContent = "
 \nNow people in many countries can live and & lt;span id=\"0043\" style=\"background-color: red;\"& gt;work anywhere& lt;/span& gt; they choose with improved communication technology and transport. Do you think the advantages outweigh the disadvantages?& lt;br& gt;Now people in many countries can live and work anywhere they choose with improved communication technology and transport. Do you think the advantages outweigh the & lt;span id=\"0345\" style=\"background-color: red;\"& gt;disadvantages& lt;/span& gt;?Now people in many countries can live and work anywhere they choose with improved communication technology and transport. Do you think the advantages outweigh the disadvantages?& lt;br& gt;Now people in many countries can live and work anywhere they choose with improved communication technology and transport. Do you think the advantages outweigh the disadvantages?2
 \n";
 "EXA_ID" = 175;
 "Ex_ID" = 13;
 IsCorrected = 0;
 Name = "<null>";
 RoleID = 3;
 UID = 38;
 questionType = "\U5199\U4f5c";
 }
 */

@interface GradeCheckWriterModel : BaseModel

@property (nonatomic,strong) NSNumber *EXA_ID;
@property (nonatomic,strong) NSNumber *UID;
@property (nonatomic,strong) NSNumber *IsCorrected;
@property (nonatomic,strong) NSNumber *RoleID;
@property (nonatomic,strong) NSNumber *Ex_ID;
@property (nonatomic,copy) NSString *Account;
@property (nonatomic,copy) NSString *AnswerContent;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *questionType;


@end
