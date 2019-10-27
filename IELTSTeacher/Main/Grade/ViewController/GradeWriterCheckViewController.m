//
//  GradeWriterCheckViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeWriterCheckViewController.h"
//#import "GradeCheckWriterModel.h"
#import "CustomSegmentedView.h"
#import "SelectNumberView.h"

#define k_TopSegmentHeight 44*AUTO_SIZE_SCALE_X
#define k_TopTableViewHeight 93*AUTO_SIZE_SCALE_X

#define k_NumberViewHeight 375*AUTO_SIZE_SCALE_Y
#define k_sureButton   45*AUTO_SIZE_SCALE_Y

@interface GradeWriterCheckViewController ()<UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) UIButton *sureButton;  //确认按钮
@property (nonatomic,strong) NSMutableArray *dataArray; //获取的数据
@property (nonatomic,strong) NSMutableArray *titleArray;//标题数组

@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,strong) UIScrollView *verticalScrollView;  //竖向
@property (nonatomic,strong) UIScrollView *landscapeScrollView; //横向

@property (nonatomic,strong) CustomSegmentedView *segment;

//@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIView    *numberView;  //选择数据的视图

@property (nonatomic,strong)  NSMutableArray *scoreArray;//存储成绩的数组

/*
  记录分数
 */
//@property (nonatomic,assign) NSInteger trScore;
//@property (nonatomic,assign) NSInteger ccScore;
//@property (nonatomic,assign) NSInteger lrScore;
//@property (nonatomic,assign) NSInteger graScore;


@end

@implementation GradeWriterCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     self.titles = @"书信写作";
    
    [self _initView];
    
    [self _initData];
    
}

