//
//  PersonalViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "PersonalViewController.h"
#import "NewsViewController.h"
#import "CollectViewController.h"
#import "RemindViewController.h"
#import "SystemSettingViewController.h"
#import "StudentAchieveViewController.h"
#import "ContactUsViewController.h"

#import "FileUploadHelper.h"
#import "UIImage+fixOrientation.h"

#import "TeacherInfoModel.h"

#define kFunctionCollectionCell @"functionCollectionViewCell"

@interface PersonalViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView      *bjView;
@property (nonatomic, strong) UIImageView *imgView;//头像
@property (nonatomic, strong) UILabel     *titLabel;//昵称
@property (nonatomic, strong) UIImageView *localImgView;//定位
@property (nonatomic, strong) UILabel     *schoolLabel;//地址
@property (nonatomic, strong) UIImageView *signBgView;
@property (nonatomic, strong) UITextField *signTextField;//个性签名

@property (nonatomic, strong) UILabel     *hourLabel1;
@property (nonatomic, strong) UILabel     *hourLabel2;
@property (nonatomic, strong) UILabel     *hourLabel3;
@property (nonatomic, strong) UILabel     *timeLabel1;//课时
@property (nonatomic, strong) UILabel     *timeLabel2;//课时
@property (nonatomic, strong) UILabel     *timeLabel3;//课时
@property (nonatomic, strong) UILabel     *totalLabel;//总授课量
@property (nonatomic, strong) UILabel     *courseLabel;//上课授课量
@property (nonatomic, strong) UILabel     *unfinishLabel;//未完成授课量
@property (nonatomic, strong) UIImageView *verImgView1;
@property (nonatomic, strong) UIImageView *verImgView2;


@property (nonatomic, strong) NSArray     *imgArr;//图片数组
@property (nonatomic, strong) NSArray     *highlightImgArr;//高亮图片数组
@property (nonatomic, strong) NSArray     *titleArr;//标题
@property (nonatomic, strong) NSArray     *viewControlls;

@property (nonatomic, strong) UIView      *downbjView;
@property (nonatomic, strong) UIImageView *horLineCenter;
@property (nonatomic, strong) UIImageView *verLineLeft;
@property (nonatomic, strong) UIImageView *verLineRight;
@property (nonatomic, strong) UIButton    *button;

@property (nonatomic, strong) UIImageView *unReadImgView; //未读消息视图

@property (nonatomic, strong) NSArray     *listArray;//学员数据

@property (nonatomic, copy)   NSString    *signText;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"个人中心";

    //初始化视图
    [self _initView];
    
    //初始化界面数据
    [self _initInfoData];
    
    /**
     *  收起键盘
     */
    [self setupForDismissKeyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    //初始化消息未读数
    [self _initMyAllMessageNoReadCount];
    
    [self hideHud];
}

