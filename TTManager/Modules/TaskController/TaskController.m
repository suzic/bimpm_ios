//
//  TaskController.m
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import "TaskController.h"
#import "TaskStepView.h"
#import "TaskOperationView.h"
#import "TaskTitleView.h"
#import "TaskContentView.h"
#import "TeamController.h"
#import "TaskParams.h"
#import "OperabilityTools.h"
#import "PopViewController.h"
#import "DocumentLibController.h"

@interface TaskController ()<APIManagerParamSource,ApiManagerCallBackDelegate,PopViewSelectedIndexDelegate,UIPopoverPresentationControllerDelegate>

@property (nonatomic,strong) UIButton *rightButtonItem;
// 任务步骤
@property (nonatomic, strong) TaskStepView *stepView;
// 任务名称
@property (nonatomic, strong) TaskTitleView *taskTitleView;
// 任务内容
@property (nonatomic, strong) TaskContentView *taskContentView;
// 任务操作页面
@property (nonatomic, strong) TaskOperationView *taskOperationView;

@property (nonatomic, strong) OperabilityTools *operabilityTools;

@property (nonatomic, strong) TaskParams *taskParams;

// Responder Chain事件处理
@property (nonatomic, strong) NSDictionary<NSString *, NSInvocation *> *eventStrategy;

// api
@property (nonatomic, strong) APITaskNewManager *taskNewManager;
@property (nonatomic, strong) APITaskEditManager *taskEditManager;
@property (nonatomic, strong) APITaskOperationsManager *taskOperationsManager;
@property (nonatomic, strong) APITaskProcessManager *taskProcessManager;
@property (nonatomic, strong) APITaskDeatilManager *taskDetailManager;
@property (nonatomic, strong) APIUploadFileManager *uploadFileManager;
@property (nonatomic, strong) APITargetNewManager *targetNewManager;

@end

@implementation TaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbackItemAndTitle];
    [self addUI];
    [self loadData];
}

#pragma mark - api
- (void)loadData{
    if (self.operabilityTools.isDetails) {
        [self.taskDetailManager loadData];
    }else{
        [self.taskNewManager loadData];
    }
}
#pragma mark - private method
- (void)setNavbackItemAndTitle{
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title = (self.operabilityTools.isDetails ? @"任务详情":@"新任务");
    if (self.taskType == task_type_detail_initiate) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButtonItem];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}
