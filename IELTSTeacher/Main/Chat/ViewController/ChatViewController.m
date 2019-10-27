//
//  ChatViewController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/8.
//  Copyright (c) 2015年 xdf. All rights reserved.
//


#import "ChatViewController.h"
#import "ChatConversationViewController.h"
#import "ChatListTableViewCell.h"
#import "ChatListPersonModel.h"

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,RCIMReceiveMessageDelegate>

@property (nonatomic, strong) UITableView *chatListTabelView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *chatGroupIdArray;
@property (nonatomic, strong) NSMutableDictionary *dataMemberAccountDic;

//创建列表红点
@property (nonatomic, strong) UIImageView *unReadImg;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"聊天室";
    
//    //初始化
    [self _initConfiger];
    //初始化数据
    [self _initData];
}

- (void)_initConfiger
{
    [self.view addSubview:self.chatListTabelView];
    //添加未读红点
    self.unReadImg.frame = CGRectMake(kScreenWidth/2+30*AUTO_SIZE_SCALE_X, 25, 10*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X);
    [self.navView addSubview:self.unReadImg];
    
    //设置消息监听
    [RCIM sharedRCIM].receiveMessageDelegate = self;
}

- (void)_initData
{
    _dataArray = [[NSMutableArray alloc]init];
    _chatGroupIdArray = [[NSMutableArray alloc]init];
    
    [self showHudInView:self.view hint:@"正在加载.."];
    [[Service sharedInstance]loadChatListSucccess:^(NSDictionary *result) {
        [self hideHud];
        if (k_IsSuccess(result)) {
            NSDictionary *data = [result objectForKey:@"Data"];
            if (data.count > 0) {
                NSArray *chats = [data objectForKey:@"chats"];
                
                NSInteger targetIdCount = 0;
                for (NSDictionary *chatsDic in chats) {
                    
                    ChatListModel *model = [[ChatListModel alloc]initWithDataDic:chatsDic];
                    model.messageCount = 0;
                    model.message = @"";
                    [_dataArray addObject:model];
                    
                    CHECK_DATA_IS_NSNULL(model.ChattingGroup, NSString);
                    CHECK_STRING_IS_NULL(model.ChattingGroup);
                    [_chatGroupIdArray addObject:model.ChattingGroup];
                    
                    //获取最新的数量和消息内容
                    [self getNewMessageAndCount:model];
                    
                    //获取单条聊天数
                    NSInteger targetCount = [[RCIMClient sharedRCIMClient]getUnreadCount:ConversationType_GROUP targetId:model.ChattingGroup];
                    targetIdCount = targetIdCount + targetCount;
                    
                }
                //用于保存所有会话的成员的MemberAccount
                [self saveMemberAccountArray];
                
                [self.chatListTabelView reloadData];
                
                //获取所有未读消息
//                NSInteger unreadCount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
                if (targetIdCount > 0) {
                    self.unReadImg.hidden = NO;
                }else{
                    self.unReadImg.hidden = YES;
                }
                
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:[error networkErrorInfo]];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_dataArray.count > 0) {
        NSInteger targetIdCount = 0;
        for (ChatListModel *model in _dataArray) {
            //获取最新的数量和消息内容
            [self getNewMessageAndCount:model];
            //获取单条聊天数
            NSInteger targetCount = [[RCIMClient sharedRCIMClient]getUnreadCount:ConversationType_GROUP targetId:model.ChattingGroup];
            targetIdCount = targetIdCount + targetCount;
        }
        //刷新列表
        [self.chatListTabelView reloadData];
        
        //获取所有未读消息
//        NSInteger unreadCount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
        if (targetIdCount > 0) {
            self.unReadImg.hidden = NO;
        }else{
            self.unReadImg.hidden = YES;
        }
    }
}

#pragma mark - private event
- (void)getNewMessageAndCount:(ChatListModel *)model
{
    //获取单条聊天数
    NSInteger targetIdCount = [[RCIMClient sharedRCIMClient]getUnreadCount:ConversationType_GROUP targetId:model.ChattingGroup];
    NDLog(@"%ld",(long)targetIdCount);
    model.messageCount = targetIdCount;
    
    //获取最新聊天
    NSArray *dataArray = [[RCIMClient sharedRCIMClient]getLatestMessages:ConversationType_GROUP targetId:model.ChattingGroup count:1];
    if (dataArray.count > 0) {
        //获取最新的消息
        RCMessage *message = dataArray[0];
        //获取当前群组的成员
        NSArray *members = model.members;
        //有成员且消息发送者包含在群组里面
        if (members.count > 0) {
            for (NSDictionary *membersDic in members) {
                NSString *MemberAccount = [membersDic objectForKey:@"MemberAccount"];
                if ([MemberAccount isEqualToString:message.senderUserId]) {
                    //取出对应的人
                    ChatListPersonModel *person = [[ChatListPersonModel alloc]initWithDataDic:membersDic];
                    CHECK_DATA_IS_NSNULL(person.MemberName, NSString);
                    CHECK_STRING_IS_NULL(person.MemberName);
                    //获取格式化消息
                    NSString *mes = [self getNewMessage:message sendPerson:person.MemberName];
                    model.message = mes;
                }
            }
        }
    }
    
}

- (void)saveMemberAccountArray
{
    _dataMemberAccountDic = [[NSMutableDictionary alloc]initWithCapacity:_dataArray.count];
    for (ChatListModel *model in _dataArray) {
        NSArray *members = model.members;
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithCapacity:members.count];
        for (NSDictionary *memberDic in members) {
            ChatListPersonModel *person = [[ChatListPersonModel alloc]initWithDataDic:memberDic];
            CHECK_DATA_IS_NSNULL(person, ChatListPersonModel);
            CHECK_DATA_IS_NSNULL(person.MemberAccount, NSString);
            CHECK_STRING_IS_NULL(person.MemberAccount);
            [userInfo setObject:person forKey:person.MemberAccount];
        }
        
        NSString *targetId = model.ChattingGroup;
        CHECK_DATA_IS_NSNULL(targetId, NSString);
        CHECK_STRING_IS_NULL(targetId);
        [_dataMemberAccountDic setObject:userInfo forKey:targetId];
    }
}

- (NSString *)getNewMessage:(RCMessage *)message
                 sendPerson:(NSString *)sendPerson
{
    NSString *objectName = message.objectName;
    if ([objectName isEqualToString:@"RC:TxtMsg"]) {
        RCTextMessage *textMessage = (RCTextMessage *)message.content;
        NSString *content =  textMessage.content;
        if ([sendPerson isEqualToString:@""]) {
            return content;
        }else{
            NSString *messageS = [NSString stringWithFormat:@"%@:%@",sendPerson,content];
            return messageS;
        }
    }else if ([objectName isEqualToString:@"RC:ImgMsg"])//RCImageMessage
    {
        if ([sendPerson isEqualToString:@""]) {
            return @"[图片]";
        }else{
            NSString *messageS = [NSString stringWithFormat:@"%@:[图片]",sendPerson];
            return messageS;
        }
    }else if ([objectName isEqualToString:@"RC:VcMsg"])//RCVoiceMessage
    {
        if ([sendPerson isEqualToString:@""]) {
            return  @"[语音]";
        }else{
            NSString *messageS = [NSString stringWithFormat:@"%@:[语音]",sendPerson];
            return messageS;
        }
    }
    return @"";
}


#pragma mark - life cycle
#pragma mark - delegate
/**
 接收消息到消息后执行。
 
 @param message 接收到的消息。
 @param left    剩余消息数.
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    NSString *targetId = message.targetId; //讨论组ID
    CHECK_DATA_IS_NSNULL(targetId, NSString);
    CHECK_STRING_IS_NULL(targetId);
    
    if (_chatGroupIdArray.count > 0) {
        dispatch_queue_t queue = dispatch_queue_create("onRCIMReceiveMessage", NULL);
        dispatch_async(queue, ^{
            if ([_chatGroupIdArray containsObject:targetId]) {
                //确定消息是哪个群组的
                NSUInteger targetIndex =  [_chatGroupIdArray indexOfObject:targetId];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:targetIndex inSection:0];
                //检索谁发的
                ChatListModel *model = (ChatListModel *)_dataArray[targetIndex];
                NSString *sendPerson = @"";
                if (_dataMemberAccountDic.count > 0) {
                    //根据讨论组找到该组成员
                    NSDictionary *userInfo = [_dataMemberAccountDic objectForKey:targetId];
                    if (userInfo.count > 0) {
                        CHECK_DATA_IS_NSNULL(message.senderUserId, NSString);
                        CHECK_STRING_IS_NULL(message.senderUserId);
                        
                        ChatListPersonModel *person = [userInfo objectForKey:message.senderUserId];
                        CHECK_DATA_IS_NSNULL(person.MemberName, NSString);
                        CHECK_STRING_IS_NULL(person.MemberName);
                        sendPerson = person.MemberName;
                    }
                }
                //消息
                NSString *mes = [self getNewMessage:message sendPerson:sendPerson];
                model.message = mes;
                
                //目标消息数
                NSInteger targetIdCount = [[RCIMClient sharedRCIMClient]getUnreadCount:ConversationType_GROUP targetId:targetId];
                NDLog(@"%ld",(long)targetIdCount);
                model.messageCount = targetIdCount;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新当前单元格
                    [self.chatListTabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    NSInteger targetIdCount = 0;
                    for (ChatListModel *model in _dataArray) {
                        //获取单条聊天数
                        NSInteger targetCount = [[RCIMClient sharedRCIMClient]getUnreadCount:ConversationType_GROUP targetId:model.ChattingGroup];
                        targetIdCount = targetIdCount + targetCount;
                    }
//                    NSInteger unreadCount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
                    if (targetIdCount > 0)
                    {
                        self.unReadImg.hidden = NO;
                    }else
                    {
                        self.unReadImg.hidden = YES;
                    }
                });
            }
        });
    }
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"ChatViewControllerCell_chatList";
    ChatListTableViewCell *cell = (ChatListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentify];
    if (cell == nil) {
        cell = [[ChatListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_dataArray.count > 0) {
        cell.model = (ChatListModel *)_dataArray[indexPath.row];
    }
    
    return cell;
}
#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0) {
        ChatListModel *model = (ChatListModel *)_dataArray[indexPath.row];
        CHECK_DATA_IS_NSNULL(model.className, NSString);
        CHECK_STRING_IS_NULL(model.className);
        
        CHECK_DATA_IS_NSNULL(model.ChattingGroup, NSString);
        CHECK_STRING_IS_NULL(model.ChattingGroup);
        
        ChatConversationViewController *chatView = [[ChatConversationViewController alloc]initWithConversationType:ConversationType_GROUP targetId:model.ChattingGroup];
        chatView.userName                    = model.className;
        [chatView setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
        chatView.model = model;
        [self.navigationController pushViewController:chatView animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0) {
        ChatListModel *model = (ChatListModel *)_dataArray[indexPath.row];
        CHECK_DATA_IS_NSNULL(model.className, NSString);
        CHECK_STRING_IS_NULL(model.className);
        
        CHECK_DATA_IS_NSNULL(model.memberCnt, NSString);
        CHECK_STRING_IS_NULL(model.memberCnt);
        
        NSString *classNames = [NSString stringWithFormat:@"%@(%@人)",model.className,model.memberCnt];
        CGFloat classNameHeight = [CommentMethod widthForNickName:classNames testLablWidth:kScreenWidth-140*AUTO_SIZE_SCALE_X textLabelFont:20].height;
        if (classNameHeight > 30 *AUTO_SIZE_SCALE_Y)
        {
            return 120*AUTO_SIZE_SCALE_X + classNameHeight - 30*AUTO_SIZE_SCALE_Y;
        }else
        {
            return 120*AUTO_SIZE_SCALE_X;
        }
    }
    return 0;
}


#pragma mark - event response
#pragma mark - private methods
#pragma mark - getters and setters
- (UITableView *)chatListTabelView
{
    if (!_chatListTabelView) {
        _chatListTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight+5, kScreenWidth, kScreenHeight-kNavHeight-5-49) style:UITableViewStylePlain];
        _chatListTabelView.delegate = self;
        _chatListTabelView.dataSource = self;
        _chatListTabelView.tableFooterView = [[UIView alloc]init];
//        _chatListTabelView.rowHeight = 120*AUTO_SIZE_SCALE_X;
    }
    return _chatListTabelView;
}

- (UIImageView *)unReadImg
{
    if (!_unReadImg) {
        _unReadImg = [CommentMethod createImageViewWithImageName:@""];
        _unReadImg.frame = CGRectMake(0, 0, 10*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X);
        _unReadImg.backgroundColor = [UIColor redColor];
        _unReadImg.layer.cornerRadius = 5*AUTO_SIZE_SCALE_X;
        _unReadImg.layer.masksToBounds = YES;
    }
    return _unReadImg;
}

@end
