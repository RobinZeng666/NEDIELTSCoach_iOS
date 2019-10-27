//
//  Service.h
//  AFNetworkingTest
//
//  Created by Sidney on 14-7-10.
//  Copyright (c) 2014年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConfig.h"
#import "ConfigData.h"
#import "AFNetworking.h"

typedef void(^SuccessData)(NSDictionary *result);
typedef void(^ErrorData)( NSError *error);
@interface Service : NSObject

+ (instancetype)sharedInstance;
/**
 取消所有的网络请求
 */
- (void)cancelAllRequest;
/**
 登录
 */
- (AFHTTPRequestOperation *)appTeacherLoginWithEmail:(NSString *)email
                                            passWord:(NSString *)password
                                             success:(SuccessData)success
                                             failure:(ErrorData)failure;

/**
 *  课表
 */
- (AFHTTPRequestOperation *)getTeacherMonthLessonsForAppWithDateParam:(NSString *)dateParam
                                                              success:(SuccessData)success
                                                              failure:(ErrorData)failure;
/**
 *  我的消息
 */
- (AFHTTPRequestOperation *)loadMessagesWithPram:(NSDictionary *)dic
                                         success:(SuccessData)success
                                         failure:(ErrorData)failure;

/**
 *  所有消息未读数
 */
- (AFHTTPRequestOperation *)myAllMessageNoReadCountSuccess:(SuccessData)success
                                                   failure:(ErrorData)failure;

/**
 *  系统消息-消息列表
 */
- (AFHTTPRequestOperation *)myAllMessageNoReadWithPram:(NSDictionary *)dic
                                               success:(SuccessData)success
                                               failure:(ErrorData)failure;

/**
 *  获取教师的课次信息 生成课堂暗号
 */
- (AFHTTPRequestOperation *)getTeacherLessonAndPassCodeWithTeacherCode:(NSString *)sTeacherId
                                                              success:(SuccessData)success
                                                           failure:(ErrorData)failure;

// teacherCode=[教师Code]&
// passCode=[课堂暗号]&
// ccId=[课次主键ID]&
// nLessonNo=[课次号]
/**
 *  教师选择临近四节课堂的其中一节课后
 */
- (AFHTTPRequestOperation *)SaveActiveClassProWithTeacherCode:(NSString *)sTeacherId
                                                         ccId:(NSString *)ccId
                                                    nLessonNo:(NSNumber *)nLessonNo
                                                      success:(SuccessData)success
                                                    failure:(ErrorData)failure;

//教师端 或 学生端 每隔3秒向服务器发送在线的消息，获取最新在线学生列表 包括在线人数/总人数和各学生信息
//passCode=[课堂暗号] 
- (AFHTTPRequestOperation *)TeacherOrStudentGetStudentOnLinePassCode:(NSString *)passCode
                                                              RoleId:(NSString *)roleId
                                                             success:(SuccessData)success
                                                             failure:(ErrorData)failure;
//passCode=[课堂暗号]
// ccId=[课次主键ID]

- (AFHTTPRequestOperation *)ActiveClassExerciseListWithPassCode:(NSString *)passCode
                                                           ccId:(NSString *)ccId
                                                        success:(SuccessData)success
                                                        failure:(ErrorData)failure;



/**
 *  我的收藏
 */
- (AFHTTPRequestOperation *)myMaterialsFavoriteListWithPram:(NSDictionary *)dic
                                                    success:(SuccessData)success
                                                    failure:(ErrorData)failure;
/**
 *  删除我的收藏
 */
- (AFHTTPRequestOperation *)deleteMyMaterialsFavoriteWithPram:(NSDictionary *)dic
                                                     succcess:(SuccessData)success
                                                      failure:(ErrorData)failure;

/**
 *  班级课程列表
 */
- (AFHTTPRequestOperation *)loadClasses:(NSDictionary *)dic
                               succcess:(SuccessData)success
                                failure:(ErrorData)failure;

/**
 *  班级课次信息
 */
- (AFHTTPRequestOperation *)getLessonInfo:(NSDictionary *)dic
                               succcess:(SuccessData)success
                                failure:(ErrorData)failure;

/**
 *  班级学生信息
 */
- (AFHTTPRequestOperation *)getClassStusWithClassCode:(NSString *)classCode
                                             succcess:(SuccessData)success
                                              failure:(ErrorData)failure;


/**
 *  班级待批改信息
 */
- (AFHTTPRequestOperation *)getCorrectListWithclassCode:(NSString *)classCode
                                              pageIndex:(NSString *)pageIndex
                                               succcess:(SuccessData)success
                                                failure:(ErrorData)failure;


/**
 *作文批改 页面
 */
