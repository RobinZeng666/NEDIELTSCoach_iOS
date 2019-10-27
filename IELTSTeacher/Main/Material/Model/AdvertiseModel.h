//
//  AdvertiseModel.h
//  IELTSTeacher
//
//  Created by Hello酷狗 on 15/7/18.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseModel.h"

@interface AdvertiseModel : BaseModel

/**
 *  Sort = 广告序号;
   Interval = 时间间隔，每隔多少秒切换广告;
   Title = 广告标题;
   Picture = 广告封面，图片名称;
   Link = 广告地址;
   Content = 广告正文;
 */

@property (nonatomic, copy) NSString *Sort;
@property (nonatomic, copy) NSString *Interval;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *Link;
@property (nonatomic, copy) NSString *Content;

@end
