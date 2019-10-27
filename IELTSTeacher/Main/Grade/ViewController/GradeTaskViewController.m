//
//  GradeTaskViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeTaskViewController.h"
#import "GradeTaskViewCell.h"
#import "GradeTaskModel.h"
//#import "GradeTaskDetailController.h"
#import "DynamicDetailController.h"
//#import "DynamicResourceController.h"

#import "MaterialDetailViewController.h"

#import "DefaultView.h"

@interface GradeTaskViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) DefaultView *defaultView1;

@end

@implementation GradeTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"任务列表";
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
    [self.view addSubview:self.tableView];
    
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
    _dataArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *moldTestArray = [[NSMutableArray alloc]init];
    NSMutableArray *exerciseArray = [[NSMutableArray alloc]init];
    NSMutableArray *resoureArray = [[NSMutableArray alloc]init];
    //增加测试试卷
    NSMutableArray *textArray = [[NSMutableArray alloc]init];
    
    CHECK_DATA_IS_NSNULL(self.lessonId, NSString);  //2
    NSDictionary *dic = @{@"lessonId":self.lessonId,
                          @"classId":self.ids};
    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service sharedInstance]loadTaskList:dic
                                 succcess:^(NSDictionary *result) {
                                     
         if (k_IsSuccess(result)) {
             NSDictionary *dataDic = [result objectForKey:@"Data"];
             NSArray *listData = [dataDic objectForKey:@"list"];
             if (listData.count > 0) {
                 for (NSDictionary *dicData  in listData) {
                     GradeTaskModel *taskModel = [[GradeTaskModel alloc]initWithDataDic:dicData];
                     CHECK_DATA_IS_NSNULL(taskModel.TaskType, NSNumber);
                     NSInteger taskType = [taskModel.TaskType integerValue];
                     switch (taskType) {//    TaskType = 任务类型 1:模考; 2:练习; 3:资料;
                         case 1: //模考
                         {
                             if (moldTestArray.count == 0) {
                                 NSDictionary *dataDic= @{@"isFrist":@"YES",
                                                          @"data":taskModel,
                                                          @"type":@"模考"};
                                 [moldTestArray addObject:dataDic];
                             }else
                             {
                                 NSDictionary *dataDic= @{@"isFrist":@"NO",
                                                          @"data":taskModel,
                                                          @"type":@"模考"};
                                 [moldTestArray addObject:dataDic];
                             }
                         }
                         break;
                         case 2: //练习
                         {
                             if (exerciseArray.count == 0) {
                                 NSDictionary *dataDic= @{@"isFrist":@"YES",
                                                          @"data":taskModel,
                                                          @"type":@"练习"};
                                 [exerciseArray addObject:dataDic];
                             }else
                             {
                                 NSDictionary *dataDic= @{@"isFrist":@"NO",
                                                          @"data":taskModel,
                                                          @"type":@"练习"};
                                 [exerciseArray addObject:dataDic];
                             }
                         }
                         break;
                         case 3: //资料
                         {
                             if (resoureArray.count == 0) {
                                 NSDictionary *dataDic= @{@"isFrist":@"YES",
                                                          @"data":taskModel,
                                                          @"type":@"资料"};
                                 [resoureArray addObject:dataDic];
                             }else
                             {
                                 NSDictionary *dataDic= @{@"isFrist":@"NO",
                                                          @"data":taskModel,
                                                          @"type":@"资料"};
                                 [resoureArray addObject:dataDic];
                             }
                         }
                         break;
                         case 4://测试试卷
                         {
                             if (textArray.count == 0) {
                                 NSDictionary *dataDic= @{@"isFrist":@"YES",
                                                          @"data":taskModel,
                                                          @"type":@"测试试卷"};
                                 [textArray addObject:dataDic];
                             }else
                             {
                                 NSDictionary *dataDic= @{@"isFrist":@"NO",
                                                          @"data":taskModel,
                                                          @"type":@"测试试卷"};
                                 [textArray addObject:dataDic];
                             }
                         }
                          break;
                         default:
                             break;
                     }
                 }
                 [_dataArray addObjectsFromArray:moldTestArray];
                 [_dataArray addObjectsFromArray:exerciseArray];
                 [_dataArray addObjectsFromArray:resoureArray];
                 [_dataArray addObjectsFromArray:textArray];
             }
             
             if (_dataArray.count>0) {
                 self.tableView.hidden = NO;
                 self.defaultView1.hidden = YES;
             }else
             {
                 self.tableView.hidden = YES;
                 self.defaultView1.hidden = NO;
             }
             
             [self.tableView reloadData];
             
         }else{
             if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                 [self showHint:[result objectForKey:@"Infomation"]];
             }
         }
         
         [self hideHud];
     } failure:^(NSError *error) {
         
         [self hideHud];
//                                     [self showHint:@"班级任务列表请求失败"];
     }];
}

