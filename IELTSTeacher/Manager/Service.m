//
//  Service.m
//  AFNetworkingTest
//
//  Created by Sidney on 14-7-10.
//  Copyright (c) 2014年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "Service.h"
#import "ConfigData.h"

#define k_AppTeacherLogin                   @"User/AppTeacherLogin"//登录
#define K_GetTeacherMonthLessonsForApp      @"Task/GetTeacherMonthLessonsForApp"//课表
#define k_GetTeacherLessonAndPassCode       @"ActiveClass/GetTeacherLessonAndPassCode"
#define k_SaveActiveClassPro                @"ActiveClass/SaveActiveClassPro"
#define k_TeacherOrStudentGetStudentOnLine  @"ActiveClass/TeacherOrStudentGetStudentOnLine"
#define k_ActiveClassExerciseList           @"ActiveClass/ActiveClassExerciseList"


#define k_loadClasses                       @"TeacherClasses/loadClasses"       //班级课程列表
#define k_getLessonInfo                     @"TeacherClasses/getLessonInfo"     //班级课次信息
#define k_getClassStus                      @"TeacherClasses/getClassStus"      //班级学生信息
#define k_getCorrectList                    @"TeacherClasses/getCorrectList"    //班级待批改信息
#define k_getPapersInfoByID                 @"TeacherClasses/getPapersInfoByID" //班级获取练习信息

#define k_loadTaskList                      @"Home/loadTaskList"     //班级任务列表
#define k_getMaterialsInfo                  @"Home/getMaterialsInfo"  //班级任务-获取资料信息
#define k_getPapersInfo                     @"Home/getPapersInfo"      //班级任务-获取模考、练习信息
#define k_getPapersInfoByMID                @"Home/getPapersInfoByMID" //班级任务-视频资料中试题库

#define k_ActiveClassExerciseByPaperNumber  @"ActiveClass/ActiveClassExerciseByPaperNumber"
#define k_ActiveClassExerciseDetail         @"ActiveClass/ActiveClassExerciseDetail"
#define k_ActiveClassExerciseDelete         @"ActiveClass/ActiveClassExerciseDelete"

//#define k_getCorrectList                    @"TeacherClasses/getCorrectList"//班级待批改信息
#define k_examCorrecting                    @"TeacherClasses/examCorrecting" //作文批改 页面
#define k_voiceCorrecting                   @"TeacherClasses/voiceCorrecting" //口语模考批改 页面
#define k_contactCorrecting                 @"TeacherClasses/contactCorrecting"//口语练习批改 页面
#define k_finishKyCorrecting                @"TeacherClasses/finishKyCorrecting"//口语/模考完成批改
#define k_finishXzCorrecting                @"TeacherClasses/finishXzCorrecting"//写作完成批改

#define k_teacherMaterials                  @"onlinestudy/teacherMaterials" //学习资料列表
#define k_addReadCount                      @"Material/addReadCount" //查看资料 增加查看次数
#define k_loadAdvertisements                @"User/loadAdvertisements" //获取广告位信息
#define k_teacherMaterialsFilter            @"onlinestudy/teacherMaterialsFilter" //资料列表筛选
#define k_getTeacherInfo                    @"TeacherHome/getTeacherInfo" //个人中心首页
#define k_UploadMyIcon                      @"User/UploadMyIcon" //上传头像
#define k_loadMessages                      @"TeacherHome/loadMessages" //我的消息
#define k_MyAllMessageNoReadCount           @"TeacherHome/teaAllMessageNoReadCount" //所有消息未读数
#define k_MyAllMessageNoRead                @"Message/MyAllMessageNoRead" //系统消息-消息列表
#define k_ReadOrDelMessage                  @"Message/ReadOrDelMessage" //更新具体人员的系统消息的阅读（或删除）状态
#define k_deleteMessage                     @"TeacherHome/deleteMessage" //删除我的消息
#define k_MyMaterialsFavoriteList           @"Material/MyMaterialsFavoriteList" //我的收藏
#define k_deleteMyMaterialsFavorite         @"Material/deleteMyMaterialsFavorite" //删除我的收藏
#define k_AddOrCancelMaterialsFavorite      @"Material/AddOrCancelMaterialsFavorite" //添加、取消收藏
#define k_loadStuInfosByClass               @"TeacherHome/loadStuInfosByClass" //学员成绩
#define k_AddSuggestionInfo                 @"Message/AddSuggestionInfo" //意见反馈


//#define k_InsertTaskFinish                              @"Task/InsertTaskFinish"    //更新TaskFinish任务完成情况表
#define k_ActiveClassExerciseChooseQuestions            @"ActiveClass/ActiveClassExerciseChooseQuestions"//保存选择的课堂练习
#define k_remindTask                                    @"TeacherClasses/remindTask" //教师任务提醒
#define k_lookVideoInfo                                 @"Material/lookVideoInfo"//获取视频信息
#define k_ActiveClassExerciseStartOrStop                @"ActiveClass/ActiveClassExerciseStartOrStop"//开始和结束

#define k_FinishActiveClass                             @"ActiveClass/FinishActiveClass"//下课
#define k_findWholeSubmitModeStudentExamMark            @"ActiveClass/findWholeSubmitModeStudentExamMark"//整套提交学生成绩单
#define k_ActiveClassExerciseByPaperNumberSave          @"ActiveClass/ActiveClassExerciseByPaperNumberSave"//保存试题
#define k_NickNameChange                                @"User/NickNameChange"//修改昵称
#define k_findWholeSubmitModeStudentExerciseReport      @"ActiveClass/findWholeSubmitModeStudentExerciseReport"//整套提交的学生练习报告
#define k_AppLogoffUser                                 @"User/AppLogoffUser"//APP退出系统
#define k_SignatureChange                               @"User/SignatureChange" //修改个性签名


