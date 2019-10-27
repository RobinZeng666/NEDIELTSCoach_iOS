//
//  VoteViewController.m
//  IELTSTeacher
//
//  Created by Newton on 15/9/6.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "VoteViewController.h"
#import "VoteTableViewCell.h"
#import "VoteHistoryViewController.h"
#import "VoteStartViewController.h"

#define  kTableViewRow  (45*AUTO_SIZE_SCALE_Y)
@interface VoteViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,VoteTableViewCellDelegate>
{
    NSInteger _selctCount;
    CGFloat org_y;
}
/**
   历史按钮
 */
@property (nonatomic, strong) UIButton      *historyButton;

/*
 背景滑动视图
 */
@property (nonatomic, strong) UIScrollView  *bgScrollView;
@property (nonatomic, strong) UIView        *bgView;

/*
  顶部视图
 */
@property (nonatomic, strong) UIView        *bgTextView;   //输入框背景视图
@property (nonatomic, strong) UITextView    *textView;     //输入框
@property (nonatomic, strong) UILabel       *tipLabel;     //提示文字

/*
  选项卡视图
 */
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) UIButton      *addButton;
@property (nonatomic, assign) NSInteger     tabelIndexRow;


/**
 *  开始投票
 */
@property (nonatomic, strong) UIButton      *startButton;   //开始按钮


@end

@implementation VoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"投票";
    //选项个数默认为0
    _selctCount = 2;

    //初始化视图
    [self _initView];
    
    [self _initKeyBoard];
    
    //初始化数据
//    [self _initData];
}

#pragma mark - Private
- (void)_initKeyBoard
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    org_y = -1;
    
}

#pragma mark -keyboard Action
- (void) keyboardWillShow:(NSNotification *)sender
{
    NSValue *keyboardBoundsValue = [[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
    CGFloat yChange = 0.0f;

    NSIndexPath *path = [NSIndexPath indexPathForRow:self.tabelIndexRow inSection:0];
    VoteTableViewCell *cell = (VoteTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
    if ([cell.textField isFirstResponder])
    {
        yChange = keyboardBounds.origin.y+100;
    }
    if( [cell.textField isFirstResponder])
    {
        if(org_y<0){
            org_y = self.view.frame.origin.y;
        }
        NSInteger offset = kScreenHeight - yChange;
        CGRect listFrame  = CGRectMake(0, -offset, kScreenWidth,kScreenHeight);
        [UIView beginAnimations:@"anim" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        //处理移动事件，将各视图设置最终要达到的状态
        self.bgScrollView.frame=listFrame;
        
        [UIView commitAnimations];
    }
}
//[self.userCellPhone isFirstResponder] ||
- (void) keyboardWillHide:(id)sender
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.tabelIndexRow inSection:0];
    VoteTableViewCell *cell = (VoteTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
    
    if([cell.textField isFirstResponder])
    {
        if(org_y >= 0)
        {
            CGRect rect = self.bgScrollView.frame;
            rect.origin.y = org_y;
            self.bgScrollView.frame = rect;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - life cycle
- (void)_initView
{
    [self.bgView addSubview:self.bgScrollView];
    
    [self.navView addSubview:self.historyButton];
    
    [self.bgScrollView addSubview:self.bgTextView];
    [self.bgTextView addSubview:self.textView];
    [self.textView addSubview:self.tipLabel];
    
    [self.bgScrollView addSubview:self.tableView];
    [self.bgScrollView addSubview:self.addButton];
    [self.bgScrollView addSubview:self.startButton];
    
    
    [self.bgView insertSubview:self.navView belowSubview:self.view];
    [self.view addSubview:self.bgView];
//    [self.view addSubview:self.bgScrollView];
    WS(this_vote);
    
    CGFloat bgWidth = kScreenWidth - 20*AUTO_SIZE_SCALE_X;
    CGFloat bgHeight = 214*AUTO_SIZE_SCALE_Y;
    [self.bgTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight-10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(bgWidth, bgHeight));
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(bgWidth-20*AUTO_SIZE_SCALE_X, bgHeight));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(10*AUTO_SIZE_SCALE_X);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_vote.bgTextView.mas_bottom).with.offset(13*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kTableViewRow*2));
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_vote.tableView.mas_bottom);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kTableViewRow));

    }];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(this_vote.view.mas_bottom).with.offset(-38*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_vote.view);
        make.size.mas_equalTo(CGSizeMake(338*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_Y));
    }];
    
    //收起键盘
    [self setupForDismissKeyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];
}

