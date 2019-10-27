//
//  GradeDetailViewController.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

@interface GradeDetailViewController : BaseViewController
/**
 *  班级课次信息
  classCode=[班级编号，不可为空]
  lessonId=[课次ID，不可为空]
 */
@property (nonatomic,copy) NSString *sCode;
@property (nonatomic,copy) NSString *classCode;
@property (nonatomic,copy) NSString *lessonId; //课次id

@property (nonatomic,strong) NSString *ids; //班级Id

@property (nonatomic,copy) NSString *classTitle;

@property (nonatomic,assign) BOOL isFutureClass;


@end
