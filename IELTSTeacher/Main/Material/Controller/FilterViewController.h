//
//  FilterViewController.h
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/16.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

@class FilterViewController;
typedef void(^MaterialFilter)(FilterViewController *viewController, NSString *fileType, NSString *nameCode, NSString *roleId, NSString *uploadYear, int page);

@interface FilterViewController : BaseViewController

@property (nonatomic, copy) MaterialFilter block;

@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, copy) NSString *nameCode;
@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, copy) NSString *uploadYear;

- (void)returnResult:(MaterialFilter)block;

@end
