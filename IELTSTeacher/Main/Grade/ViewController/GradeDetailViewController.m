//
//  GradeDetailViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeDetailViewController.h"
#import "GradeCheckViewController.h"
#import "GradeClassViewController.h"
#import "GradeTaskViewController.h"
#import "GradeExerciseViewController.h"
#import "HWPopMenu.h"

#import "GradeIConView.h"
#import "GradeChart.h"

#define kClassSelectHeight  30*AUTO_SIZE_SCALE_Y
#define kClassSelectWidth   100*AUTO_SIZE_SCALE_X
@interface GradeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  背景视图
 */
@property (nonatomic,strong) UIScrollView   *bgScrollView; //背景滑动
@property (nonatomic,strong) UIView         *topView;
@property (nonatomic,strong) UIView         *bottomView;
@property (nonatomic,strong) UIView         *middleView;

/**
 *  顶部元素
 */
@property (nonatomic,strong) UILabel        *classNumberAndTitle;
@property (nonatomic,strong) UIImageView    *timeImg;
@property (nonatomic,strong) UILabel        *timeLabel;
@property (nonatomic,strong) UIImageView    *addressImg;
@property (nonatomic,strong) UILabel        *addressLabel;
@property (nonatomic,strong) UIButton       *classSelect;
@property (nonatomic,strong) UIImageView    *classArrows;

@property (nonatomic,strong) UIImageView    *lineView;

/**
 *  搭班老师
 */

@property (nonatomic,strong) UILabel        *teacherTitl;
@property (nonatomic,strong) UIScrollView   *teacherScroll;
@property (nonatomic, strong) UILabel       *tipLabel;//无搭班老师的提示

@property (nonatomic,strong) GradeIConView *iconView;

/**
 *  模考成绩
 */
@property (nonatomic,strong) UILabel        *modelLabel;
@property (nonatomic,strong) GradeChart     *modelView;


/**
 *  数据
 */
@property (nonatomic,strong) NSArray        *classArray;
@property (nonatomic,strong) NSArray        *middleArray;

@property (nonatomic,copy) NSString       *roomName;

@end

@implementation GradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"班级详情";
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Notification_Name_ClassDetail object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:Notification_Name_ClassDetail object:nil];
    
    //初始化视图
    [self _initView];
    
    //初始化数据
    [self _initData];
}

#pragma mark - private
- (void)refreshData
{
    [self _initData];
}
//顶部视图
#define  topViewHeight (255*AUTO_SIZE_SCALE_Y)
#define  middleHeight  (154*AUTO_SIZE_SCALE_Y)
#define  bottomHeight  (kScreenHeight - topViewHeight - middleHeight - kNavHeight)
#define  leftMargins   (20*AUTO_SIZE_SCALE_X) //左边缘

- (void)_initView
{
    self.bgScrollView.hidden = YES;
    [self.view addSubview:self.bgScrollView];
    //添加到滑动视图的元素
    [self.bgScrollView addSubview:self.topView];
    [self.bgScrollView addSubview:self.bottomView];
    [self.bgScrollView addSubview:self.middleView];
    
    //1.添加到顶部的元素
    [self.topView addSubview:self.classNumberAndTitle];
    [self.topView addSubview:self.timeImg];
    [self.topView addSubview:self.addressImg];
    [self.topView addSubview:self.timeLabel];
    [self.topView addSubview:self.addressLabel];
    [self.topView addSubview:self.classSelect];
    [self.topView addSubview:self.lineView];

    [self.topView addSubview:self.teacherScroll];
    [self.topView addSubview:self.teacherTitl];
    [self.topView addSubview:self.tipLabel];
    
    //2.添加底部元素
    [self.bottomView addSubview:self.modelLabel];
    
    
    
     WS(this_GradeDetailController);
    
    if (self.isFutureClass) {
        self.bottomView.hidden = YES;
    }else
    {
        [self.classSelect addSubview:self.classArrows];
        self.classSelect.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        
        [self.classArrows mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(13, 7));
            make.centerY.mas_equalTo(this_GradeDetailController.classSelect);
        }];

    }