#pragma mark - life cycle
- (void)_initView
{
    [self.view addSubview:self.bjView];
    [self.bjView addSubview:self.imgView];
    [self.bjView addSubview:self.titLabel];
    [self.bjView addSubview:self.localImgView];
    [self.bjView addSubview:self.schoolLabel];
    [self.bjView addSubview:self.signBgView];
    [self.signBgView addSubview:self.signTextField];
    
    [self.bjView addSubview:self.hourLabel1];
    [self.bjView addSubview:self.hourLabel2];
    [self.bjView addSubview:self.hourLabel3];
    [self.bjView addSubview:self.timeLabel1];
    [self.bjView addSubview:self.timeLabel2];
    [self.bjView addSubview:self.timeLabel3];
    [self.bjView addSubview:self.totalLabel];
    [self.bjView addSubview:self.courseLabel];
    [self.bjView addSubview:self.unfinishLabel];
    [self.bjView addSubview:self.verImgView1];
    [self.bjView addSubview:self.verImgView2];
    
    [self.view addSubview:self.downbjView];
    
    WS(this_view);
    
    NewsViewController *newsViewCtrl = [[NewsViewController alloc] init];
    CollectViewController *collectViewCtrl = [[CollectViewController alloc] init];
    RemindViewController *remindViewCtrl = [[RemindViewController alloc] init];
    SystemSettingViewController *sysSetViewCtrl = [[SystemSettingViewController alloc] init];
    StudentAchieveViewController *studentViewCtrl = [[StudentAchieveViewController alloc] init];
    ContactUsViewController *contactViewCtrl = [[ContactUsViewController alloc] init];
    
    self.viewControlls = @[newsViewCtrl, collectViewCtrl, remindViewCtrl, sysSetViewCtrl, studentViewCtrl, contactViewCtrl];
    
    //背景视图
    [self.bjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+18*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 715/3*AUTO_SIZE_SCALE_Y));
    }];
    //头像视图
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(32*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(233/3*AUTO_SIZE_SCALE_X, 233/3*AUTO_SIZE_SCALE_Y));
    }];
    //用户名
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_view.bjView.top).with.offset(38*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.imgView.right).with.offset(30*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    //定位视图
    [self.localImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_view.titLabel.bottom).with.offset(6*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.titLabel.left);
    }];
    //地址
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_view.titLabel.bottom).with.offset(3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.localImgView.right).with.offset(5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(150*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    //个性签名背景视图
    [self.signBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.localImgView.bottom).with.offset(5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.localImgView.left).with.offset(-2*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(790/3*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
    }];
    //个性签名
    [self.signTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signBgView.top).with.offset(2*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(self.signBgView.left).with.offset(10/3*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(770/3*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    
    //小时
    [self.hourLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.imgView.bottom).with.offset(112/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(290/3*AUTO_SIZE_SCALE_X);
    }];
    [self.hourLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.imgView.bottom).with.offset(112/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(kScreenWidth/2+71/3*AUTO_SIZE_SCALE_X);
    }];
    [self.hourLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.imgView.bottom).with.offset(112/3*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(-55/3*AUTO_SIZE_SCALE_X);
    }];
    
    //课时
    [self.timeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.hourLabel1.bottom).with.offset(3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/3, 30*AUTO_SIZE_SCALE_Y));
    }];
    [self.timeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.hourLabel2.bottom).with.offset(3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(kScreenWidth/3);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/3, 30*AUTO_SIZE_SCALE_Y));
    }];
    [self.timeLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.hourLabel3.bottom).with.offset(3*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/3, 30*AUTO_SIZE_SCALE_Y));
    }];
    //总授课量
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.timeLabel1.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(self.timeLabel1);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    //上课授课量
    [self.courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.timeLabel2.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(self.timeLabel2);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];
    //未完成授课量
    [self.unfinishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.timeLabel3.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(self.timeLabel3);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
    }];

    [self.verImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.imgView.bottom).with.offset(132/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(kScreenWidth/3);
        make.size.mas_equalTo(CGSizeMake(1*AUTO_SIZE_SCALE_X, 230/3*AUTO_SIZE_SCALE_Y));
    }];
    [self.verImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(self.imgView.bottom).with.offset(132/3*AUTO_SIZE_SCALE_Y);
        make.right.mas_equalTo(-kScreenWidth/3);
        make.size.mas_equalTo(CGSizeMake(1*AUTO_SIZE_SCALE_X, 230/3*AUTO_SIZE_SCALE_Y));
    }];
    
    //下面背景视图
    [self.downbjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bjView.bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 2*411/3*AUTO_SIZE_SCALE_Y));
    }];
    
    CGFloat width = kScreenWidth/3;
    CGFloat height = 411/3*AUTO_SIZE_SCALE_Y;
    int rowMax = 3;
    
    //循环创建个人中心Button
    for (int i=0; i<self.titleArr.count; i++) {
        int row = i/rowMax;
        int column = i%rowMax;
        
        UIImage *img = [UIImage imageNamed:self.imgArr[i]];
        //图片宽、高
        CGFloat imgWidth = img.size.width;
        CGFloat imgHeight = img.size.height;
        
        CGFloat topHeight = height/2 - imgHeight;
        CGFloat leftWidth = (width - imgWidth)/2;
        
        _button = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(buttonAction:) Title:@""];
        _button.frame = CGRectMake(column*width, row*height, width, height);
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_button setImage:[UIImage imageNamed:self.imgArr[i]] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:self.highlightImgArr[i]] forState:UIControlStateHighlighted];
        _button.titleLabel.font = [UIFont systemFontOfSize:18.0*AUTO_SIZE_SCALE_X];
        _button.tag = 500+i;
        [self.downbjView addSubview:_button];

        _button.imageEdgeInsets = UIEdgeInsetsMake(topHeight, leftWidth, height/2, leftWidth);
        
        //标题
        UILabel *titLabel = [CommentMethod createLabelWithFont:16.0 Text:self.titleArr[i]];
        titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.frame = CGRectMake((width-70*AUTO_SIZE_SCALE_X)/2, height-69/3*AUTO_SIZE_SCALE_Y-20*AUTO_SIZE_SCALE_Y, 70*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y);
        [self.button addSubview:titLabel];
        
        if (i == 0) {
            [self.downbjView addSubview:self.unReadImgView];
            //未读视图
            [self.unReadImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(height/2+20*AUTO_SIZE_SCALE_Y);
                make.left.mas_equalTo(_button.right).with.offset(-35*AUTO_SIZE_SCALE_X);
                make.size.mas_equalTo(CGSizeMake(7, 7));
            }];
        }
    }
    
    [self.downbjView addSubview:self.horLineCenter];
    [self.downbjView addSubview:self.verLineLeft];
    [self.downbjView addSubview:self.verLineRight];

    WS(this_self);
    //线
    [self.horLineCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerY.mas_equalTo(this_self.downbjView);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 1*AUTO_SIZE_SCALE_Y));
    }];
    [self.verLineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kScreenWidth/3);
        make.size.mas_equalTo(CGSizeMake(1*AUTO_SIZE_SCALE_X, 2*411/3*AUTO_SIZE_SCALE_Y));
    }];
    [self.verLineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-kScreenWidth/3);
        make.size.mas_equalTo(CGSizeMake(1*AUTO_SIZE_SCALE_X, 2*411/3*AUTO_SIZE_SCALE_Y));
    }];
}

