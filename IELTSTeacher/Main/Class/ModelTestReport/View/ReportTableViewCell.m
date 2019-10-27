//
//  ReportTableViewCell.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ReportTableViewCell.h"
//#import "RMDownloadIndicator.h"
#import "ReportChoseView.h"
#import "ReportFillingView.h"

#import "AccListModel.h"
#import "OptionListModel.h"
#import "studentChooseListModel.h"

#import "MDRadialProgressTheme.h"
#import "MDRadialProgressView.h"
#import "ReportChooseViewController.h"

#define k_rightColor RGBACOLOR(251, 49, 79, 1)
#define k_wrongColor RGBACOLOR(154, 154, 154, 1)
#define k_rightPerLabelHeight  (20*AUTO_SIZE_SCALE_X)
#define k_TopViewHeight (90*AUTO_SIZE_SCALE_X)
#define k_ChooseAndDisPuteHeight (213*AUTO_SIZE_SCALE_Y)
#define k_FillingHeight (120*AUTO_SIZE_SCALE_Y)
@interface ReportTableViewCell()

/**
 *  圆形进度数据
 */
//@property (strong, nonatomic) RMDownloadIndicator *closedIndicator;
//@property (assign, nonatomic) CGFloat downloadedBytes;
//@property (nonatomic,strong) MDRadialProgressTheme *progressTheme;
@property (nonatomic,strong) MDRadialProgressView  *radialView7;
/*
  头部视图
 */
@property (nonatomic,strong) UIView   *topBgView;      //头部背景视图
@property (nonatomic,strong) UILabel  *rightPerLabel;  //正确率
@property (nonatomic,assign) BOOL     isFirst;         //是否为第一次加载
@property (nonatomic,strong) UILabel  *titleLabel;     //题目名称
@property (nonatomic,strong) UILabel  *trueAnswerLable;//正确答案
@property (nonatomic,strong) UIView   *divisionView;   //分割线View

/*
   内容视图
 */
@property (nonatomic,strong) UIView   *ctnViews;

//统计图部分
@property (nonatomic,strong) ReportChoseView   *choseView;    //选择题和是非题视图
@property (nonatomic,strong) ReportFillingView *fillingView;  //填空题视图

@end
@implementation ReportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
        [self _initView];
    }
    return self;
}
//初始化视图
- (void)_initView
{
    WS(weakself);
    
    [self.contentView addSubview:self.topBgView];
    [self.topBgView addSubview:self.titleLabel];      //标题
    [self.topBgView addSubview:self.trueAnswerLable]; //正确答案
    [self.topBgView addSubview:self.divisionView];
    
    self.topBgView.backgroundColor = [UIColor whiteColor];
    
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 90*AUTO_SIZE_SCALE_X));
        make.top.mas_equalTo(10*AUTO_SIZE_SCALE_X);
        make.left.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
        make.centerY.mas_equalTo(weakself.topBgView.centerY).with.offset(-20*AUTO_SIZE_SCALE_Y);
    }];

    [self.trueAnswerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
        make.centerY.mas_equalTo(weakself.topBgView.centerY).with.offset(20*AUTO_SIZE_SCALE_Y);
    }];
    
    [self.divisionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 1));
        make.bottom.mas_equalTo(weakself.topBgView.mas_bottom).with.offset(-1*AUTO_SIZE_SCALE_X);
    }];
    
    
    [self.contentView addSubview:self.ctnViews];
     self.ctnViews.backgroundColor = [UIColor whiteColor];
    [self.ctnViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, k_ChooseAndDisPuteHeight));
        make.top.mas_equalTo(weakself.topBgView.mas_bottom);
        make.left.mas_equalTo(0);
    }];
    
    
    [self.contentView addSubview:self.choseView];
    [self.contentView addSubview:self.fillingView];
    
   

    
    [self.topBgView addSubview:self.radialView7];
    [self.topBgView addSubview:self.rightPerLabel];
    
    WS(this_Dynamic);
    //添加约束
    [self.radialView7  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 64*AUTO_SIZE_SCALE_X));
        make.centerY.mas_equalTo(this_Dynamic.topBgView);
        make.right.mas_equalTo(-(10+25)*AUTO_SIZE_SCALE_X);
    }];
    
    [self.rightPerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.radialView7.mas_top).with.offset(-2*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.radialView7.mas_centerX).with.offset(-2*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
}


