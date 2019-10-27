//
//  WQAdView.m
//  WQAdvertisingColumn
//
//  Created by com.wyw on 14/11/7.
//  Copyright (c) 2014年 com.wyw. All rights reserved.
//

#import "WQAdView.h"
#import "WQComonDefine.h"
#import "AdvertiseModel.h"


#define KPCheight (20*AUTO_SIZE_SCALE_Y)    //pageController高度

@implementation WQAdView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        self.adPeriodTime=4.0f;
        self.adDataArray=[NSMutableArray array];
        self.adAutoplay=YES;
        [self setAdScrollView];
        [self setPageControl];
    }
    return self;
}

-(void)setAdScrollView{
    self.adScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectWidth(self), CGRectHeight(self))];
    self.adScrollView.pagingEnabled=YES;
    self.adScrollView.delegate=self;
    self.adScrollView.showsHorizontalScrollIndicator=NO;
    [self addSubview:self.adScrollView];
}

-(void)setPageControl{
    self.adPageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectHeight(self.adScrollView)-KPCheight, CGRectWidth(self.adScrollView), KPCheight)];
//    self.adPageControl.numberOfPages=1;
    self.adPageControl.currentPageIndicatorTintColor = RGBACOLOR(255.0,47.0,76.0,1.0);
    self.adPageControl.pageIndicatorTintColor = [CommentMethod colorFromHexRGB:k_Color_9];
    [self addSubview:self.adPageControl];
    self.adPageControl.center=CGPointMake(self.center.x, self.adPageControl.center.y);
}

#pragma mark -加载并播放广告数据内容
-(void)loadAdDataThenStart{
    if (self.adDataArray.count<=0) {
        [[[UIAlertView alloc]initWithTitle:@"广告加载失败" message:@"确认是否成功往WQAdview的adDataArray中添加image" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        return;
    }
    [self.adScrollView setContentSize:CGSizeMake(CGRectWidth(self.adScrollView)*(self.adDataArray.count+2), CGRectHeight(self.adScrollView))];
    self.adPageControl.numberOfPages=self.adDataArray.count;
    
    for (int i=0; i<self.adDataArray.count; i++) {
        
        UIButton *adBtn=[[UIButton alloc]initWithFrame:CGRectMake((i+1)*CGRectWidth(self.adScrollView), 0, CGRectWidth(self.adScrollView), CGRectHeight(self.adScrollView))];
        
        NSString *imgPath = self.adDataArray[i];
        NDLog(@"imgPath = %@", imgPath);
        [adBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Pic_Default.png"]];
        [adBtn setContentMode:UIViewContentModeScaleToFill];
        adBtn.tag=i;
        [adBtn addTarget:self action:@selector(adBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.adScrollView addSubview:adBtn];
    }
    
    UIButton *lastAdBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectWidth(self.adScrollView), CGRectHeight(self.adScrollView))];
    NSString *imgPath = self.adDataArray[self.adDataArray.count -1];
    [lastAdBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Pic_Default.png"]];
    [lastAdBtn setContentMode:UIViewContentModeScaleToFill];
    [self.adScrollView addSubview:lastAdBtn];
    
    NSString *imgPath1 = self.adDataArray[0];
    UIButton *firstAdBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.adDataArray.count+1)*CGRectWidth(self.adScrollView), 0, CGRectWidth(self.adScrollView), CGRectHeight(self.adScrollView))];
    [firstAdBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgPath1] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Pic_Default.png"]];
    [firstAdBtn setContentMode:UIViewContentModeScaleToFill];
    [self.adScrollView addSubview:firstAdBtn];
    
    [self.adScrollView setContentOffset:CGPointMake(CGRectWidth(self.adScrollView), 0)];
    
    if (self.adAutoplay) {
        if (!self.adLoopTimer) {
            if (self.adDataArray.count > 1) {
                self.adLoopTimer = [NSTimer scheduledTimerWithTimeInterval:self.adPeriodTime target:self selector:@selector(loopAd) userInfo:nil repeats:YES];
            }
        }
    }
}

#pragma mark - 循环播放
-(void)loopAd{
    CGFloat pageWidth = self.adScrollView.frame.size.width;
    int currentPage = self.adScrollView.contentOffset.x/pageWidth;
    if (currentPage == 0) {
        self.adPageControl.currentPage = self.adPageControl.numberOfPages-1;
    }
    else if (currentPage == self.adPageControl.numberOfPages+1) {
        self.adPageControl.currentPage = 0;
    }
    else {
        self.adPageControl.currentPage = currentPage-1;
    }
    
    __block NSInteger currPageNumber = self.adPageControl.currentPage;
    CGSize viewSize = self.adScrollView.frame.size;
    CGRect rect = CGRectMake((currPageNumber+2)*pageWidth, 0, viewSize.width, viewSize.height);
    
    [UIView animateWithDuration:0.7 animations:^{
        [self.adScrollView scrollRectToVisible:rect animated:NO];
    } completion:^(BOOL finished) {
        currPageNumber++;
        if (currPageNumber == self.adPageControl.numberOfPages) {
            [self.adScrollView setContentOffset:CGPointMake(CGRectWidth(self.adScrollView), 0)];
            currPageNumber = 0;
        }
    }];
    
    currentPage = self.adScrollView.contentOffset.x/pageWidth;
    if (currentPage == 0) {
        self.adPageControl.currentPage = self.adPageControl.numberOfPages-1;
    }
    else if (currentPage == self.adPageControl.numberOfPages+1) {
        self.adPageControl.currentPage = 0;
    }
    else {
        self.adPageControl.currentPage = currentPage-1;
    }
}
#pragma mark---- UIScrollView delegate methods

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        NSInteger currentAdPage;
        currentAdPage=self.adScrollView.contentOffset.x/CGRectWidth(self.adScrollView);
        if (currentAdPage==0) {
            [scrollView scrollRectToVisible:CGRectMake(CGRectWidth(self.adScrollView)*self.adPageControl.numberOfPages, 0, CGRectWidth(self.adScrollView), CGRectHeight(self.adScrollView)) animated:NO];
            currentAdPage=self.adPageControl.numberOfPages-1;
        }
        else if (currentAdPage==(self.adPageControl.numberOfPages+1)) {
            [scrollView scrollRectToVisible:CGRectMake(CGRectWidth(self.adScrollView), 0, CGRectWidth(self.adScrollView), CGRectHeight(self.adScrollView)) animated:NO];
            currentAdPage=0;
        }
        else{
            currentAdPage=currentAdPage-1;
        }
        self.adPageControl.currentPage=currentAdPage;
    
    if (self.adAutoplay) {
        if (!self.adLoopTimer) {
            self.adLoopTimer = [NSTimer scheduledTimerWithTimeInterval:self.adPeriodTime target:self selector:@selector(loopAd) userInfo:nil repeats:YES];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖动scrollview的时候 停止计时器控制的跳转
    if (self.adAutoplay) {
        if (self.adLoopTimer) {
            [self.adLoopTimer invalidate];
            self.adLoopTimer = nil;
        }
    }
}

#pragma mark - 点击
-(void)adBtnClick:(UIButton *)sender{
    [self.delegate adView:self didDeselectAdAtNum:sender.tag];
}
@end
