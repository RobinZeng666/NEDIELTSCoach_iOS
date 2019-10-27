//
//  MaterialDetailViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "MaterialDetailViewController.h"
#import "StudyMaterialModel.h"
#import "MaterialDetailModel.h"

#import <MediaPlayer/MediaPlayer.h>

@interface MaterialDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIButton      *collectButton;
@property (nonatomic, strong) UIWebView     *webView;
@property (nonatomic, strong) UIImageView   *imgView;
@property (nonatomic, strong) UILabel       *titLabel;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UIImageView   *lineImgView;
@property (nonatomic, strong) UIImageView   *teacherImgView;
@property (nonatomic, strong) UILabel       *teacherLabel;
@property (nonatomic, strong) UILabel       *dateLabel;
@property (nonatomic, strong) UIImageView   *typeImgView;
@property (nonatomic, strong) UILabel       *typeLabel;
@property (nonatomic, strong) UIImageView   *readImgView;
@property (nonatomic, strong) UILabel       *readLabel;

@property (nonatomic, strong) MPMoviePlayerViewController *videoPlayerController;

@end

@implementation MaterialDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    
    [self.view addSubview:self.webView];

    if (_isStudy) {
        [self.view addSubview:self.collectButton];
        //收藏Button
        [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
            make.height.mas_equalTo(44);
        }];
    }

    CHECK_DATA_IS_NSNULL(self.StorePoint, NSString);
    if ([self.StorePoint isEqualToString:@"1"]) {//资料
        
        self.titles = self.titleString;
        
        self.webView.frame = CGRectMake(0, kNavHeight+3, kScreenWidth, kScreenHeight-kNavHeight-3);
        
        //查看资料次数增加
        [self _initAddReadCount];
        //获取资料信息
        [self _initGetMaterialsInfo];
    } else {//视频
        
        self.titles = @"学习详情";
        //进入全屏
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterIntoFullScreen) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
        //退出全屏
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitIntoFullScreen) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
        
        //2 CC视频
        //初始化视图
        [self _initView];
        //视频资料查看
        [self _initLookUpVideoMaterials];
        //初始化视频数据
        [self _initLookVideoInfoData];
    }
    
    //资料是否收藏
    [self _initcheckCollectMaterialsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 资料
//查看资料增加查看次数
- (void)_initAddReadCount
{
    NSString *mId = self.mid;
    CHECK_DATA_IS_NSNULL(mId, NSString);
    
    NSDictionary *dic = @{@"mateId":mId};
    [[Service sharedInstance]addReadCountWithPram:dic success:^(NSDictionary *result) {
        if (k_IsSuccess(result)) {
            
        } else {
            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                [self showHint:[result objectForKey:@"Infomation"]];
            }
        }
    } failure:^(NSError *error) {
        //失败
        [self showHint:[error networkErrorInfo]];
    }];
}

//初始化视频数据
- (void)_initGetMaterialsInfo
{
    CHECK_STRING_IS_NULL(self.mid);
    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service sharedInstance]getMaterialsInfoWithMateId:self.mid
                                               succcess:^(NSDictionary *result) {
                                                   if (k_IsSuccess(result)) {
                                                       NSDictionary *dataDic = [result objectForKey:@"Data"];
                                                       CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
                                                       
                                                       if (dataDic.count > 0) {
                                                           NSString *url =[dataDic objectForKey:@"Url"];
                                                           CHECK_DATA_IS_NSNULL(url, NSString);
                                                           CHECK_STRING_IS_NULL(url);
                                                           
                                                           NSString *Name = [dataDic objectForKey:@"Name"];
                                                           CHECK_DATA_IS_NSNULL(Name, NSString);
                                                           CHECK_STRING_IS_NULL(Name);
                                                           if ([url isEqualToString:@""]) {
                                                               [self showHint:@"资料链接不存在"];
                                                           } else {
                                                               self.titles = Name;
                                                               NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
                                                               [self.webView loadRequest:request];
                                                               //显示网络加载
                                                               [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                                                           }
                                                       }
                                                   } else {
                                                       if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                           [self showHint:[result objectForKey:@"Infomation"]];
                                                       }
                                                   }
                                               } failure:^(NSError *error) {
                                                   [self showHint:[error networkErrorInfo]];
                                               }];
}

#pragma mark - 视频
//初始化视图
- (void)_initView
{
    [self.view addSubview:self.titLabel];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.lineImgView];
    [self.view addSubview:self.teacherImgView];
    [self.view addSubview:self.teacherLabel];
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.typeImgView];
    [self.view addSubview:self.typeLabel];
    [self.view addSubview:self.readImgView];
    [self.view addSubview:self.readLabel];
    [self.view addSubview:self.videoPlayerController.view];
    
