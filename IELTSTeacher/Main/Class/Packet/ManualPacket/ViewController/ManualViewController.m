//
//  ManualViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ManualViewController.h"
#import "ManualCollectionViewCell.h"
#import "IESynchronousModel.h"
#import "SynchronizedViewController.h"


#define k_cellWidth (kScreenWidth-2*60/3*AUTO_SIZE_SCALE_X)
#define k_cellHeight (411/3*AUTO_SIZE_SCALE_X)

@interface ManualViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UITextField *numTextField;
@property (nonatomic, strong) UILabel *roleLabel;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *arrowImgView;

@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UILabel *studentLabel;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *groupBtn;
@property (nonatomic, strong) UIButton *reGroupBtn;

//@property (nonatomic, assign) NSInteger indexRow;//某行
@property (nonatomic, strong) NSMutableDictionary *groupDic;


@property (nonatomic, assign) BOOL isFinishGroup;//是否完成分组
@end

@implementation ManualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"分组练习";
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Notification_Name_GroupData object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAction:) name:Notification_Name_GroupData object:nil];
    
    [self _initViews];
} 

- (void)notificationAction:(NSNotification *)notification
{
    NDLog(@"通知返回的数据userInfo = %@",notification.userInfo);
    
    NSDictionary *userDic = notification.userInfo;
    NSArray *groupArray = [userDic objectForKey:@"groupArray"];
    _groupDic = [[NSMutableDictionary alloc]initWithCapacity:groupArray.count];
    if (groupArray.count > 0) {
        for (NSArray *dataArray in groupArray) {
            if (dataArray.count > 0) {  //只存一次
                NSDictionary *dic = dataArray[0];
                NSNumber *GroupNum = [dic objectForKey:@"GroupNum"];
                CHECK_DATA_IS_NSNULL(GroupNum, NSNumber);
                [_groupDic setObject:dataArray forKey:GroupNum];
            }
        }
    }
    
//    int indexRow = (int)[userDic objectForKey:@"indexRow"];
//    self.indexRow = indexRow;
    
    [self.collectionView reloadData];
}

#pragma mark - life cycle
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
    [self.view addSubview:self.reGroupBtn];
    
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
    
    //    self.collectionView.frame = CGRectMake(60/3*AUTO_SIZE_SCALE_X, (120.5/3+38/3)*AUTO_SIZE_SCALE_Y, kScreenWidth-2*60/3*AUTO_SIZE_SCALE_X, 450/3*2*AUTO_SIZE_SCALE_Y);
    self.collectionView.frame = CGRectMake(60/3*AUTO_SIZE_SCALE_X, (120.5/3+38/3)*AUTO_SIZE_SCALE_Y, kScreenWidth-2*60/3*AUTO_SIZE_SCALE_X, (1199/3-120.5/3-38/3)*AUTO_SIZE_SCALE_Y);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.middleView addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ManualCollectionViewCell class] forCellWithReuseIdentifier:@"ManualCollectionViewCell"];
    
    
    [self.groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_view.view);
        make.bottom.mas_equalTo(this_view.view.mas_bottom).with.offset(-117/3*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-2*26*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_Y));
    }];
    [self.reGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_view.view);
        make.bottom.mas_equalTo(this_view.view.mas_bottom).with.offset(-117/3*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-2*26*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_Y));
    }];
    
    if (self.isGetHistotyGroup) {
        //显示重新分组
        self.groupBtn.hidden = YES;
        self.reGroupBtn.hidden = NO;
        
        self.isFinishGroup = YES;
        
    } else {
        
        self.isFinishGroup = NO;
        
        self.groupBtn.hidden = NO;
        self.reGroupBtn.hidden = YES;
    }
}

#pragma mark - delegate
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.groupCnt intValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ManualCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ManualCollectionViewCell" forIndexPath:indexPath ];
    if (cell==nil) {
        cell = [[ManualCollectionViewCell alloc]initWithFrame:CGRectZero];
    }
    cell.numLabel.text = [NSString stringWithFormat:@"第%ld组", indexPath.row+1];
    cell.groupNum = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.groupCnt = self.groupCnt;
    cell.passCode = self.passCode;
    cell.activeClassId = self.activeClassId;
    cell.addButton.tag = 300 + indexPath.row;
    
    if (_groupDic.count > 0) {
        NSNumber *indexRow = [NSNumber numberWithInteger:indexPath.row+1];
        NSArray *groupArray = [_groupDic objectForKey:indexRow];
        if (![groupArray isKindOfClass:[NSNull class]] &&  groupArray.count > 0) { //有分组
            
            //某个组
            cell.addButton.hidden = YES;
            cell.collectionView.hidden = NO;
            
            cell.groupArray = groupArray;
            cell.numLabel.text = [NSString stringWithFormat:@"第%ld组（%lu）",(long)indexPath.row+1, (unsigned long)cell.groupArray.count];
            //刷新
            [cell.collectionView reloadData];

        }else
        {
            //显示添加
            cell.addButton.hidden = NO;
            cell.collectionView.hidden = YES;
        
        }
    }else
    {
        //显示添加
        cell.addButton.hidden = NO;
        cell.collectionView.hidden = YES;
        
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_groupDic.count > 0) {
        NSNumber *indexRow = [NSNumber numberWithInteger:indexPath.row+1];
        NSArray *groupArray = [_groupDic objectForKey:indexRow];
        if (![groupArray isKindOfClass:[NSNull class]] &&  groupArray.count > 0) { //有分组
            //某个组
            NSInteger indexV = (int)groupArray.count;
            NSInteger row = indexV / 5;
            NSInteger cow = indexV % 5;
            if (cow > 0){
                return CGSizeMake(k_cellWidth, k_cellHeight*(row+1));
            }else{
                return CGSizeMake(k_cellWidth, k_cellHeight*row);
            }
        }else {
            //显示添加
            return CGSizeMake(k_cellWidth, k_cellHeight);
        }
    }else
    {
        //显示添加
        return CGSizeMake(k_cellWidth, k_cellHeight);
    }
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //取消
    } else {
        //确定
        
        //放弃分组
        NSDictionary *dic = @{@"activeClassId":self.activeClassId};
        [[Service sharedInstance]abandonDiviceGroupWithPram:dic succcess:^(NSDictionary *result) {
            //成功
            if (k_IsSuccess(result)) {
                NDLog(@"%@", result);
                
            } else {
                if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                    [self showHint:[result objectForKey:@"Infomation"]];
                }
            }
        } failure:^(NSError *error) {
            //失败
            [self showHint:[error networkErrorInfo]];
        }];
        //回到上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - event response
