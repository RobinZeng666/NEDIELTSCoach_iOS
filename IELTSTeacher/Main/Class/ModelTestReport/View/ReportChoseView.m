//
//  ReportChoseView.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ReportChoseView.h"
#import "ReportVerticalView.h"
#import "OptionListModel.h"
#import "ReportChooseViewController.h"

#define k_rightColor RGBACOLOR(251, 49, 79, 1)
#define k_wrongColor RGBACOLOR(154, 154, 154, 1)

#define k_ChooseAndDisPuteHeight (213*AUTO_SIZE_SCALE_Y)

#define k_LineHengHeight (240*AUTO_SIZE_SCALE_X)
#define k_LineShuHeight   (k_ChooseAndDisPuteHeight-60*AUTO_SIZE_SCALE_X)

@interface ReportChoseView ()

@property (nonatomic,strong) ReportVerticalView *verticalView;  //左侧值
@property (nonatomic,strong) UIImageView *lineHeng;
@property (nonatomic,strong) UIImageView *lineShu;

@end

@implementation ReportChoseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    [self addSubview:self.lineHeng];
    [self addSubview:self.lineShu];
    //横线，竖线
    WS(this_ChoseView);
    [self.lineHeng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(111*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(k_LineHengHeight, 1*AUTO_SIZE_SCALE_X));
        make.top.mas_equalTo(this_ChoseView.lineShu.mas_bottom);
    }];
    
    [self.lineShu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(111*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(1*AUTO_SIZE_SCALE_X,k_LineShuHeight));
        make.centerY.mas_equalTo(this_ChoseView.centerY);
    }];
    
    //比率
    [self addSubview:self.verticalView];
    [self.verticalView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(this_ChoseView.lineShu);
        make.width.mas_equalTo(35*AUTO_SIZE_SCALE_X);
        make.bottom.mas_equalTo(this_ChoseView.lineShu.mas_bottom).with.offset(0);
        make.top.mas_equalTo(this_ChoseView.mas_top).with.offset(15*AUTO_SIZE_SCALE_X);
    }];
}

- (void)setOptionArray:(NSArray *)optionArray
{
    if (_optionArray != optionArray) {
        _optionArray = optionArray;
        
        [self _dealData];
    }
}
- (void)_dealData
{
    WS(this_ChoseView);
    //处理数据
    if (self.optionArray.count > 0) {
        //CGFloat n = [_optionModel.studentChooseCount floatValue];
        // CGFloat m = [model.stuAnswerTotalCount floatValue];
        //创建button 和 title
        
        CGFloat buttonWidth = 30*AUTO_SIZE_SCALE_X;
        CGFloat gapWidth = (k_LineHengHeight - buttonWidth*self.optionArray.count)/(self.optionArray.count+1);
        for (int i=0; i<self.optionArray.count; i++) {
            
            OptionListModel *model = self.optionArray[i];
            CGFloat n = [model.studentChooseCount floatValue];
            CGFloat m = self.stuAnswerTotalCount;
            
            CGFloat buttonHeight = (n/m) *0.9*k_LineShuHeight;
            //创建条形图
            UIButton *button = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(selectCurentAnswer:) Title:@""];
            [button setBackgroundImage:[CommentMethod createImageWithColor:k_wrongColor] forState:UIControlStateNormal];
            button.tag = 100+i;
            [self addSubview:button];
            
            //创建个数label
            NSString *chooseCount =[NSString stringWithFormat:@"%.f",n];
            UILabel *numbeLabel = [CommentMethod createLabelWithFont:14.0f Text:chooseCount];
            numbeLabel.textColor = [UIColor whiteColor];
            numbeLabel.textAlignment = NSTextAlignmentCenter;
            [button addSubview:numbeLabel];
            
            //创建选项label
            UILabel *selectLabel = [CommentMethod createLabelWithFont:14.0f Text:@""];
            selectLabel.textColor = k_wrongColor;
            selectLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:selectLabel];
            if (self.questionType == 1) {
                CHECK_DATA_IS_NSNULL(model.OptionName, NSString);
                CHECK_STRING_IS_NULL(model.OptionName);
                selectLabel.text = model.OptionName;
                if ([self.qsValue isEqualToString:model.OptionName]) {
                    [button setBackgroundImage:[CommentMethod createImageWithColor:k_rightColor] forState:UIControlStateNormal];
                }
                
            }else if (self.questionType == 2)
            {
                CHECK_DATA_IS_NSNULL(model.Option, NSString);
                CHECK_STRING_IS_NULL(model.Option);
                selectLabel.text = model.Option;
                
                if ([self.qsValue isEqualToString:model.Option]) {
                    [button setBackgroundImage:[CommentMethod createImageWithColor:k_rightColor] forState:UIControlStateNormal];
                }
            }
            
            //约束
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
                make.left.mas_equalTo(this_ChoseView.lineShu.mas_right).with.offset(gapWidth+(buttonWidth+gapWidth)*i);
                make.bottom.mas_equalTo(this_ChoseView.lineHeng.mas_top);
            }];
            
            [numbeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonWidth));
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
            }];
            
            [selectLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonWidth));
                make.centerX.mas_equalTo(button.centerX);
                make.top.mas_equalTo(this_ChoseView.lineHeng.mas_bottom);
            }];
            
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - ResponeAction
- (void)selectCurentAnswer:(UIButton *)button
{
    NSInteger tag = button.tag - 100;
    if (self.optionArray.count > 0) {
        OptionListModel *model = self.optionArray[tag];
        CHECK_DATA_IS_NSNULL(model.studentChooseList, NSArray);
        if (model.studentChooseList.count > 0) {
            ReportChooseViewController *chooseCtr = [[ReportChooseViewController alloc]init];
            
            if (self.questionType == 1) {
                CHECK_DATA_IS_NSNULL(model.OptionName, NSString);
                CHECK_STRING_IS_NULL(model.OptionName);
                 chooseCtr.titleChoose = model.OptionName;
            }else if (self.questionType == 2)
            {
                CHECK_DATA_IS_NSNULL(model.Option, NSString);
                CHECK_STRING_IS_NULL(model.Option);
                 chooseCtr.titleChoose = model.Option;
            }
            
            chooseCtr.studentChooseList = model.studentChooseList;
            [self.viewController.navigationController pushViewController:chooseCtr animated:YES];
        }
    }
}


#pragma mark --------------------------------
#pragma mark - set or get
- (ReportVerticalView *)verticalView{
    if (!_verticalView) {
        _verticalView = [[ReportVerticalView alloc]init];
        _verticalView.backgroundColor = [UIColor clearColor];
    }
    return _verticalView;
}

- (UIImageView *)lineHeng{
    if (!_lineHeng) {
        _lineHeng = [[UIImageView alloc]init];
        _lineHeng.backgroundColor = k_wrongColor;
    }
    return _lineHeng;
}
- (UIImageView *)lineShu{
    if (!_lineShu) {
        _lineShu = [[UIImageView alloc]init];
        _lineShu.backgroundColor = k_wrongColor;
    }
    return _lineShu;
}


@end
