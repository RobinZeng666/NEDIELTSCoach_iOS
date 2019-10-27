//
//  NewsDetailViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/25.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //消息标题
    self.titles = @"消息详情";
    
    [self.view addSubview:self.textView];
    self.textView.text = self.bodyString;
    
    [self _initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initData
{
    if (!_isRead) {
        
        NSDictionary *dic = @{@"messageId":self.MI_ID,
                              @"type":self.typeString};
        [[Service sharedInstance]readOrDelMessageWithPram:dic
                                                 succcess:^(NSDictionary *result) {
                                                     //成功
                                                     if (k_IsSuccess(result)) {
                                                         if (self.newsDelegate && [self.newsDelegate respondsToSelector:@selector(refreshNews:)]) {
                                                             [self.newsDelegate refreshNews:_myIndex];
                                                         }

                                                     } else {
                                                         //失败
                                                         if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]] && [result objectForKey:@"Infomation"]) {
                                                             [self showHint:[result objectForKey:@"Infomation"]];
                                                         }
                                                     }
                                                     
                                                 } failure:^(NSError *error) {
                                                     //错误
                                                     [self showHint:[error networkErrorInfo]];
                                                 }];
    }
}

#pragma mark - getters and setters
- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, kNavHeight+12*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y)];
        _textView.font= [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
    }
    return _textView;
}


@end
