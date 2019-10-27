//
//  ClassRoomViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ClassRoomViewController.h"
#import "IEButton.h"
#import "SynchronousViewController.h"
#import "IEContentView.h"
#import "IEView.h"
#import "FDAlertView.h"
#import "IEClassModel.h"
#import "IEClassTableViewCell.h"
#import "MainViewController.h"
#import "CustomAlertView.h"
#import "TipLabel.h"
@interface ClassRoomViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  课堂暗号
 */
@property(nonatomic,strong)UILabel * classLabel;
/**
 *  暗号
 */
@property(nonatomic,strong)UILabel * numberLabel;
/**
 *  注释
 */
@property(nonatomic,strong)UILabel * annotationLabel;
/**
 *  同步按钮
 */
@property(nonatomic,strong)UIButton * synchronousButton;
/**
 *  按钮容器
 */
@property (nonatomic,strong) IEContentView * containerView;
@property (nonatomic,strong) NSMutableArray * listMAry;
@property (nonatomic,strong) NSString *passCode;
@property (nonatomic,strong) NSString *ccId;
@property (nonatomic,strong) NSNumber *nLessonNO;
@property (nonatomic,assign) BOOL  isFirst;
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) NSNumber *nub1;
@property (nonatomic,strong) NSNumber *nub2;
@property (nonatomic,strong) NSNumber *nub0;
@property (nonatomic,strong) NSNumber *lessonType;
@property (nonatomic,strong) UIButton *currentBtn;
@property (nonatomic,strong) FDAlertView *alert1;
@property (nonatomic,assign) NSInteger index;
@end

@implementation ClassRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles = @"课堂互动";
    _index = -1;
    WS(this_classRoom);
    [self.view addSubview:self.classLabel];
    [self.view  addSubview:self.numberLabel];
    [self.view  addSubview:self.annotationLabel];
    [self.view  addSubview:self.synchronousButton];
    [self.view  addSubview:self.containerView];
        //暗号标题
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+3+65/3*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_classRoom.view);
    }];
    //暗号数字
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_classRoom.classLabel.mas_bottom).with.offset(60/3*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_classRoom.view);
        make.height.mas_equalTo(158/3*AUTO_SIZE_SCALE_Y );
        make.width.mas_equalTo(1010/3*AUTO_SIZE_SCALE_X);
    }];
    //暗号注释
    [self.annotationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_classRoom.numberLabel.mas_bottom).with.offset(31/3*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_classRoom.view);
        make.width.mas_equalTo(650/3*AUTO_SIZE_SCALE_X );
    }];
    //同步到课堂按钮
    [self.synchronousButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_classRoom.annotationLabel.mas_bottom).with.offset(58/3*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_classRoom.view);
        make.height.mas_equalTo(137/3*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(this_classRoom.numberLabel);
    }];
    //父容器
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_classRoom.view);
        make.top.mas_equalTo(this_classRoom.synchronousButton.mas_bottom).with.offset(158/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(this_classRoom.view.mas_left);
        make.bottom.mas_equalTo(this_classRoom.view.mas_bottom);
        make.right.mas_equalTo(this_classRoom.view.mas_right);
    }];
    
/*
 下课通知，清楚上一次课的暗号，重新选课
 */
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(classOver) name:Notification_Name_ClassOver object:nil];
}

- (void)classOver
{
     _isFirst = NO;
    self.data = nil;
    self.numberLabel.text = @"";
}

