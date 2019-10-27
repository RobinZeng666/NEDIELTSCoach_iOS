//
//  IEClassTableViewCell.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/6.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IEClassTableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton *didButton;
@property(nonatomic,strong)UILabel *codeLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *classCodeLabel;
+(instancetype)cellWithClass:(UITableView *)tabelView;

@end
