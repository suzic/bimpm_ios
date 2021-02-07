//
//  PollingViewController.m
//  TTManager
//
//  Created by chao liu on 2021/2/3.
//

#import "PollingViewController.h"
#import "TaskParams.h"

@interface PollingViewController ()<APIManagerParamSource,ApiManagerCallBackDelegate,FormFlowManagerDelgate>

@property (nonatomic, strong) APITaskNewManager *taskNewManager;
@property (nonatomic, strong) APITaskDeatilManager *taskDetailManager;
@property (nonatomic, strong) FormFlowManager *formFlowManager;

@property (nonatomic, strong) APITaskOperationsManager *taskOperationsManager;
@property (nonatomic, strong) APITaskProcessManager *taskProcessManager;
@property (nonatomic, strong) UploadFileManager *uploadManager;

@property (nonatomic, strong) TaskParams *taskParams;
@property (nonatomic, strong) ZHTask *currentTask;
/// 附件id
@property (nonatomic, copy) NSString *buddy_file;

@end

@implementation PollingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"巡检";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}

#pragma mark - private

- (void)loadData{
    [self.taskNewManager loadData];
}

#pragma mark - FormFlowManagerDelgate

#pragma mark - FormFlowManagerDelgate
// 刷新页面数据
- (void)reloadView{
}

// 获取表单详情成功
- (void)formDetailResult:(BOOL)success{
//    if (success == YES && self.isCloneForm == NO) {
//        [self.formFlowManager enterEditModel];
//        [self normalFillFormInfo];
//
//    }
}
// 表单克隆成功
- (void)formCloneTargetResult:(BOOL)success{
//    if (success == YES && self.isCloneForm == YES) {
//        [self.formFlowManager enterEditModel];
//        [self normalFillFormInfo];
//    }
}
// 表单下载成功
- (void)formDownLoadResult:(BOOL)success{
    
}

// 表单操作完成
- (void)formOperationsFillResult:(BOOL)success{
    
}

// 表单更新完成
- (void)targetUpdateResult:(BOOL)success{
    
//    [CNAlertView showWithTitle:@"温馨提示" message:@"编辑成功,是否返回" tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];
}

#pragma mark - APIManagerParamSource

- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    if (manager == self.taskNewManager) {
        params = [self.taskParams getNewTaskParams];
    }else if(manager == self.taskDetailManager){
        params = [self.taskParams getTaskDetailsParams];
    }
    return params;
}

#pragma mark - ApiManagerCallBackDelegate

- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.taskNewManager) {
        self.currentTask = (ZHTask *)manager.response.responseData;
        self.taskParams.uid_task = self.currentTask.uid_task;
        [self.taskDetailManager loadData];
    }
    else if(manager == self.taskDetailManager){
        self.currentTask = (ZHTask *)manager.response.responseData;
        self.formFlowManager.buddy_file = self.currentTask.firstTarget.uid_target;
        [self.formFlowManager cloneCurrentFormByBuddy_file];
    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    
}

#pragma mark - setter and getter

-(APITaskNewManager *)taskNewManager{
    if (_taskNewManager == nil) {
        _taskNewManager = [[APITaskNewManager alloc] init];
        _taskNewManager.delegate = self;
        _taskNewManager.paramSource = self;
    }
    return _taskNewManager;
}

-(APITaskDeatilManager *)taskDetailManager{
    if (_taskDetailManager == nil) {
        _taskDetailManager = [[APITaskDeatilManager alloc] init];
        _taskDetailManager.delegate = self;
        _taskDetailManager.paramSource = self;
    }
    return _taskDetailManager;
}

- (APITaskProcessManager *)taskProcessManager{
    if (_taskProcessManager == nil) {
        _taskProcessManager = [[APITaskProcessManager alloc] init];
        _taskProcessManager.delegate = self;
        _taskProcessManager.paramSource = self;
    }
    return _taskProcessManager;
}

- (APITaskOperationsManager *)taskOperationsManager{
    if (_taskOperationsManager == nil) {
        _taskOperationsManager = [[APITaskOperationsManager alloc] init];
        _taskOperationsManager.delegate = self;
        _taskOperationsManager.paramSource = self;
    }
    return _taskOperationsManager;
}

- (UploadFileManager *)uploadManager{
    if (_uploadManager == nil) {
        _uploadManager = [[UploadFileManager alloc] init];
    }
    return _uploadManager;
}

- (FormFlowManager *)formFlowManager{
    if (_formFlowManager == nil) {
        _formFlowManager = [[FormFlowManager alloc] init];
        _formFlowManager.delegate = self;
#warning 缺少一个文件id
//        _formFlowManager.buddy_file = self.buddy_file;
    }
    return _formFlowManager;
}

- (TaskParams *)taskParams{
    if (_taskParams == nil) {
        _taskParams = [[TaskParams alloc] init];
        _taskParams.id_flow_template = 5;
    }
    return _taskParams;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
