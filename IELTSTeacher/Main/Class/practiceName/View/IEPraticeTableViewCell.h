//
//  IEStartTableViewCell.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/3.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IEPraticeTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *sexView;
@property(nonatomic,strong)UILabel *codeLabel;
@property(nonatomic,strong)UILabel *abCLabel;
@property(nonatomic,strong)UILabel *answerLabel;
@property(nonatomic,strong)UILabel *timeCode;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *countdown;
@property(nonatomic,strong)UIImageView *line;
+ (instancetype)cellWithstartTabelView:(UITableView *)tabelView;
@end