#pragma mark - delegate
#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"GradeTaskViewControllerCell";
    GradeTaskViewCell *cell = (GradeTaskViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[GradeTaskViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    /**
       ST_ID = 任务主键;
       Name="";
       TaskType = 任务类型 1:模考; 2:练习; 3:资料 ;
       RefID = 引用关联的ID[资料ID或模考、练习ID];
       CreateTime = 创建时间;
       checkFinish = 是否完成 0=未完成；1=已完成;
       StorePoint = 存储点[只针对任务类型为3，如果任务类型为1或2，默认为0， 1:够快网盘; 2:CC视频]
     */
    
    /**
     *  控制划线
     */
    if (_dataArray.count > 1) {
        if (indexPath.row == 0) {
            cell.isFristRow = YES;
            cell.isLastRow = NO;
        }else if(indexPath.row == _dataArray.count-1)
        {
            cell.isFristRow = NO;
            cell.isLastRow = YES;
        }else
        {
            cell.isFristRow = NO;
            cell.isLastRow = NO;
        }
    }else
    {
        cell.isFristRow = YES;
        cell.isLastRow = YES;
    }
    
    if (_dataArray.count > 0) {
        //控制完成度
        NSDictionary *taskModel = _dataArray[indexPath.row];
        //控制类型显示
        cell.dataDic = taskModel;
    }
    
    cell.classCode = self.classCode;
    
    
    return cell;
}


#pragma mark -<UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NDLog(@"班级详情---任务列表");
    if (_dataArray.count > 0) {
        
        NSDictionary *dayDic =  _dataArray[indexPath.row];
        NSString *type = [dayDic objectForKey:@"type"];
        GradeTaskModel *taskModel = [dayDic objectForKey:@"data"];
        
        if ([type isEqualToString:@"资料"]) {
            MaterialDetailViewController *resource =[[MaterialDetailViewController alloc]init];

            CHECK_DATA_IS_NSNULL(taskModel.RefID, NSNumber);
            resource.mid = [taskModel.RefID stringValue];
            
            CHECK_DATA_IS_NSNULL(taskModel.Name, NSString);
            CHECK_STRING_IS_NULL(taskModel.Name);
            resource.titleString = taskModel.Name;
            
            CHECK_DATA_IS_NSNULL(taskModel.StorePoint, NSNumber);
            resource.StorePoint = [taskModel.StorePoint stringValue];
            
            resource.isStudy = NO;
            [self.navigationController pushViewController:resource animated:YES];
        }else
        {
            DynamicDetailController *detail = [[DynamicDetailController alloc]init];
            detail.model = taskModel;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*AUTO_SIZE_SCALE_X;
}

#pragma mark - <DynamicResourceControllerDelegaete>
- (void)finishTaskResource
{
    [self _initData];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (DefaultView *)defaultView1
{
    if (!_defaultView1) {
        _defaultView1 = [[DefaultView alloc]init];
        _defaultView1.backgroundColor = [UIColor clearColor];
        _defaultView1.tipTitle = @"暂无任务";
        
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction)];
        [_defaultView1 addGestureRecognizer:tapOne];
    }
    return _defaultView1;
}




@end
