//
//  AddRemindViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/16.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "AddRemindViewController.h"
#import "RemindCell.h"
#import "CBDatePickerView.h"
#import "NSDate+category.h"
#import "TextInputViewController.h"

#define kRowHeight 50
#define kRemarkTextHeight 200

#define k_Application [UIApplication sharedApplication]

#define k_Tip0 @"无"
#define k_Tip1 @"提前10分钟"
#define k_Tip2 @"提前30分钟"
#define k_Tip3 @"提前1小时"
#define k_Tip4 @"提前1天"

#define k_Sound0 @"无"
#define k_Sound1 @"有"

@interface AddRemindViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,CBDatePickerDelegate,UIActionSheetDelegate>
{
    CGFloat org_y;
}

@property (nonatomic,strong) UIButton    *finishButton;
@property (nonatomic,strong) UIView      *bgView; //整个视图的父视图，做备注屏幕上下移动需要
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *titleTextField; //标题
@property (nonatomic,strong) UITextView  *remarkTextView;//备注
@property (nonatomic,strong) UILabel     *remarkLabel; //备注文字

@property (nonatomic,strong) CBDatePickerView *datePickView;
@property (nonatomic,strong) RemindCell *cell1;
@property (nonatomic,strong) RemindCell *cell2;

@property (nonatomic,strong) NSDate *timeDate; //时间

@property (nonatomic,copy) NSString *Time;
@property (nonatomic,copy) NSString *dateTime;//2015-07-01
@property (nonatomic,copy) NSString *hourTime;//am 9:00

@property (nonatomic,strong) NSIndexPath *indexPath;

/**
 *  初始数据
 */
@property (nonatomic,strong) NSArray *imgArr;
@property (nonatomic,strong) NSArray *img2Arr;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *title2Arr;
@property (nonatomic,strong) NSArray *scoreArr;
@property (nonatomic,strong) NSArray *score2Arr;


@property (nonatomic,strong) UILocalNotification *localNoti;//本地通知;

@property (nonatomic,assign) NSInteger repeatTag;
@property (nonatomic,assign) NSInteger soundTag;
@property (nonatomic,assign) NSInteger tipTag;

@end

@implementation AddRemindViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isCheck) {
        self.titles = @"提醒详情";
    } else {
        self.titles = @"新增提醒";
    }
    
    self.repeatTag = 0;
    self.soundTag = 0;
    self.tipTag = 0;
    
    /**
     初始化视图
     */
    [self _initView];
    
    //初始化数据
    [self _initData];
    
    /**
     初始化键盘监听
     */
    [self _initKeyBoard];
    /**
     *  收起键盘
     */
    [self setupForDismissKeyboard];
}

- (void)_initView
{
    
    WS(this_Remind);
    
    [self.bgView addSubview:self.tableView];
    [self.view addSubview:self.bgView];
    [self.navView addSubview:self.finishButton];
    
    [self.bgView insertSubview:self.navView belowSubview:self.view];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_Remind.bgView).with.offset(kNavHeight);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-kNavHeight));
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(44);
    }];
}

- (void)_initData
{
    _imgArr = @[@"addplan_kaishi.png", @"addplan_jiesu.png", @"addshengyin.png"];
    _img2Arr = @[@"addplan_shengyin.png"];
    _titleArr = @[@"时间", @"地点", @"声音"];
    _title2Arr = @[@"提醒"];
    _scoreArr = @[@"无", @"无", @"无"];
    _score2Arr = @[@"无"];
    
    
    if (IS_IOS_8) {
        //1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"接收";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        //    action.authenticationRequired = YES;
        //    action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=@"拒绝";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        [k_Application registerUserNotificationSettings:notiSettings];
        
    }else{
        //注册本地通知

        [k_Application registerForRemoteNotificationTypes:UIUserNotificationTypeAlert|
                                                          UIUserNotificationTypeBadge|
                                                          UIUserNotificationTypeSound
         ];
    }
    
    //获取数据
    if (self.isCheck) {
        NDLog(@"%@",self.dataCurrent);
        [self performSelector:@selector(_dealCurentData) withObject:nil afterDelay:0.35];
    }
}