- (void)back{
    if (self.operabilityTools.isDetails == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)showMenu:(UIButton *)rightBarItem{
    PopViewController *menuView = [[PopViewController alloc] init];
    menuView.delegate = self;
    menuView.view.alpha = 1.0;
    menuView.dataList = @[@"召回",@"终止"];
    menuView.modalPresentationStyle = UIModalPresentationPopover;
    menuView.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    menuView.popoverPresentationController.delegate = self;
    menuView.popoverPresentationController.sourceView = rightBarItem;
    menuView.popoverPresentationController.sourceRect = CGRectMake(rightBarItem.frame.origin.x, rightBarItem.frame.origin.y+20, 0, 0);
    [self presentViewController:menuView animated:YES completion:nil];
}
// 设置view的tools
- (void)setModuleViewOperabilityTools{
    self.stepView.tools = self.operabilityTools;
    self.taskTitleView.tools = self.operabilityTools;
    self.taskContentView.tools = self.operabilityTools;
    self.taskOperationView.tools = self.operabilityTools;
}
// 设置请求参数
- (void)setRequestParams:(ZHTask *)task{
    self.taskParams.name = task.name;
    self.taskParams.info = task.info;
    self.taskParams.uid_task = task.uid_task;
}

- (IBAction)closeVCAction:(id)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 添加或者取消步骤负责人
- (void)addUserToStep:(NSDictionary *)addStepDic{
    // 0尾步骤 ,1中间用户
    NSString *stepUserLoc = addStepDic[@"addType"];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TeamController *team = (TeamController *)[sb instantiateViewControllerWithIdentifier:@"teamController"];
    team.selectedUserType = YES;
    team.selectUserBlock = ^(ZHUser * _Nonnull user) {
        NSLog(@"当前选择的用户==%@",user.name);
        self.taskParams.id_user = INT_32_TO_STRING(user.id_user);
        
        if ([stepUserLoc isEqualToString:TO]){
            [self.taskOperationsManager loadDataWithParams:[self.taskParams getToUserParams:YES]];
        }else if([stepUserLoc isEqualToString:ASSIGN]){
            self.taskParams.uid_step = addStepDic[@"uid_step"];
            [self.taskOperationsManager loadDataWithParams:[self.taskParams getAssignUserParams]];
        }
    };
    
    [self.navigationController pushViewController:team animated:YES];
}
// 添加附件到当前步骤
- (void)addFileToCurrentStep:(NSDictionary *)addFileDic{
    NSString *type = addFileDic[@"adjunctType"];
    NSString *uid_target = addFileDic[@"uid_target"];
    self.taskParams.uid_target = uid_target;
    // 1添加附件（相册和文件库），2删除附件 ，4查看附件
    if ([type isEqualToString:@"1"]) {
        NSLog(@"添加附加");
        [self pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
            NSLog(@"当前选择的图片");
            [self.uploadFileManager.uploadArray removeAllObjects];
            [self.uploadFileManager.uploadArray addObject:imageData];
            [self.uploadFileManager loadData];
        }];
    }
    else if([type isEqualToString:@"2"]){
        NSLog(@"查看附加");
    }
    else if([type isEqualToString:@"4"]){
        NSLog(@"删除附件");
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskFileParams:NO]];
    }
}
// 设置当前步骤或者任务预计完成时间
- (void)setStepPlanTimeToTask:(NSDictionary *)planTimeDic{
    self.taskParams.planDate = planTimeDic[@"planDate"];
    [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskDatePlanParams]];
}
// 修改任务优先级
- (void)alterFlowPriorityToFlow:(NSDictionary *)priorityDic{
    NSString *priority = priorityDic[@"priority"];
    NSLog(@"当前选择的任务等级 %@",priority);
    [self.taskTitleView setTaskTitleStatusColor:[priority integerValue]];
    self.taskParams.priority = [priority integerValue];
    [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskPriorityParams]];
}
- (void)alterTaskTitleToTask:(NSDictionary *)taskTitleDic{
    NSLog(@"修改当前的任务名称 == %@",taskTitleDic[@"taskTitle"]);
    self.taskParams.name = taskTitleDic[@"taskTitle"];
    [self.taskEditManager loadData];
}
// 修改文本内容（步骤、任务、终止、召回填写的的信息）
- (void)alterContentTextToTask:(NSDictionary *)contentDic{
    NSLog(@"修改当前任务的任务内容 == %@",contentDic[@"taskContent"]);
    self.taskParams.memo = contentDic[@"taskContent"];
    if (self.taskType != task_type_detail_initiate) {
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getMemoParams]];
    }
}
// 打开文件库
- (void)openDocumentLibView:(NSDictionary *)documentDic{
    NSLog(@"打开文件库");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DocumentLibController *vc = (DocumentLibController *)[sb instantiateViewControllerWithIdentifier:@"documentLibController"];
    vc.chooseTargetFile = YES;
    vc.targetBlock = ^(ZHTarget * _Nonnull target) {
        self.taskParams.uid_task = target.uid_target;
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskFileParams:YES]];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
// 底部栏按钮操作事件
- (void)bottomToolsOperabilityEvent:(NSDictionary *)eventDic{
    NSString *operation = eventDic[@"operation"];
    if ([operation isEqualToString:@"0"]) {
        NSLog(@"发送任务");
        self.taskParams.submitParams = @"1";
    }else{
        self.taskParams.submitParams = operation;
        NSLog(@"处理任务进度");
    }
    [self.taskProcessManager loadDataWithParams:[self.taskParams getProcessSubmitParams]];
}
// 发送当前任务
- (void)sengCurrentTask:(NSDictionary *)taskDic{
    NSLog(@"发送当前任务");
    self.taskParams.submitParams = @"1";
    [self.taskProcessManager loadDataWithParams:[self.taskParams getProcessSubmitParams]];
}
// 改变当前选中的步骤
- (void)changeCurrentSelectedStepUser:(NSDictionary *)stepUserDic{
    NSLog(@"改变当前选中的步骤");
    self.operabilityTools.currentSelectedStep = stepUserDic[@"step"];
    self.taskContentView.tools = self.operabilityTools;
    self.taskOperationView.tools = self.operabilityTools;
}
// 修改内容后点击保存
- (void)alterContentTexOrTaskTitletSave:(NSDictionary *)alterDic{
    NSLog(@"点击了保存操作");
}

#pragma mark - Responder Chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    NSInvocation *invocation = self.eventStrategy[eventName];
    [invocation setArgument:&userInfo atIndex:2];
    [invocation invoke];