#pragma mark - 重新布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    WS(weakself);
    //加载圆形进度条
    if ([self.model.Accuracy integerValue] == 0) {
        self.radialView7.progressCounter = 0;
    }else
    {
        self.radialView7.progressCounter = [self.model.Accuracy integerValue];
    }
    
    //1.取出正确答案和题目
    CHECK_DATA_IS_NSNULL(self.model.QSValue, NSString);
    CHECK_STRING_IS_NULL(self.model.QSValue);
    self.trueAnswerLable.text = [NSString stringWithFormat:@"正确答案：%@",self.model.QSValue];
    
    CHECK_DATA_IS_NSNULL(self.model.Title, NSString);
    CHECK_STRING_IS_NULL(self.model.Title);
    self.titleLabel.text = [NSString stringWithFormat:@"%ld.%@",(long)self.indexRow,self.model.Title];
    
    //2.判断类型创建视图
    CHECK_DATA_IS_NSNULL(self.model.QuestionType, NSNumber);
    NSInteger questionType = [self.model.QuestionType integerValue];
    //1选择题2是非选择题3填空题,
    if (questionType == 1 || questionType == 2) {
        self.choseView.hidden = NO;
        self.fillingView.hidden = YES;
        
        CHECK_DATA_IS_NSNULL(self.model.optionList, NSArray);
        if (self.model.optionList.count > 0) {

            CHECK_DATA_IS_NSNULL(self.model.stuAnswerTotalCount, NSNumber);
            CGFloat stuAnswerTotalCount = [self.model.stuAnswerTotalCount floatValue];
            self.choseView.stuAnswerTotalCount = stuAnswerTotalCount;
            self.choseView.questionType = questionType;
            
            CHECK_STRING_IS_NULL(self.model.QSValue);
            self.choseView.qsValue = self.model.QSValue;
            
            self.choseView.optionArray = self.model.optionList;
        }
        
        [self.ctnViews mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, k_ChooseAndDisPuteHeight));
            make.top.mas_equalTo(weakself.topBgView.mas_bottom);
            make.left.mas_equalTo(0);
        }];
    }else if (questionType == 3){
        self.choseView.hidden = YES;
        self.fillingView.hidden = NO;

        CHECK_DATA_IS_NSNULL(self.model.optionList, NSArray);
        if (self.model.optionList.count > 0) {
            
            CHECK_DATA_IS_NSNULL(self.model.stuAnswerTotalCount, NSNumber);
            CGFloat stuAnswerTotalCount = [self.model.stuAnswerTotalCount floatValue];
            self.fillingView.stuAnswerTotalCount = stuAnswerTotalCount;
            
            CHECK_STRING_IS_NULL(self.model.QSValue);
            self.fillingView.qsValue = self.model.QSValue;
            
            self.fillingView.optionArray = self.model.optionList;
        }
        
        
        [self.ctnViews mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, k_FillingHeight));
            make.top.mas_equalTo(weakself.topBgView.mas_bottom);
            make.left.mas_equalTo(0);
        }];
    }
    
    /*
     else if(questionType == 2){
     [self.contentView addSubview:self.disPuteView];
     [self.ctnViews mas_updateConstraints:^(MASConstraintMaker *make) {
     make.size.mas_equalTo(CGSizeMake(kScreenWidth, k_ChooseAndDisPuteHeight));
     make.top.mas_equalTo(weakself.topBgView.mas_bottom);
     make.left.mas_equalTo(0);
     }];
     }
     */
}

#pragma mark - action
- (void)trueTapAction
{
    NSArray *accuracyStudentChooseList = self.model.AccuracyStudentChooseList;
    CHECK_DATA_IS_NSNULL(accuracyStudentChooseList, NSArray);
    if (accuracyStudentChooseList.count > 0) {
        ReportChooseViewController *chooseCtr = [[ReportChooseViewController alloc]init];
        CHECK_STRING_IS_NULL(self.model.QSValue);
        chooseCtr.titleChoose = self.model.QSValue;
        chooseCtr.studentChooseList = accuracyStudentChooseList;
        [self.viewController.navigationController pushViewController:chooseCtr animated:YES];
    }
}