//初始化消息未读数
- (void)_initMyAllMessageNoReadCount
{
    [[Service sharedInstance]myAllMessageNoReadCountSuccess:^(NSDictionary *result) {
        //成功
        if (k_IsSuccess(result)) {
            NSDictionary *dataDic = [result objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
            NSNumber *noReadCount = [dataDic objectForKey:@"noReadCount"];
            CHECK_DATA_IS_NSNULL(noReadCount, NSNumber);
            if ([noReadCount intValue] > 0) {
                //有未读
                self.unReadImgView.image = [UIImage imageNamed:@"remind_hongdian.png"];
            } else {
                self.unReadImgView.image = [UIImage imageNamed:@""];
            }
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

//初始化界面数据
- (void)_initInfoData
{
    //个人中心接口
    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service sharedInstance]getTeacherInfoSuccess:^(NSDictionary *result) {
        //成功
        if (k_IsSuccess(result)) {
            NDLog(@"个人中心 接口 result = %@", result);
            
            NSDictionary *dataDic = [result objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
            
            NSString *IconUrl = [dataDic objectForKey:@"IconUrl"];//教师头像
//            NSNumber *sCode = [dataDic objectForKey:@"sCode"];//教师编号
            NSNumber *teacherId = [dataDic objectForKey:@"teacherId"];//教师主键ID
            NSString *teacherName = [dataDic objectForKey:@"teacherName"];//教师名称
            NSString *schoolName = [dataDic objectForKey:@"schoolName"];//学校地址
            NSString *Signature = [dataDic objectForKey:@"Signature"];//个性签名
            NSNumber *TotalLesson = [dataDic objectForKey:@"TotalLesson"];//总授课量
            NSNumber *LastWeekLesson = [dataDic objectForKey:@"LastWeekLesson"];//上课授课量
            NSNumber *FutureLesson = [dataDic objectForKey:@"FutureLesson"];//未完成授课量
            
            CHECK_DATA_IS_NSNULL(IconUrl, NSString);
            CHECK_STRING_IS_NULL(IconUrl);
            CHECK_DATA_IS_NSNULL(teacherId, NSNumber);
            CHECK_DATA_IS_NSNULL(teacherName, NSString);
            CHECK_STRING_IS_NULL(teacherName);
            CHECK_DATA_IS_NSNULL(schoolName, NSString);
            CHECK_STRING_IS_NULL(schoolName);
            CHECK_DATA_IS_NSNULL(Signature, NSString);
            CHECK_STRING_IS_NULL(Signature);
            CHECK_DATA_IS_NSNULL(TotalLesson, NSNumber);
            CHECK_DATA_IS_NSNULL(LastWeekLesson, NSNumber);
            CHECK_DATA_IS_NSNULL(FutureLesson, NSNumber);

            NSString *iconPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,IconUrl];
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:iconPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
            
            //昵称
            if ([teacherName isEqualToString:@""]) {
                self.titLabel.text = @"李响";
            } else {
                self.titLabel.text = teacherName;
            }
            CGSize nickSize = [CommentMethod widthForNickName:self.titLabel.text testLablWidth:200 textLabelFont:20.0];
            [self.titLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(nickSize.width, 30));
            }];

            //学校地址
            if ([schoolName isEqualToString:@""]) {
                self.schoolLabel.text = @"新东方北京学校";
            } else {
                self.schoolLabel.text = schoolName;
            }
            CGSize schoolLabelSize = [CommentMethod widthForNickName:self.schoolLabel.text testLablWidth:150 textLabelFont:15.0];
            [self.schoolLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(schoolLabelSize.width, 20));
            }];
            
            //个性签名
            _signText = Signature;
            self.signTextField.text = Signature;
            
            //总授课量\上课授课量\未完成授课量
            if ([TotalLesson intValue] < 0) {
                self.timeLabel1.text = @"0";
            } else {
                self.timeLabel1.text = [NSString stringWithFormat:@"%d",[TotalLesson intValue]];
            }
            if ([LastWeekLesson intValue] < 0) {
                self.timeLabel2.text = @"0";
            } else {
                self.timeLabel2.text = [NSString stringWithFormat:@"%d",[LastWeekLesson intValue]];
            }
            if ([FutureLesson stringValue] < 0) {
                self.timeLabel3.text = @"0";
            } else {
                self.timeLabel3.text = [NSString stringWithFormat:@"%d",[FutureLesson intValue]];
            }
            
            NSArray *arr = [dataDic objectForKey:@"list"];
            CHECK_DATA_IS_NSNULL(arr, NSArray);
            _listArray = [[NSArray alloc] initWithArray:arr];
            CHECK_DATA_IS_NSNULL(_listArray, NSArray);
            
        } else {
            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                [self showHint:[result objectForKey:@"Infomation"]];
            }
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        //失败
        [self showHint:[error networkErrorInfo]];
    }];
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![self.signTextField.text isValidateSign]) {
        [self showHint:@"签名只能是1-50个字符的中文、字母、数字或符号"];
        [textField resignFirstResponder];
        self.signTextField.text = _signText;
        return NO;
    } else {
        [textField resignFirstResponder];
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.signBgView.layer.borderColor = [CommentMethod colorFromHexRGB:k_Color_5].CGColor;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.signBgView.layer.borderColor = [CommentMethod colorFromHexRGB:k_Color_9].CGColor;
    
    //调用修改个性签名接口
    NSString *newSignature = textField.text;
    CHECK_DATA_IS_NSNULL(newSignature, NSString);
    NSDictionary *dic = @{@"newSignature":newSignature};
    
    if (![textField.text isValidateSign]) {
        [self showHint:@"签名只能是1-50个字符的中文、字母、数字或符号"];
        self.signTextField.text = _signText;
    } else {
        
        [[Service sharedInstance]signatureChangeWithPram:dic success:^(NSDictionary *result) {
            if (k_IsSuccess(result)) {
                //提示修改成功
                [self showHint:@"修改成功"];
                _signText = newSignature;
            } else {
                if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {

                    [self showHint:[result objectForKey:@"Infomation"]];
                    self.signTextField.text = _signText;
                }
            }
        } failure:^(NSError *error) {
            //显示失败信息
            [self showHint:[error networkErrorInfo]];
        }];
    }
}

