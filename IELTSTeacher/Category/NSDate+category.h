//
//  NSDate+category.h
//  NovartisPPH
//
//  Created by Sidney on 13-10-16.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (category)

/**
 NSString to NSDate yyyy-MM-dd HH:mm
 */
+ (NSDate *)stringToDateYYYYMMDDHHMM:(NSString *)dateString;

/**
 NSString to NSDate yyyy-MM-dd
 */
+ (NSDate *)stringToDateYYYYMMDD:(NSString *)dateString;
/**
 NSString to NSDate HH:mm
 */
+ (NSDate *)stringToDateHHmm:(NSString *)dateString;

/**
获取当前时间 年月日时分 yyyy-MM-dd HH:mm
 */
+ (NSDate *)getCurrentDate;

/**
 获取当前时间 年月日时分 yyyy-MM-dd
 */
+ (NSDate *)getCurrentDateYYYYMMDD;

/**
 获取当前时间 年 YYYY
 */
+ (NSString *)getCurrentYear;

/**
 获取当前时间 月 MM
 */
+ (NSString *)getCurrentMouth;


/**
 获取当前时间 日 dd
 */
+ (NSString *)getCurrentDay;

/**
 获取当前时间 时 HH
 */
+ (NSString *)getCurrentHour;

/**
 获取当前时间 分钟 mm
 */
+ (NSString *)getCurrentMinute;
/**
 获取指定时间 分钟 mm
 */
+ (NSString *)getSelectedMinute:(NSDate *)selectedDate;
/**
  指定时间的未来N个小时的时间
 */
+ (NSDate *)priousorDateByPlusHours:(int)hours date:(NSDate *)date;

/**
 指定时间的未来N分钟的时间
 */
+ (NSDate *)priousorDateByPlusMinute:(int)minute date:(NSDate *)date;

/**
 给一个时间，给一个数，正数是以后n个月，负数是前n个月
 */
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;


/**
 指定时间与当前时间的天数间隔 YYYY-MM-DD
 */
+ (NSInteger)getDayIntervalFromDate:(NSDate *)date;

//计算一个月有多少天
+(NSInteger)getDaysInMonth:(NSInteger)month year:(NSInteger)year;


/**
 获取目标时间 年 YYYY
 */
+ (NSString *)getTargetYear:(NSDate *)targetDate;
/**
 获取目标月  MM
 */
+ (NSString *)getTargetMouth:(NSDate *)targetDate;

/*
 获取目标天 dd
 */
+ (NSString *)getTargetDay:(NSDate *)targetDate;


+ (NSString *)dateToStringYYYYMMDD:(NSDate *)dateString;


+ (NSString *)dateToStringYYYYMM:(NSDate *)dateString;

/**
 *  自定义formatter
 *
 *  @param dateString 日期
 *  @param formatter  格式
 *
 *  @return 格式化后的日期string
 */
+ (NSString *)dateToString:(NSDate *)dateString Formatter:(NSString *)formatter;

/**
 创建时间格式化
 */
+ (NSString *)changeCreatTime:(NSNumber *)creatTime;

+ (NSString *)changeCreatTimeForHHMM:(NSNumber *)creatTime;

+ (NSString *)changeCreatTime:(NSNumber *)creatTime  Formatter:(NSString *)formatter;

@end
