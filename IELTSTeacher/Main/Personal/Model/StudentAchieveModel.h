//
//  StudentAchieveModel.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/11.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface StudentAchieveModel : BaseModel

/**
 *  sName =学生名称;
    nGender =性别[1男2女];
    sCode =学生编号;
    IconUrl =头像地址;
    DateDiff =距离考试天数;
    ListenScore =听力成绩;
    ReadScore =阅读成绩;
    WriteScore =写作成绩;
    SpeakScore =口语成绩;
    TotalScore =总分;
    ReportImgName =报告名称;
 
    sStudentID =学生主键ID;
 */
@property (nonatomic,copy) NSString *sName;//学生名称
@property (nonatomic,strong) NSNumber *nGender;//性别[1男2女]
@property (nonatomic,copy) NSString *sCode;//学生编号
@property (nonatomic,copy) NSString *IconUrl;//头像地址
@property (nonatomic,copy) NSString *DateDiff;//距离考试天数
@property (nonatomic,strong) NSNumber *ListenScore;//听力成绩
@property (nonatomic,strong) NSNumber *ReadScore;//阅读成绩
@property (nonatomic,strong) NSNumber *WriteScore;//写作成绩
@property (nonatomic,strong) NSNumber *SpeakScore;//口语成绩
@property (nonatomic,strong) NSNumber *TotalScore;//总分
@property (nonatomic,copy) NSString *ReportImgName;//报告名称

@property (nonatomic,strong) NSString *sStudentID; //学生主键ID

@end
