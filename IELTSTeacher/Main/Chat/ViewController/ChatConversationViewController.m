//
//  ChatConversationViewController.m
//  IELTSStudent
//
//  Created by Newton on 15/9/1.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ChatConversationViewController.h"
#import "BaseNavView.h"
#import "ChatImageViewController.h"
#import "ChatListPersonModel.h"
#import "ChatURLViewController.h"
#import "ChatPerpleListViewController.h"

@interface ChatConversationViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,UIActionSheetDelegate>

@property (nonatomic, copy) NSString *phoneNum;

@end

@implementation ChatConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //基本设置
    [self _initSetData];
    
    //初始化视图
    [self _initView];
    
}

- (void)_initSetData
{
    // 设置用户信息提供者。
    [[RCIM sharedRCIM]setUserInfoDataSource:self];
    // 设置群组信息提供者。
    [[RCIM sharedRCIM]setGroupInfoDataSource:self];
}

- (void)_initView
{
    BaseNavView *navView = [[BaseNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    navView.title       = self.model.className;
    [self.view addSubview:navView];
    
    //创建装饰线
    UIImageView *lineImg = [CommentMethod createImageViewWithImageName:@"mainTab_navLine.png"];
    [navView addSubview:lineImg];
    
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    //群组人员
    UIButton *personButton = [CommentMethod createButtonWithImageName:@"qunzu.png" Target:self Action:@selector(personAction:) Title:@""];
    personButton.showsTouchWhenHighlighted = YES;
    [personButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    personButton.frame = CGRectMake(kScreenWidth-50*AUTO_SIZE_SCALE_X, 20+(44-25*AUTO_SIZE_SCALE_X)/2, 37*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X);  //125 × 49
    [navView addSubview:personButton];//58 × 39
    
    //创建返回的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.showsTouchWhenHighlighted = YES;
    [button setImage:[UIImage imageNamed:@"maintab_back.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"maintab_backdianjih.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(10, 20+(44-30*AUTO_SIZE_SCALE_X)/2, 30*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X);  //125 × 49
    [navView addSubview:button];
    
    //初始化视图
    self.conversationMessageCollectionView.frame = CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50*AUTO_SIZE_SCALE_Y);
    
//    self.chatSessionInputBarControl.emojiButton.hidden = YES;
//    NDLog(@"%@",self.chatSessionInputBarControl.inputTextView);//(50 7; 180 36) (50 7; 235 36)(50 7; 274 36)
//    self.chatSessionInputBarControl.inputTextView.frame = CGRectMake(50, 7, kScreenWidth-100, 36);
//    self.chatSessionInputBarControl.recordButton.frame = CGRectMake(50, 7, kScreenWidth-100, 36);
    
    //参数设置
    self.enableUnreadMessageIcon = YES;
    self.enableNewComingMessageIcon = YES;
    self.enableSaveNewPhotoToLocalSystem = YES;
    self.defaultHistoryMessageCountOfChatRoom = 50;
    
    //滚动到消息最底部
    [self scrollToBottomAnimated:NO];
    
    //移除地理位置功能
    [self.pluginBoardView removeItemWithTag:1003];
}


#pragma mark -
/**
 *  获取用户信息。
 *
 *  @param userId     用户 Id。
 *  @param completion 用户信息
 */

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    /*
     Index = 顺序号,
         RoleID = 角色，2为老师，3为学生,
         MemberAccount = 成员帐号,
         MemberName = 成员姓名,
         IconUrl = 头像，可直接访问
         Email = 邮箱,
         ChatToken = 聊天室Token,
         ChattingRoomID = ChattingRoom表ID,
     */
    NSArray *members = self.model.members;
    NSMutableArray *userInfo = [[NSMutableArray alloc]initWithCapacity:members.count];
    for (NSDictionary *memberDic in members) {
        ChatListPersonModel *person = [[ChatListPersonModel alloc]initWithDataDic:memberDic];
        CHECK_DATA_IS_NSNULL(person.MemberAccount, NSString);
        CHECK_STRING_IS_NULL(person.MemberAccount);
        
        [userInfo addObject:person.MemberAccount];
    }
    if (userInfo.count > 0) {
        if ([userInfo containsObject:userId])
        {
            NSUInteger index = [userInfo indexOfObject:userId];
            NSDictionary *memberDic = [members objectAtIndex:index];
            ChatListPersonModel *person = [[ChatListPersonModel alloc]initWithDataDic:memberDic];
            
            RCUserInfo *user = [[RCUserInfo alloc]init];
            
            CHECK_DATA_IS_NSNULL(person.MemberAccount, NSString);
            CHECK_STRING_IS_NULL(person.MemberAccount);
            user.userId = person.MemberAccount;
            
            CHECK_DATA_IS_NSNULL(person.MemberName, NSString);
            CHECK_STRING_IS_NULL(person.MemberName);
            user.name = person.MemberName;
            
            CHECK_DATA_IS_NSNULL(person.IconUrl, NSString);
            CHECK_STRING_IS_NULL(person.IconUrl);
            user.portraitUri = person.IconUrl;
            
            return completion(user);
        }
    }
}

/**
 *  获取群主信息。
 *
 *  @param groupId  群主ID.
 *  @param completion 获取完成调用的BLOCK.
 */

- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion;
{
    
    
    
}




#pragma mark - 点击图片跳转
- (void)presentImagePreviewController:(RCMessageModel *)model
{
    //    RCImageMessage *imageMessage = (RCImageMessage *)model.content;
    //    NSString *url = imageMessage.imageUrl;
    //    CHECK_STRING_IS_NULL(url);
    //    [SJAvatarBrowser showImageURL:url];
    //     @"/Users/liniudun/Desktop/IELTS_2_new/trunk/source_code/ios/IELTSStudent/IELTSStudent/Main/Chat/psb.jpeg"
    
    ChatImageViewController *imgePreview = [[ChatImageViewController alloc]init];
    imgePreview.messageModel = model;
    [self.navigationController pushViewController:imgePreview animated:YES];
}

#pragma mark - 点击链接地址跳转
/**
 *  点击消息内容中的链接，此事件不会再触发didTapMessageCell
 *
 *  @param url   Url String
 *  @param model 数据
 */
- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model
{
    ChatURLViewController *urlCtr = [[ChatURLViewController alloc]init];
    urlCtr.webURL = url;
    [self.navigationController pushViewController:urlCtr animated:YES];
}
#pragma mark - 点击电话号码
/**
 *  点击消息内容中的电话号码，此事件不会再触发didTapMessageCell
 *
 *  @param phoneNumber Phone number
 *  @param model       数据
 */
- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber model:(RCMessageModel *)model
{//提示打电话
    self.phoneNum = phoneNumber;
    NSString *phone = [phoneNumber stringByReplacingOccurrencesOfString:@"tel://" withString:@""];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"拨打号码"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:phone
                                                   otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CHECK_DATA_IS_NSNULL(self.phoneNum, NSString);
        CHECK_STRING_IS_NULL(self.phoneNum);
        NSURL *url = [NSURL URLWithString:self.phoneNum];
        [[UIApplication sharedApplication]openURL:url];
    }
}

#pragma mark - 返回事件
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 查看群组成员
- (void)personAction:(UIButton *) button
{
    NSArray *members = self.model.members;
    if (members.count > 0) {
        ChatPerpleListViewController *people = [[ChatPerpleListViewController alloc]init];
        people.dataArray = members;
        [self.navigationController pushViewController:people animated:YES];
    }
}


@end