- (void)_initView
{
    
    [self.view addSubview:self.verticalScrollView];
    [self.verticalScrollView addSubview:self.segment]; //切换的
    [self.verticalScrollView addSubview:self.landscapeScrollView]; //滑动视图

    [self.verticalScrollView addSubview:self.sureButton]; //确定按钮
    [self.verticalScrollView addSubview:self.numberView]; //选分控件
    
    /*
     创建webView
     */
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
    
    NSArray *typeArray  = @[@"TA",@"CC",@"LR",@"GRA"];
    //创建分数视图
    for (int j=0; j<typeArray.count; j++) {
        SelectNumberView *numberView = [[SelectNumberView alloc]initWithFrame:CGRectMake(20*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_Y+55*AUTO_SIZE_SCALE_Y*j, kScreenWidth-40*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_Y)];
        numberView.numberData = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        numberView.scoreType = typeArray[j];
        numberView.tag = 10000+j;
        [self.numberView addSubview:numberView];
    }

    //视图约束
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 375*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo (this_speakMode.landscapeScrollView.mas_bottom);
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


-(void)_initData
{
//    13是写作练习
//    128是写作模考
    _dataArray = [[NSMutableArray alloc]init];
    _titleArray = [[NSMutableArray alloc]init];
    
//    NSString *examId = @"128";
    CHECK_DATA_IS_NSNULL(self.checkModel.examID, NSNumber);
    NSString *examId = [self.checkModel.examID stringValue];
    CHECK_DATA_IS_NSNULL(self.checkModel.paperId, NSNumber);
    NSString *paperId = [self.checkModel.paperId stringValue];
    [[Service sharedInstance]examCorrectingWithexamInfoId:examId
                                                  paperId:paperId
                                                 succcess:^(NSDictionary *result) {
         if (k_IsSuccess(result)) {
             NSDictionary *dataDic =   [result objectForKey:@"Data"];
             CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
             if (![[dataDic objectForKey:@"examCorrectingList"] isKindOfClass:[NSNull class]]) {
                 NSArray *examCorrectingList = [dataDic objectForKey:@"examCorrectingList"];
                 CHECK_DATA_IS_NSNULL(examCorrectingList, NSArray);
                 if (examCorrectingList.count > 0) {
                     
                     NSMutableArray *IsNotCorrected = [[NSMutableArray alloc]initWithCapacity:examCorrectingList.count];
                     for (int i=0; i<examCorrectingList.count; i++) {
                         NSDictionary *dic = examCorrectingList[i];
                         [_dataArray addObject:dic];
                         
                         if (![[dic objectForKey:@"IsCorrected"] isKindOfClass:[NSNull class]]) {
                             NSInteger isCorrected = [[dic objectForKey:@"IsCorrected"] integerValue];
                             if (isCorrected == 0) { //未批改
                                 [IsNotCorrected addObject:[dic objectForKey:@"IsCorrected"]];
                             }
                         }
            
                         NSString *string = [NSString stringWithFormat:@"task%d",i+1];
                         [_titleArray addObject:string];
                     }
                
                     if (IsNotCorrected.count > 0) { //未批改数量
                         [self _dealData];
                     }else{
                         [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Name_ClassDetail
                                                                            object:nil];
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                 }
             }
         }else{
           
         }
    } failure:^(NSError *error) {
        NSString *er = [error networkErrorInfo];
        [self showHint:er];
    }];
}

- (void)_dealData
{
    if (_dataArray.count > 0) {
        /*
         设置滑动视图的宽度
         */
        [self.segment setSegmentedNames:_titleArray];
        
        self.landscapeScrollView.contentSize = CGSizeMake(kScreenWidth*_titleArray.count,0);
        
        _scoreArray = [[NSMutableArray alloc]initWithCapacity:_titleArray.count];
        for (int i=0; i<_titleArray.count; i++) {
            
            NSMutableDictionary *scoreDic = [[NSMutableDictionary alloc]initWithCapacity:4];
            [scoreDic setObject:@"0.0" forKey:@"TA"];
            [scoreDic setObject:@"0.0" forKey:@"CC"];
            [scoreDic setObject:@"0.0" forKey:@"LR"];
            [scoreDic setObject:@"0.0" forKey:@"GRA"];
            [scoreDic setObject:@"0.0" forKey:@"count"];
            [_scoreArray addObject:scoreDic];
            
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, 1)];
            webView.backgroundColor = [UIColor clearColor];
            webView.userInteractionEnabled = NO;
            [webView setOpaque:NO];
            webView.delegate = self;
            webView.tag = 1230+i;
            [self.landscapeScrollView addSubview:webView];
        }
        
        /*
         设置切换视图的宽度
         */
        WS(this_writer);
        [self.segment addSegmentedSelectedBlock:^(CustomSegmentedView *view, NSInteger selectedIndex, NSInteger lastSelectedIndex) {
            NDLog(@"%ld",(long)selectedIndex);
            if (this_writer.indexPathRow != selectedIndex) {
                
                UIWebView *webView = (UIWebView *)[this_writer.landscapeScrollView viewWithTag:1230+selectedIndex];
                webView.frame = CGRectMake(kScreenWidth*selectedIndex, 0, kScreenWidth, 1);
                //加载对应的网页
                [this_writer selectWebView:selectedIndex];
                
                this_writer.indexPathRow = selectedIndex;
                
                this_writer.landscapeScrollView.contentOffset = CGPointMake(kScreenWidth*selectedIndex, 0);
            }
            
        }];
        
        [self.segment setSelectedIndex:0];
        [self selectWebView:0];
    }
}

- (void)selectWebView:(NSInteger)indexRow
{
    NSDictionary *dataDic = _dataArray[indexRow];
    NSString * AnswerContent =[dataDic objectForKey:@"AnswerContent"];
    CHECK_DATA_IS_NSNULL(AnswerContent, NSString);
    CHECK_STRING_IS_NULL(AnswerContent);
    NSString *body =  AnswerContent;
    
    UIWebView *webView = (UIWebView *)[self.landscapeScrollView viewWithTag:1230+indexRow];
    [webView loadHTMLString:body baseURL:nil];
    
    NSInteger isCorrected = [[dataDic objectForKey:@"IsCorrected"] integerValue];
    if (isCorrected == 0) {//未批改，正常
        [self _dealNumber:NO  atIndex:indexRow];
        self.sureButton.hidden = NO;
    }else if(isCorrected == 1) { //已批改，显示分数.隐藏提交按钮
        [self _dealNumber:YES atIndex:indexRow];
        self.sureButton.hidden = YES;
    }
}

