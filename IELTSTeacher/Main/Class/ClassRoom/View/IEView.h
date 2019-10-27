//
//  IEView.h
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/26.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IEViewBlock)(BOOL isShut);
@interface IEView : UIView
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *contentString;
@property(nonatomic,strong)UIButton *cancleBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *mainBtn;
@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,copy) IEViewBlock block;
//@property(nonatomic,assign)BOOL  isMain;

@end