//    _videoPlayerController.view.frame = CGRectMake(0, kNavHeight+3, kScreenWidth, 1011/3*AUTO_SIZE_SCALE_Y);
    [self.videoPlayerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+3);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 1011/3*AUTO_SIZE_SCALE_Y));
    }];
    
    //添加下面视图
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+3+1011/3*AUTO_SIZE_SCALE_Y+17*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(17*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    //标题
    self.nameLabel.frame = CGRectMake(67*AUTO_SIZE_SCALE_X, kNavHeight+3+1011/3*AUTO_SIZE_SCALE_Y+17*AUTO_SIZE_SCALE_Y, kScreenWidth-94*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y);
        
    [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titLabel.bottom).with.offset(13*AUTO_SIZE_SCALE_Y);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.teacherImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineImgView.bottom).with.offset(11*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.titLabel.left);
    }];
    
    //老师
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineImgView.bottom).with.offset(8*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.teacherImgView.right).with.offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(150, 20*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineImgView.bottom).with.offset(11*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(-17*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(150*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teacherImgView.bottom).with.offset(26*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.titLabel.left);
        make.size.mas_equalTo(CGSizeMake(18*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_Y));
    }];
    
    //听力
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teacherImgView.bottom).with.offset(22*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.teacherImgView.right).with.offset(10*AUTO_SIZE_SCALE_X);
    }];
    
    //浏览次数
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teacherImgView.bottom).with.offset(22*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(-17*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.readImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teacherImgView.bottom).with.offset(26*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(self.readLabel.left).with.offset(-5*AUTO_SIZE_SCALE_X);
    }];
}

