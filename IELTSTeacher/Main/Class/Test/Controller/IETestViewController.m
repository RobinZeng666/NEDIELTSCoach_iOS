//
//  IETestViewController.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/6/29.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "IETestViewController.h"
#import "IETextContentView.h"
#import "IETextTableViewCell.h"
#import "IEStartViewController.h"
#import "IEChoiceMode.h"

@interface IETestViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) IETextContentView *contentView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *shureBtn;

@property (nonatomic,assign) BOOL isAll;
@property (nonatomic,assign) BOOL isAlone;
@property (nonatomic,assign) BOOL isAllSelect;
@property (nonatomic,assign) BOOL isUnAllSelect;
@property (nonatomic,strong) NSMutableArray *qidArry;
@property (nonatomic,copy) NSString *paperSubmitMode;
@property (nonatomic,copy) NSString *paperSubmitCountdown;
@property (nonatomic,strong) UITextField *completionAllText;
@property (nonatomic,strong) UITextField *completionAloneText;
@property (nonatomic,strong) UILabel * labelPer;
@property (nonatomic,strong) NSMutableArray *qids;

@property (nonatomic, strong) UIButton *doneInKeyboardButton;

@end

@implementation IETestViewController

- (void)viewDidLoad {
   
    self.isAll = YES;
    [super viewDidLoad];
    
    
    self.titles = self.titls;
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.shureBtn];
    [self  addSub];
    [self setupForDismissKeyboard];
    UIButton *allBtn = [[UIButton alloc]init];
    allBtn = self.contentView.allBtn;
    [allBtn addTarget:self
               action:@selector(allBtnClick)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *eachBtn = [[UIButton alloc]init];
    eachBtn = self.contentView.eachBtn;
    [eachBtn  addTarget:self
                 action:@selector(eachBtnClick)
       forControlEvents:UIControlEventTouchUpInside];
    selectedMarks = [NSMutableArray new];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service  sharedInstance]ActiveClassExerciseDetailWithPassCode:self.passCode
                                                                pId:self.paperId
                                                            success:^(NSDictionary *result) {
                                                                [self hideHud];
                    if (k_IsSuccess(result)) {
                        NDLog(@"展示题目 result = %@", result);
                        
                        NSArray *data = [result objectForKey:@"Data"];
                        CHECK_DATA_IS_NSNULL(data, NSArray);
                        _dataAry = [[NSMutableArray alloc]initWithCapacity:data.count];
                        for (NSDictionary *dic in data) {
                            IEChoiceMode *chModel = [[IEChoiceMode  alloc]initWithDataDic:dic];
                            [_dataAry  addObject:chModel];
                        }

                        [self.tableView reloadData];
                    }else{
                        
                        if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                            [self showHint:[result objectForKey:@"Infomation"]];
                        }
                    }
                    
                }
                failure:^(NSError *error) {
                    NDLog(@"%@",error);
                     [self hideHud];
                }];


    //注册键盘显示通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super  viewWillDisappear:animated];

    [self.view endEditing:YES];
    //注销键盘显示通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

// 键盘出现处理事件
- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
    NSDictionary *userInfo = [notification userInfo];
    // UIKeyboardAnimationDurationUserInfoKey 对应键盘弹出的动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // UIKeyboardAnimationCurveUserInfoKey 对应键盘弹出的动画类型
    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //数字彩,数字键盘添加“完成”按钮
    if (self.doneInKeyboardButton){
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration -10];//设置添加按钮的动画时间
        [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];//设置添加按钮的动画类型
        
        //设置自定制按钮的添加位置(这里为数字键盘添加“完成”按钮)
        self.doneInKeyboardButton.transform=CGAffineTransformTranslate(self.doneInKeyboardButton.transform, 0, -53);
        
        [UIView commitAnimations];
    }
    
}

// 键盘消失处理事件
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
    NSDictionary *userInfo = [notification userInfo];
    // UIKeyboardAnimationDurationUserInfoKey 对应键盘收起的动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (self.doneInKeyboardButton.superview)
    {
        [UIView animateWithDuration:animationDuration animations:^{
            //动画内容，将自定制按钮移回初始位置
            self.doneInKeyboardButton.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //动画结束后移除自定制的按钮
            [self.doneInKeyboardButton removeFromSuperview];
        }];
        
    }
}


