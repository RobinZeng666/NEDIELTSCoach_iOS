//
//  CBDatePickerView.h
//  customPickView
//
//  Created by citicbank on 14-10-1.
//  Copyright (c) 2014年 citicbank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAccessoryView.h"
@protocol CBDatePickerDelegate;

@interface CBDatePickerView : UIView<CBAccessoryViewDelegate>
@property (nonatomic,assign)BOOL           isVisible;
@property (nonatomic, strong) UIDatePicker *datePickView;
@property (nonatomic,unsafe_unretained) NSString *title;
@property (nonatomic, strong) id<CBDatePickerDelegate>delegate;
//type date
@property (nonatomic, strong) NSDate *dateValue;    //result.
@property (nonatomic, strong) NSDate *minDate;      //enabled min date range.
@property (nonatomic, strong) NSDate *maxDate;      //enabled max date range.


- (void)setSelectedDate:(NSDate *)selectedDate;     //set default display date.

- (void)showPickerView;
- (void)hidePickerView;
@end

@protocol CBDatePickerDelegate <NSObject>

@optional
- (void)returnDate:(NSDate *)selectDate;

@end