#pragma mark - event response
- (void)buttonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    
    switch (button.tag) {
        case 500:
        {
            //我的消息
            NewsViewController *news = [[NewsViewController alloc] init];
            [self.navigationController pushViewController:news animated:YES];
        }
            break;
        case 501:
        {
            //我的收藏
            CollectViewController *collect = [[CollectViewController alloc] init];
            [self.navigationController pushViewController: collect animated:YES];
        }
            break;
        case 502:
        {
            //我的提醒
            RemindViewController *remind = [[RemindViewController alloc] init];
            [self.navigationController pushViewController:remind animated:YES];
        }
            break;
        case 503:
        {
            //系统设置
            SystemSettingViewController *systemSetting = [[SystemSettingViewController alloc] init];
            [self.navigationController pushViewController:systemSetting animated:YES];
        }
            break;
        case 504:
        {
            //学员成绩
            StudentAchieveViewController *studentAchieve = [[StudentAchieveViewController alloc] init];
            studentAchieve.listArray = _listArray;
            [self.navigationController pushViewController:studentAchieve animated:YES];
        }
            break;
        case 505:
        {
            //联系我们
            ContactUsViewController *contactUs = [[ContactUsViewController alloc] init];
            [self.navigationController pushViewController:contactUs animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - getters and setters
- (UIView *)bjView
{
    if (!_bjView) {
        _bjView = [UIView new];
        _bjView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _bjView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [CommentMethod createImageViewWithImageName:@"person_default.png"];
        _imgView.layer.cornerRadius = 233/3*AUTO_SIZE_SCALE_X/2;
        _imgView.layer.masksToBounds = YES;
        _imgView.userInteractionEnabled = YES;
    }
    return _imgView;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
        _titLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_8];
    }
    return _titLabel;
}

- (UIImageView *)localImgView
{
    if (!_localImgView) {
        _localImgView = [CommentMethod createImageViewWithImageName:@"personal_planList_dizhi.png"];
    }
    return _localImgView;
}

- (UILabel *)schoolLabel
{
    if (!_schoolLabel) {
        _schoolLabel = [CommentMethod createLabelWithFont:13.0f Text:@""];
        _schoolLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_4];
    }
    return _schoolLabel;
}

