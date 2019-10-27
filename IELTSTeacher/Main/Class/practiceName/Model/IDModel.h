//
//  IDModel.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/31.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"
#import "AccListModel.h"
#import "OptionListModel.h"

@interface IDModel : BaseModel
@property(nonatomic,copy)NSString *Title;
@property(nonatomic,copy)NSString *QSValue;
@property(nonatomic,strong)NSNumber *QuestionType;
@property(nonatomic,copy)NSString *Accuracy;
@property(nonatomic,strong)NSNumber *AccuracyStudentChooseCount;
@property(nonatomic,strong)NSNumber *stuAnswerTotalCount;
//数组存放模型
@property(nonatomic,strong)NSArray *AccuracyStudentChooseList;
@property(nonatomic,strong)NSArray *optionList;

@end
