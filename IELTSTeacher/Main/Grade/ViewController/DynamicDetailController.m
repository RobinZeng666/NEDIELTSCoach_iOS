//
//  DynamicDetailController.m
//  IELTSStudent
//
//  Created by DevNiudun on 15/7/12.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "DynamicDetailController.h"

#define k_curentFont 18.0f
#define kleftGap  13*AUTO_SIZE_SCALE_X
@interface DynamicDetailController ()

@property (nonatomic,strong) UIView  *topView;   //顶部视图
@property (nonatomic,strong) UILabel *titleLabel;//试卷标题
@property (nonatomic,strong) UIView  *lineView;  //标题下面的线

@property (nonatomic,strong) UIImageView *tipImageView;
@property (nonatomic,strong) UILabel *tipLabel;

@end

@implementation DynamicDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"任务查看";
    
    /**
     初始化视图
     */
    [self _initView];
    
    /**
     初始化数据
     */
    [self _initData];
    
}
- (void)_initView
{
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.lineView];

    [self.view addSubview:self.tipImageView];
    [self.view addSubview:self.tipLabel];
    
    WS(this_dynamicDeatail);
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kNavHeight+12*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 44*7*AUTO_SIZE_SCALE_Y));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kleftGap);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-kleftGap*2, 44*AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_dynamicDeatail.titleLabel.mas_bottom);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    NSArray *title = @[@"时间:",@"类型:",@"班型:",@"题目数量:",@"课次:",@"性质:"];
    
    for (int i=0; i<title.count ; i++) {
        UILabel *titleLabel =  [CommentMethod createLabelWithFont:k_curentFont Text:title[i]];
        titleLabel.textColor = [UIColor darkGrayColor];
        [self.topView addSubview:titleLabel];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kleftGap);
            make.height.mas_equalTo(44*AUTO_SIZE_SCALE_Y);
            make.top.mas_equalTo(44*AUTO_SIZE_SCALE_Y*(i+1));
        }];
        
        UILabel *contentLabel = [CommentMethod createLabelWithFont:k_curentFont Text:@""];
        contentLabel.tag = 100+i;
        contentLabel.textColor = [UIColor darkGrayColor];
        [self.topView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-100*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_Y));
            make.top.mas_equalTo(44*AUTO_SIZE_SCALE_Y*(i+1));
        }];
    }
    //19*17
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_Y));
        make.right.mas_equalTo(this_dynamicDeatail.tipLabel.left).with.offset(-5);
        make.centerY.mas_equalTo(this_dynamicDeatail.tipLabel);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_dynamicDeatail.view).with.offset(10);
        make.top.mas_equalTo(this_dynamicDeatail.topView.mas_bottom).with.offset(20);
    }];
    
}

- (void)_initData
{
    CHECK_DATA_IS_NSNULL(self.model.ST_ID, NSNumber);
    CHECK_DATA_IS_NSNULL(self.model.RefID, NSNumber);
    
    NSDictionary *dicData = @{@"stId":[self.model.ST_ID stringValue],
                              @"pId":[self.model.RefID stringValue]};
    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service sharedInstance]getPapersInfo:dicData
                                  succcess:^(NSDictionary *result) {
                                      if (k_IsSuccess(result)) {
                                          NSDictionary *dataDic = [result objectForKey:@"Data"];
                                          [self _dealTheData:dataDic];
                                      }else
                                      {
                                          [self showHint:@"任务-获取模考失败!"];
                                      }
                                      [self hideHud];
                                  } failure:^(NSError *error) {
                                       NDLog(@"任务-获取模考、练习信息,出现错误");
                                      [self hideHud];
                                  }];
}

