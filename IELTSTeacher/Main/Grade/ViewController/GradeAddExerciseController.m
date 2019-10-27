//
//  GradeAddExerciseController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeAddExerciseController.h"
#import "FDAlertView.h"
#import "IEPlusMode.h"
#import "MJExtension.h"
#import "IEView.h"
#import "IEPlusView.h"

@interface GradeAddExerciseController ()

@property (nonatomic,strong) UILabel     *numberLabel;
@property (nonatomic,strong) UIView      *textFiledBgView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton    *addTestBt;


@end

@implementation GradeAddExerciseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"添加练习";
    //初始化ui
    [self _initView];
    //收起键盘
    [self setupForDismissKeyboard];
    
}

- (void)_initView
{
    [self.view addSubview:self.numberLabel];
    [self.view addSubview:self.textFiledBgView];
    [self.view addSubview:self.addTestBt];
    [self.textFiledBgView addSubview:self.textField];
    
    WS(this_addExercise);
    CGFloat textFieldTop = kNavHeight + 27*AUTO_SIZE_SCALE_Y; //顶部高度
    CGFloat textFieldHeight = 40*AUTO_SIZE_SCALE_Y;  //输入框的高度
    CGFloat textNumberLabelWidth = 90*AUTO_SIZE_SCALE_X; //编号 宽度
    CGFloat textFieldWidth = kScreenWidth - 90*AUTO_SIZE_SCALE_X - 15*AUTO_SIZE_SCALE_X; //输入框的宽度
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(textNumberLabelWidth, textFieldHeight));
        make.top.mas_equalTo(textFieldTop);
    }];
    
    [self.textFiledBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textFieldTop);
        make.size.mas_equalTo(CGSizeMake(textFieldWidth, textFieldHeight));
        make.right.mas_equalTo(-15*AUTO_SIZE_SCALE_X);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(textFieldWidth-10*AUTO_SIZE_SCALE_X, textFieldHeight));
        make.top.mas_equalTo(0);
    }];
    
    [self.addTestBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_addExercise.textFiledBgView.mas_bottom).with.offset(27*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(39*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-78*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_Y));
    }];

}

- (void)sureAddExercise
{
    [self.view  endEditing:YES];
    
    NSString *paperNumber = self.textField.text;
    CHECK_STRING_IS_NULL(paperNumber);
    if ([paperNumber isEqualToString:@""]) {
        [self showHint:@"请输入练习题编号"];
        return;
    }
    
    CHECK_STRING_IS_NULL(self.ccId);
    [self showHudInView:self.view hint:@"正在获取练习试卷..."];
    [[Service  sharedInstance]ActiveClassExerciseByPaperNumberWithPaperNumber:paperNumber
                                                                         ccId:self.ccId
                                                                      success:^(NSDictionary *result) {
              NDLog(@"%@",result);
              [self hideHud];
              if (k_IsSuccess(result)) {
                  NSDictionary *data = [result  objectForKey:@"Data"];
                  CHECK_DATA_IS_NSNULL(data, NSDictionary);
                  IEPlusMode *models = [IEPlusMode objectWithKeyValues:data];
                  [self   addsubPaperNumber:models.PaperNumber
                                       name: models.Name
                                      count: models.QuestionCount
                                        pid:models.P_ID];
              }else{
                  if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                      [CommentMethod showToastWithMessage:[result objectForKey:@"Infomation"] showTime:2.0];
                  }
              }
              
            }
      failure:^(NSError *error) {
          NDLog(@"%@",error);
          [self hideHud];
      }];
}

-(void)addsubPaperNumber:(NSString *)paperNumber
                    name:(NSString *)name
                   count:(NSNumber *)count
                     pid:(NSNumber *)pid {
    
    FDAlertView *alert = [[FDAlertView alloc]init];
    
    IEView *whiteView = [[IEView alloc]init];
    whiteView.frame = CGRectMake(0, 0, kScreenWidth-40*2, kScreenHeight * 0.35);
    [whiteView.contentLabel  removeFromSuperview];
    whiteView.titleString = @"添加课堂练习题";
    [whiteView.mainBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    IEPlusView *plusView = [[IEPlusView alloc]init];
    plusView.numberLabel.text = paperNumber;
    plusView.ansLabel.text = name;
    plusView.countLabel.text = [count stringValue];
    plusView.frame = CGRectMake(0, 70*AUTO_SIZE_SCALE_Y, whiteView.frame.size.width, whiteView.frame.size.height * 0.5);
    
    [whiteView  addSubview:plusView];
    
    NSString *p_id = [pid stringValue];
    CHECK_STRING_IS_NULL(p_id);
    CHECK_STRING_IS_NULL(self.ccId);
    alert.contentView = whiteView;
    [alert show];
    whiteView.block = ^(BOOL isShut){
        [alert hide];
        if (!isShut) {
            [self showHudInView:self.view hint:@"正在添加试卷..."];
            [[Service  sharedInstance]ActiveClassExerciseByPaperNumberSaveWithpaperId:p_id
                                                                                 ccId:self.ccId
                                                                              success:^(NSDictionary *result) {
          [alert hide];
          NDLog(@"%@",result);
          [self hideHud];
          if (k_IsSuccess(result)) {
              if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                  [self showHint:[result objectForKey:@"Infomation"]];
              }
              [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Name_ClassDetail object:nil];
              
              [self.navigationController popViewControllerAnimated:YES];
          }else{
              if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
//                  [self showHint:[result objectForKey:@"Infomation"]];
                  [CommentMethod showToastWithMessage:[result objectForKey:@"Infomation"] showTime:2.0];
              }
          }
      } failure:^(NSError *error) {
          NDLog(@"%@",error);
          [self hideHud];
          NSString *info =[error networkErrorInfo];
          CHECK_STRING_IS_NULL(info);
          [CommentMethod showToastWithMessage:info showTime:2.0];
//          [self showHint:info];
      }];
        }
    };
}

#pragma mark -  set or get
/**
 @property (nonatomic,strong) UILabel     *numberLabel;
 @property (nonatomic,strong) UIView      *textFiledBgView;
 @property (nonatomic,strong) UITextField *textField;
 @property (nonatomic,strong) UIButton    *addTestBt;
 */

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [CommentMethod createLabelWithFont:20.0f Text:@"编号"];
        _numberLabel.textColor = [UIColor blackColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (UIView *)textFiledBgView
{
    if (!_textFiledBgView) {
        _textFiledBgView = [[UIView alloc]init];
        _textFiledBgView.backgroundColor = [UIColor whiteColor];
    }
    return _textFiledBgView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [CommentMethod createTextFieldWithPlaceholder:@"请输入练习题编号" passWord:NO Font:18.0f];
    }
    return _textField;
}

- (UIButton *)addTestBt
{
    if (!_addTestBt) {
        _addTestBt = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(sureAddExercise) Title:@"添加到课堂练习中"];
        [_addTestBt setBackgroundImage:[CommentMethod createImageWithColor:k_PinkColor] forState:UIControlStateNormal];
    }
    return _addTestBt;
}


@end