/**
添加约束
*/
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, topViewHeight));
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, middleHeight));
        make.top.mas_equalTo(this_GradeDetailController.topView.mas_bottom);
    }];


    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_GradeDetailController.topView.mas_bottom).with.offset(middleHeight);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, bottomHeight));
        make.left.mas_equalTo(0);
    }];
    
    //设置背景的contentSize
    self.bgScrollView.contentSize = CGSizeMake(kScreenWidth, 10+topViewHeight+middleHeight+bottomHeight);

    //topView
    [self.classNumberAndTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftMargins);
        make.size.mas_equalTo(CGSizeMake(284*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo(0);
    }];
    
    [self.timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftMargins);
        make.size.mas_equalTo(CGSizeMake(11*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X));
        make.top.mas_equalTo(this_GradeDetailController.classNumberAndTitle.mas_bottom);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_GradeDetailController.timeImg.mas_right).with.offset(10*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(254*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
        make.right.mas_equalTo(-10*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(20*AUTO_SIZE_SCALE_Y);
        make.top.mas_equalTo(this_GradeDetailController.timeImg.mas_top).with.offset(-5);
    }];
    
    [self.addressImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftMargins);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X));
        make.top.mas_equalTo(this_GradeDetailController.timeImg.mas_bottom).with.offset(8);
    }];
    
    /**
     *  此处地址如果自适应高度，会影响整体布局，建议点击地点，弹出tipMessage
     */
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_GradeDetailController.addressImg.mas_right).with.offset(10*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(254*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_Y));
        make.right.mas_equalTo(-10*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(20*AUTO_SIZE_SCALE_Y);
        make.top.mas_equalTo(this_GradeDetailController.addressImg.mas_top).with.offset(-5);
    }];
    
    [self.classSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kClassSelectWidth, kClassSelectHeight));
        make.top.mas_equalTo(10*AUTO_SIZE_SCALE_Y);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_GradeDetailController.addressLabel.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(5*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(-5*AUTO_SIZE_SCALE_X);
    }];
    
    //搭班老师
    [self.teacherTitl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_GradeDetailController.lineView.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y));
        make.left.mas_equalTo(leftMargins);
    }];
    
    CGFloat teacherHeigth = 120*AUTO_SIZE_SCALE_Y;
    [self.teacherScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, teacherHeigth));
        make.top.mas_equalTo(this_GradeDetailController.teacherTitl.mas_bottom);
        make.left.mas_equalTo(0);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, teacherHeigth));
        make.top.mas_equalTo(this_GradeDetailController.teacherTitl.mas_bottom);
        make.left.mas_equalTo(0);
    }];
    
    self.teacherScroll.hidden = NO;
    self.tipLabel.hidden = YES;
    
    //中间按钮
    CGFloat  taskButtonHeight =  76*AUTO_SIZE_SCALE_X;
    CGFloat  taskMargins = (kScreenWidth-taskButtonHeight*4)/5;
    CGFloat  taskTopHeignt = (middleHeight-taskButtonHeight)/2-15;
    
    NSArray *titleData = @[@"班级人数",@"课上练习",@"任务数量",@"待批改"];
    for (int i = 0; i<titleData.count; i++) {
        
        UIButton  *classTaskBt = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(classTaskCountAction:) Title:@""];
        classTaskBt.tag = 1000+i;
        [classTaskBt setBackgroundImage:[UIImage imageNamed:@"classDetai_yuan_bg.png"] forState:UIControlStateNormal];
        classTaskBt.titleLabel.font = [UIFont systemFontOfSize:30.0f*AUTO_SIZE_SCALE_X];

        UILabel   *taskLabel = [CommentMethod createLabelWithFont:16.0f Text:titleData[i]];
        taskLabel.textAlignment = NSTextAlignmentCenter;

        [self.middleView addSubview:classTaskBt];
        [self.middleView addSubview:taskLabel];
        
        //如果未开课隐藏按钮
        if (self.isFutureClass) {
            if (i==0) {
                classTaskBt.hidden = NO;
                taskLabel.hidden = NO;
            }else
            {
                classTaskBt.hidden = YES;
                taskLabel.hidden = YES;
            }
        }

        [classTaskBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(taskMargins+(taskButtonHeight+taskMargins)*i);
            make.size.mas_equalTo(CGSizeMake(taskButtonHeight, taskButtonHeight));
            make.top.mas_equalTo(this_GradeDetailController.topView.mas_bottom).with.offset(taskTopHeignt);
        }];

        [taskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(classTaskBt.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
            make.centerX.mas_equalTo(classTaskBt);
            make.size.mas_equalTo(CGSizeMake(taskButtonHeight, 20*AUTO_SIZE_SCALE_Y));
        }];
    }
    
    //底部
    [self.modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftMargins);
        make.size.mas_equalTo(CGSizeMake(200, 30*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo(this_GradeDetailController.bottomView).with.offset(10*AUTO_SIZE_SCALE_Y);
    }];
    