//    if([eventName isEqualToString:selected_taskStep_user]){
////        [self addUserToStep:userInfo];
//    }else if([eventName isEqualToString:choose_adjunct_file]){
//        [self addFileToCurrentStep:userInfo];
//    }else if([eventName isEqualToString:select_caldenar_view]){
//        [self setStepPlanTimeToTask:userInfo];
//    }else if([eventName isEqualToString:selected_task_priority]){
//        [self alterFlowPriorityToFlow:userInfo];
//    }else if([eventName isEqualToString:change_task_title]){
//        [self alterTaskTitleToTask:userInfo];
//    }else if([eventName isEqualToString:change_task_content]){
//        [self alterContentTextToTask:userInfo];
//    }else if([eventName isEqualToString:open_document_library])
//    {
//        [self openDocumentLibView:userInfo];
//    }else if([eventName isEqualToString:task_process_submit]){
//        [self bottomToolsOperabilityEvent:userInfo];
//    }else if([eventName isEqualToString:task_send_toUser]){
//        [self sengCurrentTask:userInfo];
//    }else if([eventName isEqualToString:current_selected_step])
//    {
//        [self changeCurrentSelectedStepUser:userInfo];
//    }else if([eventName isEqualToString:task_click_save]){
//        [self alterContentTexOrTaskTitletSave:userInfo];
//    }
}

#pragma mark - APIManagerParamSource

- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    if (manager == self.taskNewManager) {
        params = [self.taskParams getNewTaskParams];
    }else if(manager == self.taskDetailManager){
        params = [self.taskParams getTaskDetailsParams];
    }else if(manager == self.uploadFileManager){
        ZHProject *project = [DataManager defaultInstance].currentProject;
        params = @{@"id_project":INT_32_TO_STRING(project.id_project)};
    }else if(manager == self.targetNewManager){
        ZHProject *project = [DataManager defaultInstance].currentProject;
        params =@{@"target_info":@{@"uid_target":@"8ec57e4f03ca4df2b26e9f9653e6ce46",@"id_module":@"0",@"is_file":@"1",
                                   @"access_mode":@"0",@"name":@"测试图片",@"fid_project":INT_32_TO_STRING(project.id_project)}
        };
    }
    return params;
}
#pragma mark - ApiManagerCallBackDelegate

- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.taskNewManager) {
        ZHTask *task = (ZHTask *)manager.response.responseData;
        self.taskParams.uid_task = task.uid_task;
        if (![SZUtil isEmptyOrNull:self.to_uid_user]) {
            self.taskParams.id_user = self.to_uid_user;
            [self.taskOperationsManager loadDataWithParams:[self.taskParams getToUserParams:YES]];
        }else{
            [self.taskDetailManager loadData];
        }
    }
    else if(manager == self.taskDetailManager){
        ZHTask *task = (ZHTask *)manager.response.responseData;
        self.operabilityTools.task = task;
        [self setRequestParams:self.operabilityTools.task];
        [self setModuleViewOperabilityTools];
    }
    else if(manager == self.taskEditManager){
        
    }
    else if(manager == self.taskOperationsManager){
        [self.taskDetailManager loadData];
    }
    else if(manager == self.taskProcessManager){
        NSDictionary *dic = (NSDictionary *)manager.response.responseData;
        NSDictionary *result = dic[@"data"][@"results"][0];
        if (![result[@"sub_code"] isEqualToNumber:@0]) {
            [SZAlert showInfo:result[@"msg"] underTitle:@"众和空间"];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self back];
            }];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if(manager == self.uploadFileManager){
        NSLog(@"上传结果%@",manager.response.responseData);
        NSDictionary *dic = (NSDictionary *)manager.response.responseData;
        
        ZHProject *project = [DataManager defaultInstance].currentProject;
        
        NSString *uid_target = dic[@"data"][@"uid_target"];
        self.taskParams.uid_target = uid_target;
        NSDictionary *params =@{@"target_info":@{@"uid_target":uid_target,@"id_module":@"0",@"is_file":@"1",
                                                 @"access_mode":@"0",@"name":[SZUtil getGUID],@"fid_project":INT_32_TO_STRING(project.id_project)}};
        [self.targetNewManager loadDataWithParams:params];
    }
    else if(manager == self.targetNewManager){
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskFileParams:YES]];
    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.taskNewManager) {
    }else if(manager == self.taskDetailManager){
    }else if(manager == self.taskEditManager){
    }else if(manager == self.taskOperationsManager){
    }else if(manager == self.taskProcessManager){
    }else if(manager == self.uploadFileManager){
    }else if(manager == self.targetNewManager){
    }
}

#pragma mark - PopViewSelectedIndexDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}
- (void)popViewControllerSelectedCellIndexContent:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.taskProcessManager loadDataWithParams:[self.taskParams getProcessRecallParams]];
    }else{
        [self.taskProcessManager loadDataWithParams:[self.taskParams getProcessTerminateParams]];
    }
}
#pragma mark - setting and getter
- (void)setTaskType:(TaskType)taskType{
    if (_taskType != taskType) {
        _taskType = taskType;
        self.operabilityTools = [[OperabilityTools alloc] initWithType:_taskType];
    }
}