- (void)_dealCurentData
{
    if (self.dataCurrent.count > 0) {
        
        /*
         @"ImgString":@"remind_hongdian.png",
         @"Title":titleTextField, //标题
         @"LocalImgName":@"personal_planList_dizhi.png",
         @"Time":cellTime,//时间
         @"Location":cellLocation,//位置
         @"Sound":sound,//声音
         @"Remind":remindTime,//提醒
         @"dateTime":self.dateTime,  //2015-07-01
         @"hourTime":self.hourTime,  //am 9：00
         };
         */
        NSString *sNameBc = [self.dataCurrent objectForKey:@"Title"];
        self.titleTextField.text = sNameBc;  //标题
        self.titleTextField.userInteractionEnabled = NO;
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:1];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:2 inSection:1];
        NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:0 inSection:2];
        
        RemindCell *cell1 = (RemindCell *)[self.tableView cellForRowAtIndexPath:indexPath1]; //时间
        RemindCell *cell2 = (RemindCell *)[self.tableView cellForRowAtIndexPath:indexPath2]; //地点
        RemindCell *cell3 = (RemindCell *)[self.tableView cellForRowAtIndexPath:indexPath3]; //声音
        RemindCell *cell4 = (RemindCell *)[self.tableView cellForRowAtIndexPath:indexPath4];//提醒
        cell1.userInteractionEnabled = NO;
        cell2.userInteractionEnabled = NO;
        cell3.userInteractionEnabled = NO;
        cell4.userInteractionEnabled = NO;
        //时间
        NSString *begString = [self.dataCurrent objectForKey:@"Time"];
        CHECK_DATA_IS_NSNULL(begString, NSString);
        CHECK_STRING_IS_NULL(begString);
        cell1.detailLabel.text = begString;
        
        //地点
        NSString *placeString = [self.dataCurrent objectForKey:@"Location"];
        CHECK_DATA_IS_NSNULL(placeString, NSString);
        CHECK_STRING_IS_NULL(placeString);
        cell2.detailLabel.text = placeString;
        
        //声音
        NSString *tipVoice = [self.dataCurrent objectForKey:@"Sound"];
        CHECK_DATA_IS_NSNULL(tipVoice, NSString);
        CHECK_STRING_IS_NULL(tipVoice);
        if ([tipVoice isEqualToString:@""]) {
            cell3.detailLabel.text = @"无";
        } else {
            cell3.detailLabel.text = tipVoice;
        }
        
        //提醒
        NSString *tipTime = [self.dataCurrent objectForKey:@"Remind"];
        CHECK_DATA_IS_NSNULL(tipTime, NSString);
        CHECK_STRING_IS_NULL(tipTime);
        if ([tipTime isEqualToString:@""]) {
            cell4.detailLabel.text = @"无";
        } else {
            cell4.detailLabel.text = tipTime;
        }
        
        //备注
        NSString *noteStr = [self.dataCurrent objectForKey:@"note"];
        self.remarkTextView.text = noteStr;  //标题
        self.remarkTextView.userInteractionEnabled = NO;
    }
}


- (void)_initKeyBoard
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    org_y = -1;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}




