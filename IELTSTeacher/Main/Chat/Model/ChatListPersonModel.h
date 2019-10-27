//
//  ChatListPersonModel.h
//  IELTSStudent
//
//  Created by DevNiudun on 15/10/16.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"
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
@interface ChatListPersonModel : BaseModel

@property (nonatomic, copy) NSString *RoleID;
@property (nonatomic, copy) NSString *MemberAccount;
@property (nonatomic, copy) NSString *MemberName;
@property (nonatomic, copy) NSString *IconUrl;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *ChatToken;
@property (nonatomic, copy) NSString *ChattingRoomID;

@end