- (TaskStepView *)stepView{
    if (_stepView == nil) {
        _stepView = [[TaskStepView alloc] init];
    }
    return _stepView;
}

- (TaskOperationView *)taskOperationView{
    if (_taskOperationView == nil) {
        _taskOperationView = [[TaskOperationView alloc] init];
    }
    return _taskOperationView;
}
- (TaskTitleView *)taskTitleView{
    if (_taskTitleView == nil) {
        _taskTitleView = [[TaskTitleView alloc] init];
    }
    return _taskTitleView;
}
- (TaskContentView *)taskContentView{
    if (_taskContentView == nil) {
        _taskContentView = [[TaskContentView alloc] init];
    }
    return _taskContentView;
}

- (TaskParams *)taskParams{
    if (_taskParams == nil) {
        _taskParams = [[TaskParams alloc] init];
        _taskParams.id_flow_template = self.taskType;
        _taskParams.uid_task = self.id_task;
        _taskParams.type = self.taskType;
    }
    return _taskParams;
}
- (UIButton *)rightButtonItem{
    if (_rightButtonItem == nil) {
        _rightButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButtonItem setImage:[UIImage imageNamed:@"task_more"] forState:UIControlStateNormal];
        _rightButtonItem.frame = CGRectMake(0, 0, 20, 20);
        [_rightButtonItem addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButtonItem;
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
- (APIUploadFileManager *)uploadFileManager{
    if (_uploadFileManager == nil) {
        _uploadFileManager = [[APIUploadFileManager alloc] init];
        _uploadFileManager.delegate = self;
        _uploadFileManager.paramSource = self;
    }
    return _uploadFileManager;
}
- (APITargetNewManager *)targetNewManager{
    if (_targetNewManager == nil) {
        _targetNewManager = [[APITargetNewManager alloc] init];
        _targetNewManager.delegate = self;
        _targetNewManager.paramSource = self;
    }
    return _targetNewManager;
}
- (NSDictionary<NSString *,NSInvocation *> *)eventStrategy{
    if (_eventStrategy == nil) {
        _eventStrategy = @{
            selected_taskStep_user:[self createInvocationWithSelector:@selector(addUserToStep:)],
            choose_adjunct_file:[self createInvocationWithSelector:@selector(addFileToCurrentStep:)],
            select_caldenar_view:[self createInvocationWithSelector:@selector(setStepPlanTimeToTask:)],
            selected_task_priority:[self createInvocationWithSelector:@selector(alterFlowPriorityToFlow:)],
            change_task_title:[self createInvocationWithSelector:@selector(alterTaskTitleToTask:)],
            change_task_content:[self createInvocationWithSelector:@selector(alterContentTextToTask:)],
            open_document_library:[self createInvocationWithSelector:@selector(openDocumentLibView:)],
            task_process_submit:[self createInvocationWithSelector:@selector(bottomToolsOperabilityEvent:)],
            task_send_toUser:[self createInvocationWithSelector:@selector(sengCurrentTask:)],
            current_selected_step:[self createInvocationWithSelector:@selector(changeCurrentSelectedStepUser:)],
            task_click_save:[self createInvocationWithSelector:@selector(alterContentTexOrTaskTitletSave:)]
        };
    }
    return _eventStrategy;
}
// 消息转发 NSInvocation中保存了方法所属的对象/方法名称/参数/返回值
- (NSInvocation *)createInvocationWithSelector:(SEL)sel{
    NSMethodSignature  *signature = [TaskController instanceMethodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = sel;
    // target 0 selector 1 参数2 返回值 3
//    [invocation setArgument:&way atIndex:2];
    return invocation;
}
#pragma mark - UI
- (void)addUI{
    // 步骤
    [self.view addSubview:self.stepView];
    // 任务名称
    [self.view addSubview:self.taskTitleView];
    // 任务内容
    [self.view addSubview:self.taskContentView];
    // 底部操作栏
    [self.view addSubview:self.taskOperationView];
    
    [self.stepView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
        make.left.right.equalTo(0);
        make.height.equalTo(itemHeight);
    }];
    [self.taskTitleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.stepView.mas_bottom).offset(25);
    }];
    [self.taskContentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskTitleView.mas_bottom);
        make.left.right.equalTo(0);
    }];
    [self.taskOperationView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskContentView.mas_bottom);
        make.left.right.equalTo(0);
        make.bottom.equalTo(-SafeAreaBottomHeight);
        make.height.equalTo(88);
    }];
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