#pragma mark - delegate
#pragma mark -<UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.tipLabel.text = @"请输入投票内容";
        self.tipLabel.hidden = NO;
    }else{
        self.tipLabel.text = @"";
        self.tipLabel.hidden = YES;
        //控制200个字
    }
    
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
        [self showHint:@"投票内容不可超过200个字符"];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = 200 -[new length];
    if(res >= 0)
    {
        return YES;
    }else
    {
        NSInteger len = [text length] + res;
        if(len < 0)
        {
            NSRange rg = {0,200};
            [textView setText:[textView.text substringWithRange:rg]];
            return NO;
        }
        
        NSRange rg = {0,[text length]+res};
        if (rg.length>0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        [self showHint:@"投票内容不可超过200个字符"];
        //隐藏提示语
        self.tipLabel.text = @"";
        self.tipLabel.hidden = YES;
        
        return NO;
    }
    return YES;
}


#pragma mark - <VoteTableViewCellDelegate>
- (void)changeCurrentCellRowHeght:(CGFloat)rowHeight  indexRow:(NSInteger)indexRow
{
    CGFloat heigh = kTableViewRow*(_selctCount-1) + rowHeight;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgTextView.mas_bottom).with.offset(13*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, heigh));
    }];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexRow inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)curentTextField:(NSInteger)indexRow
{
    //重新赋值
    self.tabelIndexRow = indexRow;
}

#pragma mark -<UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selctCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"VoteViewControllerCell";
    VoteTableViewCell *cell = (VoteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[VoteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.textField.tag = indexPath.row;
    return cell;
}


#pragma mark - event response
/**
 *  历史
 */
- (void)historyAction:(UIButton *)button
{
    VoteHistoryViewController *history = [[VoteHistoryViewController alloc]init];
    history.activeClassId = self.activeClassId;
    [self.navigationController pushViewController:history animated:YES];
}

/**
 *  开始投票
 */
- (void)startAction:(UIButton *)button
{
    NSString *textViewText = (self.textView.text == nil) ?@"":self.textView.text;
    if ([textViewText isEqualToString:@""]) {
        [self showHint:@"请输入投票内容"];
        return;
    }
    
    if (textViewText.length > 200) {
        [self showHint:@"投票内容不可超过200个字符"];
        return;
    }
    //判断输入内容为空格的情况
    if (textViewText.length > 0) {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [textViewText stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            [self showHint:@"请输入投票内容"];
            return;
        }
    }
    
    NSInteger voteNumber = 1; //投票序号
    
    NSMutableString *voteOptString = [[NSMutableString alloc]init];
    for (int i = 0; i<_selctCount; i++) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        VoteTableViewCell *cell = (VoteTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        //取出每一项答案
        NSString *textFiledText = (cell.textField.text == nil) ? @"":cell.textField.text;
        if (![textFiledText isEqualToString:@""]) {
            //给答案添加序号
            NSString *voteOpt = [NSString stringWithFormat:@"%ld:%@",(long)voteNumber,textFiledText];
            voteNumber++;
            //拼接答案
            [voteOptString appendString:voteOpt];
            
        }else {
            continue;
        }
        //如果不是最后一个答案，尾部添加“;”符号
        if (i<_selctCount-1) {
            [voteOptString appendString:@";"];
        }
    }
    
    NSString *voteSting = @"";
    if (voteOptString.length > 0) {
        //取出拼接的答案的最后一位，如果是@“;”去掉。
        NSString *string =[voteOptString substringFromIndex:voteOptString.length-1];
        if ([string isEqualToString:@";"]) {
            voteSting = [voteOptString substringToIndex:voteOptString.length-1];
        }else
        {
            voteSting = voteOptString;
        }
    }
    
    if ([voteSting isEqualToString:@""]) {
        [self showHint:@"请输入选项内容"];
        return;
    }
    //
    NSArray *voteOpts = [voteSting componentsSeparatedByString:@";"];
    if (voteOpts.count >= 2) {
        
        //1.开始投票
        /*
          activeClassId=[互动课堂ID，不可为空]
          voteDesc=[投票描述，不可为空]
          voteOpt=[投票选项，规则为选项号+":"+选项内容，多个以";"分割，举例:"1:aa;2:bbb"，不可为空]
         */
        CHECK_DATA_IS_NSNULL(self.activeClassId, NSString);
        CHECK_STRING_IS_NULL(self.activeClassId);
        
        CHECK_DATA_IS_NSNULL(textViewText, NSString);
        CHECK_STRING_IS_NULL(textViewText);
        
        CHECK_DATA_IS_NSNULL(voteSting, NSString);
        CHECK_STRING_IS_NULL(voteSting);
        
        NSDictionary *dataDic = @{@"activeClassId":self.activeClassId,
                                  @"voteDesc":textViewText,
                                  @"voteOpt":voteSting
                                  };
        button.enabled = NO;
        [self showHudInView:self.view hint:@"正在发起投票..."];
        [[Service sharedInstance]startVoteWithPram:dataDic
                                          succcess:^(NSDictionary *result) {
                                              button.enabled = YES;
                                              [self hideHud];
                                              if (k_IsSuccess(result)) {
                                                  NSDictionary *Data = [result objectForKey:@"Data"];
                                                  if (Data.count > 0) {
                                                      NSString *voteId = [Data objectForKey:@"voteId"];
                                                      CHECK_DATA_IS_NSNULL(voteId, NSString);
                                                      CHECK_STRING_IS_NULL(voteId);
                                                      VoteStartViewController *start = [[VoteStartViewController alloc]init];
                                                      start.activeClassId = self.activeClassId;
                                                      start.voteId = voteId;
                                                      start.voteDesc = textViewText;
                                                      [self.navigationController pushViewController:start animated:YES];
                                                  }
                                              } else {
                                                  if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                      
                                                      [self showHint:[result objectForKey:@"Infomation"]];                                                  }
                                              }
                                          } failure:^(NSError *error) {
                                              [self hideHud];
                                              button.enabled = YES;
                                              [self showHint:[error networkErrorInfo]];
                                          }];
    }else
    {
        [self showHint:@"至少需要填写两个选项才能发起投票"];
        return;
    }
    
}