#define k_findSingleSubmitModeStudentExamMark           @"ActiveClass/findSingleSubmitModeStudentExamMark" //单题提交的学生成绩单
#define k_findSingleSubmitModeStudentExerciseReport     @"ActiveClass/findSingleSubmitModeStudentExerciseReport" //单题提交的学生练习报告
#define k_TeacherSyncActiveClass                        @"ActiveClass/TeacherSyncActiveClass"//点击“同步到课堂”
#define k_checkCollectMaterials                         @"Material/checkCollectMaterials"//资料是否收藏
#define k_lookUpVideoMaterials                          @"Material/lookUpVideoMaterials"//视频资料查看

#define k_loadActiveClassGroup                          @"ActiveClass/loadActiveClassGroup"//获取分组信息
#define k_autoDivideIntoGroups                          @"ActiveClass/autoDivideIntoGroups"//随机分组
#define k_handDivideIntoGroups                          @"ActiveClass/handDivideIntoGroups"//手动分组
#define k_confirmDiviceGroup                            @"ActiveClass/confirmDiviceGroup"//确认分组
#define k_loadNoGroupStudents                           @"ActiveClass/loadNoGroupStudents"//手动分组获取未分组学员
#define k_getIdByPassCode                               @"ActiveClass/getIdByPassCode"//获取课堂ID
#define k_abandonDiviceGroup                            @"ActiveClass/abandonDiviceGroup"//放弃分组

#define k_loadVoteHisInfo                               @"ActiveClass/loadVoteHisInfo"//获取历史投票信息
#define k_collectStuVotes                               @"ActiveClass/collectStuVotes"//心跳汇总当前投票数据，
#define k_startVote                                     @"ActiveClass/startVote"//开始投票
#define k_finishVote                                    @"ActiveClass/finishVote"//结束投票
#define k_joinVote                                      @"ActiveClass/joinVote"   //参与投票
#define k_getChatToken                                  @"ActiveClass/getChatToken"//获取聊天室Token
#define k_loadChatList                                  @"ActiveClass/loadChatList"//获取聊天室列表信息

#define k_resetGroup                                    @"ActiveClass/resetGroup"//手动分组的重置

@interface Service()

@property(nonatomic ,strong) AFHTTPRequestOperationManager *requestManager;

@end

@implementation Service

+ (instancetype)sharedInstance
{
    static Service *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[Service alloc] init];
    });
    return instance;
}

/**
 *  取消所有的网络请求
 */
- (void)cancelAllRequest
{
    [self.requestManager.operationQueue cancelAllOperations];
}

/**
 *  Get and Post
 */
- (AFHTTPRequestOperation *)requestGetWithParameters:(NSDictionary *)parameters
                                             ApiPath:(NSString*)path
                                          WithHeader:(NSDictionary*)headers
                                             success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                                             failure:(void (^)(NSError *error))failure
{
        NSMutableDictionary *hrParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        path = [NSString stringWithFormat:@"%@/%@",BaseURLString,path];
        self.requestManager = [AFHTTPRequestOperationManager manager];
        self.requestManager.requestSerializer.timeoutInterval = 45;
        if (headers != nil) {
            self.requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
            self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
            [self.requestManager.requestSerializer setValue:[headers objectForKey:@"Authentication"] forHTTPHeaderField:@"Authentication"];
        }
        
        return  [self.requestManager GET:path
                              parameters:hrParameters
                                 success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     
//                     [[CacheManage SharedCacheManage] CacheWebAPI:apiPath AndResponse:[operation responseString]];
                     
                     success(responseObject,[operation.response allHeaderFields]);
                 }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                     NDLog(@"Error: %@", [operation responseString]);
                     failure(error);
                     
                     if([operation responseString] == nil) return;
                 }];
}

- (AFHTTPRequestOperation *)requestPostWithParameters:(NSDictionary *)parameters
                                              ApiPath:(NSString*)path
                                           WithHeader:(NSDictionary*)headers
                                              success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                                              failure:(void (^)(NSError *error))failure
{
        NSMutableDictionary *hrParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        path = [NSString stringWithFormat:@"%@/%@",BaseURLString,path];
        self.requestManager = [AFHTTPRequestOperationManager manager];
        if (headers != nil) {
            self.requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [self.requestManager.requestSerializer setValue:[headers objectForKey:@"Authentication"] forHTTPHeaderField:@"Authentication"];
            [self.requestManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        }
        return  [self.requestManager POST:path
                               parameters:hrParameters
                                  success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     //缓存数据
//                     [[CacheManage SharedCacheManage] CacheWebAPI:apiPath AndResponse:[operation responseString]];
                     success(responseObject,[operation.response allHeaderFields]);
                 }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                     NDLog(@"Error: %@", [operation responseString]);
                     failure(error);
                     if([operation responseString] == nil) return;
                 }];
}

/**
 *  登录
 */
- (AFHTTPRequestOperation *)appTeacherLoginWithEmail:(NSString *)email
                                            passWord:(NSString *)password
                                             success:(SuccessData)success
                                             failure:(ErrorData)failure
{
    NSDictionary *paramr = @{@"u":email,
                             @"p":password,
                             @"DeviceToken":@"appTeacher",
                             @"DeviceTokenType":@"Iphone"};
    return  [self requestPostWithParameters:paramr
                                    ApiPath:k_AppTeacherLogin
                                 WithHeader:nil
                                    success:^(NSDictionary *result, NSDictionary *headers) {
                                        success(result);
                                    } failure:^(NSError *error) {
                                        failure(error);
                                    }];
}