- (UIImageView *)signBgView
{
    if (!_signBgView) {
        _signBgView = [CommentMethod createImageViewWithImageName:@""];
        _signBgView.layer.borderWidth = 0.5;
        _signBgView.layer.borderColor = [CommentMethod colorFromHexRGB:k_Color_9].CGColor;
        _signBgView.layer.masksToBounds = YES;
    }
    return _signBgView;
}

- (UITextField *)signTextField
{
    if (!_signTextField) {
        _signTextField = [CommentMethod createTextFieldWithPlaceholder:@"这家伙很懒，还没有个性签名" passWord:NO Font:16.0];
        _signTextField.textColor = [CommentMethod colorFromHexRGB:k_Color_8];
        _signTextField.delegate = self;
        _signTextField.tintColor = [UIColor lightGrayColor];
        _signTextField.clearButtonMode=NO;
    }
    return _signTextField;
}

- (UILabel *)hourLabel1
{
    if (!_hourLabel1) {
        _hourLabel1 = [CommentMethod createLabelWithFont:12.0f Text:@"小时"];
        _hourLabel1.textColor = k_PinkColor;
    }
    return _hourLabel1;
}

- (UILabel *)hourLabel2
{
    if (!_hourLabel2) {
        _hourLabel2 = [CommentMethod createLabelWithFont:12.0f Text:@"小时"];
        _hourLabel2.textColor = k_PinkColor;
    }
    return _hourLabel2;
}

- (UILabel *)hourLabel3
{
    if (!_hourLabel3) {
        _hourLabel3 = [CommentMethod createLabelWithFont:12.0f Text:@"小时"];
        _hourLabel3.textColor = k_PinkColor;
        _hourLabel3.textAlignment = NSTextAlignmentRight;
    }
    return _hourLabel3;
}

