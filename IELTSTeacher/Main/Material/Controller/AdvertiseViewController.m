//
//  AdvertiseViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/18.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "AdvertiseViewController.h"

@interface AdvertiseViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AdvertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = self.titleString;
    
    [self.view addSubview:self.webView];

    [self showHudInView:self.view hint:@"正在加载..."];
    
    CHECK_STRING_IS_NULL(self.Link);
    if (![self.Link isEqualToString:@""]) {
        _webView.scalesPageToFit = YES;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.Link]];
        [self.webView loadRequest:request];
    } else {
        CHECK_DATA_IS_NSNULL(self.Content, NSString);
        CHECK_STRING_IS_NULL(self.Content);
        [_webView loadHTMLString:self.Content baseURL:nil];
        _webView.scalesPageToFit = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud];
}

#pragma mark - getters and setters
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavHeight+3, kScreenWidth, kScreenHeight-kNavHeight-3)];
        _webView.delegate = self;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, 0);
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}

@end