- (AFHTTPRequestOperation *)examCorrectingWithexamInfoId:(NSString *)examInfoId
                                                 paperId:(NSString *)paperId
                                               succcess:(SuccessData)success
                                                failure:(ErrorData)failure;

/**
 *口语模考批改 页面
 */

- (AFHTTPRequestOperation *)voiceCorrectingWithexamInfoId:(NSString *)examInfoId
                                                  paperId:(NSString *)paperId
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure;

/**
 *口语练习批改 页面
 */
- (AFHTTPRequestOperation *)contactCorrectingWithexamInfoId:(NSString *)examInfoId
                                                    paperId:(NSString *)paperId
                                                 succcess:(SuccessData)success
                                                  failure:(ErrorData)failure;

/**
 *口语/模考完成批改
 */
- (AFHTTPRequestOperation *)finishKyCorrectingWithDic:(NSDictionary *)dataDic
                                                   succcess:(SuccessData)success
                                                    failure:(ErrorData)failure;

/**
 *写作完成批改
 */
- (AFHTTPRequestOperation *)finishXzCorrectingWithDic:(NSDictionary *)dataDic
                                             succcess:(SuccessData)success
                                              failure:(ErrorData)failure;


/**
 *  班级练习信息
 */
- (AFHTTPRequestOperation *)getPapersInfoByIDWithId:(NSString *)ids
                                           succcess:(SuccessData)success
                                            failure:(ErrorData)failure;



/**
 *  获取班级任务列表
 */
- (AFHTTPRequestOperation *)loadTaskList:(NSDictionary *)ids
                                succcess:(SuccessData)success
                                 failure:(ErrorData)failure;


/**
 *  班级任务-获取资料信息
 */
- (AFHTTPRequestOperation *)getMaterialsInfoWithMateId:(NSString *)mateId
                                              succcess:(SuccessData)success
                                               failure:(ErrorData)failure;



/**
 *  班级任务-获取模考、练习信息
 */
- (AFHTTPRequestOperation *)getPapersInfo:(NSDictionary *)mateId
                                 succcess:(SuccessData)success
                                  failure:(ErrorData)failure;



/**
 *  学习 资料列表
 */
- (AFHTTPRequestOperation *)teacherMaterialsWithPram:(NSDictionary *)dic
                                            succcess:(SuccessData)success
                                             failure:(ErrorData)failure;


/**
 *  添加、取消收藏
 */
- (AFHTTPRequestOperation *)addOrCancelMaterialsFavoriteWithPram:(NSDictionary *)dic
                                                         success:(SuccessData)success
                                                         failure:(ErrorData)failure;

/**
 *  意见反馈
 */
- (AFHTTPRequestOperation *)addSuggestionInfoWithPram:(NSDictionary *)dic
                                              success:(SuccessData)success

                                              failure:(ErrorData)failure;
//paperNumber=[试卷编号]
// ccId=[课次主键ID]
/**
 *  添加课堂练习
 */
- (AFHTTPRequestOperation *)ActiveClassExerciseByPaperNumberWithPaperNumber:(NSString *)paperNumber
                                                                       ccId:(NSString *)ccId
                                                                    success:(SuccessData)success
                                                                    failure:(ErrorData)failure;


/**
 *  教师选题
 */
- (AFHTTPRequestOperation *)ActiveClassExerciseDetailWithPassCode:(NSString *)passCode
                                                              pId:(NSNumber *)pId
                                                          success:(SuccessData)success
                                                          failure:(ErrorData)failure;
// ccId=[课次Id]
// paperId=[试卷ID]

- (AFHTTPRequestOperation *)ActiveClassExerciseDeleteWithccId:(NSString *)ccId
                                                      paperId:(NSNumber *)paperId
                                                      success:(SuccessData)success
                                                      failure:(ErrorData)failure;

/**
 *  个人中心首页
 */
- (AFHTTPRequestOperation *)getTeacherInfoSuccess:(SuccessData)success
                                          failure:(ErrorData)failure;

/**
 *  学员成绩
 */
- (AFHTTPRequestOperation *)loadStuInfosByClassWithPram:(NSDictionary *)dic
                                                success:(SuccessData)success
                                                failure:(ErrorData)failure;

/**
 *  资料列表筛选
 */
- (AFHTTPRequestOperation *)teacherMaterialsFilterWithPram:(NSDictionary *)dic
                                                   success:(SuccessData)success
                                                   failure:(ErrorData)failure;



/**
 *  删除我的消息
 */
- (AFHTTPRequestOperation *)deleteMessageWithPram:(NSDictionary *)dic
                                          success:(SuccessData)success
                                          failure:(ErrorData)failure;

/**
 *  查看资料 增加查看次数
 */
