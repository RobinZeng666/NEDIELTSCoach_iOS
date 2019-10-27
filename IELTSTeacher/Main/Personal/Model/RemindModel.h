//
//  RemindModel.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/17.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface RemindModel : BaseModel

@property (nonatomic,copy) NSString *ImgString;//灰圈或红圈图片名
@property (nonatomic,copy) NSString *Title;//标题
@property (nonatomic,copy) NSString *Location;//位置
@property (nonatomic,copy) NSString *LocalImgName;//位置图片名
@property (nonatomic,copy) NSString *dateTime;//2015-05-20
@property (nonatomic,copy) NSString *hourTime;//am 9：00
@property (nonatomic,copy) NSString *note;//备注

@end
