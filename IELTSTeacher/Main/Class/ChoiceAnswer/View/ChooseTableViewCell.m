//
//  ChooseTableViewCell.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/27.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ChooseTableViewCell.h"

@implementation ChooseTableViewCell
+ (instancetype)cellWithChooseTabelView:(UITableView *)tabelView{
    
    static NSString *ID = @"status";
    ChooseTableViewCell *cell = [tabelView  dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self  addSub];
    }
    return self;
}

#define marginX 10
- (void)addSub{
    [self  addSubview:self.imgView];
    [self  addSubview:self.nameLabel];
    [self  addSubview:self.sexView];
    [self  addSubview:self.codeLabel];
    [self  addSubview:self.abCLabel];
    [self  addSubview:self.answerLabel];
    [self  addSubview:self.countdown];
    [self  addSubview:self.line];
    
    
    WS(this_cell);
    [self.imgView  makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(marginX);
        make.centerY.mas_equalTo(this_cell);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.nameLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.imgView.mas_right).with.offset(marginX);
        make.top.mas_equalTo(this_cell.imgView.mas_top).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(50, 23));
    }];
    [self.sexView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_cell.nameLabel);
        make.left.mas_equalTo(this_cell.nameLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.codeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.nameLabel);
        make.size.mas_equalTo(CGSizeMake(120, 18));
        make.top.mas_equalTo(this_cell.nameLabel.mas_bottom);
    }];
    [self.countdown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_cell.nameLabel);
        make.top.mas_equalTo(this_cell.codeLabel.mas_bottom);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(20);
    }];
    [self.abCLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_cell.nameLabel);
        make.left.mas_equalTo(this_cell.mas_left).with.offset(kScreenWidth * 0.7);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.3, 25));
    }];
    [self.answerLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_cell.abCLabel);
        make.bottom.mas_equalTo(this_cell.countdown);
        make.size.mas_equalTo(CGSizeMake(40, 25));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_cell);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(this_cell);
    }];
}
#pragma mark--get方法
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [CommentMethod createImageViewWithImageName:@""];
        _imgView.image = [UIImage imageNamed:@"person_default.png"];
        _imgView.layer.cornerRadius = 25;
        _imgView.layer.masksToBounds = YES;
        
    }
    return _imgView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [CommentMethod  createLabelWithFont:15 Text:@"小莉"];
        _nameLabel.textColor = [UIColor blackColor];
        //        _nameLabel.backgroundColor = [UIColor yellowColor];
        
        
    }
    return _nameLabel;
}
- (UIImageView *)sexView{
    if (!_sexView) {
        _sexView = [CommentMethod  createImageViewWithImageName:@""];
        //        _sexView.backgroundColor = [UIColor blueColor];
    }
    return _sexView;
}
- (UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [CommentMethod  createLabelWithFont:13 Text:@"BJ1234567"];
        _codeLabel.textColor = RGBACOLOR(200, 200, 200, 1);
        //        _codeLabel.backgroundColor = [UIColor purpleColor];
    }
    return _codeLabel;
}
- (UILabel *)countdown{
    if (!_countdown) {
        _countdown = [[UILabel alloc]init];
        _countdown.textColor = RGBACOLOR(200, 200, 200, 1);
        _countdown.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        //        _countdown.backgroundColor = [UIColor greenColor];
    }
    return _countdown;
}
- (UILabel *)abCLabel{
    if (!_abCLabel) {
        _abCLabel = [CommentMethod  createLabelWithFont:16 Text:@""];
        _abCLabel.textColor = [UIColor  redColor];
        _abCLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return _abCLabel;
}
- (UILabel *)answerLabel{
    if (!_answerLabel) {
        _answerLabel = [CommentMethod  createLabelWithFont:13 Text:@""];
        _answerLabel.textColor = RGBACOLOR(200, 200, 200, 1);
        _answerLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _answerLabel;
}
- (UIImageView *)line{
    if (!_line) {
        _line = [[UIImageView alloc]init];
        _line.backgroundColor = RGBACOLOR(200, 200, 200, 1);
    }
    return _line;
}
#pragma mark -- 百分比的学员
//更新数据

- (void)setAccListModel:(AccListModel *)accListModel{
    if (_accListModel != accListModel) {
        _accListModel = accListModel;
        //初始化数据
        [self initdata:accListModel];
    }

}
- (void)initdata :(AccListModel *)accModel{
    //1.加载图像
    CHECK_DATA_IS_NSNULL(accModel.IconUrl, NSString);
    NSString *urlPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,accModel.IconUrl];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    //2.名字
    CHECK_DATA_IS_NSNULL(accModel.sName, NSString);
    self.nameLabel.text = accModel.sName;
    //3.学号
    CHECK_DATA_IS_NSNULL(accModel.sCode, NSString);
    self.codeLabel.text = accModel.sCode;
    //4.性别图标
    CHECK_DATA_IS_NSNULL(accModel.nGender, NSNumber);
    NSInteger ngender = [accModel.nGender integerValue];
    if (ngender == 1) {
        self.sexView.image = [UIImage imageNamed:@"checkList_nan.png"];
    }else if(ngender == 2) {
        self.sexView.image = [UIImage imageNamed:@"checkList_nv.png"];
    }
    //5.考试倒计时
    CHECK_DATA_IS_NSNULL(accModel.TargetDateDiff, NSNumber);
    NSInteger downTime = [accModel.TargetDateDiff integerValue];
    self.countdown.text = [NSString stringWithFormat:@"雅思考试倒计时:%ld天",downTime];
}

#pragma mark -- 选项的学员

- (void)setStuModel:(studentChooseListModel *)stuModel{
    if (_stuModel != stuModel ) {
        _stuModel = stuModel;
        [self initdata1:stuModel];
    }
}

- (void)initdata1 :(studentChooseListModel *)stuModel{

    //1.加载图像
    CHECK_DATA_IS_NSNULL(stuModel.IconUrl, NSString);
    NSString *urlPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,stuModel.IconUrl];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    //2.名字
    CHECK_DATA_IS_NSNULL(stuModel.sName, NSString);
    self.nameLabel.text = stuModel.sName;
    //3.学号
    CHECK_DATA_IS_NSNULL(stuModel.sCode, NSString);
    self.codeLabel.text = stuModel.sCode;
    //4.性别图标
    CHECK_DATA_IS_NSNULL(stuModel.nGender, NSNumber);
    NSInteger ngender = [stuModel.nGender integerValue];
    if (ngender == 1) {
        self.sexView.image = [UIImage imageNamed:@"checkList_nan.png"];
    }else if(ngender == 2) {
        self.sexView.image = [UIImage imageNamed:@"checkList_nv.png"];
    }
    //5.考试倒计时
    CHECK_DATA_IS_NSNULL(stuModel.TargetDateDiff, NSNumber);
    NSInteger downTime = [stuModel.TargetDateDiff integerValue];
    self.countdown.text = [NSString stringWithFormat:@"雅思考试倒计时:%ld天",downTime];

}
@end
