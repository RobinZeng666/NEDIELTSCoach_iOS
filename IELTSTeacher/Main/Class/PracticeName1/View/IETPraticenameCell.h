//
//  IETPraticenameCell.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IETPraticenameCell : UITableViewCell
@property(nonatomic,strong)UIView *ctnView;
@property(nonatomic,strong)UIImageView *sexView;

+(instancetype)cellWithPracticeName:(UITableView *)tabelView;
@end
