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
    // Do any additional setup after loading the view.
    [self setNavbackItemAndTitle];
    
    [self addUI];
    
    [self loadData];
}

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

// 设置组件的tools
- (void)setModuleViewOperabilityTools{
    self.stepView.tools = self.operabilityTools;
    self.taskTitleView.tools = self.operabilityTools;
    self.taskContentView.tools = self.operabilityTools;
    self.taskOperationView.tools = self.operabilityTools;
}
- (void)setRequestParams:(ZHTask *)task{
    self.taskParams.name = task.name;
    self.taskParams.info = task.info;
    self.taskParams.uid_task = task.uid_task;
}
#pragma mark - Responder Chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if([eventName isEqualToString:selected_taskStep_user])
    {
        // 1 中间用户 ，0尾步骤
        NSString *addType = userInfo[@"addType"];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TeamController *team = (TeamController *)[sb instantiateViewControllerWithIdentifier:@"teamController"];
        team.selectedUserType = YES;
        team.selectUserBlock = ^(ZHUser * _Nonnull user) {
            NSLog(@"当前选择的用户==%@",user.name);
            self.taskParams.id_user = INT_32_TO_STRING(user.id_user);
            if ([addType isEqualToString:TO])
            {
                [self.taskOperationsManager loadDataWithParams:[self.taskParams getToUserParams:YES]];
            }else if([addType isEqualToString:ASSIGN]){
                self.taskParams.uid_step = userInfo[@"uid_step"];
                [self.taskOperationsManager loadDataWithParams:[self.taskParams getAssignUserParams]];
            }
        };
        [self.navigationController pushViewController:team animated:YES];
    }
    else if([eventName isEqualToString:choose_adjunct_file])
    {
        NSString *type = userInfo[@"adjunctType"];
        NSString *uid_target = userInfo[@"uid_target"];
        self.taskParams.uid_target = uid_target;
        if ([type isEqualToString:@"1"]) {
            NSLog(@"添加附加");
            [self pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
                NSLog(@"当前选择的图片");
                [self.uploadFileManager.uploadArray removeAllObjects];
                [self.uploadFileManager.uploadArray addObject:imageData];
                [self.uploadFileManager loadData];
                //  需要现fileUpload之后再 提交
//                [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskFileParams:YES]];
            }];
        }else if([type isEqualToString:@"2"]){
            NSLog(@"查看附加");
        }else if([type isEqualToString:@"4"]){
            NSLog(@"删除附件");
            [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskFileParams:NO]];
        }
    }
    else if([eventName isEqualToString:select_caldenar_view])
    {
        NSLog(@"选择日期");
        self.taskParams.planDate = userInfo[@"planDate"];
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskDatePlanParams]];
    
    }
    else if([eventName isEqualToString:selected_task_priority])
    {
        NSString *priority = userInfo[@"priority"];
        NSLog(@"当前选择的任务等级 %@",priority);
        [self.taskTitleView setTaskTitleStatusColor:[priority integerValue]];
        self.taskParams.priority = [priority integerValue];
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskPriorityParams]];
    }else if([eventName isEqualToString:change_task_title])
    {
        NSLog(@"修改当前的任务名称 == %@",userInfo[@"taskTitle"]);
        self.taskParams.name = userInfo[@"taskTitle"];
        [self.taskEditManager loadData];
    }else if([eventName isEqualToString:change_task_content])
    {
        NSLog(@"修改当前任务的任务内容 == %@",userInfo[@"taskContent"]);
        self.taskParams.memo = userInfo[@"taskContent"];
        if (self.taskType != task_type_detail_initiate) {
            [self.taskOperationsManager loadDataWithParams:[self.taskParams getMemoParams]];
        }
    }else if([eventName isEqualToString:open_document_library]){
        NSLog(@"打开文件库");
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"documentLibController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([eventName isEqualToString:task_process_submit]){
        NSString *operation = userInfo[@"operation"];
        if ([operation isEqualToString:@"0"]) {
            NSLog(@"发送任务");
            self.taskParams.submitParams = @"1";
        }else{
            self.taskParams.submitParams = operation;
            NSLog(@"处理任务进度");
        }
        [self.taskProcessManager loadDataWithParams:[self.taskParams getProcessSubmitParams]];
    }else if([eventName isEqualToString:task_send_toUser]){
        NSLog(@"发送当前任务");
        self.taskParams.submitParams = @"1";
        [self.taskProcessManager loadDataWithParams:[self.taskParams getProcessSubmitParams]];
    }else if([eventName isEqualToString:current_selected_step]){
        NSLog(@"改变当前选中的步骤");
        self.operabilityTools.currentSelectedStep = userInfo[@"step"];
        self.taskContentView.tools = self.operabilityTools;
        self.taskOperationView.tools = self.operabilityTools;
    }else if([eventName isEqualToString:task_click_save]){
        NSLog(@"点击了保存操作");
    }
}

#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    if (manager == self.taskNewManager) {
        params = [self.taskParams getNewTaskParams];
    }else if(manager == self.taskDetailManager){
        params = [self.taskParams getTaskDetailsParams];
    }else if(manager == self.taskEditManager){
        params = [self.taskParams getTaskEditParams];
    }else if(manager == self.taskOperationsManager){
        params = @{@"id_task":self.id_task,
                   @"code":@"",
                   @"param":@"",
                   @"info":@""};
    }else if(manager == self.taskProcessManager){
        params = @{@"task_list":@[self.id_task],
                   @"code":@"",
                   @"param":@"",
                   @"info":@""};
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
        [self.taskDetailManager loadData];
    }else if(manager == self.taskDetailManager){
        ZHTask *task = (ZHTask *)manager.response.responseData;
        self.operabilityTools.task = task;
        [self setRequestParams:self.operabilityTools.task];
        [self setModuleViewOperabilityTools];
    }
    else if(manager == self.taskEditManager){
        
    }else if(manager == self.taskOperationsManager){
        [self.taskDetailManager loadData];
    }else if(manager == self.taskProcessManager){
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
    }else if(manager == self.uploadFileManager){
        NSLog(@"上传结果%@",manager.response.responseData);
        NSDictionary *dic = (NSDictionary *)manager.response.responseData;
        
        ZHProject *project = [DataManager defaultInstance].currentProject;
        
        NSString *uid_target = dic[@"data"][@"uid_target"];
        self.taskParams.uid_target = uid_target;
        NSDictionary *params =@{@"target_info":@{@"uid_target":uid_target,@"id_module":@"0",@"is_file":@"1",
                                                 @"access_mode":@"0",@"name":[SZUtil getGUID],@"fid_project":INT_32_TO_STRING(project.id_project)}};
        [self.targetNewManager loadDataWithParams:params];
    }else if(manager == self.targetNewManager){
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
        NSLog(@"上传结果%@",manager.response.responseData);
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
    
//    self.stepView.stepArray = self.stepArray;

//    self.taskContentView.priorityType = priority_type_highGrade;
}
- (IBAction)closeVCAction:(id)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
