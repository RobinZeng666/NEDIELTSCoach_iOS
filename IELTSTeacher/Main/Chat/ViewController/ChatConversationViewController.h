//
//  ChatConversationViewController.h
//  IELTSStudent
//
//  Created by Newton on 15/9/1.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

#import "ChatListModel.h"
@interface ChatConversationViewController : RCConversationViewController

@property (nonatomic, strong) ChatListModel *model;


@end
