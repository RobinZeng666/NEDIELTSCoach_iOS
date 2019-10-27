//
//  StudentFileTableViewCell.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentAchieveModel.h"

@interface StudentFileTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView; //头像
@property (nonatomic,strong) UILabel     *titLabel; //昵称
@property (nonatomic,strong) UIImageView *sexImgView; //性别
@property (nonatomic,strong) UILabel     *detailLabel; //学员号
@property (nonatomic,strong) UILabel     *restLabel; //剩余天数
@property (nonatomic,strong) UIButton    *scoreButton; //成绩单
@property (nonatomic,strong) UIImageView *lineImgView; //线
@property (nonatomic,strong) UIImageView *circleImgView;
@property (nonatomic,strong) UILabel     *typeLabel;

@property (nonatomic,strong) StudentAchieveModel *studentModel;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableArray *scoreArray;

@end