/**
 *  课表
 */
- (AFHTTPRequestOperation *)getTeacherMonthLessonsForAppWithDateParam:(NSString *)dateParam
                                                              success:(SuccessData)success
                                                              failure:(ErrorData)failure
{
    NSDictionary *param = @{@"dateParam":dateParam};
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestGetWithParameters:param
                                  ApiPath:K_GetTeacherMonthLessonsForApp
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                      success(result);
                                  } failure:^(NSError *error) {
                                      failure(error);
                                  }];
}

/**
 *  我的消息
 */
- (AFHTTPRequestOperation *)loadMessagesWithPram:(NSDictionary *)dic
                                         success:(SuccessData)success
                                         failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:dic
                                  ApiPath:k_loadMessages
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                      success(result);
                                  } failure:^(NSError *error) {
                                      failure(error);
                                  }];
}

/**
 *  所有消息未读数
 */
#pragma mark - 所有消息未读数
- (AFHTTPRequestOperation *)myAllMessageNoReadCountSuccess:(SuccessData)success
                                                   failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestGetWithParameters:nil
                                  ApiPath:k_MyAllMessageNoReadCount
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                      success(result);
                                  } failure:^(NSError *error) {
                                      failure(error);
                                  }];
}

/**
 *  系统消息-消息列表
 */
- (AFHTTPRequestOperation *)myAllMessageNoReadWithPram:(NSDictionary *)dic
                                               success:(SuccessData)success
                                               failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:dic
                                   ApiPath:k_MyAllMessageNoRead
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

- (AFHTTPRequestOperation *)getTeacherLessonAndPassCodeWithTeacherCode:(NSString *)sTeacherId
                                                               success:(SuccessData)success
                                                               failure:(ErrorData)failure
{

    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(sTeacherId, NSString);
    NSDictionary *dic = @{@"sTeacherId":sTeacherId};
    return [self requestGetWithParameters:dic
                                  ApiPath:k_GetTeacherLessonAndPassCode
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                      success(result);
                                  } failure:^(NSError *error) {
                                      failure(error);
                                  }];

}
- (AFHTTPRequestOperation *)SaveActiveClassProWithTeacherCode:(NSString *)sTeacherId
                                                         ccId:(NSString *)ccId
                                                    nLessonNo:(NSNumber *)nLessonNo
                                                      success:(SuccessData)success
                                                      failure:(ErrorData)failure{
    NSString *token = [ConfigData  sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    CHECK_DATA_IS_NSNULL(sTeacherId, NSString);
//    CHECK_DATA_IS_NSNULL(passCode,NSString);
//    CHECK_DATA_IS_NSNULL(ccId,NSString);
//    CHECK_DATA_IS_NSNULL(nLessonNo,NSString);
    
    NSDictionary *dic = @{@"sTeacherId":sTeacherId,
                          @"ccId":ccId,
                          @"nLessonNo":nLessonNo
                          };
    
    return [self requestGetWithParameters:dic
                                  ApiPath:k_SaveActiveClassPro
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                      success(result);
                                  } failure:^(NSError *error) {
                                      failure(error);
                                  }];
}

#pragma mark - 教师端 或 学生端 每隔3秒向服务器发送在线的消息，获取最新在线学生列表 包括在线人数/总人数和各学生信息
- (AFHTTPRequestOperation *)TeacherOrStudentGetStudentOnLinePassCode:(NSString *)passCode
                                                              RoleId:(NSString *)roleId
                                                             success:(SuccessData)success
                                                             failure:(ErrorData)failure{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    CHECK_DATA_IS_NSNULL(passCode, NSString);
    NSDictionary *dic = @{@"passCode":passCode,
                          @"roleId":roleId};
    
    return [self requestGetWithParameters:dic
                                  ApiPath:k_TeacherOrStudentGetStudentOnLine
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                      success(result);
                                  } failure:^(NSError *error) {
                                      failure(error);
                                  }];
}

- (AFHTTPRequestOperation *)ActiveClassExerciseListWithPassCode:(NSString *)passCode
                                                           ccId:(NSString *)ccId
                                                        success:(SuccessData)success
                                                        failure:(ErrorData)failure
{
        NSString *token = [ConfigData sharedInstance].token;
        CHECK_STRING_IS_NULL(token);
        NSDictionary *header = @{@"Authentication":token};
        CHECK_DATA_IS_NSNULL(passCode, NSString);
        CHECK_DATA_IS_NSNULL(ccId, NSString);
       CHECK_STRING_IS_NULL(passCode);
        NSDictionary *dic = @{@"passCode":passCode,
                              @"ccId":ccId};
        return [self   requestGetWithParameters:dic
                                        ApiPath:k_ActiveClassExerciseList
                                     WithHeader:header
                                        success:^(NSDictionary *result, NSDictionary *headers) {
                                            
                                            success(result);
                                            
                                        } failure:^(NSError *error) {
                                            failure(error);
                                        }];

}

/**
 *  我的收藏
 */
- (AFHTTPRequestOperation *)myMaterialsFavoriteListWithPram:(NSDictionary *)dic
                                                    success:(SuccessData)success
                                                    failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestGetWithParameters:dic
                                  ApiPath:k_MyMaterialsFavoriteList
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                      success(result);
                                  } failure:^(NSError *error) {
                                      failure(error);
                                  }];
}

