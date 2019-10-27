//
//  LogonViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "LogonViewController.h"
@interface LogonViewController ()

@property (nonatomic,strong) UIImageView *backImgView;  //背景图
@property (nonatomic,strong) UIImageView *logoImgView;  //logo标识
@property (nonatomic,strong) UILabel     *logoLabel;    //Logo标题
@property (nonatomic,strong) UIImageView *versionView;  //底部版本标识
@property (nonatomic,strong) UIImageView *emailImgView; //账号背景图
@property (nonatomic,strong) UIImageView *pwdImgView;   //密码背景图
@property (nonatomic,strong) UIImageView *emailIconView;//账号图标
@property (nonatomic,strong) UIImageView *pwdIconView;  //密码图标

@property (nonatomic,strong) UITextField *emailTextField; //邮箱
@property (nonatomic,strong) UITextField *pwdTextField;   //密码
@property (nonatomic,strong) UIButton    *logonButton;    //登录

@end

@implementation LogonViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  初始化视图
     */
    [self _initView];
    /**
     *  初始化数据
     */
    [self _initData];
}

- (void)_initView
{

    WS(this_logon);
    
    [self.view addSubview:self.backImgView];
    [self.view addSubview:self.logoImgView];
    [self.view addSubview:self.logoLabel];
    [self.view addSubview:self.versionView];
    
    [self.view addSubview:self.emailImgView];
    [self.view addSubview:self.pwdImgView];
    
    [self.emailImgView addSubview:self.emailTextField];
    [self.emailImgView addSubview:self.emailIconView];
    [self.pwdImgView addSubview:self.pwdTextField];
    [self.pwdImgView addSubview:self.pwdIconView];
    [self.view addSubview:self.logonButton];
    
    //背景图
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(this_logon.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //登录标识  115*112
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {  //230 × 223
        make.top.mas_equalTo(70*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_logon.view);
        make.size.mas_equalTo(CGSizeMake(115.0*AUTO_SIZE_SCALE_X, 112.0*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_logon.logoImgView.mas_bottom).with.offset(24*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_logon.view);
    }];
    
    //登录背景图
    [self.emailImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_logon.logoLabel.mas_bottom).with.offset(35*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-2*26*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_Y));
        make.centerX.mas_equalTo(this_logon.view);
    }];
    
    //密码背景图
    [self.pwdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_logon.emailImgView.mas_bottom).with.offset(12*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-2*26*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_Y));
        make.centerX.mas_equalTo(this_logon.view);
    }];
    
    //登录头标
    [self.emailIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_logon.emailImgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_Y));
    }];
    
    //密码头标
    [self.pwdIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.centerY.mas_equalTo(this_logon.pwdImgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    
    //邮箱输入框
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_logon.emailIconView.mas_right).with.offset(24*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(this_logon.emailImgView.mas_right);
        make.height.mas_equalTo(this_logon.emailImgView.mas_height);
        make.top.mas_equalTo(0);
    }];
    
    //密码输入框
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_logon.pwdIconView.mas_right).with.offset(24*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(this_logon.pwdImgView.mas_right);
        make.height.mas_equalTo(this_logon.pwdImgView.mas_height);
         make.top.mas_equalTo(0);
    }];
    
    //登录
    [self.logonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_logon.pwdImgView.mas_bottom).with.offset(15*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-2*26*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_Y));
        make.centerX.mas_equalTo(this_logon.view);
    }];
    
    //底部图片
    [self.versionView mas_makeConstraints:^(MASConstraintMaker *make) {//268 × 43
        make.centerX.mas_equalTo(this_logon.view);
        make.bottom.mas_equalTo(-20*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(268*AUTO_SIZE_SCALE_X, 43*AUTO_SIZE_SCALE_Y));
    }];
    
    //设置键盘
    [self setupForDismissKeyboard];
}


- (void)_initData
{
    //账号密码
//    self.emailTextField.text = @"teachervps07@163.com";
//    self.pwdTextField.text = @"test07";
    
//    self.emailTextField.text = @"teachervps03@163.com";
//    self.pwdTextField.text = @"test03";
    
//    self.emailTextField.text = @"lanjian3@xdf.cn";
//    self.pwdTextField.text = @"lj@020416";
    
//    //先获取账号信息
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefault objectForKey:k_SAVEUserName];
    NSString *userPWD = [userDefault objectForKey:k_SAVEUserPWD];
    if (userName != nil  && userPWD != nil) {
        
        CHECK_DATA_IS_NSNULL(userName, NSString);
        CHECK_STRING_IS_NULL(userName);
        CHECK_DATA_IS_NSNULL(userPWD, NSString);
        CHECK_STRING_IS_NULL(userPWD);
        
        self.emailTextField.text = userName;
        self.pwdTextField.text = userName;

        [self logonUserName:userName pwd:userPWD];
    }else
    {
        self.emailTextField.text = userName;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navView.hidden = NO;
    
    [self hideHud];
}