//    [self.modelView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(this_GradeDetailController.modelLabel.mas_bottom).with.equalTo(0);
//        make.left.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, bottomHeight-leftMargins-30));
//    }];
    /**
     选择课次按钮
     */
    self.classSelect.layer.cornerRadius = kClassSelectHeight/2;
    self.classSelect.layer.borderColor = [UIColor clearColor].CGColor;
    self.classSelect.layer.borderWidth = 1;
    self.classSelect.layer.masksToBounds = YES;
}


- (void)_getClassInfo:(NSArray *)teachData
{
    /**
     *  班级课次信息
     */
    for (UIView *views in self.teacherScroll.subviews) {
        [views removeFromSuperview];
    }
    
    CGFloat teacherHeigth = 120*AUTO_SIZE_SCALE_Y;
    for (int i=0; i < teachData.count; i++) {
        _iconView = [[GradeIConView alloc]init];
        _iconView.backgroundColor = [UIColor clearColor];
        [self.teacherScroll addSubview:_iconView];
        
        NSDictionary *dataDic = teachData[i];
        NSString *name = [dataDic objectForKey:@"sName"];
        CHECK_DATA_IS_NSNULL(name, NSString);
        _iconView.nickName = name;
        NSString *iconUrl = [dataDic objectForKey:@"IconUrl"];
        CHECK_DATA_IS_NSNULL(iconUrl, NSString);
        CHECK_STRING_IS_NULL(iconUrl);
        _iconView.iconString = iconUrl;
        
//         NSString *sMajor = [dataDic objectForKey:@"sMajor"];
//        CHECK_DATA_IS_NSNULL(sMajor, NSString);
//        CHECK_STRING_IS_NULL(sMajor);
//        _iconView.teacherType = sMajor;
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70*AUTO_SIZE_SCALE_X, teacherHeigth));
            make.left.mas_equalTo((90*i+40)*AUTO_SIZE_SCALE_X);
            make.top.mas_equalTo(0);
        }];
    }
    self.teacherScroll.contentSize = CGSizeMake(90*AUTO_SIZE_SCALE_X*teachData.count+40*AUTO_SIZE_SCALE_X, 0);
}

