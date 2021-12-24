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

// 当前选择的服务器
#define current_selected_service        @"current_selected_service"

// 产品列表
#define product_list                    @[@{@"type":@"3",\
@"title":@"BIM+智慧工地",\
@"image":@"product_zhgd",\
@"image_selected":@"product_zhgd_selected",\
@"address":@"https://building.bim-pm.com"},\
@{@"type":@"4",\
@"title":@"BIM+智慧物业",\
@"image":@"product_zhwy",\
@"image_selected":@"product_zhwy_selected",\
@"address":@"htps://property.bim-pm.com"},\
@{@"type":@"5",\
@"title":@"BIM+智慧园区",\
@"image":@"product_zhyq",\
@"image_selected":@"product_zhyq_selected",\
@"address":@"https://park.bim-pm.com"},\
@{@"type":@"1",\
@"title":@"企业云盘",\
@"image":@"product_qyyp",\
@"image_selected":@"product_qyyp_selected",\
@"address":@"https://cloud.bim-pm.com"},\
@{@"type":@"2",\
@"title":@"管理云平台",\
@"image":@"product_glypt",\
@"image_selected":@"product_glypt_selected",\
@"address":@"https://www.bim-pm.com"}]\

// 服务器地址
#define SERVICEADDRESS ([[TTProductManager defaultInstance] getCurrentProduc][@"address"])

// 用户登录相关接口
#define URI_SIGN_IN                             @"/bimpmservice/login/signIn"
#define URI_SIGN_UP                             @"/bimpmservice/login/signUp"
#define URI_SIGN_OUT                            @"/bimpmservice/login/signOut"
#define URI_SIGN_RESET                          @"/bimpmservice/login/signReset"
#define URI_VERIFY_CAPTCHA                      @"/bimpmservice/login/verifyByCaptcha"
#define URI_VERIFY_PHONE                        @"/bimpmservice/login/verifyByPhone"

// 获取IM的token
#define URL_CHAT_TOKEN                          @"/bimpmservice/user/UserChat"
// 用户基础信息
#define URL_USER_DETAIL                         @"/bimpmservice/user/UserDetail"

// 用户对项目操作
#define URL_USER_PROJECT_INFO                   @"/bimpmservice/user/UserToProjectInfo"
#define URL_USER_PROJECT_GANTT                  @"/bimpmservice/user/UserToProjectGantt"
#define URL_USER_PROJECT_LIST                   @"/bimpmservice/user/UserToProjectList"
#define URL_USER_PROJECT_DETAIL                 @"/bimpmservice/user/UserToProjectDetail"
#define URL_USER_PROJECT_OPERATIONS             @"/bimpmservice/user/UserToProjectOperations"

// 文件
#define URL_TARGET_LIST                         @"/bimpmservice/file/TargetList"
#define URL_TARGET_RENAME                       @"/bimpmservice/file/TargetRename"
#define URL_TARGET_OPERATIONS                   @"/bimpmservice/file/TargetOperations"
#define URL_TARGET_CLONE                        @"/bimpmservice/file/TargetClone"
#define URL_TARGET_NEW                          @"/bimpmservice/file/TargetNew"
#define URL_TARGET_UPDATE                       @"/bimpmservice/file/TargetUpdate"

// 团队成员
#define URL_DEPARTMENT_LIST                      @"/bimpmservice/department/DepartmentList"
#define URL_DEPARTMENT_DETAIL                    @"/bimpmservice/department/DepartmentDetail"
#define URL_PROJECTTOUSER_DETAIL                 @"/project/ProjectToUserDetail"

// 任务
#define URL_TASK_LIST                            @"/bimpmservice/task/TaskList"
#define URL_TASK_DETAIL                          @"/bimpmservice/task/TaskDetail"
#define URL_TASK_NEW                             @"/bimpmservice/task/TaskNew"
#define URL_TASK_EDIT                            @"/bimpmservice/task/TaskEdit"
#define URL_TASK_OPERATIONS                      @"/bimpmservice/task/TaskOperations"
#define URL_TASK_PROCESS                         @"/bimpmservice/task/TaskProcess"

// 文件
#define URL_UPLOAD_FILE      @"/fileviewservice/file/FileUpload"
#define URL_FILE_DOWNLOAD(uid_target)    [NSString stringWithFormat:@"/fileviewservice/FileDownload/%@",uid_target]

#define URL_FILE_View        @"/fileviewservice/FileView"


// 表单
#define URL_FORM_NEW             @"/bimpmservice/form/FormNew"
#define URL_FORM_DETAIL          @"/bimpmservice/form/FormDetail"
#define URL_FORM_EDIT            @"/bimpmservice/form/FormEdit"
#define URL_FORM_LIST            @"/bimpmservice/form/FormList"
#define URL_FORM_OPERATIONS      @"/bimpmservice/form/FormOperations"
#endif /* NetWorkInterface_h */