/**
 *  删除我的收藏
 */
- (AFHTTPRequestOperation *)deleteMyMaterialsFavoriteWithPram:(NSDictionary *)dic
                                                     succcess:(SuccessData)success
                                                      failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestGetWithParameters:dic
                                  ApiPath:k_deleteMyMaterialsFavorite
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                   success(result);
                               } failure:^(NSError *error) {
                                   failure(error);
                               }];
}


/**
 *  班级课程列表
 */
- (AFHTTPRequestOperation *)loadClasses:(NSDictionary *)dic
                               succcess:(SuccessData)success
                                failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_loadClasses
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  班级课次信息
 */
- (AFHTTPRequestOperation *)getLessonInfo:(NSDictionary *)dic
                                 succcess:(SuccessData)success
                                  failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_getLessonInfo
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  班级学生信息
 */
- (AFHTTPRequestOperation *)getClassStusWithClassCode:(NSString *)classCode
                                             succcess:(SuccessData)success
                                              failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(classCode, NSString);
    NSDictionary *dic = @{@"sClassId":classCode};
    
    return [self requestPostWithParameters:dic
                                   ApiPath:k_getClassStus
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  班级待批改信息
 */
- (AFHTTPRequestOperation *)getCorrectListWithclassCode:(NSString *)classCode
                                              pageIndex:(NSString *)pageIndex
                                               succcess:(SuccessData)success
                                                failure:(ErrorData)failure
{

    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(classCode, NSString);
    CHECK_STRING_IS_NULL(classCode);
    CHECK_STRING_IS_NULL(pageIndex);
    NSDictionary *dic = @{@"ccId":classCode,
                          @"pageIndex":pageIndex};
    
    return [self requestPostWithParameters:dic
                                   ApiPath:k_getCorrectList
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];

}

/**
 * 作文批改 页面
 */
- (AFHTTPRequestOperation *)examCorrectingWithexamInfoId:(NSString *)examInfoId
                                                 paperId:(NSString *)paperId
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure
{
    CHECK_STRING_IS_NULL(examInfoId);
    CHECK_STRING_IS_NULL(paperId);
    NSDictionary *dic = @{@"examInfoId":examInfoId,
                          @"paperId":paperId};
    
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:dic
                                   ApiPath:k_examCorrecting
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];

}

/**
 * 口语模考批改 页面
 */