#pragma mark - request
- (void)_initData
{
    /**
     *  班级课次信息
       classCode=[班级编号，不可为空]
       lessonId=[课次ID，不可为空]
     */
    
    CHECK_STRING_IS_NULL(self.classCode);
    CHECK_STRING_IS_NULL(self.lessonId);
    if ([self.classCode isEqualToString:@""]) {
        [self showHint:@"班级编号数据异常"];
        return;
    }

    if ([self.lessonId isEqualToString:@""]) {
        [self showHint:@"课次数据异常"];
        return;
    }
    
    [self showHudInView:self.view hint:@"正在加载..."];
    NSDictionary *dic = @{@"sClassId":self.classCode,
                          @"lessonId":self.lessonId};
    [[Service sharedInstance]getLessonInfo:dic
                                  succcess:^(NSDictionary *result) {
          if (k_IsSuccess(result)) {
              NSDictionary *dataDic = [result objectForKey:@"Data"];
              if (dataDic.count > 0) {
                  self.bgScrollView.hidden = NO;
                  
                  NSString *time = [dataDic objectForKey:@"times"];
                  CHECK_DATA_IS_NSNULL(time, NSString);
                  CHECK_STRING_IS_NULL(time);
                  
                  self.timeLabel.text = time;
                  
                  //上课名称
                  NSString *sName = [dataDic objectForKey:@"roomName"];
                  CHECK_DATA_IS_NSNULL(sName, NSString);
                  CHECK_STRING_IS_NULL(sName);
                  self.roomName = sName;
                  self.addressLabel.text = sName;
                  
                  CHECK_DATA_IS_NSNULL(self.sCode, NSString);
                  CHECK_DATA_IS_NSNULL(self.classTitle, NSString);
                  NSString *titleString = [NSString stringWithFormat:@"%@  %@",self.sCode,self.classTitle];
                  self.classNumberAndTitle.text = titleString;
                  
                  //班级人数
                  NSNumber *stuNum = [dataDic objectForKey:@"stuNum"];
                  CHECK_DATA_IS_NSNULL(stuNum, NSNumber);
                  NSInteger stuNumInter = [stuNum integerValue];
                  
                  NSString *stuString = [NSString stringWithFormat:@"%ld",(long)stuNumInter];
                  UIButton *button = (UIButton *)[self.middleView viewWithTag:1000];
                  [button setTitle:stuString forState:UIControlStateNormal];
                  
                  NSNumber *paperSum =  [dataDic objectForKey:@"paperSum"]; //课上练习数
                  CHECK_DATA_IS_NSNULL(paperSum, NSNumber);
                  NSInteger paperSumInter = [paperSum integerValue];

                  NSString *paperString = [NSString stringWithFormat:@"%ld",(long)paperSumInter];
                  UIButton *button2 = (UIButton *)[self.middleView viewWithTag:1001];
                  [button2 setTitle:paperString forState:UIControlStateNormal];
                  

                  NSNumber *taskNum = [dataDic objectForKey:@"taskNum"]; //任务数
                  CHECK_DATA_IS_NSNULL(taskNum, NSNumber);
                  NSInteger taskNumInter = [taskNum integerValue];
                  NSString *taskString = [NSString stringWithFormat:@"%ld",(long)taskNumInter];
                  UIButton *button3 = (UIButton *)[self.middleView viewWithTag:1002];
                  [button3 setTitle:taskString forState:UIControlStateNormal];

                  
                  NSNumber *correctNum = [dataDic objectForKey:@"correctNum"]; //待批改数
                  CHECK_DATA_IS_NSNULL(correctNum, NSNumber);
                  NSInteger correctInter = [correctNum integerValue];
                  NSString *correctString = [NSString stringWithFormat:@"%ld",(long)correctInter];
                  UIButton *button4 = (UIButton *)[self.middleView viewWithTag:1003];
                  [button4 setTitle:correctString forState:UIControlStateNormal];
                  
                  NSNumber *lessonScoresCnt = [dataDic objectForKey:@"lessonScoresCnt"]; //判断个数  0 为没有、1 为 柱状图成绩  2为折线图成绩
                  CHECK_DATA_IS_NSNULL(lessonScoresCnt, NSNumber);
                  NSInteger lessScoresInter = [lessonScoresCnt integerValue];
                  if (lessScoresInter == 0) {
                      //隐藏底部
                      self.bottomView.hidden = YES;
                  }else if (lessScoresInter == 1)
                  {
                       //显示柱状图 只有一次模考
                      /**
                       {
                          ListenScore =听力成绩;
                          SpeakScore =口语成绩;
                          ReadScore =阅读成绩;
                          WriteScore =写作成绩;
                          TotalScore =总成绩;
                         }
                       */
                      self.bottomView.hidden = NO;
                      [self showChart:YES Data:dataDic];
                     
                  }else if (lessScoresInter > 1)
                  {
                     //折线图 多次模考总成绩集合
                      self.bottomView.hidden = NO;
                      [self showChart:NO Data:dataDic];
                  }
                  
                  NSArray *teachers = [dataDic objectForKey:@"teachers"];
                  if (teachers.count > 0) {
                      
                      self.teacherScroll.hidden = NO;
                      self.tipLabel.hidden = YES;
                      //班级信息
                      [self _getClassInfo:teachers];
                  }else
                  {
                      self.teacherScroll.hidden = YES;
                      self.tipLabel.hidden = NO;

                      for (UIView *views in self.teacherScroll.subviews) {
                          [views removeFromSuperview];
                      }
                  }
                  NSArray *lessons = [dataDic objectForKey:@"lessons"];
                  if (lessons.count > 0) {
                      _classArray = lessons;
                      
                      /**
                       *  显示当前课次
                       */
                     
                       if (self.isFutureClass) {
                          NSNumber *lessonsSizeNumber = [dataDic objectForKey:@"lessonsSize"];
                          CHECK_DATA_IS_NSNULL(lessonsSizeNumber, NSNumber);
                          NSString *titles = [NSString stringWithFormat:@"共%@节课",lessonsSizeNumber];
                          [self.classSelect setTitle:titles forState:UIControlStateNormal];
                       }else
                       {
                           for (NSDictionary *dic  in lessons) {
                               NSString *ids = [dic objectForKey:@"id"];
                               CHECK_DATA_IS_NSNULL(ids, NSString);
                               CHECK_STRING_IS_NULL(ids);
                               if ([self.lessonId isEqualToString:ids]) {
                                   NSNumber *nLessonNo =  [dic objectForKey:@"nLessonNo"];
                                   NSString *titles = [NSString stringWithFormat:@"第%@课",nLessonNo];
                                   [self.classSelect setTitle:titles forState:UIControlStateNormal];
                               }
                           }
                       }
                      
                  }
                  

                  /**
                   *  lessons =         (
                    {
                        id = 1;  //请求需要的
                        nLessonNo = 1; //展示的课次
                    }
                   );
                   
                   teachers =         (
                   {
                        IconUrl = "<null>";   //头像地址不对
                        sName = "\U97e9\U60a6\U5a07";
                        //缺少老师类型字段、
                   }
                   );
                   */
              }
          }else
          {
              if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                  [self showHint:[result objectForKey:@"Infomation"]];
              }
          }
          [self hideHud];
      } failure:^(NSError *error) {
          [self hideHud];
      }];
}


