//
//  MaterialDetailViewController.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

@protocol MaterialDetailViewControllerDelegate <NSObject>

- (void)MaterialRefreshMethod;

@end

@interface MaterialDetailViewController : BaseViewController

@property (nonatomic, copy)   NSString         *mid;//资料ID
@property (nonatomic, copy)   NSString         *StorePoint;//存储点
@property (nonatomic, copy)   NSString         *urlString;
@property (nonatomic, strong) NSMutableArray   *detailMutableArray;//数据列表
@property (nonatomic, assign) NSInteger        indexPathRow;//选中某行
@property (nonatomic, copy)   NSString         *titleString;//标题
@property (nonatomic, assign) BOOL             isStudy;//是学习 否为任务列表资料

@property (nonatomic, assign) id<MaterialDetailViewControllerDelegate> delegate;

@end