//点击输入框

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //初始化数字键盘的“完成”按钮
    [self configDoneInKeyBoardButton];
    
    return YES;
}

- (IBAction)editingDidBegin:(id)sender{}

//初始化，数字键盘“完成”按钮
- (void)configDoneInKeyBoardButton
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //初始化
    if (self.doneInKeyboardButton == nil)
    {
        UIButton *doneInKeyboardButton = [[UIButton alloc] init];
        [doneInKeyboardButton setTitle:@"Return" forState:UIControlStateNormal];
        doneInKeyboardButton.titleLabel.font = [UIFont systemFontOfSize:20*AUTO_SIZE_SCALE_X];
        [doneInKeyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        doneInKeyboardButton.frame = CGRectMake(0, screenHeight , 106, 53);
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        self.doneInKeyboardButton = doneInKeyboardButton;
        
    }
    //每次必须从新设定“完成”按钮的初始化坐标位置
    self.doneInKeyboardButton.frame = CGRectMake(0, screenHeight, 106, 53);
    
    //由于ios8下，键盘所在的window视图还没有初始化完成，调用在下一次 runloop 下获得键盘所在的window视图
    [self performSelector:@selector(addDoneButton) withObject:nil afterDelay:0.0f];
    
}

- (void)addDoneButton
{
    //获得键盘所在的window视图
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] lastObject];
    [tempWindow addSubview:self.doneInKeyboardButton];    // 注意这里直接加到window上
    
}

//点击“完成”按钮事件，收起键盘
-(void)finishAction
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}



- (void)addSub
{
    WS(this_text);
      [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(kNavHeight+3);
          make.centerX .mas_equalTo(this_text.view);
          make.size.mas_equalTo(CGSizeMake(kScreenWidth, 485/3*AUTO_SIZE_SCALE_Y));
    }];
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_text.contentView.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.mas_equalTo(this_text.view.mas_bottom).with.offset(-100*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_text.view);
    }];
    [self.shureBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_text.view);
        make.bottom.mas_equalTo(this_text.view.mas_bottom).with.offset(-117/3*AUTO_SIZE_SCALE_Y);
        make.height.mas_equalTo(45*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(kScreenWidth-110/3*2*AUTO_SIZE_SCALE_X);
    }];

}
#pragma mark--给button 添加事件
- (void)allBtnClick
{
    self.isUnAllSelect = NO;
    self.isAllSelect = YES;
    for (NSString *text in self.dataAry) {
        [selectedMarks removeObject:text];
    }
    //清除数组内所有数据
    [self.qidArry  removeAllObjects];
    self.completionAllText.text = nil;
    self.isAll = YES;
    self.isAlone = NO;
    [self.view  endEditing:YES];
    self.contentView.allBtn.selected = YES;
    self.contentView.eachBtn.selected = NO;
    self.contentView.timeLabel.alpha = 1;
    self.contentView.timeText.alpha = 1;
    self.contentView.completionLabel.alpha = 0;
    self.contentView.completionText.alpha = 0;
    self.contentView.minuteLabe.alpha = 1;
    
    [self.tableView  reloadData];
}


- (void)eachBtnClick
{
    self.isAllSelect = NO;
    self.isUnAllSelect = YES;
    _labelPer.alpha = 0;
    for (NSString *text in self.dataAry) {
        [selectedMarks removeObject:text];
    }
    //清除数组内所有数据
    [self.qidArry  removeAllObjects];
    self.completionAloneText.text = @"100";
    self.isAlone = YES;
    self.isAll = NO;
    [self.view endEditing:YES];
    self.contentView.eachBtn.selected = YES;
    self.contentView.allBtn.selected = NO;
    self.contentView.timeLabel.alpha = 0;
    self.contentView.timeText.alpha = 0;
    self.contentView.completionLabel.alpha = 1;
    self.contentView.completionText.alpha = 1;
    self.contentView.minuteLabe.alpha = 0;
    
    [self infoAction];
    
    [self.tableView  reloadData];
}
//实时监听值得变化
- (void)infoAction
{
    if (self.completionAloneText.text.length == 0) {

        _labelPer.frame = CGRectMake(0, 0, 20*AUTO_SIZE_SCALE_X, self.completionAloneText.frame.size.height);
        _labelPer.alpha = 0;
    }else{
        _labelPer.frame = CGRectMake( 5*AUTO_SIZE_SCALE_X + 10*self.completionAloneText.text.length, 0, 20*AUTO_SIZE_SCALE_Y, self.completionAloneText.frame.size.height);
        _labelPer.alpha = 1;
    }
    

}


