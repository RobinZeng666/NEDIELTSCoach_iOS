//
//  GradeExerciseViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserve

#import "IEPracticeViewController.h"
#import "IETestViewController.h"
#import "IEPraTableViewCell.h"
#import "IEPlusViewController.h"
#import "IESheetModel.h"
#import "IEChoiceMode.h"
#import "BaseNavgationController.h"

@interface IEPracticeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIButton *plusBtn;
@property (nonatomic, copy)   NSString *paperNumber;
@property (nonatomic, strong) NSMutableArray *dataArry;
@property (nonatomic, strong) NSMutableArray *Ary;
@property (nonatomic, copy)   NSString *qId;
@property (nonatomic, strong) NSNumber *SectionID; //= PaperSection试卷项ID
@property (nonatomic, strong) NSNumber *PID;
@end

@implementation IEPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.titles = @"课堂练习";
    /**
     初始化视图
     */
    [self _initView];
    
}

- (void)dealloc
{
    [self.tableView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self  _initData];
}

- (void)_initData
{
    [self showHudInView:self.view hint:@"正在加载..."];
    
    NSString *ccId = self.ccId;
    CHECK_STRING_IS_NULL(self.ccId);
    
    [[Service  sharedInstance]ActiveClassExerciseListWithPassCode:self.passCode
                                                             ccId:ccId
                                                          success:^(NSDictionary *result) {
                                                              [self hideHud];
                  if (k_IsSuccess(result)) {
                 
                      NSArray *data = [result  objectForKey:@"Data"];
                      CHECK_DATA_IS_NSNULL(data, NSArray);
                      _dataArry = [[NSMutableArray  alloc]initWithCapacity:data.count];
                      for (NSDictionary *dic in data) {
                          IESheetModel *models = [[IESheetModel  alloc]initWithDataDic:dic];
                          [_dataArry addObject:models];
                      }
                      [self.tableView reloadData];

                  }else{
                      if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                          [self showHint:[result objectForKey:@"Infomation"]];
                      }
                  }
              }
              failure:^(NSError *error) {
                  //失败
                  [self showHint:[error networkErrorInfo]];
              }];
}

//CGRectMake(10, 20+(44-20)/2, 51, 20)
- (void)_initView
{
    [self.view addSubview:self.tableView];
    
    [self.navView addSubview:self.plusBtn];
    WS(this_nav);
    [self.plusBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(this_nav.view.mas_right).with.offset(-10);
        make.top.mas_equalTo(20+(44-20)/2);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
        
    }];

}
#pragma mark - delegate
#pragma mark - <UITabelViewDatasource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return    [self.dataArry count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID= @"IEPraTableViewCell";
    IEPraTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[IEPraTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.dataArry.count > 0) {
        IESheetModel *model = self.dataArry[indexPath.row];
        self.paperNumber = model.PaperNumber;
        cell.P_ID = model.P_ID;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ctnLabel.text = model.Name;
        cell.numberLabel.text = [model.QuestionCount stringValue];
        
        CHECK_DATA_IS_NSNULL(model.PushStatus, NSNumber);
        if ([model.PushStatus integerValue] > 0) {
            cell.ctnLabel.textColor = [UIColor lightGrayColor];
            cell.numberLabel.textColor = [UIColor lightGrayColor];
        }else
        {
            cell.ctnLabel.textColor = [UIColor darkGrayColor];
            cell.numberLabel.textColor = [UIColor darkGrayColor];
        }
    }
    return cell;
}

#pragma mark - <UITabelViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74*AUTO_SIZE_SCALE_Y;
}

#pragma mark - event response
- (void)plusBtnAction
{
    IEPlusViewController *ctr = [[IEPlusViewController alloc]init];
    [self.navigationController  pushViewController:ctr animated:YES];
    ctr.ccId = self.ccId;
    ctr.paperNumber = self.paperNumber;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArry.count > 0)
    {
        IESheetModel *model = self.dataArry[indexPath.row];
        CHECK_DATA_IS_NSNULL(model.PushStatus, NSNumber);
        if ([model.PushStatus integerValue] > 0) {
            [CommentMethod showToastWithMessage:@"该试卷已推送过,不可再次推送" showTime:1.0];
            return;
        }
        
        IETestViewController *controller = [[IETestViewController alloc]init];
        controller.passCode = self.passCode;
        controller.paperId = model.P_ID;
        controller.ActiveClassPaperInfoId = model.ActiveClassPaperInfoId;
        controller.titls = model.Name;
        controller.ccId = self.ccId;
        controller.PID = self.PID;
        controller.PaperState = model.PaperState;
        
        //模态视图
        controller.isModalButton = YES;
        BaseNavgationController *nav = [[BaseNavgationController alloc]initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArry.count > 0) {
        IESheetModel *model = self.dataArry[indexPath.row];
        CHECK_DATA_IS_NSNULL(model.PushStatus, NSNumber);
        if ([model.PushStatus integerValue] > 0) {
            [CommentMethod showToastWithMessage:@"该试卷已推送过,不可删除!" showTime:1.0];
            return;
        }
        // 1.删除数据
        NSNumber *paperId = model.P_ID;
        [self.dataArry removeObjectAtIndex:indexPath.row];
        [[Service  sharedInstance]ActiveClassExerciseDeleteWithccId:self.ccId
                                                            paperId:paperId
                                                            success:^(NSDictionary *result) {
                                                                NDLog(@"%@",result);
                                                                [tableView reloadData];
                                                            }
                                                            failure:^(NSError *error) {
                                                                NDLog(@"%@",error);
                                                            }];
    }
    // 2.更新UITableView UI界面
    NDLog(@"删除数据");

}
//修改删除按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - get or set
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIButton *)plusBtn
{
    if (!_plusBtn) {
        _plusBtn = [CommentMethod createButtonWithImageName:@"classTest_tianjia"
                                                     Target:self
                                                     Action:@selector(plusBtnAction)
                                                      Title:@""];
    }
    return _plusBtn;
}

@end
