//
//  NewsDetailViewController.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/25.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

@protocol NewsDetailDelegate <NSObject>

- (void)refreshNews:(NSInteger)indexRow;

@end

@interface NewsDetailViewController : BaseViewController

@property (nonatomic, copy) NSString *titleString;//标题
@property (nonatomic, copy) NSString *bodyString;//内容

@property (nonatomic, copy) NSString *MI_ID;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *optTypeString;
@property (nonatomic, assign) NSInteger myIndex;
@property (nonatomic, assign) BOOL isRead;//是否已读

@property (nonatomic, assign) id<NewsDetailDelegate> newsDelegate;

@end
