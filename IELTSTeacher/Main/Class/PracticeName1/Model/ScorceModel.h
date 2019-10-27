//
//  ScorceModel.h
//  SingleDemo
//
//  Created by DevNiudun on 15/8/5.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import "BaseModel.h"
/*
 {
 AnswerContent = A;
 CostTime = 5;
 "EX_ID" = 282;
 IconUrl = "1438653945209181.JPG";
 RightCount = 0;
 ScoreCount = 1;
 UID = 41;
 nGender = 1;
 sCode = BJ1941324;
 sName = "\U7126\U4e2d\U77f3";
 }
 */
//"QNumber": "试题编号",
//     "AnswerContent": "学生答案(当RightCount-ScoreCount<0，答案颜色是红色，否则是绿色)",
//     "RightCount": 正确的得分点,
//     "ScoreCount": 总得分点
@interface ScorceModel : BaseModel

@property (nonatomic,copy) NSString *AnswerContent;
//@property (nonatomic,copy) NSString *sName;
@property (nonatomic,strong) NSNumber *QNumber;
@property (nonatomic,strong) NSNumber *RightCount;
@property (nonatomic,strong) NSNumber *ScoreCount;
@end