#pragma mark - delegate
#pragma mark - event response
- (void)logonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    
    //防止重点
     button.enabled = NO;
    //判断是否为空？
    NSString *emailText =  self.emailTextField.text;
    if (!emailText || [emailText isEqualToString:@""]) {
        [self showHint:@"请输入邮箱"];
        button.enabled = YES;
        return;
    }
    //判断密码是否为空
    NSString *pwdText = self.pwdTextField.text;
    if (!pwdText || [pwdText isEqualToString:@""]) {
        [self showHint:@"请输入密码"];
        button.enabled = YES;
        return;
    }
    
    //判断是否为正确地邮箱
    if (![emailText isValidateEmail]) {
        if (![emailText isValidateMobile]) {
            [self showHint:@"请输入正确账号"];
            button.enabled = YES;
            return;
        }
    }
    //lanfang@xdf.cn  mel_552069
    [self showHudInView:self.view hint:@"正在登录..."];
    //对账户进行加密
    NSString *userPWD = [CommonFunc encode:pwdText];
    //网络请求
    [[Service sharedInstance]appTeacherLoginWithEmail:emailText
                                             passWord:userPWD
                                              success:^(NSDictionary *result) {
                                                  [self hideHud];
                                                  if (k_IsSuccess(result)) {
                                                      NSDictionary *data =[result objectForKey:@"Data"];
                                                      CHECK_DATA_IS_NSNULL(data, NSDictionary);
                                                      if (data.count > 0) {
                                                        //保存登陆信息
                                                       [[ConfigData sharedInstance] saveUserLoginInfo:data];
                                                        //登陆成功通知
                                                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_LOGIN_SUCCESS object:nil];
                                                        //记录登录账号信息
                                                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                                        [userDefault setObject:emailText forKey:k_SAVEUserName];
                                                        [userDefault setObject:userPWD forKey:k_SAVEUserPWD];
                                                        [userDefault synchronize];
                                                      }
                                                      button.enabled = YES;
                                                  }else
                                                  {
                                                      if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                                                          NSString *infomation = [result objectForKey:@"Infomation"];
                                                          CHECK_DATA_IS_NSNULL(infomation, NSString);
                                                          [CommentMethod showToastWithMessage:infomation showTime:2.0];
                                                      }
                                                      button.enabled = YES;
                                                  }
                                                  
                                              } failure:^(NSError *error) {
                                                  button.enabled = YES;
                                                  [self hideHud];
                                                  [self showHint:[error networkErrorInfo]];
                                              }];
    
}
#pragma mark - private metaods
- (void)logonUserName:(NSString *)userName pwd:(NSString *)passWord
{
    //网络请求
    [self showHudInView:self.view hint:@"正在登录..."];
    
    [[Service sharedInstance]appTeacherLoginWithEmail:userName
                                             passWord:passWord
                                              success:^(NSDictionary *result) {
                                                  [self hideHud];
                                                  if (k_IsSuccess(result)) {
                                                      NSDictionary *data =[result objectForKey:@"Data"];
                                                      CHECK_DATA_IS_NSNULL(data, NSDictionary);
                                                      if (data.count > 0) {
                                                          
                                                          [[ConfigData sharedInstance] saveUserLoginInfo:data];
                                                          
                                                          [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_LOGIN_SUCCESS object:nil];
                                                      }
                                                  }else
                                                  {
                                                      if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                                                          NSString *infomation = [result objectForKey:@"Infomation"];
                                                          CHECK_DATA_IS_NSNULL(infomation, NSString);
                                                          [CommentMethod showToastWithMessage:infomation showTime:2.0];
                                                      }
                                                  }
                                                  
                                              } failure:^(NSError *error) {
                                                  [self hideHud];
                                                  [self showHint:[error networkErrorInfo]];
                                              }];

  
}

#pragma mark - getters and setters
- (UIImageView *)backImgView
{
    if (!_backImgView) {
        _backImgView = [CommentMethod createImageViewWithImageName:@""];
    }
    return _backImgView;
}

- (UILabel *)logoLabel
{
    if (!_logoLabel) {
        _logoLabel = [CommentMethod createLabelWithFont:18.0f Text:@"雅思互动学习平台教师端"];
        _logoLabel.textColor = k_PinkColor;
        _logoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _logoLabel;
}

- (UIImageView *)versionView
{
    if (!_versionView) {
        _versionView = [CommentMethod createImageViewWithImageName:@"logon_banben.png"];
    }
    return _versionView;
}


- (UIImageView *)logoImgView
{
    if (!_logoImgView) {
        _logoImgView = [CommentMethod createImageViewWithImageName:@"logon_logo.png"];
    }
    return _logoImgView;
}

- (UIImageView *)emailIconView
{
    if (!_emailIconView) {
        _emailIconView = [CommentMethod createImageViewWithImageName:@"logon_zhanghao.png"];
    }
    return _emailIconView;
}
- (UIImageView *)emailImgView
{
    if (!_emailImgView) {
        _emailImgView = [CommentMethod createImageViewWithImageName:@"logon_shurukuang.png"];
    }
    return _emailImgView;
}

- (UIImageView *)pwdIconView
{
    if (!_pwdIconView) {
        _pwdIconView = [CommentMethod createImageViewWithImageName:@"logon_mima.png"];
    }
    return _pwdIconView;
}

- (UIImageView *)pwdImgView
{
    if (!_pwdImgView) {
        _pwdImgView = [CommentMethod createImageViewWithImageName:@"logon_shurukuang.png"];
    }
    return _pwdImgView;
}

- (UITextField *)emailTextField
{
    if (!_emailTextField) {
        _emailTextField = [CommentMethod createTextFieldWithPlaceholder:@"请输入邮箱" passWord:NO Font:16.0f];
        _emailTextField.tintColor = k_PinkColor;
    }
    return _emailTextField;
}

- (UITextField *)pwdTextField
{
    if (!_pwdTextField) {
        _pwdTextField = [CommentMethod createTextFieldWithPlaceholder:@"请输入密码" passWord:YES Font:16.0f];
        _pwdTextField.tintColor = k_PinkColor;
    }
    return _pwdTextField;
}

- (UIButton *)logonButton
{
    if (!_logonButton) {
        _logonButton = [CommentMethod createButtonWithImageName:@"logon_anniu2.png" Target:self Action:@selector(logonAction:) Title:@"登录"];
    }
    return _logonButton;
}

@end