- (AFHTTPRequestOperation *)addReadCountWithPram:(NSDictionary *)dic
                                         success:(SuccessData)success
                                         failure:(ErrorData)failure;

/**
 *  获取广告位信息
 */
- (AFHTTPRequestOperation *)loadAdvertisementsWithPram:(NSDictionary *)dic
                                               success:(SuccessData)success
                                               failure:(ErrorData)failure;

/**
 *  更新具体人员的系统消息阅读（或删除）状态
 */
- (AFHTTPRequestOperation *)readOrDelMessageWithPram:(NSDictionary *)dic
                                            succcess:(SuccessData)success
                                             failure:(ErrorData)failure;

///**
// *  更新任务完成
// */
//- (AFHTTPRequestOperation *)insertTaskFinishAndkeyID:(NSString *)keyid
//                                          examInfoId:(NSString *)examInfoId
//                                         SuccessData:(SuccessData)success
//                                           errorData:(ErrorData)errors;
/**
 *  教师端，保存教师选择的课堂练习试题 iphone、Android 教师App
 */
/**
 *  activeClassPaperInfoId=[课堂与随堂试卷的关系表Id]
  paperId=[试卷ID]
  qIds=[试题ID集合(以,隔开),不可为空]
 paperSubmitMode=[随堂练习提交方式 1整套提交2单题提交]&
  paperSubmitCountdown=[答题时间(分钟)/完成率(%)，传值时，不传递单位，只传递分钟/百分比的值]
 *
 */
- (AFHTTPRequestOperation *)ActiveClassExerciseChooseQuestionsWithInfoId:(NSNumber *)InfoId
                                                                 paperId:(NSNumber *)paperId
                                                                    qIds:(NSString *)qIds
                                                         paperSubmitMode:(NSString *)paperSubmitMode
                                                    paperSubmitCountdown:(NSString *)paperSubmitCountdown
                                                             SuccessData:(SuccessData)success
                                                               errorData:(ErrorData)errors;



/**
 *教师任务提醒
 */
- (AFHTTPRequestOperation *)remindTaskWithClassCode:(NSString *)classCode
                                            message:(NSString *)message
                                             taskID:(NSString *)taskId
                                         SuccessData:(SuccessData)success
                                           errorData:(ErrorData)errors;


/**
 *  获取视频信息
 */
- (AFHTTPRequestOperation *)lookVideoInfoWithPram:(NSDictionary *)dic
                                          success:(SuccessData)success
                                          failure:(ErrorData)failure;

/**
 *  ccId=[课次Id]&
  paperId=[试卷ID]&
  type=[类型，1开始/2结束]
 */
- (AFHTTPRequestOperation *)ActiveClassExerciseStartOrStopWithccId:(NSString *)ccId
                                                           paperId:(NSString *)paperId
                                                              type:(NSString *)type
                                                           success:(SuccessData)success
                                                           failure:(ErrorData)failure;
/**
 *  passCode=[课堂暗号]
 */
- (AFHTTPRequestOperation *)FinishActiveClassWithpassCode:(NSString *)passCode
                                                  success:(SuccessData)success
                                                  failure:(ErrorData)failure;
/**
 *  ccId=[课次Id]&
  paperId=[试卷Id]
 */

- (AFHTTPRequestOperation *)findWholeSubmitModeStudentExamMarkWithccId:(NSString *)ccId
                                                               paperId:(NSString *)paperId
                                                               success:(SuccessData)success
                                                               failure:(ErrorData)failure;
/**
 *  ccId=[课次Id]&
  paperId=[试卷Id]
 */
- (AFHTTPRequestOperation *)ActiveClassExerciseByPaperNumberSaveWithpaperId:(NSString *)paperId
                                                                       ccId:(NSString *)ccId
                                                                    success:(SuccessData)success
                                                                    failure:(ErrorData)failure;

/**
 *  修改昵称
 */
- (AFHTTPRequestOperation *)nickNameChangeWithPram:(NSDictionary *)dic
                                           success:(SuccessData)success
                                           failure:(ErrorData)failure;


/**
 *  整套提交报告
  ccId=[课次Id]&
  paperId=[试卷Id]
 */

- (AFHTTPRequestOperation *)findWholeSubmitModeStudentExerciseReportWithccId:(NSString *)ccId
                                                                     paperId:(NSString *)paperId
                                                                     success:(SuccessData)success
                                                                     failure:(ErrorData)failure;

/**
 *  APP退出系统
 */
- (AFHTTPRequestOperation *)AppLogoffUserWithPram:(NSDictionary *)dic
                                          success:(SuccessData)success
                                          failure:(ErrorData)failure;

/**
 *  修改个性签名
 */
- (AFHTTPRequestOperation *)signatureChangeWithPram:(NSDictionary *)dic
                                            success:(SuccessData)success
                                            failure:(ErrorData)failure;


