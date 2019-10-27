//
//  ManualCollectionViewCell.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualCollectionViewCell : UICollectionViewCell

/**
 *  视图
 */
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *addButton;//添加
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *groupArray;//存储每组分组数据

@property (nonatomic, copy) NSString *groupNum;//分组规则
@property (nonatomic, copy) NSString *groupCnt;//分组数
@property (nonatomic, copy) NSString *passCode;//课堂暗号
@property (nonatomic, copy) NSString *activeClassId;//课堂ID


@end
