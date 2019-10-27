//
//  GradeTaskViewCell.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/27.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GradeTaskViewCell : UITableViewCell

@property (nonatomic,assign) BOOL isFristRow;
@property (nonatomic,assign) BOOL isLastRow;
@property (nonatomic,assign) BOOL isFinishStyle;
@property (nonatomic,assign) NSInteger taskType;

@property (nonatomic,strong) NSDictionary *dataDic;
//@property (nonatomic,strong) GradeTaskModel *taskModel;

@property (nonatomic,copy) NSString *classCode;


@end
