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

@property (nonatomic, strong) ZHUser *selectUser;

@property (nonatomic, assign) BOOL lastStepUser;

@property (nonatomic, strong) NSIndexPath *deleteStepIndex;
// api
@property (nonatomic, strong) APITaskNewManager *taskNewManager;
@property (nonatomic, strong) APITaskEditManager *taskEditManager;
@property (nonatomic, strong) APITaskOperationsManager *taskOperationsManager;
@property (nonatomic, strong) APITaskProcessManager *taskProcessManager;
@property (nonatomic, strong) APITaskDeatilManager *taskDetailManager;

@end

@implementation TaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavbackItemAndTitle];
    
    [self addUI];
    
    [self setModuleViewOperabilityTools];
    
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
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButtonItem];
    self.navigationItem.rightBarButtonItem = rightItem;
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
- (void)deleteCurrentSelectedStepUser:(NSIndexPath *)indexPath{
    
    ZHUser *user;
    if (indexPath.section == 1) {
        user = self.operabilityTools.finishUser;
    }else{
        user = self.operabilityTools.stepArray[indexPath.row];
    }
    self.deleteStepIndex = indexPath;
    
    NSString *string = user.name;
    
    string  = [NSString stringWithFormat:@"确认删除 %@ ",string];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.taskParams.id_user = INT_32_TO_STRING(user.id_user);
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getToUserParams:NO]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Responder Chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if([eventName isEqualToString:selected_taskStep_user]){
        // 0 中间用户 ，1尾步骤
        NSString *addType = userInfo[@"addType"];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TeamController *team = (TeamController *)[sb instantiateViewControllerWithIdentifier:@"teamController"];
        team.selectedUserType = YES;
        team.selectUserBlock = ^(ZHUser * _Nonnull user) {
            NSLog(@"当前选择的用户==%@",user.name);
            self.selectUser = user;
            self.taskParams.id_user = INT_32_TO_STRING(user.id_user);
            if ([addType isEqualToString:@"0"])
            {
                if (self.taskType != task_type_new_polling) {
                    self.lastStepUser = YES;
                }else{
                    self.lastStepUser = NO;
                }
                [self.taskOperationsManager loadDataWithParams:[self.taskParams getToUserParams:YES]];
            }else if([addType isEqualToString:@"1"]){
                [self.taskOperationsManager loadDataWithParams:[self.taskParams getAssignUserParams]];
            }
        };
        [self.navigationController pushViewController:team animated:YES];
    }else if([eventName isEqualToString:choose_adjunct_file]){
        [self pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
            NSLog(@"当前选择的图片");
        }];
    }else if([eventName isEqualToString:select_caldenar_view]){
        NSLog(@"选择日期");
//        [self.calendarView showCalendarView:YES];
//        self.calendarView.defaultSelectedDate = @"2021-01-29";
        self.taskParams.planDate = userInfo[@"planDate"];
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskDatePlanParams]];
    
    }else if([eventName isEqualToString:selected_task_priority]){
        NSString *priority = userInfo[@"priority"];
        NSLog(@"当前选择的任务等级 %@",priority);
        [self.taskTitleView setTaskTitleStatusColor:[priority integerValue]];
        self.taskParams.priority = [priority integerValue];
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskPriorityParams]];
    }else if([eventName isEqualToString:change_task_title]){
        NSLog(@"修改当前的任务名称 == %@",userInfo[@"taskTitle"]);
        self.taskParams.name = userInfo[@"taskTitle"];
        [self.taskEditManager loadData];
    }else if([eventName isEqualToString:change_task_content]){
        NSLog(@"修改当前任务的任务内容 == %@",userInfo[@"taskContent"]);
        self.taskParams.memo = userInfo[@"taskContent"];
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getMemoParams]];
    }
    else if([eventName isEqualToString:longPress_delete_index]){
        [self deleteCurrentSelectedStepUser:userInfo[@"indexPath"]];
        NSLog(@"长按删除");
    }else if([eventName isEqualToString:open_document_library]){
        NSLog(@"打开文件库");
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"documentLibController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([eventName isEqualToString:selected_save_task]){
        NSLog(@"保存任务");
    }else if([eventName isEqualToString:task_send_toUser]){
        NSLog(@"发送当前任务");
        [self.taskProcessManager loadDataWithParams:[self.taskParams getProcessSubmitParams]];
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
    }
    return params;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.taskNewManager || manager == self.taskDetailManager) {
        self.operabilityTools.task = (ZHTask *)manager.response.responseData;
        [self setModuleViewOperabilityTools];
        [self setRequestParams:self.operabilityTools.task];
    }else if(manager == self.taskEditManager){
        
    }else if(manager == self.taskOperationsManager){
        NSDictionary *params = manager.response.requestParams[@"data"];
        if ([params[@"code"] isEqualToString:@"TO"]) {
            if ([params[@"param"] isEqualToString:@"1"]) {
                [self.operabilityTools changCurrentStepArray:self.selectUser to:!self.lastStepUser];
            }else if([params[@"param"] isEqualToString:@"0"]){
                [self.operabilityTools deleteStepAttayByIndexPath:self.deleteStepIndex];
            }
        }else if([params[@"code"] isEqualToString:@"ASSIGN"]){
            [self.operabilityTools changCurrentStepArray:self.selectUser to:YES];
        }
        self.stepView.tools = self.operabilityTools;
        self.taskOperationView.tools = self.operabilityTools;
    }else if(manager == self.taskProcessManager){
        NSDictionary *dic = (NSDictionary *)manager.response.responseData;
        NSDictionary *result = dic[@"data"][@"results"][0];
        if (![result[@"sub_code"] isEqualToNumber:@0]) {
            [SZAlert showInfo:result[@"msg"] underTitle:@"众和空间"];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发送任务成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self back];
            }];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.taskNewManager) {
        
    }else if(manager == self.taskDetailManager){
        
    }else if(manager == self.taskEditManager){
        
    }else if(manager == self.taskOperationsManager){
        
    }else if(manager == self.taskProcessManager){
        
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
