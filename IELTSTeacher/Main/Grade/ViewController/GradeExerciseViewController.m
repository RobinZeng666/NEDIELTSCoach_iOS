//
//  GradeExerciseViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeExerciseViewController.h"
#import "GradeExerciseViewCell.h"
#import "GradeExerciseModel.h"
#import "IEPlusViewController.h"
#import "GradeAddExerciseController.h"
#import "IESheetModel.h"
#import "DefaultView.h"
#import "ReportViewController.h"

@interface GradeExerciseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;  //列表
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) DefaultView *defaultView1;

@end

@implementation GradeExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"课堂练习";
    
    /**
     初始化视图
     */
    [self _initView];
   
    
}

- (void)_initView
{
    [self.view addSubview:self.tableView];
    [self.navView addSubview:self.addButton];  //25*25
    
    //添加
    CGFloat addTop = (44-25*AUTO_SIZE_SCALE_X)/2 + 20;
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X));
        make.right.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(addTop);
    }];
    
    
    [self.view addSubview:self.defaultView1];
    self.defaultView1.hidden = YES;
    CGFloat defauleHeight = (kScreenHeight-100*AUTO_SIZE_SCALE_Y-64)/2;
    [self.defaultView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(defauleHeight);
    }];
}

- (void)_initData
{
    /**
     *  随堂练习
     */
    CHECK_STRING_IS_NULL(self.ccid);
    
//    self.ccid = @"29909";
//    NSString *passCode = @"893054";
//    NSString *passCode = @"";
    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service sharedInstance]ActiveClassExerciseListWithPassCode:@""
                                                            ccId:self.ccid
                                                         success:^(NSDictionary *result) {
                                                             
                 if (k_IsSuccess(result)) {
                     NSArray *data = [result objectForKey:@"Data"];
                     CHECK_DATA_IS_NSNULL(data, NSArray);
                     
                     if (data.count > 0) {
                         _dataArray = [[NSMutableArray alloc]init];
                         for (NSDictionary *dataDic in data) {
                             IESheetModel *model = [[IESheetModel alloc]initWithDataDic:dataDic];
                             [_dataArray addObject:model];
                         }
                         /**
                          *  刷新列表
                          */
                         [self.tableView reloadData];
                     }
                     if (_dataArray.count>0) {
                         self.tableView.hidden = NO;
                         self.defaultView1.hidden = YES;
                     }else
                     {
                         self.tableView.hidden = YES;
                         self.defaultView1.hidden = NO;
                     }

                 }else{
                     if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                         [self showHint:[result objectForKey:@"Infomation"]];
                     }
                 }
                 
                 [self hideHud];
                } failure:^(NSError *error) {
                 [self hideHud];
                 
                }];
}

- (void)dealloc
{
    [self.tableView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     初始化数据
     */
    [self _initData];
}

#pragma mark - event response
- (void)addExercise
{
    GradeAddExerciseController *ctr = [[GradeAddExerciseController alloc]init];
    ctr.ccId = self.ccid;
    [self.navigationController  pushViewController:ctr animated:YES];
}


#pragma mark - delegate
#pragma mark - <UITabelViewDatasource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"GradeExerciseViewCell";
    GradeExerciseViewCell  *cell = (GradeExerciseViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[GradeExerciseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.serial = indexPath.row+1;
    if (_dataArray.count > 0) {
       IESheetModel *model = _dataArray[indexPath.row];
        CHECK_DATA_IS_NSNULL(model.Name, NSString);
        CHECK_STRING_IS_NULL(model.Name);
        cell.testName = model.Name;
    }
    return cell;
}

#pragma mark - <UITabelViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*AUTO_SIZE_SCALE_Y;
}


//整套提交报告
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0) {
        IESheetModel *model = _dataArray[indexPath.row];
        
        CHECK_DATA_IS_NSNULL(model.PushStatus, NSNumber);
        if ([model.PushStatus integerValue] > 0) {

            CHECK_STRING_IS_NULL(self.ccid);
            CHECK_DATA_IS_NSNULL(model.P_ID, NSNumber);
            NSString *pid = [model.P_ID stringValue];
            CHECK_STRING_IS_NULL(pid);
            
            ReportViewController *report = [[ReportViewController alloc]init];
            report.ccId = self.ccid;
            report.paperId = pid;
            report.titleName = model.Name;
            [self.navigationController pushViewController:report animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.删除数据
    if (_dataArray.count > 0) {
        IESheetModel *model = _dataArray[indexPath.row];
        CHECK_DATA_IS_NSNULL(model.PushStatus, NSNumber);
        if ([model.PushStatus integerValue] > 0) {
            [self showHint:@"试卷已使用,不可删除!"];
            return;
        }else
        {
            NSNumber *paperId = model.P_ID;
            [_dataArray removeObjectAtIndex:indexPath.row];
            [[Service  sharedInstance]ActiveClassExerciseDeleteWithccId:self.ccid
                                                                paperId:paperId
                                                                success:^(NSDictionary *result) {
                NDLog(@"%@",result);
                if (k_IsSuccess(result)) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Name_ClassDetail object:nil];
                }
                if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                    [self showHint:[result objectForKey:@"Infomation"]];
                }
                if (_dataArray.count>0) {
                    self.tableView.hidden = NO;
                    self.defaultView1.hidden = YES;
                }else
                {
                    self.tableView.hidden = YES;
                    self.defaultView1.hidden = NO;
                }
                
                [tableView reloadData];
            }failure:^(NSError *error) {
                NDLog(@"%@",error);
            }];
        }
    }
    // 2.更新UITableView UI界面
    NDLog(@"删除数据");
    
}
//修改删除按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark - event response
- (void)tapOneAction
{
    [self _initData];
}

#pragma mark - get or set
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [CommentMethod createButtonWithImageName:@"classTest_tianjia" Target:self Action:@selector(addExercise) Title:@""];
    }
    return _addButton;
}
- (DefaultView *)defaultView1
{
    if (!_defaultView1) {
        _defaultView1 = [[DefaultView alloc]init];
        _defaultView1.backgroundColor = [UIColor clearColor];
        _defaultView1.tipTitle = @"暂无课堂练习";
        
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction)];
        [_defaultView1 addGestureRecognizer:tapOne];
    }
    return _defaultView1;
}


@end
