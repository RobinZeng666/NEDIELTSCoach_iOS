//
//  SelectIndex.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/18.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectIndex : NSObject
/**
 *  当前选中的行
 */
@property (nonatomic, assign) NSInteger selectedIndex;
//保存选中的行
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)UIImageView *imagView;
@end
