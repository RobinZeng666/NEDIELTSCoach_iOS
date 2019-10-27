//
//  VoteHistoryTableViewCell.m
//  IELTSTeacher
//
//  Created by Newton on 15/9/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "VoteHistoryTableViewCell.h"
#import "VoteHistorySelectModel.h"
#import "VoteCommentTableViewCell.h"

#define kCellHeight (45*AUTO_SIZE_SCALE_Y)
@interface VoteHistoryTableViewCell()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITextView *bodyTextView;

@end

@implementation VoteHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    [self.contentView addSubview:self.bodyTextView];
    [self.contentView addSubview:self.voteTableView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CHECK_DATA_IS_NSNULL(self.model.Subject, NSString);
    CHECK_STRING_IS_NULL(self.model.Subject);
    CGSize  contentSizeForTextView = [CommentMethod widthForNickName:self.model.Subject
                                                       testLablWidth:kScreenWidth
                                                       textLabelFont:18.0f];
    
    CGFloat textViewHeight = 0.0;
    if (contentSizeForTextView.height > 192*AUTO_SIZE_SCALE_Y) {
        textViewHeight = contentSizeForTextView.height+20;
        self.bodyTextView.frame = CGRectMake(0, 0, kScreenWidth, contentSizeForTextView.height+20);
    }else
    {
        textViewHeight =  192*AUTO_SIZE_SCALE_Y;
        self.bodyTextView.frame = CGRectMake(0, 0, kScreenWidth, 192*AUTO_SIZE_SCALE_Y);
    }
    
    self.bodyTextView.text = self.model.Subject;
    
    CGFloat tabelHeight = 0.0;
    for (NSDictionary *dataDic in self.model.opts) {
        NSString *titleDesc = [dataDic objectForKey:@"OptionDesc"];
        CHECK_DATA_IS_NSNULL(titleDesc, NSString);
        CHECK_STRING_IS_NULL(titleDesc);
        CGSize  contentSize = [CommentMethod widthForNickName:titleDesc
                                                testLablWidth:(kScreenWidth-80*AUTO_SIZE_SCALE_X)
                                                textLabelFont:18.0f];
        //计算字体高度
        if (contentSize.height > kCellHeight) {
            tabelHeight = tabelHeight + contentSize.height;
        }else{
            tabelHeight = tabelHeight + kCellHeight;
        }
    }
    
    self.voteTableView.frame = CGRectMake(0, textViewHeight, kScreenWidth, tabelHeight+self.model.opts.count * 3 * AUTO_SIZE_SCALE_Y);
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.opts.count;//_voteListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //CHECK_DATA_IS_NSNULL(self.model.opts, NSArray);
    return 1;//self.model.opts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"VoteCommentTableViewCell";
    VoteCommentTableViewCell *cell = (VoteCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[VoteCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.model.opts.count > 0) {
        NSDictionary *dataDic = self.model.opts[indexPath.section];
        cell.dataDic = dataDic;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model.opts.count > 0) {
        NSDictionary *dataDic = self.model.opts[indexPath.section];
        NSString *titleDesc = [dataDic objectForKey:@"OptionDesc"];
        CHECK_DATA_IS_NSNULL(titleDesc, NSString);
        CHECK_STRING_IS_NULL(titleDesc);
//        CGSize  contentSize = [CommentMethod widthForNickName:titleDesc
//                                                testLablWidth:(kScreenWidth-80*AUTO_SIZE_SCALE_X)
//                                                textLabelFont:18.0f];
//        //计算字体高度
//        if (contentSize.height > kCellHeight) {
//            return contentSize.height;
//        }else{
            return kCellHeight;
//        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3*AUTO_SIZE_SCALE_Y;
}



#pragma mark - getters and setters
- (UITextView *)bodyTextView
{
    if (!_bodyTextView) {
        _bodyTextView = [[UITextView alloc]initWithFrame:CGRectZero];
        _bodyTextView.userInteractionEnabled = NO;
        _bodyTextView.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _bodyTextView.backgroundColor = [UIColor clearColor];
        _bodyTextView.textColor = [UIColor darkGrayColor];
        [_bodyTextView endEditing:NO];
    }
    return _bodyTextView;
}

- (UITableView *)voteTableView
{
    if (!_voteTableView) {
        _voteTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _voteTableView.delegate = self;
        _voteTableView.dataSource = self;
        _voteTableView.bounces = NO;
        _voteTableView.tableFooterView = [[UIView alloc]init];
        _voteTableView.backgroundColor = [UIColor clearColor];
    }
    return _voteTableView;
}

@end
