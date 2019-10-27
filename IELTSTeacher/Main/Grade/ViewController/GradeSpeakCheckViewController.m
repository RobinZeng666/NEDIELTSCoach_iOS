//
//  GradeSpeakCheckViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/30.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeSpeakCheckViewController.h"
#import "CustomSegmentedView.h"
#import "SelectNumberView.h"
#import "GradeCheckModelCell.h"


#define k_TopSegmentHeight 44*AUTO_SIZE_SCALE_X
#define k_TopTableViewHeight 93*AUTO_SIZE_SCALE_X

@interface GradeSpeakCheckViewController ()<GradeCheckModelCellDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
/*
 记录分数
 */
//@property (nonatomic,assign) NSInteger trScore;
//@property (nonatomic,assign) NSInteger ccScore;
//@property (nonatomic,assign) NSInteger lrScore;
//@property (nonatomic,assign) NSInteger graScore;


@property (nonatomic,strong) UIScrollView *bgScrollView;//背景滑动视图
@property (nonatomic,strong) UIScrollView *tabScrollView;//tableView滑动视图
@property (nonatomic,strong) UIButton     *sureButton; //确认按钮
@property (nonatomic,strong) UIView       *numberView; //选分背景视图


@property (nonatomic,strong) CustomSegmentedView *segment;
@property (nonatomic,assign) NSInteger indexPathRow; //位置
//@property (nonatomic,strong) UITableView  *tableView;  //音频表视图

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong)  NSMutableArray *titlArray; //segment的标题
@property (nonatomic,strong)  NSMutableArray *scoreArray;//存储成绩的数组

@property (nonatomic,copy)  NSString *curentSpeakUrl;  //口语地址

@end