//视频资料查看
- (void)_initLookUpVideoMaterials
{
    NSDictionary *dic = @{@"mId":self.mid};
    [[Service sharedInstance]lookUpVideoMaterialsWithPram:dic succcess:^(NSDictionary *result) {
        if (k_IsSuccess(result)) {
            
            NSDictionary *dataDic = [result objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
            
            NSString *videoUrl = [dataDic objectForKey:@"videoUrl"];
            CHECK_DATA_IS_NSNULL(videoUrl, NSString);
            CHECK_STRING_IS_NULL(videoUrl);
            
            [self.videoPlayerController.moviePlayer setContentURL:[NSURL URLWithString:videoUrl]];
            [self.videoPlayerController.moviePlayer pause];
            
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

//初始化视频数据
- (void)_initLookVideoInfoData
{
    NSDictionary *dic = @{@"mateId":self.mid};
    [[Service sharedInstance] lookVideoInfoWithPram:dic success:^(NSDictionary *result) {
        //成功
        if (k_IsSuccess(result)) {
            NSDictionary *dataDic = [result objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
            
            MaterialDetailModel *model = [[MaterialDetailModel alloc] initWithDataDic:dataDic];
            CHECK_DATA_IS_NSNULL(model.Name, NSString);
            CHECK_DATA_IS_NSNULL(model.sName, NSString);
            CHECK_DATA_IS_NSNULL(model.CreateTime, NSString);
            CHECK_DATA_IS_NSNULL(model.FileType, NSString);
            CHECK_DATA_IS_NSNULL(model.ReadCount, NSNumber);
            
            //标题
            self.nameLabel.text = self.titleString;
            
            //老师名字
            self.teacherLabel.text = model.sName;
            CGSize teachLabelSize = [CommentMethod widthForNickName:self.teacherLabel.text testLablWidth:150 textLabelFont:16.0];
            [self.teacherLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.lineImgView.bottom).with.offset(8*AUTO_SIZE_SCALE_Y);
                make.left.mas_equalTo(self.teacherImgView.right).with.offset(10*AUTO_SIZE_SCALE_X);
                make.size.mas_equalTo(CGSizeMake(teachLabelSize.width+10, 20*AUTO_SIZE_SCALE_Y));
            }];

            //时间
            self.dateLabel.text = model.CreateTime;
            
            //FileType
            NSString *Name = [dataDic objectForKey:@"Name"];
            CHECK_DATA_IS_NSNULL(Name, NSString);
            CHECK_STRING_IS_NULL(Name);
            self.typeLabel.text = Name;
            //浏览次数
            if ([model.ReadCount isKindOfClass:[NSNull class]]) {
                self.readLabel.text = @"0次";
            } else {
                self.readLabel.text = [NSString stringWithFormat:@"%@次", [model.ReadCount stringValue]];
            }
            
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

#pragma mark - 资料是否收藏
//资料是否收藏
- (void)_initcheckCollectMaterialsData
{
    NSDictionary *dic = @{@"type":@"0", @"id":self.mid};
    [[Service sharedInstance]checkCollectMaterialsWithPram:dic
                                                  succcess:^(NSDictionary *result) {
                                                      //成功
                                                      if (k_IsSuccess(result)) {
                                                          
                                                          NSDictionary *dataDic = [result objectForKey:@"Data"];
                                                          CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
                                                          
                                                          NSNumber *resultNum = [dataDic objectForKey:@"result"];
                                                          CHECK_DATA_IS_NSNULL(resultNum, NSNumber);
                                                          
                                                          if ([resultNum intValue] == 0) {
                                                              //没有收藏
                                                              [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
                                                          } else {
                                                              //已收藏
                                                              [_collectButton setTitle:@"取消收藏" forState:UIControlStateNormal];
                                                              _collectButton.selected = YES;
                                                          }
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

#pragma mark - 进入or退出全屏
- (void)enterIntoFullScreen
{
    [ConfigData sharedInstance].isNeedDeviceRotation = YES;
}

- (void)exitIntoFullScreen
{
    [ConfigData sharedInstance].isNeedDeviceRotation = NO;
}

- (void)viewWillLayoutSubviews
{
//   [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
   [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    // Ignore NSURLErrorDomain error -999.
    
    [self hideHud];
    if (error.code == NSURLErrorCancelled) return;
    
    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
    
    // Normal error handling…
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // Determine if we want the system to handle it.
    NSURL *url = request.URL;
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    return YES;
}

#pragma mark - event response
- (void)collectButtonAction:(UIButton *)button
{
    CHECK_DATA_IS_NSNULL(self.mid, NSString);
    NSNumber *optType = [NSNumber numberWithBool:!button.selected];
    CHECK_DATA_IS_NSNULL(optType, NSNumber);
    //调用添加、取消收藏接口
    NSDictionary *dic = @{@"mateId":_mid, @"optType":optType,@"ST_ID":@"0"};
    [[Service sharedInstance]addOrCancelMaterialsFavoriteWithPram:dic
                                                          success:^(NSDictionary *result) {
                                                            //刷新表视图
                                                              if (k_IsSuccess(result)) {
                                                                  
                                                                  if (self.delegate && [self.delegate respondsToSelector:@selector(MaterialRefreshMethod)]) {
                                                                    
                                                                      //让代理对象调用代理方法
                                                                      [self.delegate MaterialRefreshMethod];
                                                                  }
                                                              } else {
                                                                  if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                                      [self showHint:[result objectForKey:@"Infomation"]];
                                                                  }
                                                            }
                                                        } failure:^(NSError *error) {
                                                            //显示失败信息
                                                            [self showHint:[error networkErrorInfo]];
    }];
    
    if (button.selected) {
        [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self showHint:@"取消收藏"];
    } else {
        [_collectButton setTitle:@"取消收藏" forState:UIControlStateNormal];
        [self showHint:@"收藏成功"];
    }
    button.selected = !button.selected;
}

#pragma mark - getters and setters
- (UIButton *)collectButton
{
    if (!_collectButton) {
        _collectButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(collectButtonAction:) Title:@"收藏"];
        [_collectButton setTitleColor:[CommentMethod colorFromHexRGB:@"818b8f"] forState:UIControlStateNormal];
        _collectButton.titleLabel.font = [UIFont systemFontOfSize:k_Font_2*AUTO_SIZE_SCALE_X];
    }
    return _collectButton;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, 0);
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [CommentMethod createImageViewWithImageName:@"mycollection_shipin.png"];
    }
    return _imgView;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [CommentMethod createLabelWithFont:18.0f Text:@"名称"];
        _titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _titLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _nameLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _nameLabel;
}

- (UIImageView *)lineImgView
{
    if (!_lineImgView) {
        _lineImgView = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
    }
    return _lineImgView;
}

- (UIImageView *)teacherImgView
{
    if (!_teacherImgView) {
        _teacherImgView = [CommentMethod createImageViewWithImageName:@"materialDetail_laoshi.png"];
    }
    return _teacherImgView;
}

- (UILabel *)teacherLabel
{
    if (!_teacherLabel) {
        _teacherLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _teacherLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _teacherLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _dateLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

- (UIImageView *)typeImgView
{
    if (!_typeImgView) {
        _typeImgView = [CommentMethod createImageViewWithImageName:@"materialDetail_kemu.png"];
    }
    return _typeImgView;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _typeLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _typeLabel;
}

- (UIImageView *)readImgView
{
    if (!_readImgView) {
        _readImgView = [CommentMethod createImageViewWithImageName:@"materialDetail_liulan.png"];
    }
    return _readImgView;
}

- (UILabel *)readLabel
{
    if (!_readLabel) {
        _readLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _readLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _readLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _readLabel;
}

- (MPMoviePlayerViewController *)videoPlayerController
{
    if (!_videoPlayerController) {
        _videoPlayerController = [[MPMoviePlayerViewController alloc] init];
        _videoPlayerController.moviePlayer.repeatMode = MPMovieRepeatModeOne;
        _videoPlayerController.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
        _videoPlayerController.moviePlayer.shouldAutoplay = NO;
    }
    return _videoPlayerController;
}

@end
