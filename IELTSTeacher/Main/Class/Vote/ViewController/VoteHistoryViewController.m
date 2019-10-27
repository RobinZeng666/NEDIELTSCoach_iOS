//
//  VoteHistoryViewController.m
//  IELTSTeacher
//
//  Created by Newton on 15/9/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "VoteHistoryViewController.h"
#import "VoteHistoryTableViewCell.h"
#import "VoteHistoryModel.h"
#import "VoteHistorySelectModel.h"
#import "DefaultView.h"

#define kCellHeight (45*AUTO_SIZE_SCALE_Y)
@interface VoteHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView       *historyTableView;
@property (nonatomic, strong) NSMutableArray    *dataArray;

@property (nonatomic, strong) DefaultView       *defaultView;//默认视图

@end

@implementation VoteHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @"投票历史记录";
    //初始化视图
    [self _initView];
    //初始化数据
    [self _initData];
    
}

- (void)_initView
{
    [self.view addSubview:self.historyTableView];
    [self.view addSubview:self.defaultView];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y-100*AUTO_SIZE_SCALE_Y)/2);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_Y));
    }];
    
    self.historyTableView.hidden = NO;
    self.defaultView.hidden = YES;
}

- (void)_initData
{
    //[互动课堂ID，不可为空]
    [self showHudInView:self.view hint:@"正在加载..."];
    [[Service sharedInstance]loadVoteHisInfoWithPram:self.activeClassId
                                            succcess:^(NSDictionary *result) {
                                                [self hideHud];
                                                if (k_IsSuccess(result)) {
                                                     NSDictionary *data = [result objectForKey:@"Data"];
                                                    CHECK_DATA_IS_NSNULL(data, NSDictionary);
                                                    if (data.count > 0) {
                                                        
                                                        NSArray *hisVotes= [data objectForKey:@"hisVotes"];
                                                        _dataArray = [[NSMutableArray alloc]initWithCapacity:hisVotes.count];
                                                        if (hisVotes.count > 0) {
                                                            self.historyTableView.hidden = NO;
                                                            self.defaultView.hidden = YES;

                                                            for (NSDictionary *voteDic in hisVotes) {
                                                              VoteHistoryModel *model =  [[VoteHistoryModel alloc]initWithDataDic:voteDic];
                                                               [_dataArray addObject:model];
                                                            }
                                                            [self.historyTableView reloadData];
                                                        } else {
                                                            self.historyTableView.hidden = YES;
                                                            self.defaultView.hidden = NO;
                                                        }
                                                    }
                                                } else {
                                                    if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                        [self showHint:[result objectForKey:@"Infomation"]];
                                                    }
                                                    
                                                    self.historyTableView.hidden = YES;
                                                    self.defaultView.hidden = NO;
                                                }
    } failure:^(NSError *error) {
        self.historyTableView.hidden = YES;
        self.defaultView.hidden = NO;
        
        [self hideHud];
        [self showHint:[error networkErrorInfo]];
    }];

}
#pragma mark - <UITableViewDataSource>
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return _dataArray.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"VoteHistoryViewController";
    VoteHistoryTableViewCell *cell = (VoteHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[VoteHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    if (_dataArray.count > 0) {
        VoteHistoryModel *model = _dataArray[indexPath.row];
        cell.model = model;
        cell.indexRow = indexPath.row;
        [cell.voteTableView reloadData];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3*AUTO_SIZE_SCALE_Y;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        VoteHistoryModel *model = _dataArray[indexPath.row];
        CHECK_DATA_IS_NSNULL(model.Subject, NSString);
        CHECK_STRING_IS_NULL(model.Subject);
        CGSize  contentSizeForTextView = [CommentMethod widthForNickName:model.Subject
                                                           testLablWidth:kScreenWidth
                                                           textLabelFont:18.0f];
        NSArray *opts = model.opts;
        CGFloat selectHeight = 0.0;
        for (int i=0; i<opts.count; i++) {
            NSDictionary *selectDic = opts[i];
            VoteHistorySelectModel *selectModel = [[VoteHistorySelectModel alloc]initWithDataDic:selectDic];
            CHECK_DATA_IS_NSNULL(selectModel.OptionDesc, NSString);
            CHECK_STRING_IS_NULL(selectModel.OptionDesc);
//            CGSize  contentSizeForDesc = [CommentMethod widthForNickName:selectModel.OptionDesc
//                                                           testLablWidth:(kScreenWidth - 80*AUTO_SIZE_SCALE_X)
//                                                           textLabelFont:18.0f];
//            if (contentSizeForDesc.height > kCellHeight) {
//                selectHeight = selectHeight + contentSizeForDesc.height;
//            }else{
                selectHeight = selectHeight + kCellHeight;
//            }
        }
        if (contentSizeForTextView.height > 192*AUTO_SIZE_SCALE_Y) {
            return selectHeight+contentSizeForTextView.height+20+opts.count*3*AUTO_SIZE_SCALE_Y;
        }else{
            return selectHeight+192*AUTO_SIZE_SCALE_Y+opts.count*3*AUTO_SIZE_SCALE_Y;
        }
    }
    return 0;
}


#pragma mark - set or get
- (UITableView *)historyTableView
{
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight+5, kScreenWidth, kScreenHeight-kNavHeight-10) style:UITableViewStylePlain];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.backgroundColor = [UIColor clearColor];
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _historyTableView.tableFooterView = [[UIView alloc]init];
    }
    return _historyTableView;
}

- (DefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [DefaultView new];
        _defaultView.tipTitle = @"暂无历史投票";
    }
    return _defaultView;
}

@end
