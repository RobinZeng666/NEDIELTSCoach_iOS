//
//  ReportFillingView.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ReportFillingView.h"
#import "OptionListModel.h"
#import "ReportChooseViewController.h"


#define k_rightColor RGBACOLOR(251, 49, 79, 1)
#define k_wrongColor RGBACOLOR(153, 153, 153, 1)

#define k_FillingHeight (120*AUTO_SIZE_SCALE_Y)

#define k_AllWidth (kScreenWidth - 100*AUTO_SIZE_SCALE_X) //计算总长度

@interface ReportFillingView()

@property(nonatomic,strong)UIButton*rightAnswer;


@end
@implementation ReportFillingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self _initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self _initView];
    }
    return self;
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
    WS(this_cell);
    //处理数据
    if (self.optionArray.count > 0) {
        //CGFloat n = [_optionModel.studentChooseCount floatValue];
        // CGFloat m = [model.stuAnswerTotalCount floatValue];
        //创建button 和 title
        
        for (int i=0; i<self.optionArray.count; i++) {
            
            OptionListModel *model = self.optionArray[i];
            CGFloat n = [model.studentChooseCount floatValue];
            CGFloat m = self.stuAnswerTotalCount;
            
            CGFloat buttonWidth = (n/m) *k_AllWidth;
            //创建条形图
            CHECK_DATA_IS_NSNULL(model.Option, NSString);
            CHECK_STRING_IS_NULL(model.Option);
            
            
            UIView *bgView = [[UIView alloc]init];
            bgView.backgroundColor = RGBACOLOR(230, 230, 230, 1.0);
            [self addSubview:bgView];
            
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(this_cell.centerY).with.offset(-10.0f*AUTO_SIZE_SCALE_X+i*40*AUTO_SIZE_SCALE_Y);
                make.left.mas_equalTo(50*AUTO_SIZE_SCALE_X);
                make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
                make.width.mas_equalTo(k_AllWidth);
            }];
            
            self.rightAnswer = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(rightAnswerAction:) Title:@""];
            self.rightAnswer.layer.borderColor = [UIColor clearColor].CGColor;
            self.rightAnswer.layer.cornerRadius = 3*AUTO_SIZE_SCALE_X;
            self.rightAnswer.layer.masksToBounds = YES;
            self.rightAnswer.tag = 1000+i;
            [bgView addSubview:self.rightAnswer];
            
            UILabel *titLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
            titLabel.textColor = [UIColor whiteColor];
            [bgView addSubview:titLabel];
            
            
            
            
            [self.rightAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(this_cell.centerY).with.offset(-10.0f*AUTO_SIZE_SCALE_X+i*40*AUTO_SIZE_SCALE_Y);
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
                make.width.mas_equalTo(buttonWidth);
            }];
            
            
            [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(this_cell.rightAnswer);
                make.left.mas_equalTo(10*AUTO_SIZE_SCALE_X);
                make.height.mas_equalTo(30*AUTO_SIZE_SCALE_Y);
            }];
            CHECK_DATA_IS_NSNULL(model.Option, NSString);
            CHECK_STRING_IS_NULL(model.Option);
            if ([model.Option isEqualToString:self.qsValue] && model.Option.length > 0) { //正确的
                [self.rightAnswer setBackgroundImage:[CommentMethod createImageWithColor:k_PinkColor] forState:UIControlStateNormal] ;
                titLabel.text = self.qsValue;
            }else
            {
                [self.rightAnswer setBackgroundImage:[CommentMethod createImageWithColor:k_wrongColor] forState:UIControlStateNormal];
                titLabel.text = model.Option;
            }
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews]; //other
    
}

#pragma mark - rightAnswerAction
- (void)rightAnswerAction:(UIButton *)button
{
    NSInteger tag =  button.tag-1000;
    if (self.optionArray.count > 0) {
        if (tag < 0) {
            return;
        }
        OptionListModel *model = self.optionArray[tag];
        CHECK_DATA_IS_NSNULL(model.studentChooseList, NSArray);
        if (model.studentChooseList.count > 0) {
            ReportChooseViewController *chooseCtr = [[ReportChooseViewController alloc]init];
            CHECK_DATA_IS_NSNULL(model.Option, NSString);
            CHECK_STRING_IS_NULL(model.Option);
            chooseCtr.titleChoose = model.Option;
            chooseCtr.studentChooseList = model.studentChooseList;
            [self.viewController.navigationController pushViewController:chooseCtr animated:YES];
        }
    }
}


#pragma mark - set or get
//- (UIButton *)rightAnswer{
//    if (!_rightAnswer) {
//        
//    }
//    return _rightAnswer;
//}
//

@end
