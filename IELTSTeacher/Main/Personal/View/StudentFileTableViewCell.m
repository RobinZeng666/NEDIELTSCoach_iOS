//
//  StudentFileTableViewCell.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "StudentFileTableViewCell.h"
#import "CheckScoreViewController.h"

@implementation StudentFileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titLabel];
    [self.contentView addSubview:self.sexImgView];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.restLabel];
    [self.contentView addSubview:self.scoreButton];
    [self.contentView addSubview:self.lineImgView];
    [self.contentView addSubview:self.circleImgView];
    [self.contentView addSubview:self.typeLabel];
    
    //添加约束
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(160/3*AUTO_SIZE_SCALE_X, 160/3*AUTO_SIZE_SCALE_Y));
    }];
    //名字
    self.titLabel.frame = CGRectMake((18+160/3+10)*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_Y, 60, 30*AUTO_SIZE_SCALE_Y);
    
    //性别
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titLabel.top).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.titLabel.right).with.offset(10*AUTO_SIZE_SCALE_Y);
    }];
    //学员号
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titLabel.bottom).with.offset(5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.titLabel.left);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
    }];
    //剩余天数
    [self.restLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.bottom).with.offset(-10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.detailLabel.left);
        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
    }];
    //查看成绩单
    [self.scoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70/3*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(-10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(127*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.restLabel.bottom).with.offset(15*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(18*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(-18*AUTO_SIZE_SCALE_X);
    }];
    
    for (int i=0; i<5; i++) {
        //圈
        UIImageView *imgView = [CommentMethod createImageViewWithImageName:@"score_yuan.png"];
        imgView.tag = 100+i;
        [self.contentView addSubview:imgView];
        
        //分数
        UILabel *titLabel = [CommentMethod createLabelWithFont:24.0f Text:@"6.5"];
        titLabel.textColor = k_PinkColor;
        titLabel.tag = 200+i;
        titLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titLabel];
        
        //标签
        UILabel *typeLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.textColor = [UIColor lightGrayColor];
        typeLabel.font = [UIFont systemFontOfSize:13.0*AUTO_SIZE_SCALE_X];
        typeLabel.numberOfLines = 0;
        typeLabel.tag = 300+i;
        [self.contentView addSubview:typeLabel];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _dataArray = @[@"Listening",@"Reading",@"Writing",@"Speaking",@"OverAll BandScore"];

    CGFloat scoreWidth = 60;
    CGFloat spaceWidth = (kScreenWidth- scoreWidth*5)/6;
    for (int i=0; i<5; i++) {
        //圈
        UIImageView *imgView = (UIImageView *)[self.contentView viewWithTag:100+i];
        imgView.frame = CGRectMake(spaceWidth+(scoreWidth+spaceWidth)*i, 350/3*AUTO_SIZE_SCALE_Y, scoreWidth, scoreWidth);
        //分数
        UILabel *titLabel = (UILabel *)[self.contentView viewWithTag:200+i];
        titLabel.frame = CGRectMake(spaceWidth+(scoreWidth+spaceWidth)*i, 350/3*AUTO_SIZE_SCALE_Y+(scoreWidth-30*AUTO_SIZE_SCALE_Y)/2, scoreWidth, 30*AUTO_SIZE_SCALE_Y);

        if (i == 0) {
            CHECK_DATA_IS_NSNULL(self.studentModel.ListenScore, NSNumber);
            if ([self.studentModel.ListenScore isKindOfClass:[NSNull class]]) {
                titLabel.text = @"6.5";
            } else {
                titLabel.text = [NSString stringWithFormat:@"%.1f", [self.studentModel.ListenScore floatValue]];
            }
        } else if (i == 1) {
            CHECK_DATA_IS_NSNULL(self.studentModel.ReadScore, NSNumber);
            if ([self.studentModel.ReadScore isKindOfClass:[NSNull class]]) {
                titLabel.text = @"6.5";
            } else {
                titLabel.text = [NSString stringWithFormat:@"%.1f", [self.studentModel.ReadScore floatValue]];
            }
        } else if (i == 2) {
            CHECK_DATA_IS_NSNULL(self.studentModel.WriteScore, NSNumber);
            if ([self.studentModel.WriteScore isKindOfClass:[NSNull class]]) {
                titLabel.text = @"6.5";
            } else {
                titLabel.text = [NSString stringWithFormat:@"%.1f", [self.studentModel.WriteScore floatValue]];
            }
        } else if (i == 3) {
            CHECK_DATA_IS_NSNULL(self.studentModel.SpeakScore, NSNumber);
            if ([self.studentModel.SpeakScore isKindOfClass:[NSNull class]]) {
                titLabel.text = @"6.5";
            } else {
                titLabel.text = [NSString stringWithFormat:@"%.1f", [self.studentModel.SpeakScore floatValue]];
            }
        } else {
            CHECK_DATA_IS_NSNULL(self.studentModel.TotalScore, NSNumber);
            if ([self.studentModel.TotalScore isKindOfClass:[NSNull class]]) {
                titLabel.text = @"6.5";
            } else {
                titLabel.text = [NSString stringWithFormat:@"%.1f", [self.studentModel.TotalScore floatValue]];
            }
        }
        
        //标签
        UILabel *typeLabel = (UILabel *)[self.contentView viewWithTag:300+i];
        typeLabel.frame = CGRectMake(spaceWidth+(scoreWidth+spaceWidth)*i-5*AUTO_SIZE_SCALE_X, 350/3*AUTO_SIZE_SCALE_Y+scoreWidth, scoreWidth+15*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_Y);
        typeLabel.text = _dataArray[i];
    }
    
    //头像
    CHECK_STRING_IS_NULL(self.studentModel.IconUrl);
    NSString *urlPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,self.studentModel.IconUrl];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    
    //昵称
    CHECK_STRING_IS_NULL(self.studentModel.sName);
    if ([self.studentModel.sName isKindOfClass:[NSNull class]] || self.studentModel.sName.length == 0 || [self.studentModel.sName isEqualToString:@""]) {
        self.titLabel.text = @"昵称";
    } else {
        self.titLabel.text = self.studentModel.sName;
    }

    CGSize sNameSize = [CommentMethod widthForNickName:self.studentModel.sName testLablWidth:60 textLabelFont:18.0];
    self.titLabel.frame = CGRectMake((18+160/3+10)*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_Y, sNameSize.width, 30*AUTO_SIZE_SCALE_Y);
    
    //性别
    CHECK_DATA_IS_NSNULL(self.studentModel.nGender, NSNumber);
    if ([self.studentModel.nGender isKindOfClass:[NSNull class]]) {
        //默认为男
        self.sexImgView.image = [UIImage imageNamed:@"checkList_nan.png"];
    } else {
        if ([[self.studentModel.nGender stringValue] isEqualToString:@"1"]) {
            //男
            self.sexImgView.image = [UIImage imageNamed:@"checkList_nan.png"];
        } else {
            //女
            self.sexImgView.image = [UIImage imageNamed:@"checkList_nv.png"];
        }
    }

    //学员号
    CHECK_STRING_IS_NULL(self.studentModel.sCode);
    if ([self.studentModel.sStudentID isKindOfClass:[NSNull class]]) {
        self.detailLabel.text = @"学员号";
    } else {
        self.detailLabel.text = self.studentModel.sCode;
    }
    //剩余天数
    CHECK_DATA_IS_NSNULL(self.studentModel.DateDiff, NSString);
    CHECK_STRING_IS_NULL(self.studentModel.DateDiff);
        NSInteger dateDiff = [self.studentModel.DateDiff integerValue];
        if (dateDiff <= 0) {
            self.restLabel.text = @"";
            //学员号
            [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.titLabel.bottom).with.offset(15*AUTO_SIZE_SCALE_Y);
                make.left.mas_equalTo(self.titLabel.left);
                make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
            }];
            
        } else {
            self.restLabel.text = [NSString stringWithFormat:@"雅思考试倒计时：%ld天", (long)dateDiff];
        }
}

