//
//  IETPraticenameCell.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IETPraticenameCell.h"
@interface IETPraticenameCell ()
@property(nonatomic,strong)UIView *ctentView;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *codeLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *lineView;

@end
@implementation IETPraticenameCell
+ (instancetype)cellWithPracticeName:(UITableView *)tabelView{
static NSString *Id = @"cell";
    IETPraticenameCell *cell = [tabelView   dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[IETPraticenameCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self  addSubview:self.ctentView];
        [self.ctentView  addSubview:self.iconView];
        [self.ctentView  addSubview:self.nameLabel];
        [self.ctentView  addSubview:self.sexView];
        [self.ctentView  addSubview:self.codeLabel];
        [self.ctentView  addSubview:self.timeLabel];
        [self.ctentView  addSubview:self.lineView];
        [self.ctentView  addSubview:self.ctnView];
        [self  addSub];
    }
    return self;
}
- (void)addSub{
    WS(this_cell);
    [self.ctentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth,100 ));
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(0);
    }];

    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
        make.top.mas_equalTo(5);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.iconView.mas_right).with.offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(40);
        make.centerY.mas_equalTo(this_cell.iconView.mas_centerY);
    }];
    [self.sexView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.iconView.mas_centerY);
        make.left.mas_equalTo(this_cell.nameLabel.mas_right).with.offset(5);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    [self.codeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.iconView.mas_centerY);
        make.left.mas_equalTo(this_cell.sexView.mas_right).with.offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
    }];
    [self.timeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.iconView.mas_centerY);
        make.right.mas_equalTo(this_cell.ctentView.mas_right).with.offset(-15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_cell);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(this_cell.iconView.mas_bottom).with.offset(5);
    }];
    [self.ctnView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_cell);
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(this_cell.lineView);
        make.bottom.mas_equalTo(this_cell.ctentView);
    }];

}
#pragma mark--get方法
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.layer.cornerRadius = 20;
        _iconView.layer.masksToBounds = YES;
        _iconView.image = [UIImage imageNamed:@"person_default.png"];
    }
    return _iconView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"小莉";
        _nameLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _nameLabel;
}
- (UIImageView *)sexView{
    if (!_sexView) {
        _sexView = [[UIImageView alloc]init];
        
    }
    return _sexView;
}
- (UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc]init];
        _codeLabel.text = @"BJ1234567";
        _codeLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _codeLabel.textColor = RGBACOLOR(200, 200, 200, 1);
    }
    return _codeLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel   alloc]init];
        _timeLabel.text = [NSString stringWithFormat:@"时间:%@",@"4:59"];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = RGBACOLOR(200, 200, 200, 1);
    }
    return _timeLabel;
}
- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc]init];
        _lineView.backgroundColor = RGBACOLOR(200, 200, 200, 1);
    }
    return _lineView;
}
- (UIView *)ctentView{
    if (!_ctentView) {
        _ctentView = [[UIView alloc]init];
        _ctentView.backgroundColor = [UIColor whiteColor];
    }
    return _ctentView;
}
- (UIView *)ctnView{
    if (!_ctnView) {
        _ctnView = [[UIView  alloc]init];
        
    }
    return _ctnView;
}


@end