@implementation GradeSpeakCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.indexPathRow = 0;
    //1.初始化视图
    [self _initView];
    //2.初始化数据
    [self _initData];
}
- (void)_initView
{
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.segment]; //切换的
    [self.bgScrollView addSubview:self.tabScrollView]; //滑动视图
    
    [self.bgScrollView addSubview:self.sureButton]; //确定按钮
    [self.bgScrollView addSubview:self.numberView]; //选分控件
    
    self.titles = @"口语练习";
    
    UILabel *onlineLabel = [CommentMethod createLabelWithFont:17.0f Text:@"在线批改"];
    onlineLabel.backgroundColor = [UIColor clearColor];
    onlineLabel.textColor = [UIColor blackColor];
    onlineLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, 0, 200, 40*AUTO_SIZE_SCALE_Y);
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
    //FC/LR/GRA/P
    NSArray *typeArray  = @[@"FC",@"LR",@"GRA",@"P"];
    //创建分数视图
    for (int j=0; j<typeArray.count; j++) {
        SelectNumberView *numberView = [[SelectNumberView alloc]initWithFrame:CGRectMake(20*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_Y+55*AUTO_SIZE_SCALE_Y*j, kScreenWidth-40*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_Y)];
        numberView.numberData = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        numberView.scoreType = typeArray[j];
        numberView.tag = 100000+j;
        [self.numberView addSubview:numberView];
    }

    
    //一个 90px
    [self.tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segment.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,k_TopTableViewHeight)); //90*AUTO_SIZE_SCALE_Y));
        make.left.mas_equalTo(0);
    }];
    
    //视图约束
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 375*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo (this_speakMode.tabScrollView.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
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
}
- (void)_initData
{
        CHECK_DATA_IS_NSNULL(self.checkModel.examID, NSNumber);
        NSString *examId = [self.checkModel.examID stringValue];
        CHECK_DATA_IS_NSNULL(self.checkModel.paperId, NSNumber);
        NSString *paperId = [self.checkModel.paperId  stringValue];
    
        [[Service sharedInstance]contactCorrectingWithexamInfoId:examId
                                                         paperId:paperId
                                                        succcess:^(NSDictionary *result) {
            if (k_IsSuccess(result)) {
                NSDictionary *dataDic = [result objectForKey:@"Data"];
                if (![[dataDic objectForKey:@"examCorrectSpeakList"] isKindOfClass:[NSNull class]]) {
                     NSArray *examCorrectSpeakList = [dataDic objectForKey:@"examCorrectSpeakList"];
                    /*
                     [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Name_ClassDetail object:nil];
                     [self.navigationController popViewControllerAnimated:YES];
                     */
                    NSMutableArray *IsNotCorrected = [[NSMutableArray alloc]initWithCapacity:examCorrectSpeakList.count];
                    for (int i=0; i<examCorrectSpeakList.count; i++) {
                        NSDictionary *dic = examCorrectSpeakList[i];
                        if (![[dic objectForKey:@"IsCorrected"] isKindOfClass:[NSNull class]]) {
                            NSInteger isCorrected = [[dic objectForKey:@"IsCorrected"] integerValue];
                            if (isCorrected == 0) { //未批改
                                [IsNotCorrected addObject:[dic objectForKey:@"IsCorrected"]];
                            }
                        }
                    }
                    
                    if (IsNotCorrected.count > 0) { //未批改数量
                        [self _dealData:examCorrectSpeakList];
                    }else{ //全部批改完
                        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Name_ClassDetail object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }else
            {
            
            }
        } failure:^(NSError *error) {
            
        }];
}

- (void)_dealData:(NSArray *)dataArray
{
    if (dataArray.count > 0) {
        self.dataArray = dataArray;
        //
        self.tabScrollView.contentSize = CGSizeMake(kScreenWidth*dataArray.count, k_TopTableViewHeight);
        _titlArray = [[NSMutableArray alloc]initWithCapacity:dataArray.count];
        _scoreArray = [[NSMutableArray alloc]initWithCapacity:dataArray.count];
        for (int i=0; i<dataArray.count; i++) {
            //创建标题
            NSString *part = [NSString stringWithFormat:@"Part %d",i+1];
            [_titlArray addObject:part];
            //创建分数数组
//            @"TR",@"CC",@"LR",@"GRA"  //@"FC",@"LR",@"GRA",@"P"
            NSMutableDictionary *scoreDic = [[NSMutableDictionary alloc]initWithCapacity:4];
            [scoreDic setObject:@"0.0" forKey:@"FC"];
            [scoreDic setObject:@"0.0" forKey:@"LR"];
            [scoreDic setObject:@"0.0" forKey:@"GRA"];
            [scoreDic setObject:@"0.0" forKey:@"P"];
            [scoreDic setObject:@"0.0" forKey:@"count"];
            [_scoreArray addObject:scoreDic];
            
            //创建tableView
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, k_TopTableViewHeight) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.bounces = NO;
            tableView.tableFooterView = [[UIView alloc]init];
            tableView.tag = 200+i;
            tableView.rowHeight = k_TopTableViewHeight;
            [self.tabScrollView addSubview:tableView];
        }
        [self.segment setSegmentedNames:_titlArray];
        /*
         设置切换视图的宽度
         */
        WS(this_writer);
        [self.segment addSegmentedSelectedBlock:^(CustomSegmentedView *view, NSInteger selectedIndex, NSInteger lastSelectedIndex) {
            NDLog(@"%ld",(long)selectedIndex);
            //刷新数据
            [this_writer _firstData:selectedIndex];
            
            this_writer.indexPathRow = selectedIndex;
            //切换tabScrollView
            this_writer.tabScrollView.contentOffset = CGPointMake(kScreenWidth*selectedIndex, 0);
           
        }];
        
        [self.segment setSelectedIndex:self.indexPathRow];
        
        [self _firstData:self.indexPathRow];
    }
}
//第一次调用数据
- (void)_firstData:(NSInteger)index
{
    if (self.dataArray.count > 0) {
        NSDictionary *dataDic =  self.dataArray[index];
        //表视图刷新
        NSString *answerContent =  [dataDic objectForKey:@"AnswerContent"];  //口语地址
        CHECK_DATA_IS_NSNULL(answerContent, NSString);
        CHECK_STRING_IS_NULL(answerContent);
        if ([answerContent isEqualToString:@""]) {
            [self showHint:@"口语链接地址错误"];
            return;
        }
        self.curentSpeakUrl = answerContent;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //取之前的音频,暂停
        UITableView *beforeTab = (UITableView *)[self.tabScrollView viewWithTag:200+self.indexPathRow];
        GradeCheckModelCell *indexCellBefore =(GradeCheckModelCell *)[beforeTab cellForRowAtIndexPath:indexPath];
        if (indexCellBefore != nil) {
            if ([indexCellBefore.audioPlayer isPlaying]) {
                [indexCellBefore.audioPlayer pause];
                indexCellBefore.playButton.selected = NO;
            }
        }
        //取当前的音频,刷新视图
        UITableView *tab = (UITableView *)[self.tabScrollView viewWithTag:200+index];
        GradeCheckModelCell *indexCell =(GradeCheckModelCell *)[tab cellForRowAtIndexPath:indexPath];
        if (indexCell != nil) {
            if ( indexCell.audioPlayer == nil ) {
                [tab reloadData];
            }
        }else{
            [tab reloadData];
        }
        
        
        NSInteger isCorrected = [[dataDic objectForKey:@"IsCorrected"] integerValue];
        if (isCorrected == 0) {//未批改，正常
            [self _dealNumber:NO  atIndex:index];
            self.sureButton.hidden = NO;
        }else if(isCorrected == 1) { //已批改，显示分数.隐藏提交按钮
            [self _dealNumber:YES atIndex:index];
            self.sureButton.hidden = YES;
        }
    }
}


- (void)_dealNumber:(BOOL)hasNumber  atIndex:(NSInteger)index
{
    //获取当前数据
    NSDictionary *dataDic =  self.dataArray[index]; //
    //本地存储的成绩
    NSMutableDictionary *curentScoreDic =  _scoreArray[index];
    NSArray *scorType = @[@"FC",@"LR",@"GRA",@"P"];
    //总分
     UILabel *scoreLabel = (UILabel *)[self.numberView viewWithTag:1000];
    if (hasNumber) {            //@"FC",@"LR",@"GRA",@"P"
        NSInteger fc = 0.0;
        NSInteger lr = 0.0;
        NSInteger gra = 0.0;
        NSInteger p = 0.0;
        NSArray *scoresArray = [dataDic objectForKey:@"scores"];//分数
        for (NSDictionary *scoreDic in scoresArray) {
            NSString *name = [scoreDic objectForKey:@"Name"];
            NSInteger score = [[scoreDic objectForKey:@"Score"] integerValue];
            if ([name isEqualToString:@"FC"]) {
                fc = score;
            }else if([name isEqualToString:@"LR"])
            {
                lr = score;
            }else if ([name isEqualToString:@"GRA"])
            {
                gra = score;
            }else if ([name isEqualToString:@"P"])
            {
                p = score;
            }
        }
        [self _countScore:fc ccScore:lr trScore:gra  lrScore:p];

    }else  //正常情况
    {
        NSInteger countScore = [[curentScoreDic objectForKey:@"count"] integerValue];
        if (countScore != 0.0) {
            scoreLabel.text = [NSString stringWithFormat:@"%.1ld",(long)countScore];
        }else{
            scoreLabel.text = [NSString stringWithFormat:@"0.0"];
        }
    }
    //遍历分数控件
    for (int i=0; i<scorType.count; i++) {
        NSString *types = scorType[i];
        SelectNumberView *numberView = (SelectNumberView *)[self.numberView viewWithTag:100000+i];
        if (hasNumber) {
            NSArray *scoresArray = [dataDic objectForKey:@"scores"];//分数
            for (NSDictionary *scoreDic in scoresArray) {
                NSString *name = [scoreDic objectForKey:@"Name"];
                NSInteger score = [[scoreDic objectForKey:@"Score"] integerValue];
                if ([types isEqualToString:name]) {
                    numberView.curentScore = score;
                }
            }
            numberView.userInteractionEnabled = NO;
        }else
        {
            numberView.curentScore = [[curentScoreDic objectForKey:scorType[i]] integerValue];
            numberView.userInteractionEnabled = YES;
        }

         numberView.curentTag = _titlArray[index];
        [numberView setBlock:^(NSString *scoreType,NSString *number,NSString *curentTag){
            
            NSUInteger indexInt =  [_titlArray indexOfObject:curentTag];
            NSMutableDictionary *dic =  _scoreArray[indexInt];
            //@"FC",@"LR",@"GRA",@"P"
            if ([scoreType isEqualToString:@"FC"]) {
                [dic setObject:number forKey:@"FC"];
            }else if ([scoreType isEqualToString:@"LR"])
            {
                [dic setObject:number forKey:@"LR"];
            }else if ([scoreType isEqualToString:@"GRA"])
            {
                [dic setObject:number forKey:@"GRA"];
            }else if ([scoreType isEqualToString:@"P"])
            {
                [dic setObject:number forKey:@"P"];
            }
            
            NSInteger gra = [[dic objectForKey:@"FC"] integerValue];
            NSInteger cc = [[dic objectForKey:@"LR"] integerValue];
            NSInteger tr = [[dic objectForKey:@"GRA"] integerValue];
            NSInteger lr = [[dic objectForKey:@"P"] integerValue];
            
            NSString *value = [self _countScore:gra ccScore:cc trScore:tr  lrScore:lr];
            [dic setObject:value forKey:@"count"];
        }];
    }
}

- (NSString *)_countScore:(NSInteger)graScore ccScore:(NSInteger)ccScore
                  trScore:(NSInteger)trScore lrScore:(NSInteger)lrScore
{
    UILabel *scoreLabel = (UILabel *)[self.numberView viewWithTag:1000];
    NSInteger countScore = graScore + ccScore + trScore + lrScore;
    
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
        NSString *value = [NSString stringWithFormat:@"%.1f",totalFlaot+(float)totalInt];;
        scoreLabel.text = value;
        return value;
    }else
    {
        scoreLabel.text = [NSString stringWithFormat:@"0.0"];
        return @"0.0";
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_scoreArray.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        for (int i=0; i<_scoreArray.count; i++) {
            UITableView *tabelView =(UITableView *)[self.tabScrollView viewWithTag:200+i];
            GradeCheckModelCell *indexCell =(GradeCheckModelCell *)[tabelView cellForRowAtIndexPath:indexPath];
            if (indexCell.audioPlayer != nil) {
                [indexCell.audioPlayer  dispose];
            }
        }
    }
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    cell.urlString = self.curentSpeakUrl;
//    @"http://testielts2.staff.xdf.cn/upload_dev/fileupload/Aca_Test1_Speaking_01.mp3";
    return cell;
}
#pragma mark - <TableViewCellDelegate>
- (void)selectPlay:(UIButton *)button curentCell:(UITableViewCell *)cell
{
    if (_scoreArray.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        for (int i=0; i<_scoreArray.count; i++) {
            UITableView *tabelView =(UITableView *)[self.tabScrollView viewWithTag:200+i];
            GradeCheckModelCell *indexCell =(GradeCheckModelCell *)[tabelView cellForRowAtIndexPath:indexPath];
            if (indexCell != cell) {
                if ([indexCell.audioPlayer isPlaying]) {
                    [indexCell.audioPlayer pause];
                    indexCell.playButton.selected = NO;
                }
            }
        }
    }
}

