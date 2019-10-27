//
//  ChatURLViewController.m
//  IELTSStudent
//
//  Created by DevNiudun on 15/10/26.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ChatURLViewController.h"

@interface ChatURLViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ChatURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    self.webView.frame = CGRectMake(0, kNavHeight+5*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-5*AUTO_SIZE_SCALE_Y);
    //开辟一个单独线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.webURL]];
        [self.webView loadRequest:request];
    });
    
}

#pragma mark -UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self hideHud];
    [self showHudInView:self.view hint:@"正在加载网页.."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titles = title;
    
    [self hideHud];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud];
}

#pragma mark - set or get
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, 0);
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}




@end
