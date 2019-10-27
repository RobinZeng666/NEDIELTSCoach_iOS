//
//  MaterialDetailModel.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/23.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface MaterialDetailModel : BaseModel

/**
 *  CreateTime = "2015-06-04";
 FileType = mp4;
 Name = "\U542c\U529b";
 ReadCount = 18;
 sName = "\U4f0a\U529b\U4e9a\U5c14\U6d77\U7c73\U63d0";

 */

@property (nonatomic, copy)   NSString *CreateTime;
@property (nonatomic, copy)   NSString *FileType;
@property (nonatomic, copy)   NSString *Name;
@property (nonatomic, strong) NSNumber *ReadCount;
@property (nonatomic, copy)   NSString *sName;

@end
