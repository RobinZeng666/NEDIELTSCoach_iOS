//
//  ScheduleViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ScheduleViewController.h"
#import "NSDate+FSExtension.h"
#import "FSCalendar.h"
#import "PersonalViewController.h"

@interface ScheduleViewController ()<UIScrollViewDelegate, FSCalendarDataSource, FSCalendarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) FSCalendar  *calendar;    //自定义日历
@property (copy,   nonatomic) NSDate      *selectedDate;
@property (assign, nonatomic) NSUInteger  firstWeekday;
@property (nonatomic,strong)  NSDate      *curentDate;   //当前日期

@property (nonatomic,strong) UIImageView *iconImageView;
/**
 *  顶部视图切换
 */
@property (nonatomic,strong) UIView   *topView;
@property (nonatomic,strong) UILabel  *titleLabel;
@property (nonatomic,strong) UIButton *befoerButton;
@property (nonatomic,strong) UIButton *nextButton;

@property (nonatomic,strong) UITableView *tabelView;



@end

@implementation ScheduleViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"雅思互动学习平台";
    
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
    WS(this_schedule);
    
    [self.view addSubview:self.calendar];
    [self.topView addSubview:self.befoerButton];
    [self.topView addSubview:self.nextButton];
    [self.topView addSubview:self.titleLabel];
    [self.view addSubview:self.topView];
    [self.navView addSubview:self.iconImageView];
    [self.view addSubview:self.tabelView];
    
    self.iconImageView.frame = CGRectMake(10, 20+(44-30)/2, 30, 30);
    [CommentMethod circleImage:self.iconImageView];
    
    //添加约束
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavHeight);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(40);
    }];
    
    [self.befoerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_schedule.topView).with.offset(20);
        make.centerY.mas_equalTo(this_schedule.topView);
        make.size.mas_equalTo(CGSizeMake(25, 25));

    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(this_schedule.topView).with.offset(-20);
        make.centerY.mas_equalTo(this_schedule.topView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(this_schedule.topView);
        make.width.equalTo(200);
        make.height.equalTo(40);
        make.top.equalTo(this_schedule.topView).with.offset(0);
    }];
    
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(this_schedule.topView).with.offset(@40);
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(320);
    }];
}

//初始化数据
- (void)_initData
{
    NSDate *curentDate = [NSDate date];
    NSString *formatDate = [curentDate fs_stringWithFormat:@"yyyy年MM月01日"];
    self.titleLabel.text = formatDate;
    self.curentDate = curentDate;
    
    /**
     *
     */
    NSString *dayPramar = [curentDate fs_stringWithFormat:@"yyyy-MM-01"];
    [self requestData:dayPramar];
    
}

- (void)requestData:(NSString *)dataPramar
{
    /**
     *  请求数据
     */
    dispatch_queue_t network_queue = dispatch_queue_create("PlanViewController", nil);
    dispatch_async(network_queue, ^{
    [[Service sharedInstance]getTeacherMonthLessonsForAppWithDateParam:dataPramar
                                                               success:^(NSDictionary *result) {
                                                                   if (k_IsSuccess(result)) {
                                                                       NSArray *data = [result objectForKey:@"Data"];
                                                                       if (data.count > 0) {
                                                                           
                                                                       }
                                                                       
                                                                   }else
                                                                   {
                                                                   
                                                                   }
                                                               } failure:^(NSError *error) {
                                                                   
                                                               }];
    });
}

#pragma mark - delegate
#pragma mark - FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NDLog(@"did select date %@",[date fs_stringWithFormat:@"yyyy/MM/dd"]);
    NSString *formatDate = [date fs_stringWithFormat:@"yyyy年MM月dd日"];
    self.titleLabel.text = formatDate;
    
}

- (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar
{
    NDLog(@"did change to month %@",[calendar.currentMonth fs_stringWithFormat:@"MMMM yyyy"]);
    
    NSString *formatDate = [calendar.currentMonth fs_stringWithFormat:@"yyyy年MM月dd日"];
    self.titleLabel.text = formatDate;
    self.curentDate = calendar.currentMonth;
}

- (NSInteger)calendar:(FSCalendar *)calendar hasEventCountForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *days = [dateFormatter stringFromDate:date];
    //2015-06-12  4
    //2015-10-12 3
    if ([days isEqualToString:@"2015-06-12"]) {
        return 2;
    }
    return 0;
}

#pragma mark -  <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identiy = @"ScheduleViewControllerCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identiy];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identiy];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}



#pragma mark - event response
- (void)beforeButtonAction:(UIButton *)beforeButton
{
    NSInteger currentYear =  [[NSDate getTargetYear:self.curentDate] integerValue];
    NSInteger currentMonth = [[NSDate getTargetMouth:self.curentDate] integerValue];
    NSInteger currentMonthDays = [NSDate getDaysInMonth:currentMonth-1 year:currentYear];
    NSDate *mFirstDay = [NSDate dateWithTimeInterval:-60*60*24*currentMonthDays sinceDate:self.curentDate];
    self.curentDate = mFirstDay;
    [_calendar scrollToDate:self.curentDate animate:YES];
}

- (void)nextButtonAction:(UIButton *)nextButton
{
    NSInteger currentYear =  [[NSDate getTargetYear:self.curentDate] integerValue];
    NSInteger currentMonth = [[NSDate getTargetMouth:self.curentDate] integerValue];
    NSInteger currentMonthDays = [NSDate getDaysInMonth:currentMonth year:currentYear];
    
    NSDate *mFirstDay = [NSDate dateWithTimeInterval:60*60*24*(currentMonthDays+1) sinceDate:self.curentDate];
    self.curentDate = mFirstDay;
    
    [_calendar scrollToDate:self.curentDate animate:YES];
}
//进入个人中心
- (void)iconTap:(UITapGestureRecognizer *)tap
{
    PersonalViewController *person = [[PersonalViewController alloc]init];
    [self.navigationController pushViewController:person animated:YES];
}

#pragma mark - private metaods
#pragma mark - getters and setters
- (FSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc]initWithFrame:CGRectZero];
        _calendar.delegate = self;
        _calendar.dataSource = self;
        _calendar.backgroundColor = [UIColor whiteColor];
        [_calendar setWeekdayTextColor:[UIColor darkGrayColor]];
        [_calendar setEventColor:RGBACOLOR(200, 200, 200, 1.0)];
        [_calendar setSelectionColor:RGBACOLOR(200, 200, 200, 1.0)];
        [_calendar setHeaderDateFormat:@"MMMM yyyy"];
        [_calendar setMinDissolvedAlpha:1];
        [_calendar setTodayColor:k_PinkColor];
        [_calendar setCellStyle:FSCalendarCellStyleCircle];
    }
    return _calendar;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = k_PinkColor;
    }
    return _topView;
}

- (UIButton *)befoerButton
{
    if (!_befoerButton) {
        _befoerButton = [CommentMethod createButtonWithImageName:@"rilijiantou_before.png" Target:self Action:@selector(beforeButtonAction:) Title:@""];
    }
    return _befoerButton;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [CommentMethod createButtonWithImageName:@"rilijiantou.png" Target:self Action:@selector(nextButtonAction:) Title:@""];
    }
    return _nextButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [CommentMethod createImageViewWithImageName:@"u=927192040,4207822237&fm=21&gp=0.jpg"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap:)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
}

- (UITableView *)tabelView
{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 320+kNavHeight+50, kScreenWidth, kScreenHeight-(320+kNavHeight+50)-TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.tableFooterView = [[UIView alloc]init];
    }
    return _tabelView;
}

@end
