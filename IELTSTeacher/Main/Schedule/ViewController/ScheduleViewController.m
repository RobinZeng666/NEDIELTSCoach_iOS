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
#import "PlanViewModel.h"
#import "PlanTableViewCell.h"
#import "GradeDetailViewController.h"
#import "DefaultView.h"

#define iconWith (40 * AUTO_SIZE_SCALE_X)
@interface ScheduleViewController () <
    UIScrollViewDelegate, FSCalendarDataSource, FSCalendarDelegate,
    UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) FSCalendar *calendar; //自定义日历
@property(copy, nonatomic) NSDate *selectedDate;
@property(assign, nonatomic) NSUInteger firstWeekday;
@property(nonatomic, strong) NSDate *curentDate; //当前日期
@property(nonatomic, strong) NSDate *nowDate;    //今天

@property(nonatomic, strong) UIImageView *iconImageView;
/**
 *  顶部视图切换
 */
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *befoerButton;
@property(nonatomic, strong) UIButton *nextButton;

@property(nonatomic, strong) UITableView *tabelView;

@property(nonatomic, strong) NSMutableArray *classDataArray;
@property(nonatomic, strong) NSArray *dayPlanArray;

@property(nonatomic, strong) NSMutableArray *allData;

/*
 */
@property(nonatomic, strong) DefaultView *defaultView;

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

      [self.view addSubview:self.defaultView];

      self.iconImageView.frame =
          CGRectMake(10, 20 + (44 - iconWith) / 2, iconWith, iconWith);
      //    [CommentMethod circleImage:self.iconImageView];

      //添加约束
      [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 40 * AUTO_SIZE_SCALE_Y));
      }];

      [self.befoerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_schedule.topView).with.offset(10);
        make.centerY.mas_equalTo(this_schedule.topView);
        make.size.mas_equalTo(
            CGSizeMake(25 * AUTO_SIZE_SCALE_X, 25 * AUTO_SIZE_SCALE_X));
      }];

      [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(this_schedule.topView).with.offset(-10);
        make.centerY.mas_equalTo(this_schedule.topView);
        make.size.mas_equalTo(
            CGSizeMake(25 * AUTO_SIZE_SCALE_X, 25 * AUTO_SIZE_SCALE_X));
      }];

      [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(this_schedule.topView);
        make.size.mas_equalTo(
            CGSizeMake(kScreenWidth - 80, 40 * AUTO_SIZE_SCALE_Y));
        make.top.mas_equalTo(this_schedule.topView).with.offset(0);
      }];

      CGFloat calendarHeight = 320 * AUTO_SIZE_SCALE_Y;
      [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_schedule.topView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, calendarHeight));
        make.left.mas_equalTo(0);
      }];

      self.defaultView.hidden = YES;
      CGFloat remainHeight = kScreenHeight - 320 * AUTO_SIZE_SCALE_Y -
                             40 * AUTO_SIZE_SCALE_Y - kNavHeight - 5 - 44;
      [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_schedule.calendar.mas_bottom)
            .with.offset((remainHeight - 100 * AUTO_SIZE_SCALE_Y) / 2);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100 * AUTO_SIZE_SCALE_Y));
        make.left.mas_equalTo(0);
      }];

      [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_schedule.calendar.mas_bottom)
            .with.offset(10 * AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(
            CGSizeMake(kScreenWidth, kScreenHeight - kNavHeight - TAB_BAR_HEIGHT -
                                         calendarHeight - 40 * AUTO_SIZE_SCALE_Y -
                                         10 * AUTO_SIZE_SCALE_Y));
      }];
}

