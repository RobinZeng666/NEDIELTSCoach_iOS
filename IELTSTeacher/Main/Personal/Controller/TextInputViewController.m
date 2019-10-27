//
//  TextInputViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "TextInputViewController.h"

@interface TextInputViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UIButton   *ensureButton;
@property (nonatomic,strong) UITextView *textView;

@end

@implementation TextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = self.titleString;
    
    [self.view addSubview:self.ensureButton];
    [self.view addSubview:self.textView];
    
    //确定Button
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(44);
    }];
    
    /**
     *  收起键盘
     */
        [self setupForDismissKeyboard];
}

#pragma mark - life cycle
#pragma mark - delegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.textView)
    {
        NSLog(@"%lu",(unsigned long)self.textView.text.length);
        if (self.textView.text.length > 25) {
            [self showHint:@"请不要超过25个字符"];
            return;
        }
        [self.textView endEditing:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = 25 -[new length];
    if(res >= 0)
    {
        return YES;
    }else
    {
        NSInteger len = [text length] + res;
        if(len < 0)
        {
            NSRange rg = {0,25};
            [textView setText:[textView.text substringWithRange:rg]];
            return NO;
        }
        
        NSRange rg = {0,[text length]+res};
        if (rg.length>0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        [self showHint:@"请不要超过25个字符"];
        return NO;
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

#pragma mark - event response
- (void)ensureButtonAction:(UIButton *)button
{
    NDLog(@"确定Button响应");
    //把值返回
    
//    if ([self.textView.text isEqualToString:@""]) {
//        //空
//        [self showHint:@"地址不为空"];
//    } else {
//        if (self.block) {
//            self.block(self, self.textView.text);
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    if ([self.textView.text isEqualToString:@""]) {
        [self showHint:@"地址不为空"];
        return;
    }
    
    if (self.textView.text.length > 25) {
        [self showHint:@"请不要超过25个字符"];
        return;
    }
    
    if (self.block) {
        self.block(self, self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSureBlock:(SureBlock)block
{
    self.block = block;
}

#pragma mark - private methods
#pragma mark - getters and setters
- (UIButton *)ensureButton
{
    if (!_ensureButton) {
        _ensureButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(ensureButtonAction:) Title:@"确定"];
        [_ensureButton setTitleColor:[CommentMethod colorFromHexRGB:@"818b8f"] forState:UIControlStateNormal];
    }
    return _ensureButton;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth-20, 200)];
        _textView.delegate = self;
        _textView.editable = YES;
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _textView.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        [_textView becomeFirstResponder];
    }
    return _textView;
}

@end
