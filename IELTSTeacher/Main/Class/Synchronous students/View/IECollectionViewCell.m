//
//  IECollectionViewCell.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IECollectionViewCell.h"
//#define  BaseUserIconPath  @"http://testielts.staff.xdf.cn/IELTS_2/fileupload"
//#define cornerRadiu (kScreenWidth-120)/5
@interface IECollectionViewCell ()
@property (nonatomic,assign) BOOL isMasConstraint;
@end
@implementation IECollectionViewCell
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
- (void)setUp
{
    [self.contentView  addSubview:self.imgView];
    [self.contentView  addSubview:self.nameLabel];
    
    WS(this_CollectionCell);
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_CollectionCell.contentView.mas_top);
        make.left.mas_equalTo(this_CollectionCell.contentView.mas_left);
        make.right.mas_equalTo(this_CollectionCell.contentView.mas_right);
        make.bottom.mas_equalTo(this_CollectionCell.top).with.offset((kScreenWidth-138*AUTO_SIZE_SCALE_X)/5);
        
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(this_CollectionCell.contentView.mas_width);
        make.centerX.mas_equalTo(this_CollectionCell.imgView.mas_centerX);
        make.top.mas_equalTo(this_CollectionCell.imgView.mas_bottom);
        make.bottom.mas_equalTo(this_CollectionCell.contentView.mas_bottom);
    }];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.nameLabel.text = self.nameString;
}
#pragma mark - set or get
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.layer.cornerRadius = (kScreenWidth-138*AUTO_SIZE_SCALE_X)/5/2;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12.0*AUTO_SIZE_SCALE_X];
         _nameLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

@end
