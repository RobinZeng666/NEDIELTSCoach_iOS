//
//  ManualCollectionViewCell.m
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/9/13.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ManualCollectionViewCell.h"
#import "ManualDetailCollectionViewCell.h"
#import "IESynchronousModel.h"
#import "WillGroupListViewController.h"
#import "ManualGroupModel.h"

#define k_cellWidth (kScreenWidth-2*60/3*AUTO_SIZE_SCALE_X)
#define k_cellHeight (411/3*AUTO_SIZE_SCALE_X)

@interface ManualCollectionViewCell()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *listArray;//存储数据model

@property (nonatomic, assign) int indexRow;

@end

@implementation ManualCollectionViewCell

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
    [self.contentView  addSubview:self.addButton];


    [self.collectionView registerClass:[ManualDetailCollectionViewCell class] forCellWithReuseIdentifier:@"ManualDetailCollectionViewCell_group"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.contentView  addSubview:self.collectionView];
    
    WS(this_cell);
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(this_cell.contentView.mas_width);
        make.height.mas_equalTo(90/3*AUTO_SIZE_SCALE_Y);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_cell.numLabel.bottom).with.offset(5*AUTO_SIZE_SCALE_Y);
        make.left.mas_equalTo(50/3*AUTO_SIZE_SCALE_X);
        make.width.height.mas_equalTo(176/3*AUTO_SIZE_SCALE_X);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(this_cell.numLabel.bottom).with.offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(this_cell.contentView.mas_width);
        make.bottom.mas_equalTo(this_cell.contentView.mas_bottom);
    }];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groupArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ManualDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ManualDetailCollectionViewCell_group" forIndexPath:indexPath ];
    if (cell==nil) {
        cell = [[ManualDetailCollectionViewCell alloc]init];
    }
    if (self.groupArray.count > 0) {
        self.listArray = [[NSMutableArray alloc] initWithCapacity:self.groupArray.count];
        for (NSDictionary *dic in self.groupArray) {
            ManualGroupModel *model = [[ManualGroupModel alloc] initWithDataDic:dic];
            [self.listArray addObject:model];
        }
    }
    if (self.listArray.count > 0) {
        cell.manualModel = self.listArray[indexPath.row];
    }

    return cell;
}

#pragma mark - event response
- (void)addBtnAction:(UIButton *)button
{
    _indexRow = (int)button.tag - 300;
    
    WillGroupListViewController *willGroupVC = [[WillGroupListViewController alloc] init];

    willGroupVC.groupNum = self.groupNum;
    willGroupVC.groupCnt = self.groupCnt;
    willGroupVC.passCode = self.passCode;
    willGroupVC.activeClassId = self.activeClassId;
    willGroupVC.indexRow = _indexRow;
    [self.viewController.navigationController pushViewController:willGroupVC animated:YES];
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

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [CommentMethod createButtonWithImageName:@"Group_hand_add.png" Target:self Action:@selector(addBtnAction:) Title:@""];
    }
    return _addButton;
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

@end
