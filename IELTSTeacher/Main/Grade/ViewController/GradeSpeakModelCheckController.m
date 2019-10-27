//
//  GradeSpeakModelCheckController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeSpeakModelCheckController.h"
#import "SelectNumberView.h"
#import "GradeCheckSpeakModel.h"
#import "GradeCheckModelCell.h"


#define k_TopTableViewHeight (93*AUTO_SIZE_SCALE_X)
@interface GradeSpeakModelCheckController ()<UITableViewDataSource,UITableViewDelegate,GradeCheckModelCellDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;//背景滑动视图
@property (nonatomic,strong) UIButton     *sureButton; //确认按钮
@property (nonatomic,strong) UIView       *numberView; //选分背景视图
@property (nonatomic,strong) UIView       *topView;    //头部视图

@property (nonatomic,strong) NSMutableArray  *dataArray; //音频文件个数
@property (nonatomic,strong) UITableView  *tableView;  //音频表视图

/*
 记录分数 //[@"FC",@"LR",@"GRA",@"P"]
 */
@property (nonatomic,assign) NSInteger fcScore;
@property (nonatomic,assign) NSInteger lrScore;
@property (nonatomic,assign) NSInteger graScore;
@property (nonatomic,assign) NSInteger pScore;



@end

@implementation GradeSpeakModelCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"口语模考";
    /*
     初始化视图
     */
    [self _initView];
    
    /*
      初始化数据
     */
    [self _initData];
    
}
//初始化视图
- (void)_initView
{
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.sureButton];
    [self.bgScrollView addSubview:self.numberView];
    [self.bgScrollView addSubview:self.topView];
    //测试数据
    [self.topView addSubview:self.tableView];
    
    UILabel *onlineLabel = [CommentMethod createLabelWithFont:17.0f Text:@"在线批改"];
    onlineLabel.backgroundColor = [UIColor clearColor];
    onlineLabel.textColor = [UIColor blackColor];
    onlineLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, 0, 200*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_Y);
    [self.numberView addSubview:onlineLabel];
    
    UILabel *line2 = [CommentMethod createLabelWithFont:0 Text:@""];
    line2.backgroundColor = RGBACOLOR(230, 230, 230, 1.0);
    line2.frame = CGRectMake(0, 40*AUTO_SIZE_SCALE_Y, kScreenWidth, 0.5);
    [self.numberView addSubview:line2];
    
    //总分
    UILabel *countScore = [CommentMethod createLabelWithFont:14.0f Text:@"总分"];
    [self.numberView addSubview:countScore];
    
    UILabel *scoreLabel = [CommentMethod createLabelWithFont:35.0f Text:@"0.0"];
    scoreLabel.textColor = k_PinkColor;
    scoreLabel.tag = 1000;
    [self.numberView addSubview:scoreLabel];
    
    WS(this_speakMode);
    //一个 90px
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,k_TopTableViewHeight)); //90*AUTO_SIZE_SCALE_Y));
        make.left.mas_equalTo(0);
    }];
    
    //视图约束
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 375*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo (this_speakMode.topView.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
    }];
    //按钮约束位置
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-80*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo(self.numberView.mas_bottom).with.offset(20*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_speakMode.view);
    }];
    
    //成绩
    [scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.numberView);
        make.bottom.mas_equalTo(-25*AUTO_SIZE_SCALE_X);
    }];
    //总分
    [countScore mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scoreLabel.mas_right);
        make.bottom.mas_equalTo(scoreLabel.mas_top);
    }];
    
    NSArray *typeArray  = @[@"FC",@"LR",@"GRA",@"P"];//[@"FC",@"LR",@"GRA",@"P"]
    //创建分数视图
    for (int j=0; j<typeArray.count; j++) {
        SelectNumberView *numberView = [[SelectNumberView alloc]initWithFrame:CGRectMake(20*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_Y+55*AUTO_SIZE_SCALE_Y*j, kScreenWidth-40*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_Y)];
        numberView.numberData = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        numberView.scoreType = typeArray[j];
        numberView.tag = j+10086;
        [self.numberView addSubview:numberView];
        
        [numberView setBlock:^(NSString *scoreType,NSString *number,NSString *curentTag) {
            NDLog(@"%@____%@____%@",scoreType,number,curentTag);
            if ([scoreType isEqualToString:@"FC"]) {
                
                self.fcScore = [number integerValue];
                
            }else if ([scoreType isEqualToString:@"LR"])
            {
                self.lrScore = [number integerValue];
                
            }else if ([scoreType isEqualToString:@"GRA"])
            {
                self.graScore = [number integerValue];
                
            }else if ([scoreType isEqualToString:@"P"])
            {
                self.pScore = [number integerValue];
            }
            
            NSInteger countScore = self.graScore + self.lrScore + self.fcScore + self.pScore;
            
            if (countScore != 0.0) {
                float totalValue = countScore/4.0f;
                NSInteger totalInt = countScore/4.0f;
                
                float totalFlaot = totalValue -(float)totalInt;
                if (totalFlaot>=0.25 && totalFlaot<0.75) {
                    totalFlaot = 0.5;
                }else if (totalFlaot>=0.75)
                {
                    totalFlaot = 1.0;
                }else if (totalFlaot<0.25)
                {
                    totalFlaot = 0.0;
                }
                float value = totalFlaot+(float)totalInt;
                scoreLabel.text = [NSString stringWithFormat:@"%.1f",value];
            }else
            {
                scoreLabel.text = [NSString stringWithFormat:@"0.0"];
            }
        }];
    }
}
//初始化数据
- (void)_initData
{
//    NSString *examId = @"104";
//    CHECK_STRING_IS_NULL(examId);
    
    CHECK_DATA_IS_NSNULL(self.checkModel.examID, NSNumber);
    NSString *examId = [self.checkModel.examID stringValue];
    CHECK_DATA_IS_NSNULL(self.checkModel.paperId, NSNumber);
    NSString *paperId = [self.checkModel.paperId stringValue];
    _dataArray = [[NSMutableArray alloc]init];
    [[Service sharedInstance]voiceCorrectingWithexamInfoId:examId
                                                   paperId:paperId
                                                  succcess:^(NSDictionary *result) {
      if (k_IsSuccess(result)) {
          NSDictionary *data = [result objectForKey:@"Data"];
          if (data.count > 0) {
              if (![[data objectForKey:@"examCorrectSpeakList"] isKindOfClass:[NSNull class]]) {
                  NSArray *examCorrectSpeakList = [data objectForKey:@"examCorrectSpeakList"];
                  NSMutableArray *isNoCorrectArray = [[NSMutableArray alloc]initWithCapacity:examCorrectSpeakList.count];
                  for (NSDictionary *dic in examCorrectSpeakList) {
                      GradeCheckSpeakModel *model = [[GradeCheckSpeakModel alloc]initWithDataDic:dic];
                      [_dataArray addObject:model];
                      
                      CHECK_DATA_IS_NSNULL(model.IsCorrected, NSNumber);
                      NSInteger isCorrected = [model.IsCorrected integerValue];
                      if (isCorrected == 0) {  //没有批改过的存储起来。
                        [isNoCorrectArray addObject:model.IsCorrected];
                      }
                  }
                  //更新视图
                  [self _dealData];
                  
                  if (isNoCorrectArray.count == 0 ) { //隐藏按钮。显示成绩
                      
                      self.sureButton.hidden = YES;
                      
                      if (examCorrectSpeakList.count > 0) {
                          NSDictionary *examCorrectSpeakDic =  examCorrectSpeakList[0];
                          NSArray *scores = [examCorrectSpeakDic objectForKey:@"scores"];
                          SelectNumberView *fcNumberView = (SelectNumberView *)[self.numberView viewWithTag:10086];  //@"FC",@"LR",@"GRA",@"P"
                          SelectNumberView *lrNumberView = (SelectNumberView *)[self.numberView viewWithTag:10087];
                          SelectNumberView *graNumberView = (SelectNumberView *)[self.numberView viewWithTag:10088];
                          SelectNumberView *pNumberView = (SelectNumberView *)[self.numberView viewWithTag:10089];
                          fcNumberView.userInteractionEnabled = NO;
                          lrNumberView.userInteractionEnabled = NO;
                          graNumberView.userInteractionEnabled = NO;
                          pNumberView.userInteractionEnabled = NO;
                          if (scores.count > 0) {
                              
                              NSInteger fc = 0.0;
                              NSInteger lr = 0.0;
                              NSInteger gra = 0.0;
                              NSInteger p = 0.0;
                              for (NSDictionary  *score in scores) {
                                  NSString *name = [score objectForKey:@"Name"];
                                  NSNumber *scoreNumber =  [score objectForKey:@"Score"];
                                  CHECK_DATA_IS_NSNULL(scoreNumber, NSNumber);
                                  if ([name isEqualToString:@"FC"]) {
                                      fc = [scoreNumber integerValue];
                                      fcNumberView.curentScore = fc;
                                  }else if ([name isEqualToString:@"LR"])
                                  {
                                      lr =[scoreNumber integerValue];
                                      lrNumberView.curentScore = lr ;
                                  }else if ([name isEqualToString:@"GRA"])
                                  {
                                      gra = [scoreNumber integerValue];
                                      graNumberView.curentScore = gra;
                                  }else if ([name isEqualToString:@"P"])
                                  {
                                      p = [scoreNumber integerValue];
                                      pNumberView.curentScore = p;
                                  }
                              }
                              UILabel *countScoreLabel = (UILabel *)[self.numberView viewWithTag:1000];
                              NSInteger countScore = fc+ lr +gra + p;
                              if (countScore != 0.0) {
                                  float totalValue = countScore/4.0f;
                                  NSInteger totalInt = countScore/4.0f;
                                  
                                  float totalFlaot = totalValue -(float)totalInt;
                                  if (totalFlaot>=0.25 && totalFlaot<0.75) {
                                      totalFlaot = 0.5;
                                  }else if (totalFlaot>=0.75)
                                  {
                                      totalFlaot = 1.0;
                                  }else if (totalFlaot<0.25)
                                  {
                                      totalFlaot = 0.0;
                                  }
                                  float value = totalFlaot+(float)totalInt;
                                  countScoreLabel.text = [NSString stringWithFormat:@"%.1f",value];
                              }else
                              {
                                  countScoreLabel.text = [NSString stringWithFormat:@"0.0"];
                              }
                          }
                      }
                  }else
                  {
                      self.sureButton.hidden = NO;
                  }
              }
          }else
          {
              [self showHint:@"当前数据不存在"];
          }
          
      }else{
          [self showHint:@"获取口语模考内容失败!"];
      }
  } failure:^(NSError *error) {
       NSString *string =  [error networkErrorInfo];
      [self showHint:string];
  }];
}

