//
//  TaskManager.m
//  TTManager
//
//  Created by chao liu on 2021/2/12.
//

#import "TaskManager.h"

@interface TaskManager ()<APIManagerParamSource,ApiManagerCallBackDelegate>
// api
@property (nonatomic, strong) APITaskNewManager *taskNewManager;
@property (nonatomic, strong) APITaskEditManager *taskEditManager;
@property (nonatomic, strong) APITaskOperationsManager *taskOperationsManager;
@property (nonatomic, strong) APITaskProcessManager *taskProcessManager;
@property (nonatomic, strong) APITaskDeatilManager *taskDetailManager;
//@property (nonatomic, strong) UploadFileManager *uploadManager;
@property (nonatomic, strong) APIVerifyPhoneManager *verifyPhoneManager;

/// 当前请求类型
@property (nonatomic, assign) ApiTaskType apiTaskType;

@property (nonatomic, copy) RepealBlock block;

@end

@implementation TaskManager

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma api network
/// 新建任务
- (void)api_newTask:(NSDictionary *)params{
    self.apiTaskType = apiTaskType_new;
    [self.taskNewManager loadDataWithParams:params];
}
/// 获取任务详情
- (void)api_getTaskDetail:(NSDictionary *)params{
    self.apiTaskType = apiTaskType_detail;
    [self.taskDetailManager loadDataWithParams:params];
}

/// 编辑任务
- (void)api_editTask:(NSDictionary *)params{
    self.apiTaskType = apiTaskType_edit;
    [self.taskEditManager loadDataWithParams:params];
}
/// 任务操作
- (void)api_operationsTask:(NSDictionary *)params{
    self.apiTaskType = apiTaskType_operation;
    [self.taskOperationsManager loadDataWithParams:params];
}

/// 任务进度处理
- (void)api_processTask:(NSDictionary *)params{
    self.apiTaskType = apiTaskType_process;
    [self.taskProcessManager loadDataWithParams:params];
}

/// 终止任务发送验证码
- (void)api_suspendTask:(NSDictionary *)params{
    self.apiTaskType = apiTaskType_suspend;
}

/// 撤销任务附件(当前任务已经有附件了，需要再次上传附件，先撤销后上传)
- (void)api_repealTaskAdjunct:(NSDictionary *)params callBack:(RepealBlock)callBack
{
    self.block = [callBack copy];
    self.apiTaskType = apiTaskType_repeal;
    [self.taskOperationsManager loadDataWithParams:params];
}

/// 设置任务附件,如果不需要撤销附件 直接调用api_operationsTask效果一样
- (void)api_setTaskAdjunct:(NSDictionary *)params{
    self.apiTaskType = apiTaskType_set;
    [self.taskOperationsManager loadDataWithParams:params];
}

#pragma mark - set delegate
- (void)setDelegateResult:(BOOL)success data:(BaseApiManager *)manager{
    if (self.apiTaskType == apiTaskType_repeal) {
        if (self.block) {
            self.block(success);
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(callbackApiTaskSuccess:data:apiTaskType:)]) {
            [self.delegate callbackApiTaskSuccess:success data:manager apiTaskType:self.apiTaskType];
        }
    }
}

#pragma mark - APIManagerParamSource

- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = [NSDictionary dictionary];
    return params;
}

#pragma mark - ApiManagerCallBackDelegate

- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    [self setDelegateResult:YES data:manager];
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    [self setDelegateResult:NO data:manager];
}

#pragma mark - api init

- (APITaskProcessManager *)taskProcessManager{
    if (_taskProcessManager == nil) {
        _taskProcessManager = [[APITaskProcessManager alloc] init];
        _taskProcessManager.delegate = self;
        _taskProcessManager.paramSource = self;
    }
    return _taskProcessManager;
}

-(APITaskNewManager *)taskNewManager{
    if (_taskNewManager == nil) {
        _taskNewManager = [[APITaskNewManager alloc] init];
        _taskNewManager.delegate = self;
        _taskNewManager.paramSource = self;
    }
    return _taskNewManager;
}

- (APITaskEditManager *)taskEditManager{
    if (_taskEditManager == nil) {
        _taskEditManager = [[APITaskEditManager alloc] init];
        _taskEditManager.delegate = self;
        _taskEditManager.paramSource = self;
    }
    return _taskEditManager;
}

- (APITaskOperationsManager *)taskOperationsManager{
    if (_taskOperationsManager == nil) {
        _taskOperationsManager = [[APITaskOperationsManager alloc] init];
        _taskOperationsManager.delegate = self;
        _taskOperationsManager.paramSource = self;
    }
    return _taskOperationsManager;
}

-(APITaskDeatilManager *)taskDetailManager{
    if (_taskDetailManager == nil) {
        _taskDetailManager = [[APITaskDeatilManager alloc] init];
        _taskDetailManager.delegate = self;
        _taskDetailManager.paramSource = self;
    }
    return _taskDetailManager;
}

- (APIVerifyPhoneManager *)verifyPhoneManager{
    if (_verifyPhoneManager == nil) {
        _verifyPhoneManager = [[APIVerifyPhoneManager alloc] init];
        _verifyPhoneManager.delegate = self;
        _verifyPhoneManager.paramSource = self;
    }
    return _verifyPhoneManager;
}

//- (UploadFileManager *)uploadManager{
//    if (_uploadManager == nil) {
//        _uploadManager = [[UploadFileManager alloc] init];
//    }
//    return _uploadManager;
//}

@end