//初始化数据
- (void)_initData
{
      NSDate *curentDate = [NSDate date];
      NSString *formatDate = [curentDate fs_stringWithFormat:@"yyyy年MM月"];
      self.titleLabel.text = formatDate;
      self.curentDate = curentDate;
      self.selectedDate = curentDate;
      self.nowDate = curentDate;
      //首页头像
      //    NSDictionary *userModel = [[ConfigData sharedInstance]getUserInfoModel];
      //    NSString *iconUrl = [userModel objectForKey:@"IconUrl"];
      //    CHECK_DATA_IS_NSNULL(iconUrl, NSString);
      //    CHECK_STRING_IS_NULL(iconUrl);
      //    NSString *iconPath = [NSString
      //    stringWithFormat:@"%@/%@",BaseUserIconPath,iconUrl];
      //    NSURL *url = [NSURL URLWithString:iconPath];
      //    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage
      //    imageNamed:@"person_default.png"]];

      /**
       *  请求当月课表
       */
      NSString *dayPramar = [curentDate fs_stringWithFormat:@"yyyy-MM-dd"];
      NSString *monthPramar = [curentDate fs_stringWithFormat:@"yyyy-MM"];

      [self requestData:dayPramar monthDate:monthPramar];
}

- (void)requestData:(NSString *)dataPramar monthDate:(NSString *)monthPramar {
  /*
    获取缓存数据
   */
  //    NSMutableArray *dataArray = [[ConfigData
  //    sharedInstance]getUserConfigInfowithKey:Schedule_Data];
  //    if (dataArray.count > 0) {
  //        for (NSDictionary *dataDic in dataArray) {
  //            NSString *dataPr = [dataDic objectForKey:@"dataPramar"];
  //            if ([dataPr isEqualToString:monthPramar]) {
  //                NSDictionary *result = [dataDic objectForKey:@"Data"];
  //                [self _dealData:result];
  //            }
  //        }
  //    }else{
  //第一次出现加载
  //    }
  /**
   *  请求数据
   */
  [self hideHud];
  [self showHudInView:self.view hint:@"正在加载..."];
  [[Service sharedInstance] getTeacherMonthLessonsForAppWithDateParam:dataPramar
      success:^(NSDictionary *result) {

        if (k_IsSuccess(result)) {
          //           NSDictionary *dic = @{@"dataPramar":monthPramar,
          //                                 @"Data":result};
          //           if (dataArray.count >  0) {
          //               [dataArray addObject:dic];
          //               [[ConfigData
          //               sharedInstance]saveUserConfigInfo:_allData
          //               withKey:Schedule_Data];
          //           }else {
          //               _allData = [[NSMutableArray alloc]init];
          //               [_allData addObject:dic];
          //               [[ConfigData
          //               sharedInstance]saveUserConfigInfo:_allData
          //               withKey:Schedule_Data];
          //           }

          [self _dealData:result];
        } else {
          //           [self showHint:@"课表请求失败！"];
        }
        [self hideHud];

      }
      failure:^(NSError *error) {
        [self hideHud];
        //       [self showHint:@"课表请求失败！"];
      }];
}

- (void)_dealData:(NSDictionary *)result
{
      NSArray *data = [result objectForKey:@"Data"];
      CHECK_DATA_IS_NSNULL(data, NSArray);
      _classDataArray = [[NSMutableArray alloc] initWithCapacity:data.count];

      if (data.count > 0) {
        self.defaultView.hidden = YES;
        self.tabelView.hidden = NO;
      } else {
        self.defaultView.hidden = NO;
        self.tabelView.hidden = YES;
      }

      if (data.count > 0) {
        for (NSDictionary *dayDic in data) {
          NSArray *dataArray = [dayDic allKeys];
          if (dataArray.count > 0) {
            NSMutableDictionary *dicData =
                [[NSMutableDictionary alloc] initWithCapacity:dataArray.count];

            NSString *key = [dataArray firstObject];
            NSDictionary *lessons = [dayDic objectForKey:key];
            NSArray *leesonsArray = [lessons objectForKey:@"lessons"];
            //
            NSString *countString = [NSString
                stringWithFormat:@"%lu", (unsigned long)leesonsArray.count];
            [dicData setObject:countString forKey:@"count"];
            [dicData setObject:leesonsArray forKey:@"lessons"];
            [dicData setObject:key forKey:@"keys"];

            [_classDataArray addObject:dicData];
          }
        }
        [_calendar reloadData];
        _calendar.selectedDate = self.curentDate;
      } else {
//        [self showHint:@"当月无课"];
//        [_calendar reloadData];
        _calendar.selectedDate = self.curentDate;
      }
      [self hideHud];
}

