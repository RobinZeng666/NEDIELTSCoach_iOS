//
//  CBDatePickerView.m
//  customPickView
//
//  Created by citicbank on 14-10-1.
//  Copyright (c) 2014年 citicbank. All rights reserved.
//

#import "CBDatePickerView.h"


#define kToolBarHeight 44
#define kPickerViewHeight 216

@interface CBDatePickerView ()
{
@private
    NSDate *      _tempSelectedValue;
    NSDate *        _selectedDate;
}

@end

@implementation CBDatePickerView

- (id)initWithFrame:(CGRect)frame
{
//    frame.size.height = 25.0f;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSelf];
    }
    return self;
}
- (void)initSelf{
    
    _datePickView = [[UIDatePicker alloc]init];
    if (!_isVisible) {
        [self becomeFirstResponder];
        
        _isVisible = YES;
        self.backgroundColor = [UIColor whiteColor];;
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kToolBarHeight + kPickerViewHeight);
        CBAccessoryView *accessoryView = [[CBAccessoryView alloc] initWithDelegate:self];
        [self addSubview:accessoryView];
        
        _datePickView.frame =CGRectMake(0, kToolBarHeight, kScreenWidth, kPickerViewHeight);
        [_datePickView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        _datePickView.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        _datePickView.datePickerMode = UIDatePickerModeDate;
        _datePickView.backgroundColor = [UIColor clearColor];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = kDateFormat;
//        _tempSelectedValue = [formatter stringFromDate:[NSDate date]];
        _tempSelectedValue = [NSDate date];

        [self addSubview:_datePickView];
        [self reloadData];
        
        [UIView animateWithDuration:0.26 animations:^{
            self.frame = CGRectMake(0, kScreenHeight-kToolBarHeight - kPickerViewHeight, kScreenWidth, kToolBarHeight + kPickerViewHeight);
        } completion:^(BOOL finished) {
            finished = YES;
            _isVisible = YES;
        }];
    }
    
}
- (void)reloadData{
   
        NSDate *defaultDate = nil;
        if (_selectedDate) {
            defaultDate = _selectedDate;
            
        } else {
            defaultDate = [NSDate date];
        }
        _dateValue = defaultDate;
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        //        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//        formatter.dateFormat = kDateFormat;
    _tempSelectedValue = defaultDate;
//    _tempSelectedValue = [[formatter stringFromDate:defaultDate] copy];
}
- (void)showPickerView{
    [UIView animateWithDuration:0.26 animations:^{
        self.frame = CGRectMake(0, kScreenHeight-kToolBarHeight - kPickerViewHeight, kScreenWidth, kToolBarHeight + kPickerViewHeight);
    } completion:^(BOOL finished) {
        _isVisible = YES;
        finished = YES;
    }];
}

- (void)hidePickerView{
    if (_isVisible) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kToolBarHeight + kPickerViewHeight);
        } completion:^(BOOL finished) {
            _isVisible = NO;
            finished = YES;
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    [self hidePickerView];
}

- (void)pickerViewWillShow:(NSNotification *)notification{
    [self hidePickerView];
}



#pragma mark MBAccessoryViewDelegate
- (void)accessoryViewDidPressedCancelButton:(CBAccessoryView *)view{
 
    
    [self hidePickerView];
}

- (void)accessoryViewDidPressedDoneButton:(CBAccessoryView *)view{
    //值确认
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(returnDate:)]){
        [self.delegate returnDate:_tempSelectedValue];
    }
    [self hidePickerView];
}


- (void)datePickerValueChanged:(UIDatePicker *)picker{
    
    _selectedDate = picker.date;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = kDateFormat;
//    _tempSelectedValue = [formatter stringFromDate:picker.date];
    _tempSelectedValue = picker.date;
}
- (void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    _datePickView.date = selectedDate;
    
}
- (void)setMinDate:(NSDate *)minDate{
    _datePickView.minimumDate = minDate;
    
}
- (void)setMaxDate:(NSDate *)maxDate{
     _datePickView.maximumDate = maxDate;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
