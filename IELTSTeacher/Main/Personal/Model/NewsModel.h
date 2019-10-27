//
//  NewsModel.h
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/26.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface NewsModel : BaseModel

/**
 *  
    MI_ID =消息ID;
    Title =标题;
    Body =内容;
    CreateTime =创建时间;
    AssignRoleID =指派角色;
    MState =状态 0未发布1已发布;
    Account =账号名称
    MR_ID =已读信息ID
 */

@property (nonatomic,copy) NSString *MI_ID;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *Body;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,copy) NSString *AssignRoleID;
@property (nonatomic,strong) NSNumber *MState;
@property (nonatomic,copy) NSString *Account;
@property (nonatomic,strong) NSNumber *MR_ID;

@end