- (void)showChart:(BOOL)isOneModelTest  Data:(NSDictionary *)dataDic
{
    GradeChart *modelView = [[GradeChart alloc]initWithFrame:CGRectMake(0, 30+10*AUTO_SIZE_SCALE_Y, kScreenWidth, bottomHeight-10*AUTO_SIZE_SCALE_Y-30)];
    if (isOneModelTest) {
        NSDictionary *oneDic = [dataDic objectForKey:@"one"];
        NSMutableArray *scoreArray = [[NSMutableArray alloc]initWithCapacity:5];
        if (oneDic.count > 0) {
            NSString *totalScore = [oneDic objectForKey:@"TotalScore"];
            NSString *listenScore = [oneDic objectForKey:@"ListenScore"];
            NSString *speakScore = [oneDic objectForKey:@"SpeakScore"];
            NSString *readScore = [oneDic objectForKey:@"ReadScore"];
            NSString *writeScore = [oneDic objectForKey:@"WriteScore"];
            
            [scoreArray addObject:totalScore];
            [scoreArray addObject:listenScore];
            [scoreArray addObject:speakScore];
            [scoreArray addObject:readScore];
            [scoreArray addObject:writeScore];
        }
        
        modelView.isLineChat = NO;
        modelView.barChatValueX = scoreArray;//@[@"4",@"5",@"8",@"4",@"3"];
    }else{
        NSArray *dataArray = [dataDic objectForKey:@"many"];
        NSMutableArray *totalScoreArray = [[NSMutableArray alloc]initWithCapacity:dataArray.count];
        NSMutableArray *nLessonNoArray = [[NSMutableArray alloc]initWithCapacity:dataArray.count];
        for (NSDictionary *dic in dataArray) {
            //总分
            NSString *totalScore = [dic objectForKey:@"TotalScore"];
            CHECK_STRING_IS_NULL(totalScore);
            [totalScoreArray addObject:totalScore];
            //课次
            if (![[dic objectForKey:@"nLessonNo"] isKindOfClass:[NSNull class]]) {
                NSString *nLessonNo = [[dic objectForKey:@"nLessonNo"] stringValue];
                [nLessonNoArray addObject:nLessonNo];
            }else
            {
                [nLessonNoArray addObject:@""];
            }
        }
        modelView.isLineChat = YES;
        modelView.lineChatValueX = totalScoreArray;
        modelView.lineChatX = nLessonNoArray;
    }
    [self.bottomView addSubview:modelView];
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _classArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [CommentMethod createLabelWithFont:14.0f Text:@""];
        label.frame = CGRectMake(0, 0, kClassSelectWidth, kClassSelectHeight);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        label.tag = 200;
        [cell.contentView addSubview:label];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kClassSelectHeight-0.5, kClassSelectWidth, 0.5)];
        line.backgroundColor = RGBACOLOR(210, 210, 210, 1.0);
        [cell.contentView addSubview:line];
    }
    
    if (_classArray.count > 0) {
        NSDictionary *dataDic =  _classArray[indexPath.row];
        NSNumber *nLessonNo = [dataDic objectForKey:@"nLessonNo"];
        NSString *ids = [dataDic objectForKey:@"id"];
        
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:200];
        label.text = [NSString stringWithFormat:@"第%@课",[nLessonNo stringValue]];
        
        CHECK_DATA_IS_NSNULL(ids, NSString);
        CHECK_STRING_IS_NULL(ids);
        if ([self.lessonId isEqualToString:ids]) {
            label.textColor = k_PinkColor;
        }else
        {
            label.textColor = [UIColor darkGrayColor];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic =  _classArray[indexPath.row];
    NSNumber *nLessonNo = [dataDic objectForKey:@"nLessonNo"];
    CHECK_DATA_IS_NSNULL(nLessonNo, NSNumber);
    NSString *titles = [NSString stringWithFormat:@"第%@课",[nLessonNo stringValue]];
    [self.classSelect setTitle:titles forState:UIControlStateNormal];
    self.classArrows.transform = CGAffineTransformIdentity;
    NSString *ids = [dataDic objectForKey:@"id"];
    CHECK_DATA_IS_NSNULL(ids, NSString);
    CHECK_STRING_IS_NULL(ids);
    self.lessonId = ids;
    //刷新数据
    [self _initData];
    
    self.classSelect.selected = !self.classSelect.selected;
    [HWPopMenu  coverClick];
}