#pragma mark - delegate

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 3;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *identify = @"UITableViewCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.titleTextField];
        }
        return cell;
    }else if (indexPath.section == 1)
    {
        static NSString *identify = @"RemindCell1";
        _cell1 = (RemindCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!_cell1) {
            _cell1 = [[RemindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            _cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        _cell1.imgView.image = [UIImage imageNamed:_imgArr[indexPath.row]];
        _cell1.titLabel.text = _titleArr[indexPath.row];
        _cell1.detailLabel.text = _scoreArr[indexPath.row];
        
        if (self.isCheck) {
            _cell1.accessoryImgView.hidden = YES;
        } else {
            _cell1.accessoryImgView.hidden = NO;
        }
        return _cell1;
    }else if (indexPath.section == 2)
    {
        static NSString *identify = @"RemindCell2";
        _cell2 = (RemindCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!_cell2) {
            _cell2 = [[RemindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            _cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            _cell2.imgView.image = [UIImage imageNamed:_img2Arr[indexPath.row]];
            _cell2.titLabel.text = _title2Arr[indexPath.row];
            _cell2.detailLabel.text = _score2Arr[indexPath.row];
            
            if (self.isCheck) {
                _cell2.accessoryImgView.hidden = YES;
            } else {
                _cell2.accessoryImgView.hidden = NO;
            }
        }
        
        return _cell2;
        
    }else if (indexPath.section == 3)
    {
        static NSString *identify = @"UITableViewCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.remarkLabel];
            [cell.contentView addSubview:self.remarkTextView];
        }
        return cell;
    }
    return nil;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return kRemarkTextHeight+30;
    }
    return kRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //记录当前的section
    self.indexPath = indexPath;
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                [self.view addSubview:self.datePickView];
                //                self.datePickView.minDate = [NSDate date];
                [self.datePickView showPickerView];
            }
                break;
            case 1:
            {
                //如果没隐藏的话，需要隐藏
                [self.datePickView hidePickerView];
                
                TextInputViewController *textInput = [[TextInputViewController alloc] init];
                [self.navigationController pushViewController:textInput animated:YES];
                [textInput addSureBlock:^(TextInputViewController *viewController, NSString *inputText) {
                    //返回值
                    CHECK_STRING_IS_NULL(inputText);
                    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:1];
                    RemindCell *cell = (RemindCell *)[self.tableView cellForRowAtIndexPath:index];
                    cell.detailLabel.text = inputText;
                    
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_scoreArr];
                    [tempArray replaceObjectAtIndex:1 withObject:inputText];
                    _scoreArr = [NSArray arrayWithArray:tempArray];
                    
                }];
            }
                break;
            case 2:
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                        delegate:self
                                                               cancelButtonTitle:@"取消"
                                                          destructiveButtonTitle:nil
                                                               otherButtonTitles:k_Sound0,k_Sound1,nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                [actionSheet showInView:self.view];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:k_Tip0,k_Tip1,k_Tip2,k_Tip3,k_Tip4,nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
    }
}

