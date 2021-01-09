//
//  NetWorkInterface.h
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#ifndef NetWorkInterface_h
#define NetWorkInterface_h
#define SERVICEADDRESS @"www.suzic.cn:8010"

// 用户登录相关接口
#define URI_SIGN_IN                             @"/login/signIn"
#define URI_SIGN_UP                             @"/login/signUp"
#define URI_SIGN_OUT                            @"/login/signOut"
#define URI_SIGN_RESET                          @"/login/signReset"
#define URI_VERIFY_CAPTCHA                      @"/login/verifyByCaptcha"
#define URI_VERIFY_PHONE                        @"/login/verifyByPhone"

// 获取IM的token
#define URL_CHAT_TOKEN                          @"/user/UserChat"
// 用户对项目操作
#define URL_USER_PROJECT_INFO                   @"/user/UserToProjectInfo"
#define URL_USER_PROJECT_GANTT                  @"/user/UserToProjectGantt"
#define URL_USER_PROJECT_LIST                   @"/user/UserToProjectList"

// 文件
#define URL_TARGET_LIST                         @"/file/TargetList"
#define URL_FILE_View                           @"/fileviewservice/FileView"

// 团队成员
#define URL_DEPARTMENT_LIST                      @"/department/DepartmentList"
#define URL_DEPARTMENT_DETAIL                    @"/department/DepartmentDetail"

// 任务
#define URL_TASK_LIST                            @"/task/TaskList"
#define URL_TASK_DETAIL                          @"/task/TaskDetail"
#define URL_TASK_NEW                             @"/task/TaskNew"
#define URL_TASK_EDIT                            @"/task/TaskEdit"
#define URL_TASK_OPERATIONS                      @"/task/TaskOperations"
#define URL_TASK_PROCESS                         @"/task/TaskProcess"

#endif /* NetWorkInterface_h */
