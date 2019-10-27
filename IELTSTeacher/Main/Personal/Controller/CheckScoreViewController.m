//
//  CheckScoreViewController.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/15.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "CheckScoreViewController.h"

@interface CheckScoreViewController ()

@property (nonatomic,strong) UIImageView *imgView;

@end

@implementation CheckScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"查看成绩单";
    [self.view addSubview:self.imgView];
    
    //成绩单图片视图
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+12*AUTO_SIZE_SCALE_Y);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_Y));
    }];
    
    CHECK_DATA_IS_NSNULL(self.ReportImgName, NSString);
    CHECK_STRING_IS_NULL(self.ReportImgName);
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, self.ReportImgName];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - life cycle
#pragma mark - delegate
#pragma mark - event response
#pragma mark - private methods
#pragma mark - getters and setters
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [CommentMethod createImageViewWithImageName:@""];
    }
    return _imgView;
}
@end