#pragma mark -  <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offset = self.tabScrollView.contentOffset.x/self.tabScrollView.bounds.size.width;
    [self.segment setSelectedIndex:offset];
    //更新数据
    [self _firstData:offset];
    
    self.indexPathRow = offset;
   
}

#pragma mark - event response
- (void)sureButtonAction:(UIButton *)button
{
    /**
      examAnswerIds=[答题内容ID ExamAnswer，类型为字符串数组，不可为空]
      FCV=[FC成绩，不可为空]
      LRV=[LR成绩，不可为空]
      GRAV=[GRAV成绩，不可为空]
      PV=[PV成绩，不可为空]
      examInfoId=[答题信息ID ExamInfo，不可为空]
      type=[类型，1模考2口语，不可为空]
     */
    NSString *taskType = self.checkModel.taskType;
    CHECK_STRING_IS_NULL(taskType);
    
    NSDictionary *allDic = self.dataArray[self.indexPathRow];// "EXA_ID" = 577; "Ex_ID" = 94;
    NSNumber *exa_id = [allDic objectForKey:@"EXA_ID"];
    NSNumber *ex_id = [allDic objectForKey:@"Ex_ID"];
    CHECK_DATA_IS_NSNULL(ex_id, NSNumber);
    CHECK_DATA_IS_NSNULL(exa_id, NSNumber);
    NSString *exa = [exa_id stringValue];
    NSString *ex = [ex_id stringValue];
    CHECK_STRING_IS_NULL(ex);
    CHECK_STRING_IS_NULL(exa);
 //@"FC",@"LR",@"GRA",@"P"
    NSDictionary *dataDic =  self.scoreArray[self.indexPathRow];
    NSString *fc = [dataDic objectForKey:@"FC"];
    NSString *lr =  [dataDic objectForKey:@"LR"];
    NSString *gra =  [dataDic objectForKey:@"GRA"];
    NSString *p =  [dataDic objectForKey:@"P"];
    
    CHECK_STRING_IS_NULL(fc);
    CHECK_STRING_IS_NULL(lr);
    CHECK_STRING_IS_NULL(gra);
    CHECK_STRING_IS_NULL(p);
    //@[@"FC",@"LR",@"GRA",@"P"];
    if (!([fc integerValue] > 0)) {
        [self showHint:@"请选择FC分数"];
        return;
    }
    
    if (!([lr integerValue] > 0)) {
        [self showHint:@"请选择LR分数"];
        return;
    }
    
    if (!([gra integerValue] > 0)) {
        [self showHint:@"请选择GRA分数"];
        return;
    }
    
    if (!([p integerValue] > 0)) {
        [self showHint:@"请选择P分数"];
        return;
    }
    
    NSDictionary *dic = @{@"examAnswerIds":exa,
                          @"FCV":fc,
                          @"LRV":lr,
                          @"GRAV":gra,
                          @"PV":p,
                          @"examInfoId":ex,
                          @"type":taskType};
    [self showHudInView:self.view hint:@"正在提交..."];
    [[Service sharedInstance]finishKyCorrectingWithDic:dic
                                              succcess:^(NSDictionary *result) {
                                                  [self hideHud];
                                                  if (k_IsSuccess(result)) {
                                                      [self _initData];
                                                  }else{
                                                      if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                                                          [self showHint:[result objectForKey:@"Infomation"]];
                                                      }
                                                  }
                                              } failure:^(NSError *error) {
                                                  [self hideHud];
                                                  NSString *network =  [error networkErrorInfo];
                                                  [self showHint:network];
                                              }];

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

- (UIScrollView *)tabScrollView
{
    if (!_tabScrollView) {
        _tabScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight+5+k_TopSegmentHeight, kScreenWidth, k_TopTableViewHeight)];
        _tabScrollView.showsHorizontalScrollIndicator = NO;
        _tabScrollView.showsVerticalScrollIndicator = NO;
        _tabScrollView.pagingEnabled = YES;
        _tabScrollView.delegate = self;
    }
    return _tabScrollView;
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

- (CustomSegmentedView *)segment
{
    if (!_segment) {
        _segment = [[CustomSegmentedView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, k_TopSegmentHeight) type:SEGMENTED_TYPE_NORMAL_ESSENCE_LISTENS_LIST];
    }
    return _segment;
}

@end