#pragma mark -----------------------------
#pragma mark - set or get

/////顶部视图
//- (RMDownloadIndicator *)closedIndicator
//{
//    if (!_closedIndicator) {
//        _closedIndicator= [[RMDownloadIndicator alloc]initWithFrame:CGRectZero type:kRMClosedIndicator];
//        [_closedIndicator setBackgroundColor:[UIColor clearColor]];
//        [_closedIndicator setFillColor:kIndicatorColor];
//        [_closedIndicator setStrokeColor:k_rightColor];
//    }
//    return _closedIndicator;
//}

- (MDRadialProgressView *)radialView7
{
    if (!_radialView7) {
        MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
        newTheme.completedColor = k_PinkColor;
        newTheme.incompletedColor = RGBACOLOR(230, 230, 230, 1.0);
        newTheme.centerColor = [UIColor clearColor];
        //	newTheme.centerColor = [UIColor colorWithRed:224/255.0 green:248/255.0 blue:216/255.0 alpha:1.0];
        newTheme.sliceDividerHidden = YES;
        newTheme.font = [UIFont systemFontOfSize:16.0*AUTO_SIZE_SCALE_X];
        newTheme.labelColor = [UIColor darkGrayColor];
        newTheme.labelShadowColor = [UIColor whiteColor];
        
        _radialView7 = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(0, 0, 64*AUTO_SIZE_SCALE_X, 64*AUTO_SIZE_SCALE_X) andTheme:newTheme];
        _radialView7.progressTotal = 100;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(trueTapAction)];
        [_radialView7 addGestureRecognizer:tap];
        _radialView7.userInteractionEnabled = YES;
        
    }
    return _radialView7;
}

- (UIView *)topBgView
{
    if (!_topBgView) {
        _topBgView = [[UIView alloc]init];
    }
    return _topBgView;
}
- (UILabel *)rightPerLabel
{
    if (!_rightPerLabel) {
        _rightPerLabel = [[UILabel alloc]init];
        _rightPerLabel.backgroundColor = k_rightColor;
        _rightPerLabel.text = @"正确率";
        _rightPerLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _rightPerLabel.layer.cornerRadius = k_rightPerLabelHeight/2;
        _rightPerLabel.layer.masksToBounds = YES;
        _rightPerLabel.textColor = [UIColor whiteColor];
        _rightPerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightPerLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [CommentMethod createLabelWithFont:15.0f Text:@""];
        _titleLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _titleLabel;
}

- (UILabel *)trueAnswerLable
{
    if (!_trueAnswerLable) {
        _trueAnswerLable = [CommentMethod createLabelWithFont:14.0f Text:@"正确答案："];
        _trueAnswerLable.textColor = k_PinkColor;
    }
    return _trueAnswerLable;
}

- (UIView *)divisionView
{
    if (!_divisionView) {
        _divisionView = [[UIView alloc]init];
        _divisionView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    }
    return _divisionView;
}


///统计图视图
- (UIView *)ctnViews
{
    if (!_ctnViews) {
        _ctnViews = [[UIView alloc]init];
    }
    return _ctnViews;
}
- (ReportFillingView *)fillingView
{
    if (!_fillingView) {
        _fillingView = [[ReportFillingView alloc]initWithFrame:CGRectMake(0, k_TopViewHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth,k_FillingHeight)];
    }
    return _fillingView;
}

//- (ReportDisputeView *)disPuteView
//{
//    if (!_disPuteView) {
//        _disPuteView = [[ReportDisputeView alloc]initWithFrame:CGRectMake(0, k_TopViewHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth,k_ChooseAndDisPuteHeight)];
//    }
//    return _disPuteView;
//}

- (ReportChoseView *)choseView
{
    if (!_choseView) {
        _choseView = [[ReportChoseView alloc]initWithFrame:CGRectMake(0, k_TopViewHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth,k_ChooseAndDisPuteHeight)];
    }
    return _choseView;
}






@end
