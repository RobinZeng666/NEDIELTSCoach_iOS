//
//  IEChoiceMode.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface IEChoiceMode : BaseModel

@property (nonatomic,copy) NSString *Q_ID;//= 试题ID,
@property (nonatomic,copy) NSString *QName;//= 试题编号,
@property (nonatomic,copy) NSString *QNumber;//= 试题名称
@property (nonatomic,strong) NSNumber *SectionID; //= PaperSection试卷项ID
@property (nonatomic,strong) NSNumber *PID;// = QuestionPage试题页ID

@end
