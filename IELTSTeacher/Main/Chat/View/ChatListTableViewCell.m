//
//  ChatListTableViewCell.m
//  IELTSStudent
//
//  Created by DevNiudun on 15/10/16.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ChatListTableViewCell.h"
@interface ChatListTableViewCell()

@property (nonatomic, strong) UIImageView *iconImgView;//头像
@property (nonatomic, strong) UILabel     *titLabel; //聊天标题
@property (nonatomic, strong) UIImageView *countBgView; //未读消息背景
@property (nonatomic, strong) UILabel     *countLabel; //未读消息个数

@property (nonatomic, strong) UILabel     *messageLabel;//未读消息
@property (nonatomic, strong) UILabel     *messageTimeLabel;//消息时间

@end
@implementation ChatListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}
//
- (void)_initView
{
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.countBgView];
    [self.countBgView addSubview:self.countLabel];
    
    //120*AUTO_SIZE_SCALE_X
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 80*AUTO_SIZE_SCALE_X));
        //        make.centerY.mas_equalTo(self.contentView);
        make.top.mas_equalTo(20*AUTO_SIZE_SCALE_X);
    }];
    
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).with.offset(20*AUTO_SIZE_SCALE_X);
        //        make.centerY.mas_equalTo(self.contentView).with.offset(-20*AUTO_SIZE_SCALE_Y);
        make.top.mas_equalTo(20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-140*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).with.offset(20*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(self.titLabel.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-140*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.countBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.iconImgView.mas_right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(self.iconImgView.mas_top).with.offset(-10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(45*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    /*
     ID = ChattingRoom表ID,
        ClassID = BS_Class表ID,
        className = 班级名称,
        ChattingGroup = 聊天室群组ID,
        ImgUrl = 群组头像，路径可直接访问,
        memberCnt = 群组成员人数,
     */
    
    
    CHECK_DATA_IS_NSNULL(self.model.ImgUrl, NSString);
    CHECK_STRING_IS_NULL(self.model.ImgUrl);
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:self.model.ImgUrl] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    
    CHECK_DATA_IS_NSNULL(self.model.className, NSString);
    CHECK_STRING_IS_NULL(self.model.className);
    CHECK_DATA_IS_NSNULL(self.model.memberCnt, NSString);
    CHECK_STRING_IS_NULL(self.model.memberCnt);
    
    NSString *classNames = [NSString stringWithFormat:@"%@(%@人)",self.model.className,self.model.memberCnt];
    self.titLabel.text = classNames;//self.model.className;
    CGFloat classNameHeight = [CommentMethod widthForNickName:classNames testLablWidth:kScreenWidth-140*AUTO_SIZE_SCALE_X textLabelFont:20].height;
    if (classNameHeight > 30*AUTO_SIZE_SCALE_Y) {
        [self.titLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImgView.mas_right).with.offset(20*AUTO_SIZE_SCALE_X);
            make.top.mas_equalTo(20*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-140*AUTO_SIZE_SCALE_X, classNameHeight));
        }];
    }else
    {
        [self.titLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImgView.mas_right).with.offset(20*AUTO_SIZE_SCALE_X);
            make.top.mas_equalTo(20*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-140*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
        }];
    }
    
    CHECK_DATA_IS_NSNULL(self.model.message, NSString);
    CHECK_STRING_IS_NULL(self.model.message);
    NSString *message = self.model.message;
    
    self.messageLabel.text = message;
    /*
     if (self.model.messageCount < 9) {
     self.countLabel.font = [UIFont systemFontOfSize:13];
     }else if(self.model.messageCount > 9 && self.model.messageCount < 99){
     self.countLabel.font = [UIFont systemFontOfSize:12];
     }else{
     self.countLabel.font = [UIFont systemFontOfSize:10];
     }
     */
    if (self.model.messageCount > 0) {
        self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.model.messageCount];
        if (self.model.messageCount > 99) {
            self.countLabel.text = @"99+";
        }
        self.countBgView.hidden = NO;
    }else
    {
        self.countBgView.hidden = YES;
    }
    
}

#pragma mark - set or get
- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [CommentMethod createImageViewWithImageName:@""];
        _iconImgView.layer.borderWidth = 1;
        _iconImgView.layer.borderColor = [UIColor clearColor].CGColor;
        _iconImgView.layer.cornerRadius = 40*AUTO_SIZE_SCALE_X;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [CommentMethod createLabelWithFont:20.0f Text:@""];
//        _titLabel.font = [UIFont systemFontOfSize:20.0f*AUTO_SIZE_SCALE_X];
        _titLabel.textColor = [UIColor darkGrayColor];
    }
    return _titLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
//        _messageLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];//[[UILabel alloc]init];
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _messageLabel.textColor = [UIColor lightGrayColor];
    }
    return _messageLabel;
}
- (UIImageView *)countBgView
{
    if (!_countBgView) {
        _countBgView = [CommentMethod createImageViewWithImageName:@"chatNumber.png"];
    }
    return _countBgView;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor=[UIColor whiteColor];
    }
    return _countLabel;
}

@end
