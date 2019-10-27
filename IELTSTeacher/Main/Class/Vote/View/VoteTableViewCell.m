//
//  VoteTableViewCell.m
//  IELTSTeacher
//
//  Created by Newton on 15/9/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "VoteTableViewCell.h"

#define  kTableViewRow  (45*AUTO_SIZE_SCALE_Y)
@interface VoteTableViewCell()<UITextFieldDelegate>

//@property (nonatomic, strong) UILabel     *showTextLabel;
@property (nonatomic, strong) UILabel       *tipLabel;     //提示文字

@end
@implementation VoteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    /**
     *  创建输入框
     */
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.contentView addSubview:self.textField];
    [self.textField addSubview:self.tipLabel];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-40*AUTO_SIZE_SCALE_X, kTableViewRow));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-40*AUTO_SIZE_SCALE_X, kTableViewRow));
    }];
    
//    [self.showTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20*AUTO_SIZE_SCALE_X);
//        make.centerY.mas_equalTo(self);
//        make.width.mas_equalTo(kScreenWidth-40*AUTO_SIZE_SCALE_X);
//    }];
    //收键盘
    [self.viewController setupForDismissKeyboard];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self.textField placeholderRectForBounds:CGRectMake((kScreenWidth-200*AUTO_SIZE_SCALE_X)/2, 0, 200*AUTO_SIZE_SCALE_X, kTableViewRow)];
    //设置textFiled的默认输入文字
    
    if (self.textField.text.length == 0) {
        [self _textFiledPlaceholder];
    }
}

- (void)_textFiledPlaceholder
{
    switch (self.textField.tag) {
        case 0:
        {
            self.tipLabel.text = @"选项一";
        }
            break;
        case 1:
        {
            self.tipLabel.text = @"选项二";
        }
            break;
        case 2:
        {
            self.tipLabel.text = @"选项三";
        }
            break;
        case 3:
        {
            self.tipLabel.text = @"选项四";
        }
            break;
        case 4:
        {
            self.tipLabel.text = @"选项五";
        }
            break;
        default:
            break;
    }

}


#pragma mark - <UITextFieldDelegate>
- (void)textFieldTextDidChange
{
    if (self.textField.text.length == 0) {
        self.tipLabel.hidden = NO;
        [self _textFiledPlaceholder];
    }else{
        self.tipLabel.text = @"";
        self.tipLabel.hidden = YES;
        //控制200个字
    }
    
    if (self.textField.text.length > 50) {
        self.textField.text = [self.textField.text substringToIndex:50];
        [self.viewController showHint:@"选项不可超过50个字符"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textField.text.length > 20) {
        return NO;
    }
    [self endEditing:YES];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.textField) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(curentTextField:)]) {
            [self.delegate curentTextField:textField.tag];
        }
    }
}
/**
 *  结束编辑
    1.检查输入是否满足限制条件
    2.将输入内容赋值到cell上
 *
 *  @param textField
 */
//- (void)textFieldDidChange:(UITextField *)textField
//{
//    if (textField == self.textField)
//    {        
//        NSLog(@"%lu",(unsigned long)self.textField.text.length);
//        if (self.textField.text.length > 50) {
//            textField.text = [textField.text substringToIndex:50];
////            [self.viewController showHint:@"选项不可超过50个字符" yOffset:-280];
//            return;
//        }
//        [self.textField endEditing:NO];
//    }
//}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res = 50 -[new length];
    if(res >= 0)
    {
        return YES;
    }else
    {
        NSInteger len = [string length] + res;
        if(len < 0)
        {
            NSRange rg = {0,50};
            [textField setText:[textField.text substringWithRange:rg]];
            return NO;
        }
        
        NSRange rg = {0,[string length]+res};
        if (rg.length>0)
        {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        [self.viewController showHint:@"选项不可超过50个字符"];
        
        //隐藏提示语
        self.tipLabel.text = @"";
        self.tipLabel.hidden = YES;
        return NO;
    }
    return YES;
}



#pragma mark - event response
#pragma mark - set or get
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [CommentMethod createTextFieldWithPlaceholder:@"" passWord:NO Font:18.0f];
        _textField.delegate = self;
        //清除按钮
        _textField.clearButtonMode=NO;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.tintColor = [UIColor darkGrayColor];
    }
    return _textField;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
        _tipLabel.enabled = NO;//lable必须设置为不可用
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

@end