- (AFHTTPRequestOperation *)voiceCorrectingWithexamInfoId:(NSString *)examInfoId
                                                  paperId:(NSString *)paperId
                                                 succcess:(SuccessData)success
                                                  failure:(ErrorData)failure
{
    CHECK_STRING_IS_NULL(examInfoId);
    CHECK_STRING_IS_NULL(paperId);
    
    NSDictionary *dic = @{@"examInfoId":examInfoId,
                          @"paperId":paperId};
    
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:dic
                                   ApiPath:k_voiceCorrecting
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 * 口语练习批改 页面
 */
- (AFHTTPRequestOperation *)contactCorrectingWithexamInfoId:(NSString *)examInfoId
                                                    paperId:(NSString *)paperId
                                                   succcess:(SuccessData)success
                                                    failure:(ErrorData)failure
{
    CHECK_STRING_IS_NULL(examInfoId);
    CHECK_STRING_IS_NULL(paperId);
    NSDictionary *dic = @{@"examInfoId":examInfoId,
                          @"paperId":paperId};
    
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:dic
                                   ApiPath:k_contactCorrecting
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 * 口语/模考完成批改
 */
- (AFHTTPRequestOperation *)finishKyCorrectingWithDic:(NSDictionary *)dataDic
                                             succcess:(SuccessData)success
                                              failure:(ErrorData)failure
{
    CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
    
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:dataDic
                                   ApiPath:k_finishKyCorrecting
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 * 写作完成批改
 */
- (AFHTTPRequestOperation *)finishXzCorrectingWithDic:(NSDictionary *)dataDic
                                             succcess:(SuccessData)success
                                              failure:(ErrorData)failure
{
    CHECK_DATA_IS_NSNULL(dataDic, NSDictionary);
    
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:dataDic
                                   ApiPath:k_finishXzCorrecting
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}


/**
 *  班级练习信息
 */
- (AFHTTPRequestOperation *)getPapersInfoByIDWithId:(NSString *)ids
                                           succcess:(SuccessData)success
                                            failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(ids, NSString);
    NSDictionary *dic = @{@"id":ids};
    
    return [self requestPostWithParameters:dic
                                   ApiPath:k_getPapersInfoByID
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  获取班级任务列表
 */
- (AFHTTPRequestOperation *)loadTaskList:(NSDictionary *)ids
                                succcess:(SuccessData)success
                                 failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
//    CHECK_DATA_IS_NSNULL(ids, NSDictionary);
//    NSDictionary *dic = @{@"id":ids};
    
    return [self requestPostWithParameters:ids
                                   ApiPath:k_loadTaskList
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  班级任务-获取资料信息
 */
- (AFHTTPRequestOperation *)getMaterialsInfoWithMateId:(NSString *)mateId
                                              succcess:(SuccessData)success
                                               failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(mateId, NSString);
    NSDictionary *dic = @{@"mateId":mateId};
    
    return [self requestPostWithParameters:dic
                                   ApiPath:k_getMaterialsInfo
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  班级任务-获取模考、练习信息
 */
- (AFHTTPRequestOperation *)getPapersInfo:(NSDictionary *)mateId
                                 succcess:(SuccessData)success
                                  failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(mateId, NSDictionary);
    
    return [self requestPostWithParameters:mateId
                                   ApiPath:k_getPapersInfo
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  学习 资料列表
 */
- (AFHTTPRequestOperation *)teacherMaterialsWithPram:(NSDictionary *)dic
                                            succcess:(SuccessData)success
                                             failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestGetWithParameters:dic
                                  ApiPath:k_teacherMaterials
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  添加、取消收藏
 */
- (AFHTTPRequestOperation *)addOrCancelMaterialsFavoriteWithPram:(NSDictionary *)dic
                                                         success:(SuccessData)success
                                                         failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestGetWithParameters:dic
                                  ApiPath:k_AddOrCancelMaterialsFavorite
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  意见反馈
 */
- (AFHTTPRequestOperation *)addSuggestionInfoWithPram:(NSDictionary *)dic
                                              success:(SuccessData)success
                                              failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_AddSuggestionInfo
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  添加练习
 */
- (AFHTTPRequestOperation *)ActiveClassExerciseByPaperNumberWithPaperNumber:(NSString *)paperNumber
                                                                       ccId:(NSString *)ccId
                                                                    success:(SuccessData)success
                                                                    failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    CHECK_DATA_IS_NSNULL(paperNumber, NSString);
    CHECK_DATA_IS_NSNULL(ccId, NSString);
    NSDictionary *dic = @{@"paperNumber":paperNumber,@"ccId":ccId};
    return [self requestGetWithParameters:dic
                                  ApiPath:k_ActiveClassExerciseByPaperNumber
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                success(result);
                            } failure:^(NSError *error) {
                                failure(error);
                            }];
}

/**
 *  教师选题
 */
- (AFHTTPRequestOperation *)ActiveClassExerciseDetailWithPassCode:(NSString *)passCode
                                                              pId:(NSNumber *)pId
                                                          success:(SuccessData)success
                                                          failure:(ErrorData)failure{

    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    CHECK_DATA_IS_NSNULL(passCode, NSString);
    CHECK_DATA_IS_NSNULL(pId, NSNumber);
    CHECK_STRING_IS_NULL(passCode);
    NSDictionary *dic = @{@"passCode":passCode,@"pId":pId};
    return [self requestGetWithParameters:dic
                               ApiPath:k_ActiveClassExerciseDetail
                            WithHeader:header
                               success:^(NSDictionary *result, NSDictionary *headers) {
                                success(result);
                            } failure:^(NSError *error) {
                                failure(error);
                            }];

}

/**
 *  删除练习
 */
- (AFHTTPRequestOperation *)ActiveClassExerciseDeleteWithccId:(NSString *)ccId
                                                      paperId:(NSNumber *)paperId
                                                      success:(SuccessData)success
                                                      failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    /**
     *  ccId=[课次Id]
      paperId=[试卷ID]
     */
    NSDictionary *dic = @{@"ccId":ccId,
                          @"paperId":paperId};
    return [self requestGetWithParameters:dic
                               ApiPath:k_ActiveClassExerciseDelete
                            WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                success(result);
                            } failure:^(NSError *error) {
                                failure(error);
                            }];
}

/**
 *  个人中心首页
 */
- (AFHTTPRequestOperation *)getTeacherInfoSuccess:(SuccessData)success
                                          failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:nil
                                   ApiPath:k_getTeacherInfo
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  学员成绩
 */
- (AFHTTPRequestOperation *)loadStuInfosByClassWithPram:(NSDictionary *)dic
                                                success:(SuccessData)success
                                                failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_loadStuInfosByClass
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  资料列表筛选
 */
- (AFHTTPRequestOperation *)teacherMaterialsFilterWithPram:(NSDictionary *)dic
                                                   success:(SuccessData)success
                                                   failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_teacherMaterialsFilter
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  删除我的消息
 */
- (AFHTTPRequestOperation *)deleteMessageWithPram:(NSDictionary *)dic
                                          success:(SuccessData)success
                                          failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_deleteMessage
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  查看资料 增加查看次数
 */
- (AFHTTPRequestOperation *)addReadCountWithPram:(NSDictionary *)dic
                                         success:(SuccessData)success
                                         failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_addReadCount
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  获取广告位信息
 */
- (AFHTTPRequestOperation *)loadAdvertisementsWithPram:(NSDictionary *)dic
                                               success:(SuccessData)success
                                               failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_loadAdvertisements
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  更新具体人员的系统消息阅读（或删除）状态
 */
- (AFHTTPRequestOperation *)readOrDelMessageWithPram:(NSDictionary *)dic
                                            succcess:(SuccessData)success
                                             failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_DATA_IS_NSNULL(token, NSString);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestGetWithParameters:dic
                                  ApiPath:k_ReadOrDelMessage
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                   success(result);
                               } failure:^(NSError *error) {
                                   failure(error);
                               }];
}


//- (AFHTTPRequestOperation *)insertTaskFinishAndkeyID:(NSString *)keyid
//                                          examInfoId:(NSString *)examInfoId
//                                         SuccessData:(SuccessData)success
//                                           errorData:(ErrorData)errors
//{
//    NSString *token = [ConfigData sharedInstance].token;
//    CHECK_STRING_IS_NULL(token);
//    NSDictionary *header = @{@"Authentication":token};
//    
//    CHECK_STRING_IS_NULL(keyid);
//    NSDictionary *dicData = @{@"stId":keyid,
//                              @"examInfoId":examInfoId};
//    
//    return [self requestGetWithParameters:dicData
//                                  ApiPath:k_InsertTaskFinish
//                               WithHeader:header
//                                  success:^(NSDictionary *result, NSDictionary *headers) {
//                                      success(result);
//                                  } failure:^(NSError *error) {
//                                      errors(error);
//                                  }];
//}

