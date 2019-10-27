//
//  GroupResultCollectionViewCell.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/8/31.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GroupResultCollectionViewCell.h"
#import "IEGroupCollectionViewCell.h"
#import "IESynchronousModel.h"

#define k_cellWidth (kScreenWidth-2*60/3*AUTO_SIZE_SCALE_X)
#define k_cellHeight (411/3*AUTO_SIZE_SCALE_X)

@interface GroupResultCollectionViewCell()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IESynchronousModel *model;

@end

@implementation GroupResultCollectionViewCell

//通过纯代码创建
- (instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}
//通过xib或是storyboard创建
- (id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [CommentMethod colorFromHexRGB:k_Color_6].CGColor;
    
    [self.contentView  addSubview:self.numLabel];
    
    [self.collectionView registerClass:[IEGroupCollectionViewCell class] forCellWithReuseIdentifier:@"IECollectionViewCell_group"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.contentView  addSubview:self.collectionView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    WS(this_cell);
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(this_cell.contentView.mas_width);
        make.height.mas_equalTo(90/3*AUTO_SIZE_SCALE_Y);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_cell.numLabel.bottom).with.offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(this_cell.contentView.mas_width);
        make.bottom.mas_equalTo(this_cell.contentView.mas_bottom);
    }];

    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"IECollectionViewCell_group";
    IEGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath ];
    if (cell==nil) {
        cell = [[IEGroupCollectionViewCell alloc]init];
    }
    if (self.numArray.count > 0) {
        self.listArray = [[NSMutableArray alloc] initWithCapacity:self.numArray.count];
        for (NSDictionary *dic in self.numArray) {
            RandomListModel *model = [[RandomListModel alloc] initWithDataDic:dic];
            [self.listArray addObject:model];
        }
    }
    if (self.listArray.count > 0) {
        cell.randomModel = self.listArray[indexPath.row];
    }
    return cell;
}

#pragma mark - private methods
#pragma mark - getters and setters
- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [CommentMethod createLabelWithFont:15 Text:@""];
        _numLabel.textColor = [CommentMethod colorFromHexRGB:k_Color_2];
        _numLabel.backgroundColor = [CommentMethod colorFromHexRGB:k_Color_6];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (k_cellWidth-92*AUTO_SIZE_SCALE_X)/5;
        CGFloat hight =(kScreenWidth-92*AUTO_SIZE_SCALE_Y)/4+20*AUTO_SIZE_SCALE_Y;
        flowLayout.itemSize = CGSizeMake(width, hight);
        flowLayout.minimumInteritemSpacing = 10*AUTO_SIZE_SCALE_X;
        flowLayout.minimumLineSpacing = 10*AUTO_SIZE_SCALE_Y;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(10*AUTO_SIZE_SCALE_Y, 5*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_Y, 5*AUTO_SIZE_SCALE_X);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)numArray
{
    if (!_numArray) {
        _numArray = [[NSMutableArray alloc] init];
    }
    return _numArray;
}

@end
