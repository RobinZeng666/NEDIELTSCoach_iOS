//
//  ManualViewController.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

@protocol ManualViewControllerDelegate <NSObject>
@optional
//重新分组
- (void)againManualViewGroupView;
@end

@interface ManualViewController : BaseViewController

@property (nonatomic, weak) id <ManualViewControllerDelegate>delegate;

@property (nonatomic, copy) NSString *passCode;//课堂暗号
@property (nonatomic, copy) NSString *activeClassId;//课堂ID
@property (nonatomic, copy) NSString *groupCnt;//分组数
@property (nonatomic, copy) NSString *groupMode;//分组规则
@property (nonatomic, assign) BOOL isGetHistotyGroup;//是否有历史分组

//@property (nonatomic, strong) NSArray *groupArray;//分组数据

@end