/**
 *  单题提交的学生成绩单
 */
- (AFHTTPRequestOperation *)findSingleSubmitModeStudentExamMark:(NSString *)ccId
                                                         paperId:(NSString *)paperId
                                                         success:(SuccessData)success
                                                         failure:(ErrorData)failure;
/**
 *  单题提交的学生练习报告
 */
- (AFHTTPRequestOperation *)findSingleSubmitModeStudentExerciseReport:(NSString *)ccId
                                                             paperId:(NSString *)paperId
                                                             success:(SuccessData)success
                                                             failure:(ErrorData)failure;

- (AFHTTPRequestOperation *)TeacherSyncActiveClassWithpassCode:(NSString *)passCode
                                                   teacherCode:(NSString *)sTeacherId
                                                          ccId:(NSString *)ccId
                                                     nLessonNo:(NSString *)nLessonNo
                                                       success:(SuccessData)success
                                                       failure:(ErrorData)failure;

/**
 *  资料是否收藏
 */
- (AFHTTPRequestOperation *)checkCollectMaterialsWithPram:(NSDictionary *)dic
                                                 succcess:(SuccessData)success
                                                  failure:(ErrorData)failure;

/**
 *  视频资料查看
 */
- (AFHTTPRequestOperation *)lookUpVideoMaterialsWithPram:(NSDictionary *)dic
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure;

/**
 *  获取课堂分组信息
 */
- (AFHTTPRequestOperation *)loadActiveClassGroupWithPram:(NSDictionary *)dic
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure;
/**
 *  随机分组
 */
- (AFHTTPRequestOperation *)autoDivideIntoGroupsWithPram:(NSDictionary *)dic
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure;

/**
 *  手动分组
 */
- (AFHTTPRequestOperation *)handDivideIntoGroupsWithPram:(NSDictionary *)dic
                                                succcess:(SuccessData)success
                                                 failure:(ErrorData)failure;
/**
 *  确认分组
 */
- (AFHTTPRequestOperation *)confirmDiviceGroupWithPram:(NSDictionary *)dic
                                              succcess:(SuccessData)success
                                               failure:(ErrorData)failure;

/**
 *  手动分组获取未分组学生
 */
- (AFHTTPRequestOperation *)loadNoGroupStudentsWithPram:(NSDictionary *)dic
                                               succcess:(SuccessData)success
                                                failure:(ErrorData)failure;

/**
 *  获取课堂ID
 */
- (AFHTTPRequestOperation *)getIdByPassCodeWithPram:(NSDictionary *)dic
                                           succcess:(SuccessData)success
                                            failure:(ErrorData)failure;


/**
 *  放弃分组
 */
- (AFHTTPRequestOperation *)abandonDiviceGroupWithPram:(NSDictionary *)dic
                                              succcess:(SuccessData)success
                                               failure:(ErrorData)failure;

/*
   获取历史投票信息
 */
- (AFHTTPRequestOperation *)loadVoteHisInfoWithPram:(NSString *)activeClassId
                                           succcess:(SuccessData)success
                                            failure:(ErrorData)failure;

/*
   心跳汇总当前投票数据
 */
- (AFHTTPRequestOperation *)collectStuVotesWithPram:(NSString *)activeClassId
                                             voteId:(NSString *)voteId
                                           succcess:(SuccessData)success
                                            failure:(ErrorData)failure;

/*
   开始投票
 */
- (AFHTTPRequestOperation *)startVoteWithPram:(NSDictionary *)dataDic
                                     succcess:(SuccessData)success
                                      failure:(ErrorData)failure;


/*
   结束投票
 */
- (AFHTTPRequestOperation *)finishVoteWithPram:(NSString *)activeClassId
                                        voteId:(NSString *)voteId
                                     succcess:(SuccessData)success
                                      failure:(ErrorData)failure;

/*
 参与投票
 */
- (AFHTTPRequestOperation *)joinVoteWithPram:(NSDictionary *)dataDic
                                    succcess:(SuccessData)success
                                     failure:(ErrorData)failure;


/*
 获取聊天室Token
 */
- (AFHTTPRequestOperation *)getChatTokenWithPram:(NSDictionary *)dataDic
                                        succcess:(SuccessData)success
                                         failure:(ErrorData)failure;


/*
 获取聊天室列表信息
 */
- (AFHTTPRequestOperation *)loadChatListSucccess:(SuccessData)success
                                         failure:(ErrorData)failure;

/*
 手动分组的重置
 */
- (AFHTTPRequestOperation *)resetGroupWithPram:(NSDictionary *)dataDic
                                      succcess:(SuccessData)success
                                       failure:(ErrorData)failure;


@end
