//
//  CustomSegmentedView.h
//  WangliBank
//
//  Created by Sidney on 14-4-24.
//  Copyright (c) 2014年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConfig.h"

typedef enum SEGMENTED_TYPE
{
    SEGMENTED_TYPE_SYSTEM_DEFAULT,
    SEGMENTED_TYPE_NORMAL,
    SEGMENTED_TYPE_NORMAL_MOCK_EXAM,
    SEGMENTED_TYPE_NORMAL_ESSENCE_LISTENS_LIST,
}SEGMENTED_TYPE;

@protocol CustomSegmentedViewDelegate;


@interface CustomSegmentedView : UIView

@property(nonatomic,assign) id<CustomSegmentedViewDelegate> segmentsedDelegate;
@property(nonatomic,assign) SEGMENTED_TYPE mType;


@property(nonatomic,strong) void(^ segmentedSelectedBlock)(CustomSegmentedView *view,NSInteger selectedIndex,NSInteger lastSelectedIndex);

- (void)addSegmentedSelectedBlock:(void(^)(CustomSegmentedView *view,NSInteger selectedIndex,NSInteger lastSelectedIndex)) block;


- (id)initWithFrame:(CGRect)frame type:(SEGMENTED_TYPE)type;

- (void)setSegmentedNames:(NSArray *)names;

//设置当前选择
- (void)setSelectedIndex:(NSInteger)index;

@end

@protocol CustomSegmentedViewDelegate <NSObject>
@optional

- (void)segmentedSelectedIndex:(NSInteger)index lastSelectedIndex:(NSInteger)lastIndex menuView:(CustomSegmentedView *)view;

@end