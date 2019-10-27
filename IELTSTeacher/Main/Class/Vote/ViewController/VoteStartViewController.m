//
//  VoteStartViewController.m
//  IELTSTeacher
//
//  Created by Newton on 15/9/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "VoteStartViewController.h"
#import "VoteCommentTableViewCell.h"
#import "VoteHistorySelectModel.h"

#define kCellHeight (45*AUTO_SIZE_SCALE_Y)
@interface VoteStartViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIButton *endButton;
@property (nonatomic, strong) UITextView *bodyTextView; //上面显示的文字
@property (nonatomic, strong) NSTimer *timers; //定时器


@property (nonatomic, strong) NSArray *voteListArray;//投票的选项
@property (nonatomic, strong) UITableView *voteListTabelView;//投票列表

@property (nonatomic, assign) BOOL isFirstSelect;//是否选择过

@end

@implementation VoteStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titles = @"投票内容";
   //初始化视图
    [self _initView];
 
    //获取一次投票信息
    [self  changeTimeValue];
    
    //开启定时器开始获取学生端的投票数据
    [self startCollectStuVote];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.timers != nil) {
        [self.timers invalidate];
        self.timers = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //默认进入时老师未选择投票
    self.isFirstSelect = YES;
}


- (void)_initView
{
    //去掉返回按钮
    self.backButton.hidden = YES;
    
    [self.view addSubview:self.endButton];
    [self.view addSubview:self.bodyTextView];
    [self.view addSubview:self.voteListTabelView];
    
    [self.endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-38*AUTO_SIZE_SCALE_Y);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(338*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_Y));
    }];
    [self.voteListTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.bodyTextView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 6*kCellHeight));
    }];
    
    //投票内容
    self.bodyTextView.text = self.voteDesc;
    CHECK_DATA_IS_NSNULL(self.voteDesc, NSString);
    CHECK_STRING_IS_NULL(self.voteDesc);
    CGSize  contentSizeForTextView = [CommentMethod widthForNickName:self.voteDesc
                                                       testLablWidth:kScreenWidth
                                                       textLabelFont:18.0f];
    
    if (contentSizeForTextView.height > 192*AUTO_SIZE_SCALE_Y) {
        [self.bodyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kNavHeight+5);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, contentSizeForTextView.height+20));
        }];
    }else{
        [self.bodyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kNavHeight+5);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 192*AUTO_SIZE_SCALE_Y));
        }];
    }

}

- (void)startCollectStuVote
{
    self.timers = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                   target:self
                                                 selector:@selector(changeTimeValue)
                                                 userInfo:nil
                                                  repeats:YES];
    [self.timers fire];
 }


//0-100
- (void)changeTimeValue
{
    //2.开始心跳包
//      activeClassId=[互动课堂ID，不可为空]
//      voteId=[投票定义ID，不可为空]
    [[Service sharedInstance]collectStuVotesWithPram:self.activeClassId
                                              voteId:self.voteId
                                            succcess:^(NSDictionary *result) {
                                                //更新数据成功，刷新cell的数据
                                                if (k_IsSuccess(result)) {
                                                    NSArray *data = [result objectForKey:@"Data"];
                                                    if (data.count > 0) {
                                                        self.voteListArray = data;
                                                    }
                                                    [self.voteListTabelView reloadData];
                                                }
                                            } failure:^(NSError *error) {
                                                
                                            }];
}



#pragma mark - event response
- (void)endAction:(UIButton *)button
{
    if (self.timers != nil) {
        [self.timers invalidate];
        self.timers = nil;
    }
    //结束投票
    [self endVoteAction:button];
}

//停止投票
- (void)endVoteAction:(UIButton *)button
{
    button.enabled = NO;
    [self showHudInView:self.view hint:@"正在停止投票..."];
    [[Service sharedInstance]finishVoteWithPram:self.activeClassId
                                         voteId:self.voteId
                                       succcess:^(NSDictionary *result) {
                                           [self hideHud];
                                           button.enabled = YES;
                                           if (k_IsSuccess(result)) {
                                               //返回到互动首页
                                               [self dismissViewControllerAnimated:YES completion:nil];
                                           }
                                       } failure:^(NSError *error) {
                                           [self hideHud];
                                           button.enabled = YES;
                                           [self showHint:[error networkErrorInfo]];
                                       }];
    
}



#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _voteListArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;//_voteListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfiy = @"VoteStartViewController";
    VoteCommentTableViewCell *cell = (VoteCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identfiy];
    if (!cell) {
        cell = [[VoteCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfiy];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_voteListArray.count > 0) {
        cell.dataDic = _voteListArray[indexPath.section];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isFirstSelect) {
        self.isFirstSelect = NO;
        //自己选择投票
        NSDictionary *voteDic = _voteListArray[indexPath.section];
        VoteHistorySelectModel *selectModel = [[VoteHistorySelectModel alloc]initWithDataDic:voteDic];
        NSNumber *OptionNum = selectModel.OptionNum;
        CHECK_DATA_IS_NSNULL(OptionNum, NSNumber);
        
        NSDictionary *dataDic = @{@"activeClassId":self.activeClassId,
                                  @"voteId":self.voteId,
                                  @"optNum":[OptionNum stringValue]
                                  };
        [[Service sharedInstance]joinVoteWithPram:dataDic
                                         succcess:^(NSDictionary *result) {
                                             if (k_IsSuccess(result)) {
                                                 NDLog(@"投票信息：%@", result);
                                                 [self showHint:@"投票成功!"];
                                             }
                                         } failure:^(NSError *error) {
                                             
                                         }];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3*AUTO_SIZE_SCALE_Y;
}


#pragma mark - getters and setters
- (UITextView *)bodyTextView
{
    if (!_bodyTextView) {
        _bodyTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 192*AUTO_SIZE_SCALE_Y)];
        _bodyTextView.userInteractionEnabled = NO;
        _bodyTextView.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _bodyTextView.backgroundColor = [UIColor clearColor];
        _bodyTextView.textColor = [UIColor darkGrayColor];
        [_bodyTextView endEditing:NO];
    }
    return _bodyTextView;
}

- (UITableView *)voteListTabelView
{
    if (!_voteListTabelView) {
        _voteListTabelView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _voteListTabelView.delegate = self;
        _voteListTabelView.dataSource = self;
        _voteListTabelView.tableFooterView = [[UIView alloc]init];
        _voteListTabelView.backgroundColor = [UIColor clearColor];
        _voteListTabelView.rowHeight = kCellHeight;
        _voteListTabelView.bounces = NO;
    }
    return _voteListTabelView;
}


- (UIButton *)endButton
{
    if (!_endButton) {  //338 × 45
        _endButton  = [CommentMethod createButtonWithImageName:@"interation_anniu.png" Target:self Action:@selector(endAction:) Title:@"结束投票"];
        [_endButton setBackgroundImage:[UIImage imageNamed:@"interation_anniu_dianji.png"] forState:UIControlStateHighlighted];
        [_endButton setTitle:@"开始投票" forState:UIControlStateSelected];
    }
    return _endButton;
}

@end
