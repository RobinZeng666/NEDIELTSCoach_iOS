//
//  UserInfoModel.h
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/19.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

@property (nonatomic,copy) NSString *Account;  //U2 uid
//@property (nonatomic,copy) NSString *BSSNAME;  //
@property (nonatomic,copy) NSString *Email;    //邮箱
@property (nonatomic,copy) NSString *IconUrl;  //头像
@property (nonatomic,copy) NSString *NickName; //昵称
@property (nonatomic,strong) NSNumber *RoleID; //1.集团，2.老师，3.学生
@property (nonatomic,strong) NSNumber *UID;    //系统uid
@property (nonatomic,strong) NSString *sTeacherID;


@end
