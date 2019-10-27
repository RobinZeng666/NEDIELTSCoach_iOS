//
//  GradeCheckMarkView.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/10.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  打分视图
 */
@protocol GradeCheckMarkViewDelegate <NSObject>

- (void)getCurrentScore:(NSString *)score curentType:(NSString *)type;

@end

@interface GradeCheckMarkView : UIView

@property (nonatomic,assign)id<GradeCheckMarkViewDelegate>delegate;


@end
