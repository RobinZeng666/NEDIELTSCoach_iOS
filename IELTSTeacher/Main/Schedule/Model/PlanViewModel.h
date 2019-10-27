//
//  PlanViewModel.h
//  IELTSStudent
//
//  Created by DevNiudun on 15/6/22.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"
/**
 {
 SectBegin = 1435317000000;
 SectEnd = 1435322400000;
 nLessonNo = 6;
 sAddress = "\U5317\U4eac\U5e02\U6d77\U6dc0\U533a\U77e5\U6625\U8def17\U53f7\U96621-2\U5c42\U90e8\U5206";
 sCode = "<null>";
 sNameBc = "<null>";  //班级名称
 sNameBr = "\U6d77\U6dc0\U77e5\U6625\U8def\U6821\U533a209\U6559\U5ba4"; //上课教室
 id = 14221397;
 nowLessonId = 14221387;

 }
 */
@interface PlanViewModel : BaseModel

@property (nonatomic,strong) NSNumber *SectBegin;
@property (nonatomic,strong) NSNumber *SectEnd;
@property (nonatomic,strong) NSNumber *nLessonNo;
@property (nonatomic,copy) NSString *sAddress;
@property (nonatomic,copy) NSString *sCode;
@property (nonatomic,copy) NSString *sNameBc;
@property (nonatomic,copy) NSString *sNameBr;

@property (nonatomic,strong) NSString *ids;
@property (nonatomic,strong) NSString *nowLessonId;
@property (nonatomic,strong) NSString *classId;

@end