#pragma mark - event response 
- (void)scoreButtonAction:(UIButton *)button
{
    //进入详情界面
    CheckScoreViewController *check = [[CheckScoreViewController alloc] init];
    CHECK_STRING_IS_NULL(self.studentModel.ReportImgName);
    if ([self.studentModel.ReportImgName isKindOfClass:[NSNull class]]) {
        [self.viewController showHint:@"该学生未上传成绩单"];
        check.ReportImgName = @"person_default.png";
    } else {
        check.ReportImgName = self.studentModel.ReportImgName;
        [self.viewController.navigationController pushViewController:check animated:YES];
    }
}

#pragma mark - setters and getters
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [CommentMethod createImageViewWithImageName:@"person_default.png"];
        _imgView.layer.cornerRadius = 160/3*AUTO_SIZE_SCALE_X/2;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
//        _titLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
        _titLabel = [[UILabel alloc] init];
        _titLabel.font = [UIFont systemFontOfSize:17.0f*AUTO_SIZE_SCALE_X];
        _titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_8];
    }
    return _titLabel;
}

- (UIImageView *)sexImgView
{
    if (!_sexImgView) {
        _sexImgView = [CommentMethod createImageViewWithImageName:@"checkList_nan.png"];
    }
    return _sexImgView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [CommentMethod createLabelWithFont:13.0f Text:@""];
        _detailLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_4];
    }
    return _detailLabel;
}

- (UILabel *)restLabel
{
    if (!_restLabel) {
        _restLabel = [CommentMethod createLabelWithFont:13.0f Text:@""];
        _restLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_4];
    }
    return _restLabel;
}

- (UIButton *)scoreButton
{
    if (!_scoreButton) {
        _scoreButton = [CommentMethod createButtonWithImageName:@"score_chengjidan.png" Target:self Action:@selector(scoreButtonAction:) Title:@"成绩单"];
        [_scoreButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_9] forState:UIControlStateNormal];
        _scoreButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
        _scoreButton.layer.cornerRadius = 5;
        _scoreButton.layer.masksToBounds = YES;
    }
    return _scoreButton;
}

- (UIImageView *)lineImgView
{
    if (!_lineImgView) {
        _lineImgView = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
    }
    return _lineImgView;
}

@end