//activeClassPaperInfoId=[课堂与随堂试卷的关系表Id]
// paperId=[试卷ID]
// qIds=[试题ID集合(以,隔开),不可为空]

- (AFHTTPRequestOperation *)ActiveClassExerciseChooseQuestionsWithInfoId:(NSNumber *)InfoId
                                                                 paperId:(NSNumber *)paperId
                                                                    qIds:(NSString *)qIds
                                                         paperSubmitMode:(NSString *)paperSubmitMode
                                                    paperSubmitCountdown:(NSString  *)paperSubmitCountdown
                                                             SuccessData:(SuccessData)success
                                                               errorData:(ErrorData)errors
{
    NSString *token = [ConfigData  sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    CHECK_DATA_IS_NSNULL(paperId, NSNumber);
    CHECK_DATA_IS_NSNULL(InfoId, NSNumber);
    CHECK_DATA_IS_NSNULL(qIds, NSString);
    CHECK_DATA_IS_NSNULL(paperSubmitMode, NSString);
    CHECK_DATA_IS_NSNULL(paperSubmitCountdown, NSString);
    NSDictionary *dic = @{@"paperId":paperId,
                          @"activeClassPaperInfoId":InfoId,
                          @"qIds":qIds,
                          @"paperSubmitMode":paperSubmitMode,
                          @"paperSubmitCountdown":paperSubmitCountdown};

    return [self requestGetWithParameters:dic
                               ApiPath:k_ActiveClassExerciseChooseQuestions
                            WithHeader:header
                               success:^(NSDictionary *result, NSDictionary *headers) {
                                   success(result);
                               } failure:^(NSError *error) {
                                    errors(error);
                               }];
}

- (AFHTTPRequestOperation *)remindTaskWithClassCode:(NSString *)classCode
                                            message:(NSString *)message
                                             taskID:(NSString *)taskId
                                        SuccessData:(SuccessData)success
                                          errorData:(ErrorData)errors
{
    NSString *token = [ConfigData  sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};

    CHECK_STRING_IS_NULL(classCode);
    CHECK_STRING_IS_NULL(message);
    CHECK_STRING_IS_NULL(taskId);
    NSDictionary *dic = @{@"sClassID":classCode,
                          @"message":message,
                          @"taskID":taskId};
    
    return [self requestPostWithParameters:dic
                                    ApiPath:k_remindTask
                                 WithHeader:header
                                    success:^(NSDictionary *result, NSDictionary *headers) {
                                        success(result);
                                    } failure:^(NSError *error) {
                                        errors(error);
                                    }];
}

/**
 *  获取视频信息
 */
- (AFHTTPRequestOperation *)lookVideoInfoWithPram:(NSDictionary *)dic
                                          success:(SuccessData)success
                                          failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_lookVideoInfo
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  开始结束的按钮的点击事件
 */
- (AFHTTPRequestOperation *)ActiveClassExerciseStartOrStopWithccId:(NSString *)ccId
                                                           paperId:(NSString *)paperId
                                                              type:(NSString *)type
                                                           success:(SuccessData)success
                                                           failure:(ErrorData)failure{
    NSString *token = [ConfigData  sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    CHECK_DATA_IS_NSNULL(ccId, NSString);
    CHECK_DATA_IS_NSNULL(paperId, NSString);
    CHECK_DATA_IS_NSNULL(type, NSString);
    NSDictionary *dic = @{@"ccId":ccId,
                          @"paperId":paperId,
                          @"type":type};

    return [self requestGetWithParameters:dic
                              ApiPath:k_ActiveClassExerciseStartOrStop
                               WithHeader:header
                              success:^(NSDictionary *result, NSDictionary *headers) {
                                  success(result);
                              }failure:^(NSError *error) {
                                  failure(error);
                              }];
}

/**
 *  下课的网络请求
 */
- (AFHTTPRequestOperation *)FinishActiveClassWithpassCode:(NSString *)passCode
                                                  success:(SuccessData)success
                                                  failure:(ErrorData)failure
{
    NSString *token = [ConfigData  sharedInstance].token ;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    CHECK_DATA_IS_NSNULL(passCode, NSString);
    NSDictionary *dic = @{@"passCode":passCode};
    return [self requestGetWithParameters:dic
                              ApiPath:k_FinishActiveClass
                           WithHeader:header
                              success:^(NSDictionary *result, NSDictionary *headers) {
                                  success(result);
                              } failure:^(NSError *error) {
                                  failure(error);
                              }];
}

/**
 *  整套提交学生成绩单的报告 ccId=[课次Id]&
  paperId=[试卷Id]
 */
- (AFHTTPRequestOperation *)findWholeSubmitModeStudentExamMarkWithccId:(NSString *)ccId
                                                               paperId:(NSString *)paperId
                                                               success:(SuccessData)success
                                                               failure:(ErrorData)failure
{
    NSString *token = [ConfigData  sharedInstance].token ;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    CHECK_DATA_IS_NSNULL(ccId, NSString);
    CHECK_DATA_IS_NSNULL(paperId, NSString);
    NSDictionary *dic = @{@"ccId":ccId,@"paperId":paperId};
    
    return [self requestGetWithParameters:dic
                               ApiPath:k_findWholeSubmitModeStudentExamMark
                               WithHeader:header
                               success:^(NSDictionary *result, NSDictionary *headers) {
                                   success(result);
                               } failure:^(NSError *error) {
                                   failure(error);
                               }];
}

/**
 *  保存添加的试题
 */
- (AFHTTPRequestOperation *)ActiveClassExerciseByPaperNumberSaveWithpaperId:(NSString *)paperId
                                                                       ccId:(NSString *)ccId
                                                                    success:(SuccessData)success
                                                                    failure:(ErrorData)failure
{
    NSString *token = [ConfigData  sharedInstance].token ;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    CHECK_DATA_IS_NSNULL(ccId, NSString);
    CHECK_DATA_IS_NSNULL(paperId, NSString);
    NSDictionary *dic = @{@"ccId":ccId,@"paperId":paperId};

    return [self  requestGetWithParameters:dic
                                   ApiPath:k_ActiveClassExerciseByPaperNumberSave
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                    success(result);
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
}

/**
 *  修改昵称
 */
- (AFHTTPRequestOperation *)nickNameChangeWithPram:(NSDictionary *)dic
                                           success:(SuccessData)success
                                           failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_NickNameChange
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  整套提交报告
 */
- (AFHTTPRequestOperation *)findWholeSubmitModeStudentExerciseReportWithccId:(NSString *)ccId
                                                                     paperId:(NSString *)paperId
                                                                     success:(SuccessData)success
                                                                     failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};

    CHECK_DATA_IS_NSNULL(ccId, NSString);
    CHECK_DATA_IS_NSNULL(paperId, NSString);
    NSDictionary *dic = @{@"ccId":ccId,@"paperId":paperId};
    return [self requestGetWithParameters:dic
                                    ApiPath:k_findWholeSubmitModeStudentExerciseReport
                                 WithHeader:header
                                    success:^(NSDictionary *result, NSDictionary *headers) {
                                        success(result);
                                    } failure:^(NSError *error) {
                                        failure(error);
                                    }];
}

/**
 *  APP退出系统
 */
- (AFHTTPRequestOperation *)AppLogoffUserWithPram:(NSDictionary *)dic
                                               success:(SuccessData)success
                                               failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:nil
                                   ApiPath:k_AppLogoffUser
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  修改个性签名
 */
- (AFHTTPRequestOperation *)signatureChangeWithPram:(NSDictionary *)dic
                                            success:(SuccessData)success
                                            failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_SignatureChange
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  单题提交的学生成绩单
 */
- (AFHTTPRequestOperation *)findSingleSubmitModeStudentExamMark:(NSString *)ccId
                                                        paperId:(NSString *)paperId
                                                        success:(SuccessData)success
                                                        failure:(ErrorData)failure
{

    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(ccId, NSString);
    CHECK_DATA_IS_NSNULL(paperId, NSString);
    NSDictionary *dic = @{@"ccId":ccId,@"paperId":paperId};
    return [self   requestGetWithParameters:dic
                                    ApiPath:k_findSingleSubmitModeStudentExamMark
                                 WithHeader:header
                                    success:^(NSDictionary *result, NSDictionary *headers) {
                                        success(result);
                                    } failure:^(NSError *error) {
                                        failure(error);
                                    }];
}

/**
 *  单题提交的学生练习报告
 */
- (AFHTTPRequestOperation *)findSingleSubmitModeStudentExerciseReport:(NSString *)ccId
                                                              paperId:(NSString *)paperId
                                                              success:(SuccessData)success
                                                              failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(ccId, NSString);
    CHECK_DATA_IS_NSNULL(paperId, NSString);
    NSDictionary *dic = @{@"ccId":ccId,@"paperId":paperId};
    return [self requestGetWithParameters:dic
                                    ApiPath:k_findSingleSubmitModeStudentExerciseReport
                                 WithHeader:header
                                    success:^(NSDictionary *result, NSDictionary *headers) {
                                        success(result);
                                    } failure:^(NSError *error) {
                                        failure(error);
                                    }];
}



