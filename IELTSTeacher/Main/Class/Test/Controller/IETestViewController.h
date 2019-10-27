//
//  IETestViewController.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/29.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  单题和整套题 选题页面
 */
@interface IETestViewController : BaseViewController
{
 NSMutableArray *selectedMarks;
}
@property (nonatomic,strong) NSMutableArray *dataAry;
/**
 *  课次ID
 */
@property (nonatomic,copy) NSString *ccId;
//试卷id
@property (nonatomic,strong) NSNumber *paperId;
//课堂id
@property (nonatomic,strong) NSNumber *ActiveClassPaperInfoId;
//试题id
@property (nonatomic,strong) NSNumber *qId;
@property (nonatomic,strong) NSNumber *SectionID; //= PaperSection试卷项ID
@property (nonatomic,strong) NSNumber *PID;//试卷业的id
@property (nonatomic,copy) NSString *titls;
@property (nonatomic,copy) NSString *passCode;

//添加判断试卷是否
@property (nonatomic,strong) NSNumber *PaperState;

@end