#pragma mark -  CBDatePickerDelegate
- (void)returnDate:(NSDate *)selectDate
{
    NSString *timeString =  [NSDate dateToString:selectDate Formatter:@"yyyy-MM-dd HH:mm"];
    NSString *dateTimeString = [NSDate dateToString:selectDate Formatter:@"yyyy-MM-dd"];
    NSString *hourTimeString = [NSDate dateToString:selectDate Formatter:@"HH:mm"];
    NSString *hourString = [NSDate dateToString:selectDate Formatter:@"HH"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    self.Time = timeString;
    self.dateTime = dateTimeString;
    
    if ([hourString compare:@"12" options:NSNumericSearch] == NSOrderedAscending) {
        //大于12点
        self.hourTime = [NSString stringWithFormat:@"%@",hourTimeString];
    } else if ([hourString compare:@"12" options:NSNumericSearch] == NSOrderedDescending) {
        self.hourTime = [NSString stringWithFormat:@"%@",hourTimeString];
    } else {
        self.hourTime = [NSString stringWithFormat:@"%@",hourTimeString];
    }
    self.timeDate = selectDate;
    
    RemindCell *cell = (RemindCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailLabel.text = timeString;
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_scoreArr];
    [tempArray replaceObjectAtIndex:0 withObject:timeString];
    _scoreArr = [NSArray arrayWithArray:tempArray];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.indexPath.section == 1) {
        if(self.indexPath.row == 2) {
            //声音
            self.soundTag = buttonIndex;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
            RemindCell *cell = (RemindCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            switch (buttonIndex) {
                case 0:
                {
                    cell.detailLabel.text = k_Sound0;
                }
                    break;
                case 1:
                {
                    cell.detailLabel.text = k_Sound1;
                }
                default:
                    break;
            }
        }
    }else if (self.indexPath.section == 2)
    {
        //提醒  @"无",@"提前10分钟",@"提前30分钟",@"提前1小时",@"提前1天"
        self.tipTag = buttonIndex;
        switch (buttonIndex) {
            case 0:
            {
                _cell2.detailLabel.text = k_Tip0;
            }
                break;
                
            case 1:
            {
                _cell2.detailLabel.text = k_Tip1;
            }
                break;
            case 2:
            {
                _cell2.detailLabel.text = k_Tip2;
            }
                break;
            case 3:
            {
                _cell2.detailLabel.text = k_Tip3;
            }
                break;
                
            case 4:
            {
                _cell2.detailLabel.text = k_Tip4;
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.titleTextField)
    {
        NDLog(@"%lu",(unsigned long)self.titleTextField.text.length);
        if (self.titleTextField.text.length > 25) {
            [self showHint:@"请不要超过25个字符"];
            return;
        }
        [self.titleTextField endEditing:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res = 25 -[new length];
    if(res >= 0)
    {
        return YES;
    }else
    {
        NSInteger len = [string length] + res;
        if(len < 0)
        {
            NSRange rg = {0,25};
            [textField setText:[textField.text substringWithRange:rg]];
            return NO;
        }
        
        NSRange rg = {0,[string length]+res};
        if (rg.length>0)
        {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        [self showHint:@"请不要超过25个字符"];
        return NO;
    }
    return YES;
}

#pragma mark - <UITextViewDelegate>
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = 100 -[new length];
    if(res >= 0)
    {
        return YES;
    }else
    {
        NSInteger len = [text length] + res;
        if(len < 0)
        {
            NSRange rg = {0,100};
            [textView setText:[textView.text substringWithRange:rg]];
            return NO;
        }
        
        NSRange rg = {0,[text length]+res};
        if (rg.length>0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        [self showHint:@"请不要超过100个字符"];
        
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.remarkTextView)
    {
        NDLog(@"%lu",(unsigned long)self.remarkTextView.text.length);
        if (self.remarkTextView.text.length > 100) {
            [self showHint:@"请不要超过100个字符"];
            return;
        }
        [self.remarkTextView endEditing:NO];
    }
}

#pragma mark - event response
#pragma mark -keyboard Action
- (void) keyboardWillShow:(NSNotification *)sender
{
    NSValue *keyboardBoundsValue = [[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
    CGFloat yChange = 0.0f;
    if ([self.remarkTextView isFirstResponder])
    {
        yChange = keyboardBounds.origin.y+100;
    }
    if( [self.remarkTextView isFirstResponder])
    {
        if(org_y<0){
            org_y = self.view.frame.origin.y;
        }
        NSInteger offset = kScreenHeight - yChange;
        CGRect listFrame  = CGRectMake(0, -offset, kScreenWidth,kScreenHeight-kNavHeight);
        [UIView beginAnimations:@"anim" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        //处理移动标题，将各视图设置最终要达到的状态
        self.tableView.frame=listFrame;
        
        [UIView commitAnimations];
    }
}
//[self.userCellPhone isFirstResponder] ||
- (void) keyboardWillHide:(id)sender
{
    if([self.remarkTextView isFirstResponder])
    {
        if(org_y >= 0)
        {
            CGRect rect = self.tableView.frame;
            rect.origin.y = org_y+kNavHeight;
            self.tableView.frame = rect;
        }
    }
}
#pragma mark- event response
- (void)deletButtonAction:(UIButton *)button
{
    //1.删除数据
    NSMutableArray *allArray = [[ConfigData sharedInstance]getUserConfigInfowithKey:k_addRemind];
    NSDictionary *dic = [allArray objectAtIndex:self.index];
    NSString *keyStr = [dic objectForKey:@"Title"];
    [allArray removeObjectAtIndex:self.index];

    //2.保存信息
    [[ConfigData sharedInstance]saveUserConfigInfo:allArray withKey:k_addRemind];

//    //3.刷新
//    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshRemindList)]) {
//        [self.delegate refreshRemindList];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Remind_addSuccess object:nil];

    [self.navigationController popViewControllerAnimated:YES];

    //4.删除通知
    [self cancelLocalNotification:keyStr];
}

- (void)finishButtonAction:(UIButton *)button
{
    //取数据
    //1.标题
    NSString *titleStr = self.titleTextField.text == nil ? @"" : self.titleTextField.text;
    if ([titleStr isEqualToString:@""]) {
        [self showHint:@"请输入标题"];
        return;
    }
    if (titleStr.length > 25) {
        [self showHint:@"请不要超过25个字符"];
        return;
    }
    
    //2.开始、地点、声音
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:2 inSection:1];
    
    RemindCell *cell1 = (RemindCell *)[self.tableView cellForRowAtIndexPath:indexPath1];
    RemindCell *cell2 = (RemindCell *)[self.tableView cellForRowAtIndexPath:indexPath2];
    RemindCell *cell3 = (RemindCell *)[self.tableView cellForRowAtIndexPath:indexPath3];
    
    NSString *cellTime = cell1.detailLabel.text == nil ?@"":cell1.detailLabel.text;

    if ([cellTime isEqualToString:@"无"]) {
        [self showHint:@"请设置时间"];
        return;
    }
    
    NSString *cellLocation = cell2.detailLabel.text == nil ?@"":cell2.detailLabel.text;
    
    NSString *sound  = cell3.detailLabel.text == nil ?@"":cell3.detailLabel.text;
    NSString *soundType = @"";
    if ([sound isEqualToString:k_Sound1]) //有
    {
        soundType  = UILocalNotificationDefaultSoundName;
    }
    
    //3.提醒
    NSIndexPath *indexPath5 = [NSIndexPath indexPathForRow:0 inSection:2];
    RemindCell *cell5 = (RemindCell *)[self.tableView cellForRowAtIndexPath:indexPath5];
    CHECK_STRING_IS_NULL(cell5.detailLabel.text);
    NSString *remindTime = cell5.detailLabel.text;
    //开始时间提前时间
    NSDate *begainDate;
    if ([remindTime isEqualToString:k_Tip1]) {  //提前十分钟
        begainDate = [self.timeDate dateByAddingTimeInterval:-10*60];
    }else if ([remindTime isEqualToString:k_Tip2]) //提前三十分钟
    {
        begainDate = [self.timeDate dateByAddingTimeInterval:-30*60];
    }else if ([remindTime isEqualToString:k_Tip3]) //提前一个小时
    {
        begainDate = [self.timeDate dateByAddingTimeInterval:-60*60];
        
    }else if ([remindTime isEqualToString:k_Tip4]) //提前一天
    {
        begainDate = [self.timeDate dateByAddingTimeInterval:-24*60*60];
        
    }else  //准时
    {
        begainDate = self.timeDate;
    }
    
    //4.备注
    CHECK_DATA_IS_NSNULL(self.remarkTextView.text, NSString);
    CHECK_STRING_IS_NULL(self.remarkTextView.text);
    
    NSString *remarkText = self.remarkTextView.text == nil ? @"" : self.remarkTextView.text;
    
    if (remarkText.length > 100) {
        [self showHint:@"请不要超过100个字符"];
        return;
    }
    
    //存储字典
    NSDictionary *currentDic = @{
                                 @"ImgString":@"remind_hongdian.png",
                                 @"Title":titleStr, //标题
                                 @"LocalImgName":@"personal_planList_dizhi.png",
                                 @"Time":cellTime,//时间
                                 @"Location":cellLocation,//位置
                                 @"Sound":sound,//声音
                                 @"Remind":remindTime,//提醒
                                 @"dateTime":self.dateTime,  //2015-07-01
                                 @"hourTime":self.hourTime,  //am 9：00
                                 @"note":remarkText,//备注
                                 };
    NDLog(@"%@",currentDic);

    NSMutableArray *allArray = [[ConfigData sharedInstance]getUserConfigInfowithKey:k_addRemind];

//    if (_muArray.count == 0) {
        _muArray = [[NSMutableArray alloc] initWithArray:allArray];
//    }
    [_muArray insertObject:currentDic atIndex:0];
    //保存信息
    [[ConfigData sharedInstance]saveUserConfigInfo:_muArray withKey:k_addRemind];
    
    //开启通知
    [self addLocalNotificationWithTitle:titleStr
                                  sound:soundType
                               fireDate:begainDate];
    //刷新
//    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshRemindList)]) {
//        [self.delegate refreshRemindList];
//        [self showHint:@"添加成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:Remind_addSuccess object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


//本地推送
- (void)addLocalNotificationWithTitle:(NSString *)title
                                sound:(NSString *)soundPath
                             fireDate:(NSDate *)fireDate
{
    //创建一个本地推送
    _localNoti = [[UILocalNotification alloc] init];
    //设置推送时间
    _localNoti.fireDate = [fireDate dateByAddingTimeInterval:0];
    NDLog(@"设置的提醒时间 %@", _localNoti.fireDate);
    _localNoti.applicationIconBadgeNumber = 1;
    //设置时区
    _localNoti.timeZone = [NSTimeZone defaultTimeZone];
    //推送声音
    _localNoti.soundName = soundPath;
    //内容
    _localNoti.alertBody = title;
    //设置userinfo 方便在之后需要撤销的时候使用
    NSString *keyString = [NSString stringWithFormat:@"%@",title];
    NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:keyString];
    _localNoti.userInfo = infoDic;
    //添加推送到uiapplication
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:_localNoti];
}

//取消本地通知
- (void)cancelLocalNotification:(NSString *)key
{
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    UILocalNotification *localNoti;
    if (localArr) {
        for (UILocalNotification *noti in localArr) {
            NSDictionary *dict = noti.userInfo;
            if (dict){
                NSArray *allKeys =  [dict allKeys];
                if ([allKeys containsObject:key]) {
                    if (localNoti){
                        localNoti = nil;
                    }
                    localNoti = noti;
                    break;
                }
            }
        }
    }
    
    //判断是否找到已经存在的相同key的推送
    if (!localNoti) {
        //不存在 初始化
        localNoti = [[UILocalNotification alloc] init];
    }
    if (localNoti) {
        //不推送 取消推送
        [app cancelLocalNotification:localNoti];
        return;
    }
}

#pragma mark - private metaods
#pragma mark - getters and setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
    }
    return _tableView;
}

- (UITextField *)titleTextField
{
    if (!_titleTextField) {
        _titleTextField = [CommentMethod createTextFieldWithPlaceholder:@"标题" passWord:NO Font:k_Font_4];
        _titleTextField.delegate = self;
        _titleTextField.frame = CGRectMake(20, 0, kScreenWidth-40, kRowHeight);
        _titleTextField.tintColor = [UIColor darkGrayColor];
        _titleTextField.textColor = [UIColor darkGrayColor];
        _titleTextField.returnKeyType = UIReturnKeyDone;
    }
    return _titleTextField;
}

- (UITextView *)remarkTextView
{
    if (!_remarkTextView) {
        _remarkTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 30, kScreenWidth-40, kRemarkTextHeight)];
        _remarkTextView.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _remarkTextView.delegate = self;
    }
    return _remarkTextView;
}

- (UILabel *)remarkLabel
{
    if (!_remarkLabel) {
        _remarkLabel = [CommentMethod createLabelWithFont:18.0f Text:@"备注"];
        _remarkLabel.frame = CGRectMake(20, 0, 100, 30);
        _remarkLabel.textColor = [UIColor lightGrayColor];
    }
    return _remarkLabel;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (CBDatePickerView *)datePickView
{
    if (!_datePickView) {
        _datePickView = [[CBDatePickerView alloc] initWithFrame:CGRectZero];
        _datePickView.delegate = self;
        _datePickView.selectedDate = [NSDate date];
        _datePickView.datePickView.datePickerMode = UIDatePickerModeDateAndTime;
        /**
         //隐藏日期控件
         if (_datePickView != nil &&  _datePickView.isVisible) {
         [_datePickView hidePickerView];
         }
         if (!_datePickView.isVisible) {
         [_datePickView showPickerView];
         }
         */
    }
    return _datePickView;
}

- (UIButton *)finishButton
{
    if (!_finishButton) {
        if (!self.isCheck) {
            _finishButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(finishButtonAction:) Title:@"完成"];
        } else {
            _finishButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(deletButtonAction:) Title:@"删除"];
        }
        [_finishButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return _finishButton;
}


@end