- (UILabel *)timeLabel1
{
    if (!_timeLabel1) {
        _timeLabel1 = [CommentMethod createLabelWithFont:38.0f Text:@""];
        _timeLabel1.textColor = k_PinkColor;
        _timeLabel1.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel1;
}

- (UILabel *)timeLabel2
{
    if (!_timeLabel2) {
        _timeLabel2 = [CommentMethod createLabelWithFont:38.0f Text:@""];
        _timeLabel2.textColor = k_PinkColor;
        _timeLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel2;
}

- (UILabel *)timeLabel3
{
    if (!_timeLabel3) {
        _timeLabel3 = [CommentMethod createLabelWithFont:38.0f Text:@""];
        _timeLabel3.textColor = k_PinkColor;
        _timeLabel3.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel3;
}

- (UILabel *)totalLabel
{
    if (!_totalLabel) {
        _totalLabel = [CommentMethod createLabelWithFont:14.0f Text:@"总授课量"];
        _totalLabel.textColor = [CommentMethod colorFromHexRGB:@"a9a9a9"];
    }
    return _totalLabel;
}

- (UILabel *)courseLabel
{
    if (!_courseLabel) {
        _courseLabel = [CommentMethod createLabelWithFont:14.0f Text:@"上课授课量"];
        _courseLabel.textColor = [CommentMethod colorFromHexRGB:@"a9a9a9"];
    }
    return _courseLabel;
}

- (UILabel *)unfinishLabel
{
    if (!_unfinishLabel) {
        _unfinishLabel = [CommentMethod createLabelWithFont:14.0f Text:@"未完成授课量"];
        _unfinishLabel.textColor = [CommentMethod colorFromHexRGB:@"a9a9a9"];
    }
    return _unfinishLabel;
}

- (UIImageView *)verImgView1
{
    if (!_verImgView1) {
        _verImgView1 = [CommentMethod createImageViewWithImageName:@""];
        _verImgView1.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
    }
    return _verImgView1;
}

- (UIImageView *)verImgView2
{
    if (!_verImgView2) {
        _verImgView2 = [CommentMethod createImageViewWithImageName:@""];
        _verImgView2.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
    }
    return _verImgView2;
}

- (UIView *)downbjView
{
    if (!_downbjView) {
        _downbjView = [UIView new];
        _downbjView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _downbjView;
}

- (UIImageView *)horLineCenter
{
    if (!_horLineCenter) {
        _horLineCenter = [CommentMethod createImageViewWithImageName:@""];
        _horLineCenter.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
    }
    return _horLineCenter;
}

- (UIImageView *)verLineLeft
{
    if (!_verLineLeft) {
        _verLineLeft = [CommentMethod createImageViewWithImageName:@""];
        _verLineLeft.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
    }
    return _verLineLeft;
}

- (UIImageView *)verLineRight
{
    if (!_verLineRight) {
        _verLineRight = [CommentMethod createImageViewWithImageName:@""];
        _verLineRight.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
    }
    return _verLineRight;
}

- (UIImageView *)unReadImgView
{
    if (!_unReadImgView) {
        _unReadImgView = [CommentMethod createImageViewWithImageName:@""];
    }
    return _unReadImgView;
}

- (NSArray *)imgArr
{
    if (!_imgArr) {
        _imgArr = @[@"personal_wodexiaoxi.png", @"personal_shoucang.png", @"personal_tixing.png", @"personal_qiangdaqi.png", @"personal_chengji.png", @"personal_lianxiwomen.png"];
    }
    return _imgArr;
}

- (NSArray *)highlightImgArr
{
    if (!_highlightImgArr) {
        _highlightImgArr = @[@"personal_wodexiaoxi_anxia.png", @"personal_shoucang_anxia.png", @"personal_tixing_anxia.png", @"personal_qiangdaqi_anxia.png", @"personal_chengji_anxia.png", @"personal_lianxiwomen_anxia.png"];
    }
    return _highlightImgArr;
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"我的消息", @"我的收藏", @"我的提醒", @"系统设置", @"学员成绩", @"联系我们"];
    }
    return _titleArr;
}

@end