- (AFHTTPRequestOperation *)TeacherSyncActiveClassWithpassCode:(NSString *)passCode
                                                   teacherCode:(NSString *)sTeacherId
                                                          ccId:(NSString *)ccId
                                                     nLessonNo:(NSString *)nLessonNo
                                                       success:(SuccessData)success
                                                       failure:(ErrorData)failure{

    
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(sTeacherId, NSString);
    CHECK_DATA_IS_NSNULL(passCode, NSString);
    CHECK_DATA_IS_NSNULL(ccId, NSString);
    CHECK_DATA_IS_NSNULL(nLessonNo, NSString);
    CHECK_STRING_IS_NULL(sTeacherId);
    CHECK_STRING_IS_NULL(passCode);
    CHECK_STRING_IS_NULL(ccId);
    CHECK_STRING_IS_NULL(nLessonNo);
    
    NSDictionary *dic = @{@"sTeacherId":sTeacherId,
                          @"passCode":passCode,
                          @"ccId":ccId,
                          @"nLessonNo":nLessonNo};
    
    return [self requestGetWithParameters:dic ApiPath:k_TeacherSyncActiveClass WithHeader:header success:^(NSDictionary *result, NSDictionary *headers) {
        success(result);
    } failure:^(NSError *error) {
        failure(error);
    }];

}

/**
 *  资料是否收藏
 */
- (AFHTTPRequestOperation *)checkCollectMaterialsWithPram:(NSDictionary *)dic
                                                 succcess:(SuccessData)success
                                                  failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestGetWithParameters:dic
                                  ApiPath:k_checkCollectMaterials
                               WithHeader:header
                                  success:^(NSDictionary *result, NSDictionary *headers) {
                                      success(result);
                                  } failure:^(NSError *error) {
                                      failure(error);
                                  }];
}

