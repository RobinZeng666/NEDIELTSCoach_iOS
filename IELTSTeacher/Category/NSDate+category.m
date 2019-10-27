//
//  NSDate+category.m
//  NovartisPPH
//
//  Created by Sidney on 13-10-16.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "NSDate+category.h"

@implementation NSDate (category)

+ (NSDate *)stringToDateYYYYMMDD:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSDate *)stringToDateHHmm:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate * date = [dateFormatter dateFromString:dateString];
    return date;
}


+ (NSDate *)getCurrentDate;
{
//    NSLog(@"%@",    [NSTimeZone knownTimeZoneNames]);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString *todayTime = [dateFormatter stringFromDate:today];
    return [self stringToDateYYYYMMDDHHMM:todayTime];
}

/**
 获取当前时间 年月日时分 yyyy-MM-dd
 */
+ (NSDate *)getCurrentDateYYYYMMDD
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString *todayTime = [dateFormatter stringFromDate:today];
    return [self stringToDateYYYYMMDD:todayTime];
}

+ (NSString *)getCurrentYear
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString * year = [dateFormatter stringFromDate:today];
    return year;

}

+ (NSString *)getCurrentMouth
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString * mouth = [dateFormatter stringFromDate:today];
    return mouth;

}

+ (NSString *)getCurrentDay
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString * day = [dateFormatter stringFromDate:today];
    return day;
}

+ (NSString *)getCurrentHour
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString * hours = [dateFormatter stringFromDate:today];
    return hours;
}

+ (NSString *)getCurrentMinute
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:@"mm"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString * hours = [dateFormatter stringFromDate:today];
    return hours;
}




+ (NSString *)getSelectedMinute:(NSDate *)selectedDate
{
   // NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:@"mm"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString * hours = [dateFormatter stringFromDate:selectedDate];
    return hours;
}



+ (NSDate *)priousorDateByPlusHours:(int)hours date:(NSDate *)date
{
    NSTimeInterval interval = date.timeIntervalSinceReferenceDate;
    interval += 3600 * hours;
    NSDate * newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:interval];
    return newDate;
}

+ (NSDate *)priousorDateByPlusMinute:(int)minute date:(NSDate *)date
{
    NSTimeInterval interval = date.timeIntervalSinceReferenceDate;
    interval += 60 * minute;
    NSDate * newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:interval];
    
    return newDate;
}

+ (NSDate *)stringToDateYYYYMMDDHHMM:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate * date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}

/**
 指定时间与当前时间的天数间隔 YYYY-MM-DD
 */
+ (NSInteger)getDayIntervalFromDate:(NSDate *)date
{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate * startDate = [NSDate getCurrentDateYYYYMMDD];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:date options:0];
    NSInteger days = [comps day];
    return days;
    
}


+(NSInteger)getDaysInMonth:(NSInteger)month year:(NSInteger)year
{
    int daysInFeb = 28;
    if (year%4 == 0) {
        daysInFeb = 29;
    }
    int daysInMonth [12] = {31,daysInFeb,31,30,31,30,31,31,30,31,30,31};
    return daysInMonth[month-1];
}

/**
 获取目标时间 年 YYYY
 */
+ (NSString *)getTargetYear:(NSDate *)targetDate
{
//    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString * year = [dateFormatter stringFromDate:targetDate];
    return year;

}
/**
 获取目标月 年 MM
 */
+ (NSString *)getTargetMouth:(NSDate *)targetDate
{
//    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString * mouth = [dateFormatter stringFromDate:targetDate];
    return mouth;
}

+ (NSString *)getTargetDay:(NSDate *)targetDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString * day = [dateFormatter stringFromDate:targetDate];
    return day;
}


+ (NSString *)dateToStringYYYYMMDD:(NSDate *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [dateFormatter stringFromDate:dateString];
    return string;
}

+ (NSString *)dateToStringYYYYMM:(NSDate *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *string = [dateFormatter stringFromDate:dateString];
    return string;
}


+ (NSString *)dateToString:(NSDate *)dateString Formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *string = [dateFormatter stringFromDate:dateString];
    return string;
}

+ (NSString *)changeCreatTime:(NSNumber *)creatTime
{
    long long time = [creatTime longLongValue];
    long long  times =  time/1000;
    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //hh:mm:ss
    NSString *dateTime =  [dateFormatter stringFromDate:creatDate];
    
    return dateTime;
}

+ (NSString *)changeCreatTimeForHHMM:(NSNumber *)creatTime
{
    long long time = [creatTime longLongValue];
    long long  times =  time/1000;
    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"]; //hh:mm:ss
    NSString *dateTime =  [dateFormatter stringFromDate:creatDate];
    
    return dateTime;
}

+ (NSString *)changeCreatTime:(NSNumber *)creatTime  Formatter:(NSString *)formatter
{
    long long time = [creatTime longLongValue];
    long long  times =  time/1000;
    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatter]; //hh:mm:ss
    NSString *dateTime =  [dateFormatter stringFromDate:creatDate];
    
    return dateTime;
}


@end