#pragma mark 
- (void)_requestClassCode
{
    if (!_isFirst) {
        //选择课次
        FDAlertView *alert = [[FDAlertView alloc]init];
        self.alert1 = alert;
        IEView *whiteView = [[IEView alloc]init];
        whiteView.frame = CGRectMake(0, 0, kScreenWidth- AUTO_SIZE_SCALE_X*40*2, kScreenHeight*0.4);
        whiteView.cancleBtn.alpha = 0;
        [whiteView.contentLabel removeFromSuperview];
        [whiteView.mainBtn  setTitle:@"确定" forState:UIControlStateNormal];
        
        UIButton *canclebtn = [[UIButton alloc]init];
        canclebtn.frame = CGRectMake(kScreenWidth- AUTO_SIZE_SCALE_X*40*2-25*AUTO_SIZE_SCALE_X-20*AUTO_SIZE_SCALE_X, 0, 20*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_Y);
        [canclebtn setImage:[UIImage imageNamed:@"classRoom_guanbi_dianji"] forState:UIControlStateNormal];
        [canclebtn  addTarget:self action:@selector(canclebtnClick) forControlEvents:UIControlEventTouchUpInside ];
        [whiteView  addSubview:canclebtn];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.frame = CGRectMake(0, 30*AUTO_SIZE_SCALE_Y, kScreenWidth- AUTO_SIZE_SCALE_X *40*2, 25*AUTO_SIZE_SCALE_Y);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"选择当前课次";
        nameLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        nameLabel.font = [UIFont systemFontOfSize:18*AUTO_SIZE_SCALE_Y];
        whiteView.titleLabel.alpha = 0;
        [whiteView  addSubview:nameLabel];
        
        UITableView *tabelView = [[UITableView alloc]init];
        tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tabelView.showsVerticalScrollIndicator = NO;
        tabelView.frame = CGRectMake(0, 60 * AUTO_SIZE_SCALE_Y ,
                                     kScreenWidth- AUTO_SIZE_SCALE_X * 40*2, 155 * AUTO_SIZE_SCALE_Y );
        tabelView.delegate = self;
        tabelView.dataSource = self;
        [whiteView  addSubview:tabelView];
        alert.contentView = whiteView;
        [alert show];
        
        whiteView.block = ^(BOOL isShut){
            
            if (self.listMAry.count>0) {
                NDLog(@"%ld",(long)self.index);
            
                if (self.index == -1)
                {
                    [self showHint:@"请您选课"];
                }else
                {
                    IEClassModel * models = self.listMAry[self.index];
                    _ccId = models.ID;
                    _nLessonNO = models.nLessonNo;
                    NDLog(@"%@",models.nLessonNo);
                    
                    NSString *sTeacherId = [ConfigData sharedInstance].sTeacherId;
                    [[Service sharedInstance]SaveActiveClassProWithTeacherCode:sTeacherId
                                                                          ccId:_ccId
                                                                     nLessonNo:_nLessonNO
                                                                       success:^(NSDictionary *result) {
                       if (k_IsSuccess(result)) {
                           NSString *data = [result  objectForKey:@"Data"];
                           CHECK_DATA_IS_NSNULL(data, NSString);
                           self.data = data;
                           self.numberLabel.text = self.data;
                           if (self.numberLabel.text != nil){
                               [alert hide];
                           }
                       }
                   } failure:^(NSError *error) {
                       //失败
                       [self showHint:[error networkErrorInfo]];
                   }];
                }
                _isFirst = YES;
            }
        };
    }
}
//取消按钮点击事件
- (void)canclebtnClick
{
    _isFirst = NO;
   [self.alert1 hide];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //如果暗号文本有值 就不让弹出提示框
    [self delayAction];
}
- (void)delayAction
{
    NSString *sTeacherId =  [ConfigData sharedInstance].sTeacherId;
    CHECK_DATA_IS_NSNULL(sTeacherId, NSString);
    [self showHudInView:self.view hint:@"加载中..."];
    [[Service sharedInstance]getTeacherLessonAndPassCodeWithTeacherCode:sTeacherId
                                                                success:^(NSDictionary *result) {

        [self hideHud];
        if (k_IsSuccess(result)) {
            NSDictionary *dataDic = [result  objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
            NSNumber *lessonType = [dataDic  objectForKey:@"lessonType"];
            CHECK_DATA_IS_NSNULL(lessonType, NSNumber);
            self.lessonType = lessonType;

            _nub0 = [NSNumber numberWithLong:0];
            _nub1 = [NSNumber numberWithLong:1];
            _nub2 = [NSNumber numberWithLong:2];
            
            //进行判断
            if ( [lessonType isEqualToNumber:_nub0] )
            {
                [self showHint:@"该老师没有课"];
                return ;
            }else if ([lessonType isEqualToNumber: _nub1])
            {
                NSNumber *passCode = [dataDic  objectForKey:@"passCode"];
                CHECK_DATA_IS_NSNULL(passCode, NSNumber);

                self.passCode = (NSString *)passCode;
                self.numberLabel.text = self.passCode;
                NSDictionary *lesson = [dataDic  objectForKey:@"lesson"];
                CHECK_DATA_IS_NSNULL(lesson, NSDictionary);
                NSString *ccId = [lesson  objectForKey:@"ID"];
                CHECK_DATA_IS_NSNULL(ccId, NSString);
                self.ccId = ccId;

                NSNumber *lessonNo = [lesson objectForKey:@"nLessonNo"];
                CHECK_DATA_IS_NSNULL(lessonNo, NSNumber);
                self.nLessonNO = lessonNo;

                _isFirst = YES;
            }else if ([lessonType isEqualToNumber: _nub2])
            {
                NSArray *listAry = [dataDic  objectForKey:@"listLessons"];
                
                _listMAry = [[NSMutableArray  alloc]initWithCapacity:listAry.count];
                if (dataDic.count > 0) {
                    for (NSDictionary *dic in listAry) {
                        IEClassModel *model = [[IEClassModel alloc]initWithDataDic:dic];
                        [_listMAry addObject:model];
                    }

                }
                [self _requestClassCode];
            }
            
        }else{
            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                [self showHint:[result objectForKey:@"Infomation"]];
            }
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        //失败
        [self showHint:[error networkErrorInfo]];
    }];
}

//同步到课堂
- (void)didClick
{
    NSString *sTeacherId = [ConfigData sharedInstance].sTeacherId;
    CHECK_DATA_IS_NSNULL(sTeacherId, NSString);
    CHECK_DATA_IS_NSNULL(self.passCode, NSString);

    if (self.passCode == nil && self.data == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"请您点击课堂进行选课"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }else{
        
        [[Service sharedInstance]TeacherSyncActiveClassWithpassCode:self.numberLabel.text
                                                        teacherCode:sTeacherId
                                                               ccId:self.ccId
                                                          nLessonNo:[self.nLessonNO stringValue]
                                                            success:^(NSDictionary *result) {

        } failure:^(NSError *error) {
            //失败
            [self showHint:[error networkErrorInfo]];
        }];
        
        SynchronousViewController * synch = [[SynchronousViewController alloc]init];
        synch.numLabel.text = [NSString stringWithFormat:@"%@",self.passCode];

        if (_lessonType == _nub1) {
            synch.numLabel.text = self.passCode ;
        }else if(_lessonType == _nub2){
            synch.numLabel.text = self.data;
        }
        synch.ccId = self.ccId;
        
        [self.navigationController pushViewController:synch animated:YES];
    }
}

#pragma mark - event response
- (void)_initAlertViewTip:(NSString *)textString fromRange:(int)fromValue toRange:(int)toValue
{
    FDAlertView *alert = [[FDAlertView alloc]init];
    IEView *whiteView = [[IEView alloc]init];
    whiteView.titleLabel.font = [UIFont systemFontOfSize:18*AUTO_SIZE_SCALE_X];
    whiteView.contentLabel.alpha = 0;
    UILabel * contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(25*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_Y, whiteView.frame.size.width - 50*AUTO_SIZE_SCALE_X, 80*AUTO_SIZE_SCALE_Y)];
    contentlabel.text = textString;
    contentlabel.font = [UIFont  systemFontOfSize:16*AUTO_SIZE_SCALE_X];
    contentlabel.numberOfLines = 0;
    contentlabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentlabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:k_PinkColor range:NSMakeRange(fromValue,toValue)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:10*AUTO_SIZE_SCALE_Y];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [contentlabel.text length])];
    [contentlabel setAttributedText:str];
    [contentlabel sizeToFit];
    [whiteView addSubview:contentlabel];
    alert.contentView = whiteView;
    [alert show];
    whiteView.block = ^(BOOL isShut){
        [alert hide];
    };
}
//答题卡点击事件
-(void)sheetClick
{
    [self _initAlertViewTip:@"选择答题形式前，请先同步到所在课堂再选择练习形式" fromRange:10 toRange:7];
}
//分组练点击
- (void)practiceClick
{
    [self _initAlertViewTip:@"选择分组前，请先同步到所在课堂" fromRange:8 toRange:7];
}
//投票的点击
- (void)voteClick
{
    [self _initAlertViewTip:@"选择投票前，请先同步到所在课堂" fromRange:8 toRange:7];
}

