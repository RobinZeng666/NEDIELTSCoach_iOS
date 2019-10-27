//
//  IEPraTableViewCell.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/29.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IEPraTableViewCell : UITableViewCell
@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,strong)UILabel *ctnLabel;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)NSNumber *P_ID;
@end