- (void)_dealData
{
    if (_dataArray.count > 0) {
        //一个 90px
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, k_TopTableViewHeight*_dataArray.count));
        }];
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, k_TopTableViewHeight*_dataArray.count);
        [self.tableView reloadData];
        //创建音频列表
        self.bgScrollView.contentSize = CGSizeMake(kScreenWidth,k_TopTableViewHeight*_dataArray.count+(375+10+45+40)*AUTO_SIZE_SCALE_Y);
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //销毁音频
     if (_dataArray.count > 0) {
        for (int i=0; i<_dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            GradeCheckModelCell *indexCell =(GradeCheckModelCell *) [self.tableView cellForRowAtIndexPath:indexPath];
            if (indexCell.audioPlayer != nil) {
                [indexCell.audioPlayer  dispose];
            }
        }
     }
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"GradeSpeakModelCheckController";
    GradeCheckModelCell *cell = (GradeCheckModelCell *)[tableView dequeueReusableCellWithIdentifier:
                                                identify];
    if (!cell) {
        cell = [[GradeCheckModelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (self.dataArray.count > 0) {
        GradeCheckSpeakModel *model =  self.dataArray[indexPath.row];
        CHECK_DATA_IS_NSNULL(model.AnswerContent, NSString);
        CHECK_STRING_IS_NULL(model.AnswerContent);
        cell.urlString = model.AnswerContent;
    }

    return cell;
}
#pragma mark - <TableViewCellDelegate>
- (void)selectPlay:(UIButton *)button curentCell:(UITableViewCell *)cell
{
    for (int i=0; i<_dataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        GradeCheckModelCell *indexCell =(GradeCheckModelCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (indexCell != cell) {
            if ([indexCell.audioPlayer isPlaying]) {
                [indexCell.audioPlayer pause];
                indexCell.playButton.selected = NO;
            }
        }
    }
}


#pragma mark - event respont
- (void)sureButtonAction:(UIButton *)button
{
    //提交成绩
    NSString *taskType = self.checkModel.taskType;
    CHECK_STRING_IS_NULL(taskType);
    if (self.dataArray.count > 0) {
        GradeCheckSpeakModel *model =  self.dataArray[0];
        CHECK_DATA_IS_NSNULL(model.Ex_ID, NSNumber);
        NSMutableString *exa_ID_String = [[NSMutableString alloc]initWithCapacity:self.dataArray.count];
        for (int i=0 ; i < self.dataArray.count; i++) {
            GradeCheckSpeakModel *model = self.dataArray[i];
            if (![model.EXA_ID isKindOfClass:[NSNull class]]) {
                NSString *exaId = [model.EXA_ID stringValue];
                [exa_ID_String appendFormat:@"%@",exaId];
                if (i< self.dataArray.count-1) {
                    [exa_ID_String appendFormat:@","];
                }
            }
        }
        NDLog(@"%@",exa_ID_String); //[@"FC",@"LR",@"GRA",@"P"]
        NSString *fcs = [NSString stringWithFormat:@"%ld",(long)self.fcScore];
        NSString *lrs = [NSString stringWithFormat:@"%ld",(long)self.lrScore];
        NSString *gras = [NSString stringWithFormat:@"%ld",(long)self.graScore];
        NSString *ps = [NSString stringWithFormat:@"%ld",(long)self.pScore];
        
        //[@"FC",@"LR",@"GRA",@"P"]
        if (!([fcs integerValue] > 0)) {
            [self showHint:@"请选择FC分数"];
            return;
        }
        
        if (!([lrs integerValue] > 0)) {
            [self showHint:@"请选择LR分数"];
            return;
        }
        
        if (!([gras integerValue] > 0)) {
            [self showHint:@"请选择GRA分数"];
            return;
        }
        
        if (!([ps integerValue] > 0)) {
            [self showHint:@"请选择P分数"];
            return;
        }
        
        NSDictionary *dic = @{@"examAnswerIds":exa_ID_String,
                              @"FCV":fcs,
                              @"LRV":lrs,
                              @"GRAV":gras,
                              @"PV":ps,
                              @"examInfoId":[model.Ex_ID stringValue],
                              @"type":@"1"};
        [self showHudInView:self.view hint:@"正在提交..."];
        [[Service sharedInstance]finishKyCorrectingWithDic:dic
                                                  succcess:^(NSDictionary *result) {
          [self hideHud];
          if (k_IsSuccess(result)) {
              
              [self showHint:@"批改成功"];
              //批改完成
              [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Name_ClassDetail object:nil];
              [self.navigationController popViewControllerAnimated:YES];
          }else{
               //信息
              if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                  if (![[result objectForKey:@"Infomation"] isEqualToString:@""]) {
                      [self showHint:[result objectForKey:@"Infomation"]];
                  }
              }
          }
      } failure:^(NSError *error) {
          [self hideHud];
          //提示信息
          [self showHint:[error networkErrorInfo]];
      }];
    }
}

#pragma mark - set or get
- (UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight+5, kScreenWidth, kScreenHeight-kNavHeight-5)];
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.showsVerticalScrollIndicator = NO;
    }
    return _bgScrollView;
}

- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(sureButtonAction:) Title:@"确定"];
         [_sureButton setBackgroundImage:[CommentMethod createImageWithColor:k_PinkColor] forState:UIControlStateNormal];
    }
    return _sureButton;
}
- (UIView *)numberView
{
    if (!_numberView) {
        _numberView = [[UIView alloc]init];
        _numberView.backgroundColor = [UIColor whiteColor];
    }
    return _numberView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, k_TopTableViewHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = k_TopTableViewHeight;
    }
    return _tableView;
}

@end