/**
 *  视频资料查看
 */
- (AFHTTPRequestOperation *)lookUpVideoMaterialsWithPram:(NSDictionary *)dic
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_lookUpVideoMaterials
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  获取课堂分组信息
 */
- (AFHTTPRequestOperation *)loadActiveClassGroupWithPram:(NSDictionary *)dic
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_loadActiveClassGroup
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  随机分组
 */
- (AFHTTPRequestOperation *)autoDivideIntoGroupsWithPram:(NSDictionary *)dic
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_autoDivideIntoGroups
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  手动分组
 */
- (AFHTTPRequestOperation *)handDivideIntoGroupsWithPram:(NSDictionary *)dic
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_handDivideIntoGroups
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  确认分组
 */
- (AFHTTPRequestOperation *)confirmDiviceGroupWithPram:(NSDictionary *)dic
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_confirmDiviceGroup
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  手动分组获取未分组学生
 */
- (AFHTTPRequestOperation *)loadNoGroupStudentsWithPram:(NSDictionary *)dic
                                              succcess:(SuccessData)success
                                               failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_loadNoGroupStudents
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}


/**
 *  获取课堂ID
 */
- (AFHTTPRequestOperation *)getIdByPassCodeWithPram:(NSDictionary *)dic
                                           succcess:(SuccessData)success
                                            failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_getIdByPassCode
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/**
 *  放弃分组
 */
- (AFHTTPRequestOperation *)abandonDiviceGroupWithPram:(NSDictionary *)dic
                                           succcess:(SuccessData)success
                                            failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    return [self requestPostWithParameters:dic
                                   ApiPath:k_abandonDiviceGroup
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}


/*
 获取历史投票信息
 */
- (AFHTTPRequestOperation *)loadVoteHisInfoWithPram:(NSString *)activeClassId
                                           succcess:(SuccessData)success
                                            failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(activeClassId, NSString);
    CHECK_STRING_IS_NULL(activeClassId);
    NSDictionary *dataDic = @{@"activeClassId":activeClassId};
    
    return [self requestPostWithParameters:dataDic
                                   ApiPath:k_loadVoteHisInfo
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];


}

/*
 心跳汇总当前投票数据
 */
- (AFHTTPRequestOperation *)collectStuVotesWithPram:(NSString *)activeClassId
                                             voteId:(NSString *)voteId
                                           succcess:(SuccessData)success
                                            failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(activeClassId, NSString);
    CHECK_STRING_IS_NULL(activeClassId);
    
    CHECK_DATA_IS_NSNULL(voteId, NSString);
    CHECK_STRING_IS_NULL(voteId);
    
    NSDictionary *dataDic = @{@"activeClassId":activeClassId,
                              @"voteId":voteId};
    
    return [self requestPostWithParameters:dataDic
                                   ApiPath:k_collectStuVotes
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];

}

/*
 开始投票
 */
- (AFHTTPRequestOperation *)startVoteWithPram:(NSDictionary *)dataDic
                                     succcess:(SuccessData)success
                                      failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:dataDic
                                   ApiPath:k_startVote
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
   
}


/*
 结束投票
 */
- (AFHTTPRequestOperation *)finishVoteWithPram:(NSString *)activeClassId
                                        voteId:(NSString *)voteId
                                      succcess:(SuccessData)success
                                       failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    CHECK_DATA_IS_NSNULL(activeClassId, NSString);
    CHECK_STRING_IS_NULL(activeClassId);
    
    CHECK_DATA_IS_NSNULL(voteId, NSString);
    CHECK_STRING_IS_NULL(voteId);
    
    NSDictionary *dataDic = @{@"activeClassId":activeClassId,
                              @"voteId":voteId};
    
    return [self requestPostWithParameters:dataDic
                                   ApiPath:k_finishVote
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];

}

/*
 参与投票
 */
- (AFHTTPRequestOperation *)joinVoteWithPram:(NSDictionary *)dataDic
                                    succcess:(SuccessData)success
                                     failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:dataDic
                                   ApiPath:k_joinVote
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
    
}


/*
 获取聊天室Token
 */
- (AFHTTPRequestOperation *)getChatTokenWithPram:(NSDictionary *)dataDic
                                        succcess:(SuccessData)success
                                         failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
//    CHECK_DATA_IS_NSNULL(checkUpdate, NSString);
//    CHECK_STRING_IS_NULL(checkUpdate);
    
//    NSDictionary *dataDic = @{@"checkUpdate":checkUpdate};
    
    return [self requestPostWithParameters:dataDic
                                   ApiPath:k_getChatToken
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}


/*
 获取聊天室列表信息
 */
- (AFHTTPRequestOperation *)loadChatListSucccess:(SuccessData)success
                                         failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:nil
                                   ApiPath:k_loadChatList
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

/*
 手动分组的重置
 */
- (AFHTTPRequestOperation *)resetGroupWithPram:(NSDictionary *)dataDic
                                        succcess:(SuccessData)success
                                         failure:(ErrorData)failure
{
    NSString *token = [ConfigData sharedInstance].token;
    CHECK_STRING_IS_NULL(token);
    NSDictionary *header = @{@"Authentication":token};
    
    return [self requestPostWithParameters:dataDic
                                   ApiPath:k_resetGroup
                                WithHeader:header
                                   success:^(NSDictionary *result, NSDictionary *headers) {
                                       success(result);
                                   } failure:^(NSError *error) {
                                       failure(error);
                                   }];
}

@end
