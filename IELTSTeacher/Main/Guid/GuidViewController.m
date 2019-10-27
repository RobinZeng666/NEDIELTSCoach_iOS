//
//  GuidViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GuidViewController.h"

@interface GuidViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *intoButton;

@end

@implementation GuidViewController
//@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *guideImages = @[
                             @"Guide_ydy-1.png",
                             @"Guide_ydy-2.png",
                             @"Guide_ydy-3.png",
                             @"Guide_ydy-4.png",
                             @"Guide_ydy-5.png",
                             ];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth*guideImages.count, kScreenHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    //bottom  480/3 =    500*145
    
    for (int i = 0; i < guideImages.count; i++) {
        NSString *guideImageName = guideImages[i];
        //创建操作指南图片视图
        UIImageView *guideImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:guideImageName]];
        guideImageView.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight);
        [_scrollView addSubview:guideImageView];
        
        if (i == guideImages.count -1) {
            UIButton *button = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(intoButtonAction:) Title:@""];
            button.frame = CGRectMake((kScreenWidth-165*AUTO_SIZE_SCALE_X)/2, kScreenHeight-160*AUTO_SIZE_SCALE_Y, 165*AUTO_SIZE_SCALE_X, 48*AUTO_SIZE_SCALE_Y);
            [guideImageView addSubview:button];
            guideImageView.userInteractionEnabled = YES;
        }
    }
}

- (void)intoButtonAction:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //滑动到末尾，这两个值是相等的：
    //scrollView.contentOffset.x == scrollView.contentSize.width-scrollView.width
    CGFloat width =  scrollView.contentSize.width;
    CGFloat scWidth = scrollView.frame.size.width;
    CGFloat  sub = scrollView.contentOffset.x -width+ scWidth;
    if (sub > 30) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
    }
}

@end