//确定
//发送请求获取数据
- (void)shureClick:(UIButton *)button
{
    CHECK_DATA_IS_NSNULL(self.PaperState, NSNumber);
    if (![self.PaperState isEqualToNumber:@3]) {
        [self showHint:@"试卷未打包，请和管理员联系"];
        return ;
    }
    
    IEStartViewController *ctr = [[IEStartViewController alloc]init];
    ctr.ccId = self.ccId;
    ctr.paperId = self.paperId;
    
    NSNumber *paperId = self.paperId;
    NSNumber *infoId = self.ActiveClassPaperInfoId;
    //拼接字符串
    NSMutableString *qIds = [[NSMutableString alloc]init];
    for (int i=0; i<self.qidArry.count; i++) {
        NSString *qid = self.qidArry[i];
        [qIds appendFormat:@"%@",qid];
        if (i< self.qidArry.count-1) {
            [qIds appendFormat:@";"];
        }
    }
//此处qIds 就是想要的参数
    //整套提交
    if (self.isAll) {
        ctr.questionString = @"正确率";
//        ctr.str = @"60%";
        ctr.Btn.tag = 0;
        ctr.isAll = self.isAll;
        self.paperSubmitMode = @"1";
        ctr.paperSubmitMode = self.paperSubmitMode;
        self.paperSubmitCountdown = self.completionAllText.text;
        
        if ([self.completionAllText.text intValue] >= 1 && [self.completionAllText.text intValue] <= 99) {
            NDLog(@"%@",self.completionAllText.text);
            button.enabled = NO;
            [self showHudInView:self.view hint:@"正在发送..."];
            [[Service  sharedInstance]ActiveClassExerciseChooseQuestionsWithInfoId:infoId
                                                                           paperId:paperId
                                                                              qIds:qIds
                                                                   paperSubmitMode:self.paperSubmitMode
                                                              paperSubmitCountdown:self.paperSubmitCountdown                                                                SuccessData:^(NSDictionary *result) {
                                                                  NDLog(@"整套提交 练习题 result = %@",result);
                                                                  button.enabled = YES;
                                                                  [self hideHud];
                                                                  if (k_IsSuccess(result)) {
                                                                      if (self.qidArry.count > 0 ) {
                                                                          ctr.qids = self.qids;
                                                                          ctr.nameText = self.titls;
                                                                          [self.navigationController pushViewController:ctr animated:YES];
                                                                      }
                                                                      //                              [self.tableView reloadData];
                                                                  }else{
                                                                      
                                                                      if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                                          [self showHint:[result objectForKey:@"Infomation"]];
                                                                      }
                                                                  }
                                                                  
                                                              } errorData:^(NSError *error) {
                                                                  [self hideHud];
                                                                  button.enabled = YES;
                                                                  NDLog(@"%@",error);
                                                              }];
            }else
            {
                NSString *str2 = @"输入的时间请设置为1-99";
                [self showHint:str2];
                return;
            }
    }else if (self.isAlone){//单题提交
    
        ctr.questionString = @"答案";
//        ctr.str = @"C";
        ctr.Btn.tag = 1;
        ctr.isAlone = self.isAlone;
        self.paperSubmitMode = @"2";
        ctr.paperSubmitMode = self.paperSubmitMode;
        self.paperSubmitCountdown = self.completionAloneText.text;
        
        if ([self.completionAloneText.text isEqualToString: @""]) {
            
                NSString *str = @"请您输入完成率";
                [self showHint:str];
        }else{
            if ([self.completionAloneText.text intValue] >= 10 && [self.completionAloneText.text intValue] <= 100) {
                        button.enabled = NO;
                        [self showHudInView:self.view hint:@"正在发送..."];
                        [[Service  sharedInstance]ActiveClassExerciseChooseQuestionsWithInfoId:infoId
                                                                                       paperId:paperId
                                                                                          qIds:qIds
                                                                               paperSubmitMode:self.paperSubmitMode
                                                                          paperSubmitCountdown:self.paperSubmitCountdown                                                                SuccessData:^(NSDictionary *result) {
                                  NDLog(@"单题提交 练习题 result = %@",result);
                                   button.enabled = YES;
                                      [self hideHud];
                                  if (k_IsSuccess(result)) {
                                      if (self.qidArry.count > 0 ) {
                                          ctr.qids = self.qids;
                                           ctr.nameText = self.titls;
                                          [self.navigationController pushViewController:ctr animated:YES];
                                      }
                                      NDLog(@"%@",result);
                                  }else{
                                      
                                      if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                          [self showHint:[result objectForKey:@"Infomation"]];
                                      }
                                  }
                                  
                              } errorData:^(NSError *error) {
                                  [self hideHud];
                                  button.enabled = YES;
                                  NDLog(@"%@",error);
                                  
                              }];
            } else {
                [self showHint:@"完成率请设置为10%-100%"];
                return;
            }
        }
    }
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark--UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"IETextTableViewCell";
    IETextTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[IETextTableViewCell alloc]init];
   }
    UIImageView *imagView = [[UIImageView alloc]initWithFrame:cell.frame];
    imagView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = imagView;
    IEChoiceMode *model = self.dataAry[indexPath.row];
    NSString * str = model.QName;
    cell.label.text = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row + 1,str];
    
    NSString *text = [self.dataAry objectAtIndex:[indexPath row]];
    if (self.isAllSelect) {
        cell.selected = NO;
    }else if (self.isUnAllSelect){
        cell.selected = NO;
    }else{
        cell.isSelected =[selectedMarks containsObject:text]?YES:NO;
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IEChoiceMode *model = self.dataAry[indexPath.row];
    self.SectionID = model.SectionID;
    self.qId = [NSNumber numberWithInteger:[model.Q_ID integerValue]];
    self.isUnAllSelect = NO;
    self.isAllSelect = NO;
    NSString *text = [self.dataAry objectAtIndex:indexPath.row];
    if ([selectedMarks containsObject:text])// Is selected?
    {
        NSUInteger index = [selectedMarks indexOfObject:text];
        if (self.qidArry.count > 0) {
            if (self.qidArry[index] != nil) {
                NSString *qidString = self.qidArry[index];
                [self.qidArry removeObject:qidString];
            }
        }
        if (self.qids.count > 0) {
            if (self.qids[index] != nil) {
                NSString *qidstring = self.qids[index];
                [self.qids  removeObject:qidstring];
            }
        }
        
        [selectedMarks removeObject:text];
    } else{
    
        [selectedMarks addObject:text];        
        NSString *qidString =  [NSString stringWithFormat:@"%@,%@",self.qId,self.SectionID];//,model.PID];
        [self.qids addObject:self.qId];
        [self.qidArry addObject:qidString];
    }
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200/3*AUTO_SIZE_SCALE_Y;
}