#pragma mark - event response
//显示课次
- (void)showClassNumber:(UIButton *)button
{
    if (self.isFutureClass) {
        return;
    }
    
    if (button.selected) {
        self.classArrows.transform = CGAffineTransformIdentity;
        [HWPopMenu  coverClick];
    }else
    {
        self.classArrows.transform = CGAffineTransformMakeRotation(M_PI);

        CGFloat viewHeigth =(255-10+90)*AUTO_SIZE_SCALE_Y;

        if (_classArray.count < 10) {
            viewHeigth =(_classArray.count+1)*30*AUTO_SIZE_SCALE_Y;
        }
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kClassSelectWidth, viewHeigth)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = kClassSelectHeight/2;
        view.layer.borderWidth = 1;
        view.layer.borderColor = k_PinkColor.CGColor;//[CommentMethod colorFromHexRGB:@"e84d60"].CGColor;
        view.layer.masksToBounds = YES;

        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kClassSelectHeight,kClassSelectWidth, viewHeigth-kClassSelectHeight-5) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = kClassSelectHeight;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc]init];
        [view addSubview:tableView];
        
        if (_classArray.count < 10) {
            tableView.showsVerticalScrollIndicator = NO;
            tableView.scrollEnabled = NO;
        }
        
        [HWPopMenu popFromRect:CGRectMake(0, -viewHeigth, kClassSelectWidth, viewHeigth)
                        inView:self.classSelect
                       content:view
                       dismiss:^{
                           self.classArrows.transform = CGAffineTransformIdentity;
                       }];
    }
    
    button.selected = !button.selected;
}
//任务数量列表
- (void)classTaskCountAction:(UIButton *)button
{
    NSInteger tag = button.tag;
    switch (tag ) {
        case 1000:
        {
            GradeClassViewController *class = [[GradeClassViewController alloc]init];
            class.classCode = self.classCode;
            [self.navigationController pushViewController:class animated:YES];
        }
            break;
        case 1001:
        {
            GradeExerciseViewController *exercise = [[GradeExerciseViewController alloc]init];
            exercise.ccid = self.lessonId;
            [self.navigationController pushViewController:exercise animated:YES];
        }
            break;
        case 1002:
        {
            GradeTaskViewController *task = [[GradeTaskViewController alloc]init];
            task.lessonId = self.lessonId;
            task.ids = self.ids;
            task.classCode = self.classCode;
            [self.navigationController pushViewController:task animated:YES];
        }
            break;
        case 1003:
        {
            GradeCheckViewController *check = [[GradeCheckViewController alloc]init];
//            check.sCode = self.classCode;
            check.ccId = self.lessonId;
            [self.navigationController pushViewController:check animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)addressAction:(UITapGestureRecognizer *)tap
{
    CHECK_STRING_IS_NULL(self.roomName);
    if (![self.roomName isEqualToString:@""]) {
        [CommentMethod showToastWithMessage:self.roomName showTime:1.0];
    }
}

#pragma mark - get or set
- (UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight+13, kScreenWidth, kScreenHeight-kNavHeight-13)];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.userInteractionEnabled = YES;
    }
    return _bgScrollView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIView *)middleView
{
    if (!_middleView) {
        _middleView = [UIView new];
        _middleView.backgroundColor = [UIColor clearColor];
    }
    return _middleView;
}


