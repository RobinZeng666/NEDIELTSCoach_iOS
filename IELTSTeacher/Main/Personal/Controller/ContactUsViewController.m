//
//  ContactUsViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UIButton    *sendButton;
@property (nonatomic,strong) UITextView  *textView;
@property (nonatomic,strong) UILabel     *tipLabel;

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.titles = @"联系我们";
    [self.view addSubview:self.sendButton];
    [self.view addSubview:self.textView];
    [self.textView addSubview:self.tipLabel];

    //发送Button
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(44);
    }];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+12*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(10*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(-10*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(640/3*AUTO_SIZE_SCALE_Y);
    }];

    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
    }];

    //设置键盘
    [self setupForDismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - event response
- (void)sendButtonAction:(UIButton *)button
{
    NDLog(@"发送Button响应");
    
    if (self.textView.text.length == 0) {
        [self showHint:@"请输入您的宝贵意见"];
        return;
    }
    
    if (self.textView.text.length > 100) {
        [self showHint:@"您输入的内容超过100个字符限制"];
        return;
    }
    
        NSDictionary *dic = @{@"contentText":self.textView.text};
        
        //发送请求
        [[Service sharedInstance]addSuggestionInfoWithPram:dic
                                                   success:^(NSDictionary *result) {
                                                       if (k_IsSuccess(result)) {
                                                           //成功
                                                           [self showHint:@"发送成功，谢谢您的宝贵意见"];
                                                           //返回到上级页面
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       } else {
                                                           if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                               [self showHint:[result objectForKey:@"Infomation"]];
                                                           }
                                                       }
                                                    
                                                } failure:^(NSError *error) {
                                                    //提示失败信息
                                                    [self showHint:[error networkErrorInfo]];
                                                }];
}

#pragma mark - delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.tipLabel.text = @"想说什么，尽管咆哮吧！";
        self.tipLabel.hidden = NO;
    }else{
        self.tipLabel.text = @"";
        self.tipLabel.hidden = YES;
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
        [self showHint:@"您输入的内容超过100个字符限制"];
        //隐藏提示语
        self.tipLabel.text = @"";
        self.tipLabel.hidden = YES;
        
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.textView)
    {
        NSLog(@"%lu",(unsigned long)self.textView.text.length);
        if (self.textView.text.length > 100) {
            [self showHint:@"您输入的内容超过100个字符限制"];
            return;
        }
        [self.textView endEditing:NO];
    }
}

#pragma mark - private methods
#pragma mark - getters and setters
- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(sendButtonAction:) Title:@"发送"];
        [_sendButton setTitleColor:[CommentMethod colorFromHexRGB:@"818b8f"] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
    }
    return _sendButton;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.layer.cornerRadius = 2;
        _textView.layer.masksToBounds = YES;
        _textView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
        _textView.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _textView.font = [UIFont systemFontOfSize:16.0f*AUTO_SIZE_SCALE_X];
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [CommentMethod createLabelWithFont:16.0f Text:@"想说什么，尽管咆哮吧！"];
        _tipLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _tipLabel.enabled = NO;
    }
    return _tipLabel;
}

@end