#pragma mark - delegate
#pragma mark - FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
      //    NDLog(@"did select date %@",[date fs_stringWithFormat:@"yyyy/MM/dd"]);
      NSString *formatDate = [date fs_stringWithFormat:@"yyyy年MM月"];
      self.titleLabel.text = formatDate;
      //保存当前时间
      self.selectedDate = date;

      _dayPlanArray = [[NSArray alloc] init];
      NSString *selectDate = [date fs_stringWithFormat:@"yyyy-MM-dd"];
      for (NSDictionary *dayDic in _classDataArray) {
        NSString *dayString = [dayDic objectForKey:@"keys"];
        if ([selectDate isEqualToString:dayString]) {
          NSArray *leesonsArray = [dayDic objectForKey:@"lessons"];
          _dayPlanArray = leesonsArray;
        }
      }

      if (_dayPlanArray.count > 0) {
        self.defaultView.hidden = YES;
        self.tabelView.hidden = NO;
      } else {
        self.defaultView.hidden = NO;
        self.tabelView.hidden = YES;
      }

      [self.tabelView reloadData];
}

- (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar {
  //    NDLog(@"did change to month %@",[calendar.currentMonth
  //    fs_stringWithFormat:@"MMMM yyyy"]);

      NSString *formatDate =
          [calendar.currentMonth fs_stringWithFormat:@"yyyy年MM月"];
      self.titleLabel.text = formatDate;
    
    NSString *mFirstMonth =  [NSDate dateToStringYYYYMM:calendar.currentMonth];
    NSString *mCurrentMonth = [NSDate dateToStringYYYYMM:[NSDate date]];
    CHECK_STRING_IS_NULL(mFirstMonth);
    CHECK_STRING_IS_NULL(mCurrentMonth);
    //当天的时候选择当天时间
    if ([mFirstMonth isEqualToString:mCurrentMonth]) {
        self.curentDate = [NSDate date];
    } else {
        self.curentDate = calendar.currentMonth;
    }
      //请求数据
      NSString *dayPramar =
          [calendar.currentMonth fs_stringWithFormat:@"yyyy-MM-dd"];
      NSString *monthPramar =
          [calendar.currentMonth fs_stringWithFormat:@"yyyy-MM"];
      [self requestData:dayPramar monthDate:monthPramar];
}

- (NSInteger)calendar:(FSCalendar *)calendar hasEventCountForDate:(NSDate *)date
{
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyy-MM-dd"];
      NSString *days = [dateFormatter stringFromDate:date];
      // 2015-06-12  4
      // 2015-10-12 3
      if (_classDataArray.count > 0) {
        for (NSDictionary *dayDic in _classDataArray) {
          NSString *dayString = [dayDic objectForKey:@"keys"];
          if ([days isEqualToString:dayString]) {
            return [[dayDic objectForKey:@"count"] integerValue];
          }
        }
      }

      return 0;
}

#pragma mark -  <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _dayPlanArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      static NSString *identiy = @"ScheduleViewControllerCell";
      PlanTableViewCell *cell = (PlanTableViewCell *)
          [tableView dequeueReusableCellWithIdentifier:identiy];
      if (!cell) {
        cell = [[PlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identiy];
        cell.selectionStyle = UITableViewCellAccessoryNone;
      }
      if (_dayPlanArray.count > 0) {
        NSDictionary *dic = _dayPlanArray[indexPath.row];
        PlanViewModel *model = [[PlanViewModel alloc] initWithDataDic:dic];
        cell.planModel = model;

        NSString *selectedDate =
            [self.selectedDate fs_stringWithFormat:@"yyyy-MM-dd"];
        NSString *curentDate = [self.nowDate fs_stringWithFormat:@"yyyy-MM-dd"];
        if ([selectedDate isEqualToString:curentDate]) {
          cell.detailImageView.hidden = NO;
          cell.isCurrentDate = YES;
        } else {
          cell.detailImageView.hidden = YES;
          cell.isCurrentDate = NO;
        }
      }
      return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (_dayPlanArray.count > 0) {
        NSDictionary *dic = _dayPlanArray[indexPath.row];
        PlanViewModel *model = [[PlanViewModel alloc] initWithDataDic:dic];
        NSString *sNameBc = model.sNameBc;

        NSString *sAddre = model.sAddress;
        CHECK_DATA_IS_NSNULL(sAddre, NSString);
        CHECK_STRING_IS_NULL(sAddre);
        NSString *sNameBr = model.sNameBr;
        CHECK_DATA_IS_NSNULL(sNameBr, NSString);
        CHECK_STRING_IS_NULL(sNameBr);
        NSString *addressString = [NSString stringWithFormat:@"%@%@", sAddre, sNameBr];

        NSString *sAddress = addressString;
        CHECK_DATA_IS_NSNULL(sNameBc, NSString);
        CHECK_DATA_IS_NSNULL(sAddress, NSString);
        CHECK_STRING_IS_NULL(sNameBc);
        CHECK_STRING_IS_NULL(sAddress);

        CGFloat titlesHeight = [CommentMethod widthForNickName:sNameBc
                                                 testLablWidth:234 * AUTO_SIZE_SCALE_X
                                                 textLabelFont:18.0f].height;
        CGFloat addressHeight = [CommentMethod widthForNickName:sAddress
                                                  testLablWidth:280 * AUTO_SIZE_SCALE_X
                                                  textLabelFont:16.0f].height;
        CGFloat addTit = 0;
        if (titlesHeight > 25*AUTO_SIZE_SCALE_Y) {
          addTit = titlesHeight - 25*AUTO_SIZE_SCALE_Y;
        }
        CGFloat addAdd = 0;
        if (addressHeight > 25*AUTO_SIZE_SCALE_Y) {
          addAdd = addressHeight - 25*AUTO_SIZE_SCALE_Y;
        }
//        NSLog(@"_____cellHeight_%f",90 + addTit + addAdd);
        return 90*AUTO_SIZE_SCALE_Y + addTit + addAdd + 10*AUTO_SIZE_SCALE_Y;
      }
      return 0;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (_dayPlanArray.count > 0) {
    NSString *selectedDate =
        [self.selectedDate fs_stringWithFormat:@"yyyy-MM-dd"];
    NSString *curentDate = [self.nowDate fs_stringWithFormat:@"yyyy-MM-dd"];
    if ([selectedDate isEqualToString:curentDate]) {
      NSDictionary *dic = _dayPlanArray[indexPath.row];
      PlanViewModel *model = [[PlanViewModel alloc] initWithDataDic:dic];
      GradeDetailViewController *grade =
          [[GradeDetailViewController alloc] init];
//      CHECK_DATA_IS_NSNULL(model.sCode, NSString);
      CHECK_DATA_IS_NSNULL(model.ids, NSString);
      CHECK_STRING_IS_NULL(model.ids);
      CHECK_DATA_IS_NSNULL(model.classId, NSString);
      CHECK_STRING_IS_NULL(model.classId);
      CHECK_DATA_IS_NSNULL(model.sCode, NSString);
      CHECK_STRING_IS_NULL(model.sCode);

      grade.classCode =  model.classId;//model.sCode;
      grade.sCode = model.sCode;
      grade.lessonId = model.ids;
      grade.ids = model.classId;

      CHECK_DATA_IS_NSNULL(model.sNameBr, NSString);
      grade.classTitle = model.sNameBc;
      [self.navigationController pushViewController:grade animated:YES];
    }
  }
}

#pragma mark - event response
- (void)beforeButtonAction:(UIButton *)beforeButton
{
      NSInteger currentYear = [[NSDate getTargetYear:self.curentDate] integerValue];
      NSInteger currentMonth =
          [[NSDate getTargetMouth:self.curentDate] integerValue];
      NSInteger currentMonthDays =
          [NSDate getDaysInMonth:currentMonth - 1 year:currentYear];

      NSDate *mFirstDay =   [NSDate dateWithTimeInterval:-60 * 60 * 24 * currentMonthDays
                                               sinceDate:self.curentDate];
      self.curentDate = mFirstDay;
     [_calendar scrollToDate:self.curentDate animate:YES];
}

- (void)nextButtonAction:(UIButton *)nextButton
{
      NSInteger currentYear = [[NSDate getTargetYear:self.curentDate] integerValue];
      NSInteger currentMonth =
          [[NSDate getTargetMouth:self.curentDate] integerValue];
      NSInteger currentMonthDays =
          [NSDate getDaysInMonth:currentMonth year:currentYear];

      NSDate *mFirstDay =
          [NSDate dateWithTimeInterval:60 * 60 * 24 * (currentMonthDays + 1)
                             sinceDate:self.curentDate];
      self.curentDate = mFirstDay;
      [_calendar scrollToDate:self.curentDate animate:YES];
}
//进入个人中心
- (void)iconTap:(UITapGestureRecognizer *)tap
{
      PersonalViewController *person = [[PersonalViewController alloc] init];
      [self.navigationController pushViewController:person animated:YES];
}

//- (void)tapOneAction
//{
//    [self _initData];
//}

#pragma mark - private metaods
#pragma mark - getters and setters
- (FSCalendar *)calendar
{
  if (!_calendar) {
    _calendar = [[FSCalendar alloc] initWithFrame:CGRectZero];
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.backgroundColor = [UIColor whiteColor];
    [_calendar setWeekdayTextColor:[UIColor darkGrayColor]];
    [_calendar setEventColor:RGBACOLOR(200, 200, 200, 1.0)];
    [_calendar setSelectionColor:k_PinkColor];
    [_calendar setHeaderDateFormat:@"MMMM yyyy"];
    [_calendar setMinDissolvedAlpha:1];
    //        [_calendar setTodayColor:k_PinkColor];
    [_calendar setCellStyle:FSCalendarCellStyleCircle];
    //        _calendar.selectedDate = [NSDate date];
  }
  return _calendar;
}

- (UIView *)topView
{
  if (!_topView)
  {
    _topView = [UIView new];
    _topView.backgroundColor = k_PinkColor;
  }
  return _topView;
}

- (UIButton *)befoerButton
{
  if (!_befoerButton)
  {
    _befoerButton = [CommentMethod
        createButtonWithImageName:@"schedule_rilijiantou_before.png"
                           Target:self
                           Action:@selector(beforeButtonAction:)
                            Title:@""];
  }
  return _befoerButton;
}

- (UIButton *)nextButton
{
  if (!_nextButton)
  {
    _nextButton =
        [CommentMethod createButtonWithImageName:@"schedule_rilijiantou.png"
                                          Target:self
                                          Action:@selector(nextButtonAction:)
                                           Title:@""];
  }
  return _nextButton;
}

- (UILabel *)titleLabel
{
  if (!_titleLabel)
  {
    _titleLabel = [CommentMethod createLabelWithFont:16.0f Text:@""];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
  }
  return _titleLabel;
}

- (UIImageView *)iconImageView
{
  if (!_iconImageView)
  {
    _iconImageView =
        [CommentMethod createImageViewWithImageName:@"person_default.png"];
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(iconTap:)];
    _iconImageView.layer.borderColor = [UIColor clearColor].CGColor;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.layer.cornerRadius = iconWith / 2;
    _iconImageView.layer.masksToBounds = YES;

    [_iconImageView addGestureRecognizer:tap];
  }
  return _iconImageView;
}

- (UITableView *)tabelView
{
  if (!_tabelView)
  {
    _tabelView = [[UITableView alloc]
        initWithFrame:CGRectMake(0, 320 + kNavHeight + 50, kScreenWidth,
                                 kScreenHeight - (320 + kNavHeight + 50) -
                                     TAB_BAR_HEIGHT)
                style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.tableFooterView = [[UIView alloc] init];
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabelView.backgroundColor = [UIColor clearColor];
  }
  return _tabelView;
}

- (DefaultView *)defaultView
{
  if (!_defaultView)
  {
    _defaultView = [[DefaultView alloc] init];
    _defaultView.backgroundColor = [UIColor clearColor];
    _defaultView.tipTitle = @"当天没有课程和计划";

//      UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction)];
//      [_defaultView addGestureRecognizer:tapOne];
  }
  return _defaultView;
}

@end