- (void)_dealTheData:(NSDictionary *)dataDic
{
    if (dataDic.count > 0) {
        NSString *name = [dataDic objectForKey:@"Name"];
        CHECK_DATA_IS_NSNULL(name, NSString);
        self.titleLabel.text = name;
        
        UILabel *timeLabel =  (UILabel *)[self.topView viewWithTag:100];
        UILabel *typeLabel =  (UILabel *)[self.topView viewWithTag:101];
        UILabel *classTypeLabel =  (UILabel *)[self.topView viewWithTag:102];
        UILabel *classNumLabel =  (UILabel *) [self.topView viewWithTag:103];
        UILabel *otherLabel =  (UILabel *)[self.topView viewWithTag:104];
        
        UILabel *taskPropertyLabel =  (UILabel *)[self.topView viewWithTag:105];
        
        NSString *OpenDate = [dataDic objectForKey:@"OpenDate"];
        CHECK_DATA_IS_NSNULL(OpenDate, NSString);
        timeLabel.text = OpenDate;
        
        /*
         TaskProperty 性质：-1.预测、 0. 随堂、  1. 复习
         */
        
        if (![[dataDic objectForKey:@"TaskProperty"] isKindOfClass:[NSNull class]]) {
            NSString *taskProperty = [[dataDic objectForKey:@"TaskProperty"] stringValue];
            CHECK_DATA_IS_NSNULL(taskProperty , NSString);
            if ([taskProperty isEqualToString:@"-1"]) {
                taskPropertyLabel.text = @"预习";
            }else if ([taskProperty isEqualToString:@"0"]){
                taskPropertyLabel.text = @"随堂";
            }else if ([taskProperty isEqualToString:@"1"]){
                taskPropertyLabel.text = @"复习";
            }
        }
        
        /**
         *  TaskType 类型： 1 模考、 2 练习 3资料
         */
        NSNumber *TaskType = [dataDic objectForKey:@"TaskType"];
        CHECK_DATA_IS_NSNULL(TaskType , NSNumber);
        NSInteger taskType = [TaskType integerValue];
        if (taskType == 1) {
            typeLabel.text = @"模考考试";
        }else if(taskType == 2)
        {
            typeLabel.text = @"练习考试";
        }else if (taskType == 4)
        {
            typeLabel.text = @"测试试卷";
        }
            
        /**
         *  班型
         */
        NSDictionary *classType = [dataDic objectForKey:@"classType"];
        CHECK_DATA_IS_NSNULL(classType, NSDictionary);
        if (classType.count > 0) {
            NSString *sName = [classType objectForKey:@"sName"];
            CHECK_DATA_IS_NSNULL(sName, NSString);
            CHECK_STRING_IS_NULL(sName);
            classTypeLabel.text = sName;
        }
        
        /**
         *  题目数量
         */
        
        NSNumber *questionNum = [dataDic objectForKey:@"questionNum"];
        CHECK_DATA_IS_NSNULL(questionNum, NSNumber);
        classNumLabel.text = [questionNum stringValue];
        
        /**
         *  课次
         */
        if (![[dataDic objectForKey:@"lessonNo"] isKindOfClass:[NSNull class]]) {
            NSDictionary *lessonNO = [dataDic objectForKey:@"lessonNo"];
            NSNumber *nlessonNo = [lessonNO objectForKey:@"nLessonNo"];
            CHECK_DATA_IS_NSNULL(nlessonNo, NSNumber);
            otherLabel.text = [NSString stringWithFormat:@"第%@课",[nlessonNo stringValue]];
        }
    }
}

#pragma mark - set or get 
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [CommentMethod createLabelWithFont:18.0f Text:@""];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20.0f*AUTO_SIZE_SCALE_X];
    }
    return _titleLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBACOLOR(230.0, 230.0, 230.0, 1.0);
    }
    return _lineView;
}

- (UIImageView *)tipImageView
{
    if (!_tipImageView) {
        _tipImageView = [CommentMethod createImageViewWithImageName:@"dynamic_gantanhao.png"];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [CommentMethod createLabelWithFont:k_curentFont Text:@"建议在web端或者iPad端完成任务"];
        _tipLabel.textColor = k_PinkColor;
    }
    return _tipLabel;
}



@end