- (UILabel *)classNumberAndTitle
{
    if (!_classNumberAndTitle) {
        _classNumberAndTitle = [[UILabel alloc] init];
        _classNumberAndTitle.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _classNumberAndTitle.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _classNumberAndTitle;
}

- (UIImageView *)timeImg
{
    if (!_timeImg) {
        _timeImg = [CommentMethod createImageViewWithImageName:@"classDetai_shijian.png"];
    }
    return _timeImg;
}

- (UIImageView *)addressImg
{
    if (!_addressImg) {
        _addressImg = [CommentMethod createImageViewWithImageName:@"personal_planList_dizhi.png"];
    }
    return _addressImg;
}
- (UIButton *)classSelect
{
    if (!_classSelect) {
        _classSelect = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(showClassNumber:) Title:@""];
        [_classSelect setBackgroundImage:[CommentMethod createImageWithColor:k_PinkColor] forState:UIControlStateNormal];
        _classSelect.titleLabel.font = [UIFont systemFontOfSize:14.0f*AUTO_SIZE_SCALE_X];
       
    }
    return _classSelect;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:15.0f*AUTO_SIZE_SCALE_X];
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = [UIColor lightGrayColor];
        _addressLabel.font = [UIFont systemFontOfSize:15.0f*AUTO_SIZE_SCALE_X];
        _addressLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressAction:)];
        [_addressLabel addGestureRecognizer:tap];
    }
    return _addressLabel;
}

- (UILabel *)teacherTitl
{
    if (!_teacherTitl) {
        _teacherTitl = [CommentMethod createLabelWithFont:18.0f Text:@"搭班老师"];
        _teacherTitl.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _teacherTitl;
}

- (UIScrollView *)teacherScroll
{
    if (!_teacherScroll) {
        _teacherScroll = [UIScrollView new];
        _teacherScroll.showsHorizontalScrollIndicator = NO;
        _teacherScroll.showsVerticalScrollIndicator = NO;
        _teacherScroll.backgroundColor = [UIColor clearColor];
    }
    return _teacherScroll;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [CommentMethod createLabelWithFont:18.0f Text:@"当前无搭班老师"];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (GradeChart *)modelView
{
    if (!_modelView) {
        _modelView = [[GradeChart alloc]init];
    }
    return _modelView;
}

- (UILabel *)modelLabel
{
    if (!_modelLabel) {
        _modelLabel = [CommentMethod createLabelWithFont:18.0f Text:@"模考成绩"];
        _modelLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _modelLabel;
}

- (UIImageView *)lineView
{
    if (!_lineView) {
        _lineView = [CommentMethod createImageViewWithImageName:@"material_huixian.png"];
    }
    return _lineView;
}

- (UIImageView *)classArrows
{
    if (!_classArrows) {
        _classArrows = [CommentMethod createImageViewWithImageName:@"classDetai_jiantou.png"];
    }
    return _classArrows;
}




@end
