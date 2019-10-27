//
//  AddRemindViewController.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/16.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

//@protocol RemindViewControllerDelegate<NSObject>
//- (void)refreshRemindList;
//@end

@interface AddRemindViewController : BaseViewController

//@property (nonatomic,assign)id<RemindViewControllerDelegate>delegate;


@property (nonatomic,strong) NSMutableArray *muArray;
@property (nonatomic,assign) BOOL isCheck; //查看通知
@property (nonatomic,strong) NSDictionary *dataCurrent;
@property (nonatomic,assign) NSInteger index;

@end
