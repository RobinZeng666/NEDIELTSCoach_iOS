//
//  ChatPerpleCollectionViewCell.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/12/1.
//  Copyright © 2015年 xdf. All rights reserved.
//

#import "ChatPerpleCollectionViewCell.h"

@interface ChatPerpleCollectionViewCell()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;

@end

@implementation ChatPerpleCollectionViewCell
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self setUp];
//    }
//    return self;
//}
////通过纯代码创建
- (instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self){
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
    
    CHECK_DATA_IS_NSNULL(self.model.IconUrl, NSString);
    CHECK_STRING_IS_NULL(self.model.IconUrl);

    [self.imgView sd_setImageWithURL:[NSURL  URLWithString:self.model.IconUrl] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    self.nameLabel.text = self.model.MemberName;
    
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
