//
//  GroupTestViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/8/29.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GroupTestViewController.h"
#import "IECollectionViewCell.h"
#import "HWPopMenu.h"
#import "IESynchronousModel.h"
#import "GroupViewController.h"
#import "ManualViewController.h"

@interface GroupTestViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UITextField *numTextField;
@property (nonatomic, strong) UILabel *roleLabel;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) NSArray *titArr;//随机分组、手动分组

@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UILabel *studentLabel;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *groupBtn;//开始分组

@property (nonatomic, strong) UIButton *doneInKeyboardButton;

@property (nonatomic, strong) NSTimer *myTimer;//轮询学员的定时器
@property (nonatomic, strong) NSMutableArray *studentList;//所有学员
@property (nonatomic, strong) NSMutableArray *onLineArray;//在线学员
@property (nonatomic, strong) NSNumber *totalCount;//学员总数
@property (nonatomic, strong) NSNumber *onLineCount;//在线人数

@property (nonatomic, copy) NSString *groupCnt;//分组数
@property (nonatomic, copy) NSString *groupMode;//分组规则

@end

@implementation GroupTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"分组练习";
    
    //开启定时器
    NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(_loadStudentList) userInfo:nil repeats:YES];
    self.myTimer = tempTimer;
    
    //初始化视图
    [self _initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myTimer setFireDate:[NSDate distantPast]];
    
    //注册键盘显示通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    /**
     *  收起键盘
     */
    [self setupForDismissKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [self.myTimer setFireDate:[NSDate distantFuture]];
    
    //注销键盘显示通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 键盘
// 键盘出现处理事件
- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
    NSDictionary *userInfo = [notification userInfo];
    // UIKeyboardAnimationDurationUserInfoKey 对应键盘弹出的动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // UIKeyboardAnimationCurveUserInfoKey 对应键盘弹出的动画类型
    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //数字彩,数字键盘添加“完成”按钮
    if (self.doneInKeyboardButton){
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration -10];//设置添加按钮的动画时间
        [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];//设置添加按钮的动画类型
        
        //设置自定制按钮的添加位置(这里为数字键盘添加“完成”按钮)
        self.doneInKeyboardButton.transform=CGAffineTransformTranslate(self.doneInKeyboardButton.transform, 0, -53);
        
        [UIView commitAnimations];
    }
    
}

// 键盘消失处理事件
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
    NSDictionary *userInfo = [notification userInfo];
    // UIKeyboardAnimationDurationUserInfoKey 对应键盘收起的动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (self.doneInKeyboardButton.superview)
    {
        [UIView animateWithDuration:animationDuration animations:^{
            //动画内容，将自定制按钮移回初始位置
            self.doneInKeyboardButton.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //动画结束后移除自定制的按钮
            [self.doneInKeyboardButton removeFromSuperview];
        }];
        
    }
}


//点击输入框

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //初始化数字键盘的“完成”按钮
    [self configDoneInKeyBoardButton];
    
    return YES;
}

//初始化，数字键盘“完成”按钮
- (void)configDoneInKeyBoardButton{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //初始化
    if (self.doneInKeyboardButton == nil)
    {
        UIButton *doneInKeyboardButton = [[UIButton alloc] init];
        [doneInKeyboardButton setTitle:@"Return" forState:UIControlStateNormal];
        [doneInKeyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        doneInKeyboardButton.titleLabel.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        doneInKeyboardButton.frame = CGRectMake(0, screenHeight , 106, 53);
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        self.doneInKeyboardButton = doneInKeyboardButton;
    }
    //每次必须从新设定“完成”按钮的初始化坐标位置
    self.doneInKeyboardButton.frame = CGRectMake(0, screenHeight, 106, 53);
    
    //由于ios8下，键盘所在的window视图还没有初始化完成，调用在下一次 runloop 下获得键盘所在的window视图
    [self performSelector:@selector(addDoneButton) withObject:nil afterDelay:0.0f];
}

- (void)addDoneButton
{
    //获得键盘所在的window视图
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] lastObject];
    [tempWindow addSubview:self.doneInKeyboardButton];    // 注意这里直接加到window上
}

//点击“完成”按钮事件，收起键盘
-(void)finishAction
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    //分组数
    self.groupCnt = self.numTextField.text;
}

