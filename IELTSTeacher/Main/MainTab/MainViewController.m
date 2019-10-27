//
//  MainViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "MainViewController.h"
#import "ScheduleViewController.h"
#import "GradeViewController.h"
#import "ClassRoomViewController.h"
#import "MaterialViewController.h"
#import "ChatViewController.h"
#import "CustomAlertView.h"

static const CGFloat kDefaultPlaySoundInterval = 3.0;
@interface MainViewController ()
{
    UIImageView *_selectImageView;  //选择图片
}

@property (nonatomic,strong)UIImageView *tabbarView;  //tab视图
@property (nonatomic,strong)UIButton    *tabButton;

@property (strong, nonatomic) NSDate *lastPlayDate;//最后时间

@end

@implementation MainViewController

#pragma mark - lify cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化控制器
    [self _initViewControll];
    //初始化tabbar
    [self _initTabBar];
    //记录登入登出时间
    [self _saveStartTime];
}
#pragma mark - initView
//创建子控制器
-(void)_initViewControll
{
    //创建三级视图
    ScheduleViewController  *schedule = [[ScheduleViewController alloc]init];
    GradeViewController     *gradeView = [[GradeViewController alloc]init];
    ClassRoomViewController *classRoom = [[ClassRoomViewController alloc]init];
    MaterialViewController  *material = [[MaterialViewController alloc]init];
    ChatViewController  *chat =  [[ChatViewController alloc]init];
    //存储三级控制器
    NSArray *viewCtrl = @[schedule,gradeView,classRoom,material,chat];
    //将二级导航器交给控制器
    self.viewControllers = viewCtrl;
}
//自定义分栏控制器
-(void)_initTabBar
{
    //隐藏状态栏
    self.tabBar.hidden = YES;
    //设置tabbar的背景颜色和位置
    _tabbarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    _tabbarView.image =[UIImage imageNamed:@"mainTab_bar_white_640X88@2x.png"];
    _tabbarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabbarView];
    
    NSArray *titleArray  = @[@"计划",@"班级",@"课堂",@"学习",@"聊天"];
    float with = kScreenWidth/5;
    for (int i = 0;  i < 5 ; i++) {
        //遍历图片 127 × 88
        NSString *norMalImge = [NSString stringWithFormat:@"Home_normal_0%d.png",i+1];
        NSString *selectImge = [NSString stringWithFormat:@"Home_highlight_0%d.png",i+1];
        
        //设置自定义按钮
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((with-37)/2+ i*with, 5, 37, 29)];
        [button setBackgroundImage:[UIImage imageNamed:norMalImge] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:selectImge] forState:UIControlStateSelected];
        
        [button setTitleColor:[CommentMethod colorFromHexRGB:@"838a8e"] forState:UIControlStateNormal];
        [button setTitleColor:[CommentMethod colorFromHexRGB:@"e84d60"] forState:UIControlStateSelected];
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11.0f*AUTO_SIZE_SCALE_X];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        button.showsTouchWhenHighlighted = YES;
        button.tag = i;
        if (button.tag == 0) {
            [self selectorAction:button];
        }
        
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 40, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(45, 0, 0, 0);
        /*
         预留聊天红点
         */
//        if (button.tag == 3) {
//            _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.right-with/2+5, -3, 18, 18)];
//            _unreadLabel.backgroundColor = [UIColor redColor];
//            _unreadLabel.textColor = [UIColor whiteColor];
//            
//            _unreadLabel.textAlignment = NSTextAlignmentCenter;
//            _unreadLabel.font = [UIFont systemFontOfSize:11];
//            _unreadLabel.layer.cornerRadius = _unreadLabel.width/2;
//            _unreadLabel.clipsToBounds = YES;
//            _unreadLabel.hidden = YES;
//            [_tabbarView addSubview:_unreadLabel];
//        }
        
        //设置按钮事件
        [button addTarget:self action:@selector(selectorAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
    }
}



#pragma mark -private methods  
/*
   用于记录app的使用时间
 */
- (void)_saveStartTime
{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlayDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NDLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlayDate);
        return;
    }
    //保存最后一次时间
    self.lastPlayDate = [NSDate date];
}

#pragma mark - event response
//分栏按钮事件
- (void)selectorAction:(UIButton *)button
{
//    if (button.tag == 2) {
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:Notification_Name_ClassRoom object:nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Name_ClassRoom object:nil];
//    }
    
    if (button.tag == 4) {
        [self ChatClick];
    }
    
    self.selectedIndex = button.tag;
    // 1.控制状态
    self.tabButton.selected = NO;
    button.selected = YES;
    self.tabButton = button;
    
    [UIView animateWithDuration:0.2 animations:^{
        _selectImageView.center = button.center;
    }];
    
}
////聊天的点击
- (void)ChatClick
{  
//    [[CustomAlertView sharedAlertView]creatAlertView];
//    [[CustomAlertView sharedAlertView]showAlert];
}



@end