- (void)backAction
{
    if (self.isFinishGroup) {
        //直接回到分组练界面
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        //说明尚未点击“完成分组”
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"是否放弃分组"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"确定", nil];
        [myAlertView show];
    }
}

#pragma mark - event response
-(void)groupManualBtnClick:(UIButton *)button
{
    
    NSUInteger tempValue = self.groupDic.count;
    if (tempValue == [self.groupCnt integerValue]) {

        self.isFinishGroup = YES;
        
        //确认分组
        [self _confirmDiviceGroup];

    } else {
        self.groupBtn.hidden = NO;
        self.reGroupBtn.hidden = YES;
        [self showHint:@"还有学员未分组"];
        return;
    }
    
}

//确认分组
- (void)_confirmDiviceGroup
{
    NSDictionary *dic = @{@"passCode":self.passCode,
                          @"activeClassId":self.activeClassId};
    [[Service sharedInstance]confirmDiviceGroupWithPram:dic succcess:^(NSDictionary *result) {
        if (k_IsSuccess(result)) {
            self.groupBtn.hidden = YES;
            self.reGroupBtn.hidden = NO;
            NDLog(@"确认分组：%@", result);
        } else {
            self.groupBtn.hidden = NO;
            self.reGroupBtn.hidden = YES;
            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                [self showHint:[result objectForKey:@"Infomation"]];
            }
        }
    } failure:^(NSError *error) {
        self.groupBtn.hidden = NO;
        self.reGroupBtn.hidden = YES;

        //失败
        [self showHint:[error networkErrorInfo]];
    }];
}

-(void)regroupManualBtnClick:(UIButton *)button
{
    //调用接口
    NSDictionary *dic = @{@"activeClassId":self.activeClassId};

    //手动分组的重置
    [[Service sharedInstance]resetGroupWithPram:dic succcess:^(NSDictionary *result) {
        if (k_IsSuccess(result)) {
            //调用
            [self manualMethod];
            
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

- (void)manualMethod
{
    if (self.isGetHistotyGroup) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(againManualViewGroupView)]) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate againManualViewGroupView];
        }
    } else {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - private methods
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
        _numTextField.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        _numTextField.enabled = NO;
        _numTextField.text = self.groupCnt;
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
        _selectButton = [CommentMethod createButtonWithImageName:@"" Target:self Action:nil Title:self.groupMode];
        [_selectButton setTitleColor:[CommentMethod colorFromHexRGB:k_Color_2] forState:UIControlStateNormal];
        [_selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 200*AUTO_SIZE_SCALE_X)];
        _selectButton.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_9];
        _selectButton.layer.cornerRadius = 5;
        _selectButton.layer.borderColor = [CommentMethod colorFromHexRGB:k_Color_6].CGColor;
        _selectButton.layer.borderWidth = 1;
        _selectButton.layer.masksToBounds = YES;
        _selectButton.enabled = NO;
    }
    return _selectButton;
}

- (UIImageView *)arrowImgView
{
    if (!_arrowImgView) {
        _arrowImgView = [CommentMethod createImageViewWithImageName:@"score_xila.png"];
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

//分组结果
- (UILabel *)studentLabel{
    if (!_studentLabel) {
        _studentLabel = [[UILabel alloc]init];
        _studentLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        _studentLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _studentLabel.textAlignment = NSTextAlignmentLeft;
        _studentLabel.text = @"分组结果";
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
        CGFloat width = k_cellWidth;
        CGFloat hight = k_cellHeight;
        flowLayout.itemSize = CGSizeMake(width, hight);
        flowLayout.minimumInteritemSpacing = 10*AUTO_SIZE_SCALE_X;
        flowLayout.minimumLineSpacing = 15*AUTO_SIZE_SCALE_Y;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}
- (UIButton *)groupBtn{
    if (!_groupBtn) {
        _groupBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(groupManualBtnClick:) Title:@"完成分组"];
        [_groupBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
        [_groupBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji"] forState:UIControlStateHighlighted];
        _groupBtn.tag = 101;
    }
    return _groupBtn;
}

- (UIButton *)reGroupBtn{
    if (!_reGroupBtn) {
        _reGroupBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(regroupManualBtnClick:) Title:@"重新分组"];
        [_reGroupBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu"] forState:UIControlStateNormal];
        [_reGroupBtn setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji"] forState:UIControlStateHighlighted];
        _reGroupBtn.tag = 102;
    }
    return _reGroupBtn;
}
//
//- (NSArray *)groupArray
//{
//    if (!_groupArray) {
//        _groupArray = [[NSArray alloc] init];
//    }
//    return _groupArray;
//}

@end
