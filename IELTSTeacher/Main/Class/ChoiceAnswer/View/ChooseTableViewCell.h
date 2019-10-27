//
//  ChooseTableViewCell.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/27.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccListModel.h"
#import "studentChooseListModel.h"
@interface ChooseTableViewCell : UITableViewCell

@property(nonatomic,strong)AccListModel *accListModel;
@property(nonatomic,strong)studentChooseListModel *stuModel;

@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *sexView;
@property(nonatomic,strong)UILabel *codeLabel;
@property(nonatomic,strong)UILabel *countdown;
@property(nonatomic,strong)UILabel *abCLabel;
@property(nonatomic,strong)UILabel *answerLabel;
@property(nonatomic,strong)UIImageView *line;
@property(nonatomic,assign)CGFloat nameW;

+ (instancetype)cellWithChooseTabelView:(UITableView *)tabelView;
@end
