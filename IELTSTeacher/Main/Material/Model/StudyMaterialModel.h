//
//  StudyMaterialModel.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/7.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface StudyMaterialModel : BaseModel

/**
 *   filetype = 文件类型（doc等）
   uid = 用户ID
   RoleID = 角色ID，1集团2个人
   name = 标题
   mate_id = 材料ID
   MF_ID = 收藏资料ID，如果为NULL表示未收藏
   type = 分类标签（听力等）
   createtime = 创建日期
   url = 点击打开网址
   StorePoint = 存储点 1:够快网盘; 2:CC视频
   ReadCount = 被查看次数
   VideoDuration = 视频长度（分钟）
   VideoThumbNail = 视频截图
 */


@property (nonatomic, copy)   NSString *filetype;
@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSNumber *RoleID;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, strong) NSNumber *mate_id;
@property (nonatomic, strong) NSNumber *MF_ID;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSString *createtime;
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, strong) NSNumber *StorePoint;
@property (nonatomic, strong) NSNumber *ReadCount;
@property (nonatomic, strong) NSNumber *VideoDuration;
@property (nonatomic, copy)   NSString *VideoThumbNail;

@end