#pragma mark - private methods
//初始化视图
- (void)_initViews
{
    [self.view addSubview:self.upView];
    [self.upView addSubview:self.numLabel];
    [self.upView addSubview:self.numTextField];
    [self.upView addSubview:self.roleLabel];
    [self.upView addSubview:self.selectButton];
    [self.selectButton addSubview:self.arrowImgView];
    
    [self.view addSubview:self.middleView];
    [self.middleView addSubview:self.studentLabel];
    [self.middleView addSubview:self.line];
    
    [self.view addSubview:self.groupBtn];
    
    WS(this_view);
    [self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+12*AUTO_SIZE_SCALE_X);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 408/3*AUTO_SIZE_SCALE_Y));
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(10*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(80*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(118/3*AUTO_SIZE_SCALE_Y);
    }];
    [self.numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_view.numLabel.centerY);
        make.left.mas_equalTo(this_view.numLabel.right).with.offset(5*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(-42/3*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(118/3*AUTO_SIZE_SCALE_Y);
    }];
    
    [self.roleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_view.numLabel.bottom).with.offset(58/3*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(10*AUTO_SIZE_SCALE_X);
        make.width.mas_equalTo(80*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(118/3*AUTO_SIZE_SCALE_Y);
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_view.roleLabel.centerY);
        make.left.mas_equalTo(this_view.roleLabel.right).with.offset(5*AUTO_SIZE_SCALE_X);
        make.right.mas_equalTo(-42/3*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(118/3*AUTO_SIZE_SCALE_Y);
    }];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(this_view.selectButton.centerY);
        make.right.mas_equalTo(-10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(17, 9));
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_view.upView.bottom).with.offset(9*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 1199/3*AUTO_SIZE_SCALE_Y));
    }];
    
    //学员列表
    [self.studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_view.middleView.mas_left).with.offset(62/3*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_view.middleView.mas_top).with.offset(10*AUTO_SIZE_SCALE_Y);
    }];
    //分割线
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(this_view.middleView);
        make.bottom.mas_equalTo(this_view.studentLabel.mas_bottom).with.offset(10*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(this_view.middleView);
        make.height.mas_equalTo(0.5*AUTO_SIZE_SCALE_Y);
    }];
    
    self.collectionView.frame = CGRectMake(0, 120.5/3*AUTO_SIZE_SCALE_Y, kScreenWidth, (1199/3-120.5/3)*AUTO_SIZE_SCALE_Y);
    [self.collectionView registerClass:[IECollectionViewCell class] forCellWithReuseIdentifier:@"GroupCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.middleView addSubview:self.collectionView];
    
    [self.groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_view.view);
        make.bottom.mas_equalTo(this_view.view.mas_bottom).with.offset(-117/3*AUTO_SIZE_SCALE_Y);
        make.width.mas_equalTo(1010/3*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(45*AUTO_SIZE_SCALE_Y);
    }];
}

//轮询
- (void)_loadStudentList
{
    _studentList = [[NSMutableArray  alloc]init];
    _onLineArray = [[NSMutableArray alloc] init];

    NSString *passCode = self.passCode;
    CHECK_DATA_IS_NSNULL(passCode, NSString);
    [[Service sharedInstance]TeacherOrStudentGetStudentOnLinePassCode:passCode RoleId:@"2" success:^(NSDictionary *result) {
        if (k_IsSuccess(result)) {
            NSDictionary *data = [result objectForKey:@"Data"];
            CHECK_DATA_IS_NSNULL(data, NSDictionary);
            NSNumber *studentOnLineNum = [data objectForKey:@"studentOnLineNum"];
            CHECK_DATA_IS_NSNULL(studentOnLineNum, NSNumber);
            self.onLineCount = studentOnLineNum;
            NSNumber *classStudentTotalNum = [data  objectForKey:@"classStudentTotalNum"];
            CHECK_DATA_IS_NSNULL(classStudentTotalNum, NSNumber);
            self.totalCount = classStudentTotalNum;
            _studentLabel.text = [NSString stringWithFormat:@"学员列表 (%@/%@)",self.onLineCount,self.totalCount];
            NSArray *studentList = [data objectForKey:@"studentList"];
            CHECK_DATA_IS_NSNULL(studentList, NSArray);
            if (data.count > 0) {
                for (NSDictionary *dic in studentList) {
                    IESynchronousModel *model = [[IESynchronousModel alloc]initWithDataDic:dic];
                    [_studentList  addObject:model];
                    
                    //在线学员数组
                    NSNumber *status2 = [NSNumber  numberWithLong:1];
                    if (model.studentloginstatus == status2){
                        [_onLineArray addObject:model];
                    }
                }
            }
            
//            if (_onLineArray.count < 2) {
//                self.groupBtn.enabled = NO;
//                self.groupBtn.alpha = 0.5;
//            } else {
//                self.groupBtn.enabled = YES;
//                self.groupBtn.alpha = 1;
//            }
            
            [self.collectionView  reloadData];
        }else{
            //            NSString *info = [result objectForKey:@"Infomation"];
            //            CHECK_DATA_IS_NSNULL(info, NSString);
            //            [self showHint:info];
        }
    } failure:^(NSError *error) {
        NDLog(@"%@",error);
    }];
}

