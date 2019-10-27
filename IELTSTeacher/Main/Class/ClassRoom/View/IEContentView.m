//
//  IEContentView.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/25.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IEContentView.h"
#import "IEButton.h"
#import "IEView.h"
#import "FDAlertView.h"
@interface IEContentView ()
@property(nonatomic,assign)BOOL isFirst;

@property(nonatomic,strong)UIImageView * line1;
@property(nonatomic,strong)UIImageView * line2;
@property(nonatomic,strong)UIImageView * line3;
@property(nonatomic,strong)UIImageView * line4;

@end
@implementation IEContentView

//通过纯代码创建
- (instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
//通过xib或是storyboard创建
- (id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp{

//设置背景颜色
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.sheetButton];
    [self addSubview:self.voteButton];
    [self addSubview:self.buzzerButton];
    [self addSubview:self.practiceButton];
    [self addSubview:self.moreButton];
    [self addSubview:self.line1];
    [self addSubview:self.line2];
    [self addSubview:self.line3];
    [self addSubview:self.line4];
    
    WS(this_classRoom);
    //答题卡按钮
    CGFloat width = kScreenWidth/3  ;
    [self.sheetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_classRoom).with.offset(0);
        make.left.mas_equalTo(this_classRoom).with.offset(0);
        make.width.mas_equalTo(width) ;
        make.height.mas_equalTo(width);
    }];
    //左边竖线
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(this_classRoom.sheetButton.mas_right).with.offset(0.5*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(0.5*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo((width+0.5*AUTO_SIZE_SCALE_X)*2);
    }];
    //上边横线
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_classRoom.sheetButton.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(0.5*AUTO_SIZE_SCALE_Y);
    }];
    //分组练
    [self.practiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(this_classRoom.line1.mas_right).with.offset(0);
        make.width.mas_equalTo(this_classRoom.sheetButton.mas_width);
        make.height.mas_equalTo(this_classRoom.sheetButton.mas_height);
    }];
    //右边竖线
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(this_classRoom.practiceButton.mas_right);
        make.width.mas_equalTo(0.5*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(this_classRoom.line1.mas_height);
        
    }];
    //投票题
    [self.voteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(this_classRoom.line3.mas_right).with.offset(0);
        make.width.mas_equalTo(this_classRoom.sheetButton.mas_width);
        make.height.mas_equalTo(this_classRoom.sheetButton.mas_height);
    }];
    //抢答器
    [self.buzzerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_classRoom.sheetButton.mas_bottom).with.offset(1*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(this_classRoom.sheetButton.mas_width);
        make.height.mas_equalTo(this_classRoom.sheetButton.mas_height);
    }];
    //下边横线
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_classRoom.buzzerButton.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(0.5*AUTO_SIZE_SCALE_Y);
    }];
    //更多按钮
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_classRoom.buzzerButton.mas_top);
        make.left.mas_equalTo(this_classRoom.line1.mas_right);
        make.width.mas_equalTo(this_classRoom.sheetButton.mas_width);
        make.height.mas_equalTo(this_classRoom.sheetButton.mas_height);
        
    }];

}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//
//    if (!_isFirst) {
//        [self addBtn];
//        _isFirst = YES;
//    }
//    
//}
//-(void)addBtn
//{
//
//  }

-(UIImageView *)line1{
    if (!_line1) {
        _line1 = [CommentMethod createImageViewWithImageName:@""];
        _line1.backgroundColor = RGBACOLOR(236, 236, 236, 1.0);
    }
    return _line1;
}
-(UIImageView *)line2{
    if (!_line2) {
        _line2 = [CommentMethod createImageViewWithImageName:@""];
        _line2.backgroundColor = RGBACOLOR(236, 236, 236, 1.0);
    }
    return _line2;
}
-(UIImageView *)line3{
    
    if (!_line3) {
        _line3 = [CommentMethod createImageViewWithImageName:@""];
        _line3.backgroundColor = RGBACOLOR(236, 236, 236, 1.0);
    }
    return _line3;
}
-(UIImageView *)line4{
    
    if (!_line4) {
        _line4 = [CommentMethod createImageViewWithImageName:@""];
        _line4.backgroundColor = RGBACOLOR(236, 236, 236, 1.0);
    }
    return _line4;
}

-(IEButton *)sheetButton{
    if (!_sheetButton) {
        _sheetButton = [[IEButton alloc]init];
        [_sheetButton  setTitle:@"答题卡"  forState:UIControlStateNormal];
        [_sheetButton setImage:[UIImage imageNamed:@"classRoom_datiika"] forState:UIControlStateNormal];
        [_sheetButton setImage:[UIImage imageNamed:@"classRoom_datiika_dianji"] forState:UIControlStateHighlighted];
        [_sheetButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_sheetButton setTitleColor:RGBACOLOR(251.0, 49.0, 79.0, 1.0) forState:UIControlStateHighlighted];
        _sheetButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
    }
    return _sheetButton;
}

-(IEButton *)practiceButton{
    if (!_practiceButton) {
        _practiceButton = [[IEButton  alloc]init];
        [_practiceButton  setTitle:@"分组练"  forState:UIControlStateNormal];
        [_practiceButton setImage:[UIImage imageNamed:@"classRoom_fenzu"] forState:UIControlStateNormal];
        [_practiceButton setImage:[UIImage imageNamed:@"classRoom_fenzu_dianji"] forState:UIControlStateHighlighted];
        [_practiceButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_practiceButton setTitleColor:RGBACOLOR(251.0, 49.0, 79.0, 1.0) forState:UIControlStateHighlighted];
        _practiceButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
    };
    return _practiceButton;
}

-(IEButton *)voteButton{
    
    if (!_voteButton) {
        _voteButton = [[IEButton alloc]init];
        [_voteButton  setTitle:@"投票题"  forState:UIControlStateNormal];
        [_voteButton setImage:[UIImage imageNamed:@"classRoom_toupiao"] forState:UIControlStateNormal];
        [_voteButton setImage:[UIImage imageNamed:@"classRoom_toupiao_dianji"] forState:UIControlStateHighlighted];
        [_voteButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_voteButton setTitleColor:RGBACOLOR(251.0, 49.0, 79.0, 1.0) forState:UIControlStateHighlighted];
        _voteButton.titleLabel.font = [UIFont  systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        
        
    }
    return _voteButton;
}
-(IEButton *)buzzerButton{
    if (!_buzzerButton) {
        _buzzerButton = [[IEButton alloc]init];
        [_buzzerButton  setTitle:@"抢答器"  forState:UIControlStateNormal];
        [_buzzerButton setImage:[UIImage imageNamed:@"classRoom_qiangdaqi"] forState:UIControlStateNormal];
        [_buzzerButton setImage:[UIImage imageNamed:@"classRoom_qiangdaqi_dianji"] forState:UIControlStateHighlighted];
        [_buzzerButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_buzzerButton setTitleColor:RGBACOLOR(251.0, 49.0, 79.0, 1.0) forState:UIControlStateHighlighted];
        _buzzerButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        
    }
    return _buzzerButton;
}

-(IEButton *)moreButton{
    if (!_moreButton){
        _moreButton = [[IEButton alloc]init];
        [_moreButton  setTitle:@"更多"  forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"classRoom_gengduo"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"classRoom_gengduo_dianji"] forState:UIControlStateHighlighted];
        [_moreButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_moreButton setTitleColor:RGBACOLOR(251.0, 49.0, 79.0, 1.0) forState:UIControlStateHighlighted];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        
    }
    return _moreButton;
}
@end
