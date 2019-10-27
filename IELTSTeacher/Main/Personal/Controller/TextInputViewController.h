//
//  TextInputViewController.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/24.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseViewController.h"

@class TextInputViewController;

typedef void(^SureBlock)(TextInputViewController *viewController, NSString *inputText);

@interface TextInputViewController : BaseViewController

@property (nonatomic,copy) NSString *titleString;
@property (nonatomic,copy) NSString *valueString;

@property (nonatomic,copy) SureBlock block;

- (void)addSureBlock:(void (^)(TextInputViewController *viewController, NSString *inputText))block;

@end