#pragma mark - collection的数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.studentList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"GroupCollectionViewCell";
    IECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath ];
    if (cell==nil) {
        cell = [[IECollectionViewCell alloc]init];
    }
    if (self.studentList.count > 0) {
        IESynchronousModel *model = self.studentList[indexPath.row];
        cell.nameString = model.studentname;
        NSNumber *status1 = [NSNumber  numberWithLong:0];
        NSNumber *status2 = [NSNumber  numberWithLong:1];
        
        if (model.studentloginstatus == status1) {
            NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, model.iconUrl];
            [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
            cell.alpha = 0.5;
        }else if (model.studentloginstatus == status2){
            NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, model.iconUrl];
            [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
            cell.alpha = 1.0;
        }
    }
    
    return cell;
}

#pragma mark - event response
- (void)selectButtonAction:(UIButton *)button
{
    if (button.selected) {
        self.arrowImgView.transform = CGAffineTransformIdentity;
        [HWPopMenu  coverClick];
    }else
    {
        self.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
        
        CGFloat viewWidth = self.selectButton.bounds.size.width;
        CGFloat viewHeigth = self.selectButton.bounds.size.height;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeigth*3)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [CommentMethod colorFromHexRGB:k_Color_6].CGColor;//[CommentMethod colorFromHexRGB:@"e84d60"].CGColor;
        view.layer.masksToBounds = YES;
        
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, viewHeigth,viewWidth, viewHeigth*2) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = self.selectButton.bounds.size.height;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc]init];
        [view addSubview:tableView];
        
        _titArr = @[@"随机分组", @"手动分组"];
        
        [HWPopMenu popFromRect:CGRectMake(0, -viewHeigth, viewWidth, viewHeigth)
                        inView:self.selectButton
                       content:view
                       dismiss:^{
                           self.arrowImgView.transform = CGAffineTransformIdentity;
                       }];
    }
    
    button.selected = !button.selected;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"GroupTestViewController";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        CGFloat viewWidth = self.selectButton.bounds.size.width;
        CGFloat viewHeigth = self.selectButton.bounds.size.height;
        
        UILabel *label = [CommentMethod createLabelWithFont:18.0f Text:@""];
        label.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, 0, viewWidth, viewHeigth);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        label.tag = 200+indexPath.row;
        [cell.contentView addSubview:label];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeigth-0.5, viewWidth, 0.5)];
        line.backgroundColor = RGBACOLOR(210, 210, 210, 1.0);
        [cell.contentView addSubview:line];
    }
    
    if (_titArr.count > 0) {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:200+indexPath.row];
        label.text = _titArr[indexPath.row];
        self.groupMode = _titArr[0];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectButton.selected = !self.selectButton.selected;
    [self.selectButton setTitle:_titArr[indexPath.row] forState:UIControlStateNormal];
   
    [HWPopMenu  coverClick];
}