//更多点击
- (void)moreClick
{
    [[CustomAlertView sharedAlertView]creatAlertView];
    [[CustomAlertView sharedAlertView]showAlert];
}

//抢答题点击
- (void)buzzerClick
{
    [[CustomAlertView sharedAlertView]creatAlertView];
    [[CustomAlertView sharedAlertView]showAlert];
}
//cell按钮的点击
- (void)didBtnClick :(UIButton *)btn
{
    if (btn != _currentBtn) {
        _currentBtn.selected = NO;
        btn.selected = YES;
        _currentBtn = btn;
    }else{
        _currentBtn.selected = YES;
    }
    self.index = btn.tag;
}

#pragma mark--数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listMAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IEClassTableViewCell *cell = [IEClassTableViewCell cellWithClass:tableView];
    if (self.listMAry.count > 0 ) {
        IEClassModel * models = self.listMAry[indexPath.row];
        CHECK_DATA_IS_NSNULL(models.ID, NSString);
        CHECK_STRING_IS_NULL(models.ID);
        CHECK_DATA_IS_NSNULL(models.nLessonNo, NSNumber);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.codeLabel.text = models.sClassCode;
        cell.contentLabel.text = models.className;
        NSString *str = [models.nLessonNo  stringValue];
        cell.classCodeLabel.text = [NSString stringWithFormat:@"第%@课次",str];
        cell.didButton.tag = [indexPath  row];
        [cell.didButton  addTarget:self action:@selector(didBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;
}

#pragma mark--代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50*AUTO_SIZE_SCALE_Y;
}

#pragma mark - getters and setters
- (UILabel *)classLabel
{
    if (!_classLabel) {
        _classLabel = [CommentMethod createLabelWithFont:17 Text:@"课堂暗号"];
        _classLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _classLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _classLabel;
}

-(UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = [UIFont systemFontOfSize:28*AUTO_SIZE_SCALE_X];
        _numberLabel.backgroundColor = [UIColor lightGrayColor];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.layer.cornerRadius  = 2*AUTO_SIZE_SCALE_X;
        _numberLabel.layer.masksToBounds = YES;
    }
    return _numberLabel;
}

-(UILabel *)annotationLabel
{
    if (!_annotationLabel) {
        _annotationLabel = [CommentMethod createLabelWithFont:14 Text:@"把这组数字发给学员,同步到课堂"];
        _annotationLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _annotationLabel.layer.cornerRadius = 5*AUTO_SIZE_SCALE_X;
        _annotationLabel.layer.masksToBounds = YES;
        _annotationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _annotationLabel;
}

-(UIButton *)synchronousButton
{
    if (!_synchronousButton) {
        _synchronousButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(didClick) Title:@"同步到课堂"]  ;
        _synchronousButton.titleLabel.font = [UIFont systemFontOfSize:18*AUTO_SIZE_SCALE_X];
        [_synchronousButton setBackgroundImage:[UIImage imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
        [_synchronousButton setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji"] forState:UIControlStateHighlighted];
    }
    return _synchronousButton;
}

- (IEContentView *)containerView{
    if (!_containerView) {
        _containerView = [[IEContentView alloc]init];
        [_containerView.sheetButton addTarget:self action:@selector(sheetClick) forControlEvents:UIControlEventTouchUpInside];
        [_containerView.voteButton addTarget:self action:@selector(voteClick) forControlEvents:UIControlEventTouchUpInside];
        [_containerView.practiceButton addTarget:self action:@selector(practiceClick) forControlEvents:UIControlEventTouchUpInside];
        [_containerView.buzzerButton addTarget:self action:@selector(buzzerClick) forControlEvents:UIControlEventTouchUpInside];
        [_containerView.moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _containerView;
}

@end
