//
//  ChatPerpleListViewController.m
//  IELTSStudent
//
//  Created by DevNiudun on 15/10/26.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ChatPerpleListViewController.h"
#import "ChatListPersonModel.h"
//#import "IECollectionViewCell.h"
#import "ChatPerpleCollectionViewCell.h"

@interface ChatPerpleListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ChatPerpleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"群组成员";

    self.collectionView.frame = CGRectMake(0, kNavHeight + 5*AUTO_SIZE_SCALE_Y, kScreenWidth, kScreenHeight-kNavHeight-5*AUTO_SIZE_SCALE_Y);
    [self.collectionView registerClass:[ChatPerpleCollectionViewCell class] forCellWithReuseIdentifier:@"ChatPerpleCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];

}
#pragma mark--collection的数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"ChatPerpleCollectionViewCell";
    ChatPerpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath ];
    if (!cell) {
        cell = [[ChatPerpleCollectionViewCell alloc]init];
    }
    if (self.dataArray.count > 0) {
        NSDictionary *dataDic = self.dataArray[indexPath.row];
        ChatListPersonModel *model = [[ChatListPersonModel alloc]initWithDataDic:dataDic];
        cell.model = model;
    }
    return cell;
}

#pragma mark - set or get 
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (kScreenWidth-138*AUTO_SIZE_SCALE_X)/5;
        CGFloat hight =(kScreenWidth-138*AUTO_SIZE_SCALE_Y)/5/0.725;
        flowLayout.itemSize = CGSizeMake(width, hight);
        flowLayout.minimumInteritemSpacing = 10*AUTO_SIZE_SCALE_X;
        flowLayout.minimumLineSpacing = 10*AUTO_SIZE_SCALE_Y;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(15*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_Y, 20*AUTO_SIZE_SCALE_X);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}


@end