-(void)groupBtnClick {

    //1、分组数 2-12
    if ([self.numTextField.text intValue] < 2 || [self.numTextField.text intValue] > 12) {
        [self showHint:@"请输入正确的预分组数2-12"];
        return;
    }
    
    if (self.onLineArray.count < 2*[self.numTextField.text intValue]) {
        [CommentMethod showToastWithMessage:@"分组条件异常，请重新设定分组数及分组规则" showTime:2.0];
        return;
    }
    
    self.groupCnt = self.numTextField.text;
    //分组规则
    self.groupMode = self.selectButton.titleLabel.text;
    if ([self.groupMode isEqualToString:@"随机分组"]) {
        //调用接口
        GroupViewController *groupVC = [[GroupViewController alloc] init];
        groupVC.passCode = self.passCode;
        groupVC.groupCnt = self.groupCnt;
        groupVC.groupMode = self.groupMode;
        groupVC.activeClassId = self.activeClassId;
        groupVC.isGetHistotyGroup = NO;
        [self.navigationController pushViewController:groupVC animated:YES];
    } else {
        ManualViewController *manualVC = [[ManualViewController alloc] init];
        manualVC.passCode = self.passCode;
        manualVC.groupCnt = self.groupCnt;
        manualVC.groupMode = self.groupMode;
        manualVC.activeClassId = self.activeClassId;
        manualVC.isGetHistotyGroup = NO;
        [self.navigationController pushViewController:manualVC animated:YES];
    }
}

#pragma mark - getters and setters
- (UIView *)upView
{
    if (!_upView) {
        _upView = [[UIView alloc] init];
        _upView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _upView;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [CommentMethod createLabelWithFont:18 Text:@"分组数"];
        _numLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _numLabel;
}

- (UITextField *)numTextField
{
    if (!_numTextField) {
        _numTextField = [[UITextField alloc]init];
        [_numTextField setBorderStyle:UITextBorderStyleRoundedRect];
        _numTextField.keyboardType = UIKeyboardTypeNumberPad;
        _numTextField.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _numTextField.placeholder = @"请输入预分组数2-12";
        _numTextField.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        _numTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numTextField.delegate = self;
    }
    return _numTextField;
}

- (UILabel *)roleLabel{
    if (!_roleLabel) {
        _roleLabel = [CommentMethod createLabelWithFont:18 Text:@"分组规则"];
        _roleLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
    }
    return _roleLabel;
}

- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(selectButtonAction:) Title:@"随机分组"];
        [_selectButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 200*AUTO_SIZE_SCALE_X)];
        _selectButton.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
        _selectButton.layer.cornerRadius = 5;
        _selectButton.layer.borderColor = [CommentMethod colorFromHexRGB:k_Color_6].CGColor;
        _selectButton.layer.borderWidth = 1;
        _selectButton.layer.masksToBounds = YES;
    }
    return _selectButton;
}

- (UIImageView *)arrowImgView
{
    if (!_arrowImgView) {
        _arrowImgView = [CommentMethod createImageViewWithImageName:@"Group_down.png"];
    }
    return _arrowImgView;
}

- (UIView *)middleView
{
    if (!_middleView) {
        _middleView = [[UIView alloc] init];
        _middleView.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
    }
    return _middleView;
}

//学员列表
- (UILabel *)studentLabel{
    if (!_studentLabel) {
        _studentLabel = [[UILabel alloc]init];
        _studentLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        _studentLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _studentLabel.textAlignment = NSTextAlignmentLeft;
        _studentLabel.text = @"学员列表";
    }
    return _studentLabel;
}
//分割线
- (UIImageView *)line{
    if (!_line) {
        _line = [CommentMethod createImageViewWithImageName:@""];
        _line.backgroundColor = RGBACOLOR(200.0, 200.0, 200.0, 1.0);
    }
    return _line;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (kScreenWidth-138*AUTO_SIZE_SCALE_X)/5;
        CGFloat hight =(kScreenWidth-138*AUTO_SIZE_SCALE_Y)/5/0.725;
        flowLayout.itemSize = CGSizeMake(width, hight);
        flowLayout.minimumInteritemSpacing = 10*AUTO_SIZE_SCALE_X;
        flowLayout.minimumLineSpacing = 10*AUTO_SIZE_SCALE_Y;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(15*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}
- (UIButton *)groupBtn{
    if (!_groupBtn) {
        _groupBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(groupBtnClick) Title:@"开始分组"];
        [_groupBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
        [_groupBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji"] forState:UIControlStateHighlighted];
        
    }
    return _groupBtn;
}

@end
