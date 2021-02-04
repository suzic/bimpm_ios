//
//  NetWorkInterface.h
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#ifndef NetWorkInterface_h
#define NetWorkInterface_h

// 固定模版id
#define work_form_template_id           @"basicform-gzrb_43_105"
#define clock_form_template_id          @"basicform-rcdk_43_105"
#define roadwork_form_template_id       @"basicform-sgrz_37_104"
#define inspection_form_template_id     @"basicform-xjd_20_39_51_103_104"

// 切换服务器
#define UserDefaultsNetService          @"userDefaultsNetService"
// 当前选择的服务器 0 测试 1线上
#define SelectedService                 ([[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsNetService])

// 服务器地址
#if DEBUG
#define SERVICEADDRESS ({ \
NSString *service = @"https://www.bim-pm.com/bimpmservice"; \
if ([SelectedService isEqualToString:@"0"]) { \
    service =@"http://www.suzic.cn:8010"; \
}else if([SelectedService isEqualToString:@"1"]){ \
    service = @"https://www.bim-pm.com/bimpmservice"; \
} \
service; \
})
#else
#define SERVICEADDRESS  @"https://www.bim-pm.com/bimpmservice"
#endif

// 服务器地址
#if DEBUG
#define FILESERVICEADDRESS ({ \
NSString *fileService = @"https://www.bim-pm.com"; \
if ([SelectedService isEqualToString:@"0"]) { \
fileService =@"https://www.suzic.cn"; \
}else if([SelectedService isEqualToString:@"1"]){ \
fileService = @"https://www.bim-pm.com"; \
} \
fileService; \
})
#else
#define FILESERVICEADDRESS @"https://www.bim-pm.com"
#endif

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
#define URL_USER_PROJECT_DETAIL                 @"/user/UserToProjectDetail"
#define URL_USER_PROJECT_OPERATIONS             @"/user/UserToProjectOperations"

// 文件
#define URL_TARGET_LIST                         @"/file/TargetList"
#define URL_TARGET_RENAME                       @"/file/TargetRename"
#define URL_TARGET_OPERATIONS                   @"/file/TargetOperations"
#define URL_TARGET_CLONE                        @"/file/TargetClone"
#define URL_TARGET_NEW                          @"/file/TargetNew"
#define URL_TARGET_UPDATE                       @"/file/TargetUpdate"

// 团队成员
#define URL_DEPARTMENT_LIST                      @"/department/DepartmentList"
#define URL_DEPARTMENT_DETAIL                    @"/department/DepartmentDetail"
#define URL_PROJECTTOUSER_DETAIL                 @"/project/ProjectToUserDetail"

// 任务
#define URL_TASK_LIST                            @"/task/TaskList"
#define URL_TASK_DETAIL                          @"/task/TaskDetail"
#define URL_TASK_NEW                             @"/task/TaskNew"
#define URL_TASK_EDIT                            @"/task/TaskEdit"
#define URL_TASK_OPERATIONS                      @"/task/TaskOperations"
#define URL_TASK_PROCESS                         @"/task/TaskProcess"

// 文件
#define URL_UPLOAD_FILE      @"/fileviewservice/file/FileUpload"
#define URL_FILE_DOWNLOAD(uid_target)    [NSString stringWithFormat:@"/fileviewservice/FileDownload/%@",uid_target]

#define URL_FILE_View        @"/fileviewservice/FileView"


// 表单
#define URL_FORM_NEW             @"/form/FormNew"
#define URL_FORM_DETAIL          @"/form/FormDetail"
#define URL_FORM_EDIT            @"/form/FormEdit"
#define URL_FORM_LIST            @"/form/FormList"
#define URL_FORM_OPERATIONS      @"/form/FormOperations"
#endif /* NetWorkInterface_h */