#pragma mark - set or get
- (IETextContentView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[IETextContentView alloc]init];
        _contentView.timeText.delegate = self;
        self.completionAllText = _contentView.timeText;
        self.completionAloneText = _contentView.completionText;
        self.completionAloneText.delegate = self;
        
        [_contentView.timeText addTarget:self action:@selector(editingDidBegin:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView.completionText addTarget:self action:@selector(editingDidBegin:) forControlEvents:UIControlEventTouchUpInside];
        _labelPer = [[UILabel alloc]init];
        _labelPer.text = @"%";
        _labelPer.textColor = [UIColor blackColor];
        _labelPer.font = [UIFont systemFontOfSize:18*AUTO_SIZE_SCALE_X];
        
        [self.completionAloneText  addSubview:_labelPer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction)name:UITextFieldTextDidChangeNotification object:nil];
    }
    return _contentView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(UIButton *)shureBtn
{
    if (!_shureBtn) {
        _shureBtn = [[UIButton alloc]init];
        [_shureBtn setTitle:@"确认" forState:UIControlStateNormal];
        _shureBtn.titleLabel.font = [UIFont  systemFontOfSize:18*AUTO_SIZE_SCALE_X];
        [_shureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shureBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
        [_shureBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji"] forState:UIControlStateHighlighted];
        [_shureBtn  addTarget:self action:@selector(shureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shureBtn;
}

//懒加载
- (NSMutableArray *)qidArry
{
    if (!_qidArry) {
        _qidArry = [[NSMutableArray alloc]init];
    }
    return _qidArry;
}
- (NSMutableArray *)qids
{
    if (!_qids) {
        _qids = [[NSMutableArray alloc]init];
    }
    return _qids;
}


@end
