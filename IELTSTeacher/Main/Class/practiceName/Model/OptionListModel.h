//
//  OptionListModel.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/31.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import  "BaseModel.h"
#import  "studentChooseListModel.h"
@interface OptionListModel : BaseModel


@property(nonatomic,copy)NSString *OptionName;
@property(nonatomic,copy)NSString *Option;
@property(nonatomic,strong)NSNumber *OrderNum;
@property(nonatomic,strong)NSNumber *SQ_ID;
@property(nonatomic,strong)NSNumber *studentChooseCount;

//数组存放模型
@property(nonatomic,strong)NSArray *studentChooseList;
@end
