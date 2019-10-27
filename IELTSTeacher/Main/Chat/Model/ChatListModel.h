//
//  ChatListModel.h
//  IELTSStudent
//
//  Created by DevNiudun on 15/10/16.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"
/*
  chats = 聊天室列表数据[{,
    ID = ChattingRoom表ID,
    ClassID = BS_Class表ID,
    className = 班级名称,
    ChattingGroup = 聊天室群组ID,
    ImgUrl = 群组头像，路径可直接访问,
    memberCnt = 群组成员人数,
    members = 群组成员详情[{,
    }]
   }]
 */
@interface ChatListModel : BaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ClassID;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *ChattingGroup;
@property (nonatomic, copy) NSString *ImgUrl;
@property (nonatomic, copy) NSString *memberCnt;
@property (nonatomic, strong) NSArray *members;

@property (nonatomic, copy) NSString *message;//消息内容
@property (nonatomic, assign) NSInteger messageCount;//消息数量


@end
