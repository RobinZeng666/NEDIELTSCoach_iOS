//
//  IEPlusView.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/30.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IEPlusView : UIView
@property(nonatomic,assign)BOOL  isFist;
@property(nonatomic,strong)UILabel *code;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UILabel *questionLabel;
@property(nonatomic,strong)UILabel *ansLabel;
@property(nonatomic,strong)UILabel *qcountLabel;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UILabel *instructLabel;
@end
