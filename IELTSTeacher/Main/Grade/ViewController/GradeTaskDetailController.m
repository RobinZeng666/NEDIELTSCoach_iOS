//
//  GradeTaskDetailController.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/7.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeTaskDetailController.h"

@interface GradeTaskDetailController ()

@end

@implementation GradeTaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     初始化视图
     */
    [self _initView];
    /**
     初始化数据
     */
    [self _initData];
    
    
}
#pragma mark -
- (void)_initView
{

}
- (void)_initData
{
    CHECK_DATA_IS_NSNULL(self.taskModel.TaskType, NSNumber);
    NSInteger taskType = [self.taskModel.TaskType integerValue];
    switch (taskType) {
        case 1:
        case 2:
        {
            NSString *refID = self.taskModel.RefID;
            [[Service sharedInstance]getMaterialsInfoWithMateId:refID
                                                       succcess:^(NSDictionary *result) {
                
                                                       } failure:^(NSError *error) {
                
                                                       }];
        }
            break;
        case 3:
        {
            NSString *st_id = self.taskModel.ST_ID;
            NSString *refId = self.taskModel.RefID;
            NSDictionary *dicData = @{@"stId":st_id,
                                      @"pId":refId};
            [[Service sharedInstance]getPapersInfo:dicData
                                          succcess:^(NSDictionary *result) {
            
                                          } failure:^(NSError *error) {
            
                                          }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - set or get


@end
