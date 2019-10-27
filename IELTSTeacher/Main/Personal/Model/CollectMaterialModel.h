//
//  CollectMaterialModel.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/7.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface CollectMaterialModel : BaseModel

/**
 *  CreateTime = 创建时间;
   FileType = 文件类型 扩展名;
   IsPublic = 是否发布 0=未发布 1=已发布;
   MF_ID = 收藏主键;
   Mate_ID = 资料主键;
   Name = 资料名称;
   NickName = 账号名称;
   ReadCount = 被查看次数;
   RoleID = 创建人角色;
   StoreID = 存储点的记录ID;
   StorePoint = 存储点 1:够快网盘; 2:CC视频;
   StoreState = 状态 0:待上传; 1:上传中; 2:上传成功; 3:上传失败;
   UID = 创建人ID;
   Url = 资料查看地址;
   CategoryName = 科目名称;
 */

@property (nonatomic,strong) NSNumber *CreateTime;
@property (nonatomic,copy) NSString *FileType;
@property (nonatomic,strong) NSNumber *IsPublic;
@property (nonatomic,strong) NSNumber *MF_ID;
@property (nonatomic,strong) NSNumber *Mate_ID;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *NickName;
@property (nonatomic,strong) NSNumber *ReadCount;
@property (nonatomic,strong) NSNumber *RoleID;
@property (nonatomic,strong) NSNumber *StoreID;
@property (nonatomic,strong) NSNumber *StorePoint;
@property (nonatomic,strong) NSNumber *StoreState;
@property (nonatomic,strong) NSNumber *UID;
@property (nonatomic,copy) NSString *Url;
@property (nonatomic,copy) NSString *CategoryName;

@end
