//
//  ManualDetailCollectionViewCell.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/10/26.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ManualDetailCollectionViewCell.h"

#define k_cellWidth (kScreenWidth-2*60/3*AUTO_SIZE_SCALE_X)

@interface ManualDetailCollectionViewCell ()
@property (nonatomic,assign) BOOL isMasConstraint;
@end

@implementation ManualDetailCollectionViewCell

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
- (void)setUp{
    [self.contentView  addSubview:self.imgView];
    [self.contentView  addSubview:self.nameLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.layer.cornerRadius = (k_cellWidth-92*AUTO_SIZE_SCALE_X)/5/2;
    self.imgView.layer.masksToBounds = YES;
    
    if (!_isMasConstraint) {
        WS(this_CollectionCell);
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(this_CollectionCell.contentView.mas_top);
            make.left.mas_equalTo(this_CollectionCell.contentView.mas_left);
            make.right.mas_equalTo(this_CollectionCell.contentView.mas_right);
            make.bottom.mas_equalTo(this_CollectionCell.top).with.offset((k_cellWidth-92*AUTO_SIZE_SCALE_X)/5);
            
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(this_CollectionCell.contentView.mas_width);
            make.centerX.mas_equalTo(this_CollectionCell.imgView.mas_centerX);
            make.top.mas_equalTo(this_CollectionCell.imgView.mas_bottom);
            make.height.mas_equalTo(20*AUTO_SIZE_SCALE_Y);
        }];
        
        _isMasConstraint = YES;
    }
    
    CHECK_DATA_IS_NSNULL(self.manualModel.IconUrl, NSString);
    CHECK_STRING_IS_NULL(self.manualModel.IconUrl);
    if (![self.manualModel.IconUrl isEqualToString:@""]) {
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, self.manualModel.IconUrl];
        [self.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    } else {
        self.imgView.image = [UIImage imageNamed:@"person_default.png"];
    }
    
    CHECK_STRING_IS_NULL(self.manualModel.sName);
    self.nameLabel.text = self.manualModel.sName;
}
#pragma mark - set or get
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
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
