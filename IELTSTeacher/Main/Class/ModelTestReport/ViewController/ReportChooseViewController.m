//
//  ReportChooseViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/8/14.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ReportChooseViewController.h"
#import "studentChooseListModel.h"
#import "ReportChooseTableViewCell.h"

@interface ReportChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tabelView;

@end

@implementation ReportChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title = [NSString stringWithFormat:@"选择答案 %@ 的同学",self.titleChoose];
    self.titles = title;
    
    [self.view addSubview:self.tabelView];
    
}


#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _studentChooseList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ReportViewController";
    ReportChooseTableViewCell *cell = (ReportChooseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify ];
    if (!cell) {
        cell = [[ReportChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_studentChooseList.count > 0) {
        studentChooseListModel *model =  _studentChooseList[indexPath.row];
        cell.model = model;
    }
    return cell;
}

#define k_TopViewHeight (90*AUTO_SIZE_SCALE_X)
#define k_ChooseAndDisPuteHeight (213*AUTO_SIZE_SCALE_Y)
#define k_FillingHeight (120*AUTO_SIZE_SCALE_Y)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95*AUTO_SIZE_SCALE_X;
}


#pragma mark - set or get
- (UITableView *)tabelView
{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_X) style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.tableFooterView = [[UIView alloc]init];
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabelView.backgroundColor = [UIColor clearColor];
        _tabelView.showsHorizontalScrollIndicator = NO;
        _tabelView.showsVerticalScrollIndicator = NO;
    }
    return _tabelView;
}



@end