/**
 * 增加按钮
 */
- (void)addButtonAction:(UIButton *)button
{
    if (_selctCount > 5) {
        return;
    }
    _selctCount++;
    [self.tableView reloadData];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgTextView.mas_bottom).with.offset(13*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kTableViewRow*_selctCount));
    }];
    
    if (_selctCount == 5) {
        self.addButton.hidden = YES;
    }
}

#pragma mark - private methods
#pragma mark - getters and setters
- (UIButton *)historyButton
{
    if (!_historyButton) {
        _historyButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(historyAction:) Title:@"历史"];
        [_historyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _historyButton.frame = CGRectMake(kScreenWidth-80*AUTO_SIZE_SCALE_X, 20, 80*AUTO_SIZE_SCALE_X, 44);
    }
    return _historyButton;
}

- (UIButton *)startButton
{
    if (!_startButton) {  //338 × 45
        _startButton  = [CommentMethod createButtonWithImageName:@"interation_anniu.png" Target:self Action:@selector(startAction:) Title:@"开始投票"];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji.png"] forState:UIControlStateHighlighted];
    }
    return _startButton;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(addButtonAction:) Title:@"增加一个选项"];
        [_addButton setTitleColor:k_PinkColor forState:UIControlStateNormal];
        _addButton.backgroundColor =  [UIColor whiteColor];
    }
    return  _addButton;
}

/**
 * 头部视图
 */
- (UIView *)bgTextView
{
    if (!_bgTextView) {
        _bgTextView = [[UIView alloc]init];
        _bgTextView.backgroundColor = [UIColor whiteColor];
    }
    return _bgTextView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
    }
    return _textView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [CommentMethod createLabelWithFont:18.0f Text:@"请输入投票内容"];
        _tipLabel.enabled = NO;//lable必须设置为不可用
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textColor = [UIColor lightGrayColor];
    }
    return _tipLabel;
}

/**
 *  列表
 */
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = kTableViewRow;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgScrollView.backgroundColor = [UIColor clearColor];
    }
    return _bgScrollView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}


@end
