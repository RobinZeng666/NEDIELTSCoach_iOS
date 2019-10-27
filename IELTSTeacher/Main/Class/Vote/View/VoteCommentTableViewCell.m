//
//  VoteCommentTableViewCell.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/10/29.
//  Copyright © 2015年 xdf. All rights reserved.
//

#import "VoteCommentTableViewCell.h"
#import "VoteHistorySingleView.h"
#import "VoteHistorySelectModel.h"

#define kCellHeight (45*AUTO_SIZE_SCALE_Y)
@interface VoteCommentTableViewCell()

@property (nonatomic, strong) VoteHistorySingleView *singleView;

@end

@implementation VoteCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化视图
        [self _initView];
    }
    return self;
}
//初始化视图
- (void)_initView
{
    [self.contentView addSubview:self.singleView];
    [self.singleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.dataDic.count > 0) {
        VoteHistorySelectModel *selectModel = [[VoteHistorySelectModel alloc]initWithDataDic:self.dataDic];
        NSString *titleDesc = selectModel.OptionDesc;
        CHECK_DATA_IS_NSNULL(titleDesc, NSString);
        CHECK_STRING_IS_NULL(titleDesc);
        self.singleView.titLabel.text = titleDesc;
        
//        CGSize  contentSize = [CommentMethod widthForNickName:titleDesc
//                                                testLablWidth:(kScreenWidth-80*AUTO_SIZE_SCALE_X)
//                                                textLabelFont:18.0f];
//        //计算字体高度
//        if (contentSize.height > kCellHeight) {
//            self.singleView.frame = CGRectMake(0, 0, kScreenWidth, contentSize.height);
//        }else{
            self.singleView.frame = CGRectMake(0, 0, kScreenWidth, kCellHeight);
//        }
        CHECK_DATA_IS_NSNULL(selectModel.ownVote, NSNumber);
        if ([selectModel.ownVote isEqualToNumber:@1]) {
            self.singleView.imgView.backgroundColor = k_PinkColor;
        }else{
            self.singleView.imgView.backgroundColor = K_VotePickColor;
        }
        
        CHECK_DATA_IS_NSNULL(selectModel.voteNum, NSNumber);
        self.singleView.percentString = [NSString stringWithFormat:@"%@%%",selectModel.voteNum];
    }
}

- (VoteHistorySingleView *)singleView
{
    if (!_singleView) {
        _singleView = [[VoteHistorySingleView alloc]init];
    }
    return _singleView;
}

@end