//重新计算高度
- (void)_loadNewView
{
    UIWebView *webView = (UIWebView *)[self.landscapeScrollView viewWithTag:1230+self.indexPathRow];
    self.landscapeScrollView.contentOffset = CGPointMake(kScreenWidth*self.indexPathRow, 0);
    self.landscapeScrollView.frame = CGRectMake(0, k_TopSegmentHeight, kScreenWidth, webView.frame.size.height);
    //计算纵向滑动视图的内容高度
    self.verticalScrollView.contentSize = CGSizeMake(kScreenWidth, k_NumberViewHeight+k_sureButton+(20*2)*AUTO_SIZE_SCALE_Y+webView.frame.size.height+k_TopSegmentHeight);
}

- (void)_dealNumber:(BOOL)hasNumber  atIndex:(NSInteger)index
{
    //获取当前数据
    NSDictionary *dataDic =  self.dataArray[index];
    //已批改的分数设定
    NSArray *scoresArray = [dataDic objectForKey:@"scores"];//分数
    
    NSMutableDictionary *curentScoreDic =  _scoreArray[index];
    NSArray *scorType = @[@"TA",@"CC",@"LR",@"GRA"];
    //总分
    NSInteger countScore = [[curentScoreDic objectForKey:@"count"] integerValue];
    UILabel *scoreLabel = (UILabel *)[self.numberView viewWithTag:1000];
    if (countScore != 0.0) {
        scoreLabel.text = [NSString stringWithFormat:@"%.1ld",(long)countScore];
    }else
    {
        scoreLabel.text = [NSString stringWithFormat:@"0.0"];
    }
    //遍历分数控件
    NSInteger GRA = 0.0;
    NSInteger CC = 0.0;
    NSInteger TR = 0.0;
    NSInteger LR = 0.0;
    for (int i=0; i<scorType.count; i++) {
        SelectNumberView *numberView = (SelectNumberView *)[self.numberView viewWithTag:10000+i];
        if (hasNumber) {
            
            
            for (NSDictionary *scoresDic in scoresArray) {
                NSString *Name = [scoresDic objectForKey:@"Name"];
                CHECK_DATA_IS_NSNULL(Name, NSString);
                CHECK_STRING_IS_NULL(Name);
                if ([Name isEqualToString:scorType[i]])
                {
                    if (![[scoresDic objectForKey:@"Score"] isKindOfClass:[NSNull class]]) {
                        NSInteger Score =  [[scoresDic objectForKey:@"Score"] integerValue];
                        numberView.curentScore =Score;
                        if ([Name isEqualToString:@"GRA"]) {
                            GRA = Score;
                        }else if ([Name isEqualToString:@"CC"])
                        {
                            CC = Score;
                        }else if ([Name isEqualToString:@"TA"])
                        {
                            TR = Score;
                        }else if ([Name isEqualToString:@"LR"])
                        {
                            LR = Score;
                        }
                    }
                }
            }
            
            numberView.userInteractionEnabled = NO;
            [self _countScore:GRA ccScore:CC trScore:TR lrScore:LR];

        }else
        {
            numberView.userInteractionEnabled = YES;
            numberView.curentScore = [[curentScoreDic objectForKey:scorType[i]] integerValue];
            numberView.curentTag = _titleArray[index];
        }
    
        [numberView setBlock:^(NSString *scoreType,NSString *number,NSString *curentTag){
            
            NSUInteger indexInt =  [_titleArray indexOfObject:curentTag];
            NSMutableDictionary *dic =  _scoreArray[indexInt];
            
            if ([scoreType isEqualToString:@"GRA"]) {
                
                [dic setObject:number forKey:@"GRA"];
                
            }else if ([scoreType isEqualToString:@"CC"])
            {
                [dic setObject:number forKey:@"CC"];
            }else if ([scoreType isEqualToString:@"TA"])
            {
                [dic setObject:number forKey:@"TA"];
                
            }else if ([scoreType isEqualToString:@"LR"])
            {
                [dic setObject:number forKey:@"LR"];
            }
            
            NSInteger gra = [[dic objectForKey:@"GRA"] integerValue];
            NSInteger cc = [[dic objectForKey:@"CC"] integerValue];
            NSInteger tr = [[dic objectForKey:@"TA"] integerValue];
            NSInteger lr = [[dic objectForKey:@"LR"] integerValue];
            
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


#pragma mark - delegate
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.landscapeScrollView) {
        
        NSInteger offset = scrollView.contentOffset.x/kScreenWidth;
        if (self.indexPathRow != offset) {
            
            self.indexPathRow = offset;
            
            UIWebView *webView = (UIWebView *)[self.landscapeScrollView viewWithTag:1230+self.indexPathRow];
            webView.frame = CGRectMake(kScreenWidth*self.indexPathRow, 0, kScreenWidth, 1);
            
            //加载对应的网页
            [self selectWebView:offset];
            [self.segment setSelectedIndex:offset];
        }
    }
   
}
#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    
    UIWebView *webViews = (UIWebView *)[self.landscapeScrollView viewWithTag:1230+self.indexPathRow];
    webViews.frame = frame;
    
    //加载完成之后更新视图
    [self _loadNewView];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}


#pragma mark - event response
- (void)sureButtonAction:(UIButton *)button
{
    /**
      TRV=[TRV成绩，不可为空]
      CCV=[CCV成绩，不可为空]
      LRV=[LRV成绩，不可为空]
      GRAV=[GRAV成绩，不可为空]
      examInfoId=[答题信息ID ExamInfo，不可为空]
      examAnswerId=[答题内容ID ExamAnswer，不可为空]
     */
    if (self.dataArray.count > 0) {
        
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
        
        NSDictionary *dataDic =  self.scoreArray[self.indexPathRow];
        NSString *gra = [dataDic objectForKey:@"GRA"];
        NSString *cc =  [dataDic objectForKey:@"CC"];
        NSString *tr =  [dataDic objectForKey:@"TA"];
        NSString *lr =  [dataDic objectForKey:@"LR"];
        
        CHECK_STRING_IS_NULL(gra);
        CHECK_STRING_IS_NULL(cc);
        CHECK_STRING_IS_NULL(tr);
        CHECK_STRING_IS_NULL(lr);
        ///@[@"TR",@"CC",@"LR",@"GRA"];
        if (!([tr integerValue] > 0)) {
            [self showHint:@"请选择TA分数"];
            return;
        }
        
        if (!([cc integerValue] > 0)) {
            [self showHint:@"请选择CC分数"];
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
        NSDictionary *dic = @{@"TRV":tr,
                              @"CCV":cc,
                              @"LRV":lr,
                              @"GRAV":gra,
                              @"examInfoId":ex,
                              @"examAnswerId":exa_id};
        
        [self showHudInView:self.view hint:@"正在提交..."];
        [[Service sharedInstance]finishXzCorrectingWithDic:dic succcess:^(NSDictionary *result) {
            //1.如果只有一篇，直接提交退出
            //2.如果多篇，提交完成刷新数据。
            [self hideHud];
            if (k_IsSuccess(result)) {
                [self showHint:@"批改成功"];
                //更新详情页的数据
                [self _initData];
            }else{
                if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                    [self showHint:[result objectForKey:@"Infomation"] ];
                }
            }
        } failure:^(NSError *error) {
            [self hideHud];
            NSString *network = [error networkErrorInfo];
            [self showHint:network];
        }];
    }else
    {
        [self showHint:@"无法提交..."];
    }
}

#pragma mark - set or get
- (UIScrollView *)verticalScrollView
{
    if (!_verticalScrollView) {
        _verticalScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y)];
        _verticalScrollView.showsHorizontalScrollIndicator = NO;
        _verticalScrollView.showsVerticalScrollIndicator = NO;
    }
    return _verticalScrollView;
}

- (UIScrollView *)landscapeScrollView
{
    if (!_landscapeScrollView) {
        _landscapeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _landscapeScrollView.showsHorizontalScrollIndicator = NO;
        _landscapeScrollView.showsVerticalScrollIndicator = NO;
        _landscapeScrollView.pagingEnabled = YES;
        _landscapeScrollView.delegate = self;
    }
    return _landscapeScrollView;
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
        _segment = [[CustomSegmentedView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, k_TopSegmentHeight) type:SEGMENTED_TYPE_NORMAL_ESSENCE_LISTENS_LIST];
    }
    return _segment;
}


@end
