//
//  BaseTableView.h
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/4.
//  Copyright (c) 2015年 xdf. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@protocol BaseTableViewDelegate <NSObject>
@optional
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView;
@end

@interface BaseTableView : UITableView<MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSArray *data;

//当前选中得单元格indexPath
@property(nonatomic,retain)NSIndexPath *selectIndexPath;

@property (nonatomic,assign)id<BaseTableViewDelegate>delegates;

@property (nonatomic,strong)MJRefreshHeaderView *head;
@property (nonatomic,strong)MJRefreshFooterView *foot;

- (void)removeHeadRefresh;
- (void)removeFootRefresh;


@end
