//
//  IESheetModel.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/7.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface IESheetModel : BaseModel
//   P_ID = 试卷ID,
//   Name = 试卷名称,
//   PaperNumber = 试卷编号,
//   QuestionCount = 试题数量,
//   ActiveClassPaperInfoId = 课堂主键ID
//   PaperState = 3 的表示打包成功
@property(nonatomic,copy)NSNumber *P_ID;
@property(nonatomic,copy)NSString *Name;
@property(nonatomic,copy)NSString *PaperNumber;
@property(nonatomic,copy)NSNumber *QuestionCount;
@property(nonatomic,copy)NSNumber *ActiveClassPaperInfoId;
@property(nonatomic,copy)NSNumber *PushStatus;
@property(nonatomic,copy)NSNumber *PaperState;


@end
