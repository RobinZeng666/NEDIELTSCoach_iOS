//
//  ChoiceViewController.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/21.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"
@class OptionListModel;
@class AccListModel;
@class studentChooseListModel;
@interface ChoiceViewController : BaseViewController
@property(nonatomic,copy)NSString *str;
//cell的属性值
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *sexView;
@property(nonatomic,strong)UILabel *codeLabel;
@property(nonatomic,strong)UILabel *countdown;
@property(nonatomic,strong)OptionListModel *optionModel;
@property(nonatomic,strong)AccListModel *accModel;
@property(nonatomic,strong)studentChooseListModel *stuModel;
@end
