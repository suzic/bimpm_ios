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
#import "UploadFileManager.h"
#import "WebController.h"
#import "FormDetailController.h"
#import "PollingFormView.h"
#import "TaskManager.h"

@interface TaskController ()<PopViewSelectedIndexDelegate,UIPopoverPresentationControllerDelegate,UITextFieldDelegate,TaskApiDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *rightButtonItem;
// 任务步骤
@property (nonatomic, strong) TaskStepView *stepView;
// 任务名称
@property (nonatomic, strong) TaskTitleView *taskTitleView;
// 任务内容
@property (nonatomic, strong) TaskContentView *taskContentView;
// 巡检表单
@property (nonatomic, strong) PollingFormView *pollingFormView;

// 任务操作页面
@property (nonatomic, strong) TaskOperationView *taskOperationView;

@property (nonatomic, strong) OperabilityTools *operabilityTools;

@property (nonatomic, strong) TaskParams *taskParams;

// Responder Chain事件处理
@property (nonatomic, strong) NSDictionary<NSString *, NSInvocation *> *eventStrategy;

@property (nonatomic, strong) UploadFileManager *uploadManager;

@property (nonatomic, strong) TaskManager *taskManager;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation TaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeImagePicker];
    self.actionSheetType = 1;
    [self setNavbackItemAndTitle];
    [self addUI];
    [self isTaskType:self.taskType];
    [self loadData];
}
#pragma mark - api
- (void)loadData{
    if (self.operabilityTools.isDetails) {
        [self.taskManager api_getTaskDetail:[self.taskParams getTaskDetailsParams]];
    }else{
        [self.taskManager api_newTask:[self.taskParams getNewTaskParams]];
    }
}

#pragma mark - private method

- (void)setNavbackItemAndTitle{
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title = (self.operabilityTools.isDetails ? @"任务详情":@"新任务");
    if (self.operabilityTools.isDetails == YES) {
        if (self.taskType == task_type_detail_draft || self.taskType == task_type_detail_initiate) {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButtonItem];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
    }else{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButtonItem];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)back{
    
    if (self.taskType == task_type_new_polling ||self.isPolling == YES) {
        if (self.pollingFormView.isModification == YES) {
            [CNAlertView showWithTitle:@"是否保存当前修改" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self.pollingFormView saveForm:^(BOOL success) {
                        [self backViewVC];
                    }];
                }
            }];
        }
        else{
            [self backViewVC];
        }
    }else{
        [self backViewVC];
    }
}

- (void)backViewVC{
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //present方式
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }

}

- (void)showMenu:(UIButton *)rightBarItem{
    PopViewController *menuView = [[PopViewController alloc] init];
    menuView.delegate = self;
    menuView.view.alpha = 1.0;
    NSArray *array = @[];
    if (self.operabilityTools.isDetails == YES) {
        if (self.taskType == task_type_detail_draft) {
            array = @[@"召回"];
        }else{
            array = @[@"召回",@"终止"];
        }
    }else{
        if (self.taskType != task_type_detail_finished) {
            array = @[@"召回",@"终止"];
        }
    }
    menuView.dataList = array;
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
    self.pollingFormView.tools = self.operabilityTools;
}

// 设置请求参数
- (void)setRequestParams:(ZHTask *)task{
    self.taskParams.name = task.name;
    if (self.operabilityTools.currentSelectedStep != nil) {
        self.taskParams.memo = self.operabilityTools.currentSelectedStep.memo;
    }else{
        self.taskParams.memo = self.operabilityTools.task.memo;
    }
    self.taskParams.info = task.info;
    self.taskParams.uid_task = task.uid_task;
}

// 返回
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
    NSIndexPath *indexPath = addStepDic[@"indexPath"];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TeamController *team = (TeamController *)[sb instantiateViewControllerWithIdentifier:@"teamController"];
    team.selectedUserType = YES;
    team.selectUserBlock = ^(ZHUser * _Nonnull user) {
        NSLog(@"当前选择的用户==%@",user.name);
        self.taskParams.id_user = INT_32_TO_STRING(user.id_user);
        
        if ([stepUserLoc isEqualToString:TO]){
            [self.taskManager api_operationsTask:[self.taskParams getToUserParams:YES]];
        }else if([stepUserLoc isEqualToString:ASSIGN]){
            self.taskParams.uid_step = addStepDic[@"uid_step"];
            [self.taskManager api_operationsTask:[self.taskParams getAssignUserParams]];
        }
        // 表单填充步骤负责人
        [self setPollingStepUser:user.name index:indexPath.row];
    };
    
    [self.navigationController pushViewController:team animated:YES];
}
// 添加附件到当前步骤
- (void)addFileToCurrentStep:(NSDictionary *)addFileDic{
    NSString *type = addFileDic[@"adjunctType"];
    NSString *uid_target = addFileDic[@"uid_target"];
    BOOL canEdit = addFileDic[@"canEdit"];
    self.taskParams.uid_target = uid_target;
    // 1添加附件（相册和文件库），2删除附件 ，4查看附件
    if ([type isEqualToString:@"1"]) {
        NSLog(@"添加附加");
        __weak typeof(self) weakSelf = self;
        [weakSelf pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image, NSString * _Nonnull mediaType) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSLog(@"当前选择的图片");
            [strongSelf.uploadManager uploadFile:imageData fileName:[SZUtil getTimeNow] target:@{@"id_module":@"10",@"fid_parent":@"0"}];
            strongSelf.uploadManager.uploadResult = ^(BOOL success, NSDictionary * _Nonnull targetInfo, NSString * _Nonnull id_file) {
                if (success == YES) {
                    weakSelf.taskParams.uid_target = id_file;
                    [weakSelf.taskManager api_operationsTask:[weakSelf.taskParams getTaskFileParams:@"1"]];
                }
            };
        }];
    }
    else if([type isEqualToString:@"2"]){
        NSLog(@"查看附加");
        
        if ([addFileDic[@"type"] isEqualToString:@"11"]) {
            FormDetailController *vc = [[FormDetailController alloc] init];
            vc.buddy_file = uid_target;
            vc.isTaskDetail = YES;
            vc.hideEdit = canEdit;
            vc.selectedTarget = ^(NSString * _Nullable buddy_file) {
                if (![SZUtil isEmptyOrNull:buddy_file]) {
                    [self setTaskAdjunctBy:self.taskParams.uid_target newtarget:buddy_file];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ZHUser *user = [DataManager defaultInstance].currentUser;
            WebController *webVC = [[WebController alloc] init];
            [webVC fileView:@{@"uid_target":addFileDic[@"uid_target"],@"t":user.token,@"m":@"1",@"f":@"0"}];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:webVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    else if([type isEqualToString:@"4"]){
        NSLog(@"删除附件");
        [CNAlertView showWithTitle:@"确认删除当前附件？" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self.taskManager api_operationsTask:[self.taskParams getTaskFileParams:@"0"]];
            }
        }];
    }
}
// 设置当前步骤或者任务预计完成时间
- (void)setStepPlanTimeToTask:(NSDictionary *)planTimeDic{
    self.taskParams.planDate = planTimeDic[@"planDate"];
    [self.taskManager api_operationsTask:[self.taskParams getTaskDatePlanParams]];
}
// 修改任务优先级
- (void)alterFlowPriorityToFlow:(NSDictionary *)priorityDic{
    NSString *priority = priorityDic[@"priority"];
    NSLog(@"当前选择的任务等级 %@",priority);
    [self.taskTitleView setTaskTitleStatusColor:[priority integerValue]];
    self.taskParams.priority = [priority integerValue];
    [self.taskManager api_operationsTask:[self.taskParams getTaskPriorityParams]];

}
// 修改任务名称
- (void)alterTaskTitleToTask:(NSDictionary *)taskTitleDic{
    NSLog(@"修改当前的任务名称 == %@",taskTitleDic[@"taskTitle"]);
    if ([self.taskParams.name isEqualToString:taskTitleDic[@"taskTitle"]]) {
        return;
    }
    self.taskParams.name = taskTitleDic[@"taskTitle"];
    [self.taskManager api_editTask:[self.taskParams getTaskEditParams]];
}
// 修改文本内容（步骤、任务、终止、召回填写的的信息）
- (void)alterContentTextToTask:(NSDictionary *)contentDic{
    NSLog(@"修改当前任务的任务内容 == %@",contentDic[@"taskContent"]);
    if (![self.taskParams.memo isEqualToString:contentDic[@"taskContent"]]) {
        self.taskParams.memo = contentDic[@"taskContent"];
        if (self.taskType != task_type_detail_initiate) {
            [self.taskManager api_operationsTask:[self.taskParams getMemoParams]];
        }
    }
}
// 打开文件库
- (void)openDocumentLibView:(NSDictionary *)documentDic{
    NSLog(@"打开文件库");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DocumentLibController *vc = (DocumentLibController *)[sb instantiateViewControllerWithIdentifier:@"documentLibController"];
    vc.chooseTargetFile = YES;
    vc.targetBlock = ^(ZHTarget * _Nonnull target) {
        self.taskParams.uid_target = target.uid_target;
        [self.taskManager api_operationsTask:[self.taskParams getTaskFileParams:@"1"]];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
// 底部栏按钮操作事件
- (void)bottomToolsOperabilityEvent:(NSDictionary *)eventDic{
    NSString *operation = eventDic[@"operation"];
    if ([operation isEqualToString:@"0"]) {
        NSLog(@"发送任务");
        [CNAlertView showWithTitle:@"是否发送当前任务" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                self.taskParams.submitParams = @"1";
                [self operationPollingForm];
            }
        }];
    }
    else if([operation isEqualToString:@"3"]){
        [CNAlertView showWithTitle:@"您即将进行“我知道了”操作，请再次确认。" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                self.taskParams.submitParams = @"1";
                [self operationPollingForm];
            }
        }];
    }
    else{
        [CNAlertView showWithTitle:@"确认提交任务进度" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                self.taskParams.submitParams = operation;
                [self operationPollingForm];
            }
        }];
        NSLog(@"处理任务进度");
    }
    
}
// 发送当前任务
- (void)sengCurrentTask:(NSDictionary *)taskDic{
    NSLog(@"发送当前任务");
    [CNAlertView showWithTitle:@"是否发送当前任务" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            self.taskParams.submitParams = @"1";
            [self operationPollingForm];
        }
    }];
}

// 改变当前选中的步骤
- (void)changeCurrentSelectedStepUser:(NSDictionary *)stepUserDic{
    NSLog(@"改变当前选中的步骤 = %@",stepUserDic);
    self.operabilityTools.currentSelectedStep = stepUserDic[@"step"];
//    NSIndexPath *indexPath = stepUserDic[@"indexPath"];
    self.taskContentView.tools = self.operabilityTools;
    self.taskOperationView.tools = self.operabilityTools;
    self.pollingFormView.currentStep = self.operabilityTools.currentIndex;
//    [self setPollingStepUser:self.operabilityTools.currentSelectedStep.responseUser.name index:indexPath.row];
    [self setPollingFromDetail];
}

// 修改内容后点击保存
- (void)alterContentTexOrTaskTitletSave:(NSDictionary *)alterDic{
//    [self operationPollingForm];
    NSLog(@"点击了保存按钮");
}

- (void)savePollingForm:(NSDictionary *)dic{
    NSLog(@"当前选中步骤的状态==%d",self.operabilityTools.currentSelectedStep.state);
    NSLog(@"当前流程状态==%d",self.operabilityTools.task.belongFlow.state)
    if (self.operabilityTools.task.belongFlow.state == 1 ||self.operabilityTools.task.belongFlow.state == 3) {
        return;
    }
    if (self.operabilityTools.currentSelectedStep.state == 1 || self.operabilityTools.currentSelectedStep.state == 3 ) {
        return;
    }
    NSArray *memoDocs = [self.operabilityTools.currentStep.memoDocs allObjects];
    NSString *id_target = @"";
    if (memoDocs.count >0) {
        ZHTarget *target = memoDocs[0];
        id_target = target.uid_target;
    }
    [self setTaskAdjunctBy:id_target newtarget:self.pollingFormView.clone_buddy_file];
}

- (void)operationPollingForm{
    if (self.taskType == task_type_new_polling || self.isPolling == YES) {
        
        // 未开始或者进行中的，修改巡检单状态
        if (self.operabilityTools.task.belongFlow.state == 0 ||self.operabilityTools.task.belongFlow.state == 2) {
            BOOL isPass = [self.pollingFormView checkPollinFormParams:self.operabilityTools.currentIndex];
            if (isPass == NO) {
                return;
            }
            [self.pollingFormView changPollingFormStatus:self.operabilityTools.currentIndex];
        }
        // 有修改则保存
        if (self.pollingFormView.isModification == YES) {
            [self.pollingFormView saveForm:^(BOOL success) {
                [self.taskManager api_processTask:[self.taskParams getProcessSubmitParams]];
            }];
        }else{
            [self.taskManager api_processTask:[self.taskParams getProcessSubmitParams]];
        }
    }else{
        [self.taskManager api_processTask:[self.taskParams getProcessSubmitParams]];
    }
}

- (void)showRecallTaskAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入手机验证码" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSString *code = alertController.textFields[0].text;
        self.taskParams.memo = code;
        [self.taskManager api_processTask:[self.taskParams getProcessRecallParams]];
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入验证码";
        textField.delegate = self;
    }];
    [self presentViewController:alertController animated:true completion:nil];
}
- (void)updatePollingViewFrame:(NSDictionary *)dic{
    CGFloat height = [dic[@"height"] floatValue];
    NSLog(@"当前巡检单的高度%f",height);
    [self.pollingFormView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height+150);
        make.top.equalTo(self.taskTitleView.mas_bottom).offset(10);
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
}
#pragma mark - Responder Chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if (self.taskTitleView.isModification == YES) {
        [self alterTaskTitleToTask:@{@"taskTitle":self.taskTitleView.taskTitle.text}];
    }else if(self.taskContentView.isModification == YES){
        [self alterContentTextToTask:@{@"taskContent":self.taskContentView.contentView.text}];
    }
    NSInvocation *invocation = self.eventStrategy[eventName];
    [invocation setArgument:&userInfo atIndex:2];
    [invocation invoke];
}

#pragma mark - TaskApiDelegate
- (void)callbackApiTaskSuccess:(BOOL)success data:(BaseApiManager *)manager apiTaskType:(ApiTaskType)type{
    if (success == YES) {
        switch (type) {
            case apiTaskType_detail:
                [self callBackDetail:manager];
                break;
            case apiTaskType_new:
                [self callBackNew:manager];
                break;
            case apiTaskType_edit:
                [self callBackEdit:manager];
                break;
            case apiTaskType_operation:
                [self callBackOperation:manager];
                break;
            case apiTaskType_process:
                [self callBackProcess:manager];
                break;
            case apiTaskType_set:
                [self callBackOperation:manager];
                break;
            case apiTaskType_suspend:
                [self callBackSuspend:manager];
                break;
            
            default:
                break;
        }
    }else{
        
    }
}
- (void)callBackDetail:(BaseApiManager *)manager{
    ZHTask *task = (ZHTask *)manager.response.responseData;
    self.operabilityTools.task = task;
    [self setRequestParams:self.operabilityTools.task];
    self.taskParams.tools = self.operabilityTools;
    [self setModuleViewOperabilityTools];
    [self setPollingFromDetail];
}

- (void)callBackEdit:(BaseApiManager *)manager{
    self.taskContentView.isModification = NO;
}

- (void)callBackNew:(BaseApiManager *)manager{
    ZHTask *task = (ZHTask *)manager.response.responseData;
    self.taskParams.uid_task = task.uid_task;
    if (![SZUtil isEmptyOrNull:self.to_uid_user]) {
        self.taskParams.id_user = self.to_uid_user;
        [self.taskManager api_operationsTask:[self.taskParams getToUserParams:YES]];
    }else{
        
        [self.taskManager api_getTaskDetail:[self.taskParams getTaskDetailsParams]];
    }
}

- (void)callBackOperation:(BaseApiManager *)manager{
    self.taskTitleView.isModification = NO;
    [self.taskManager api_getTaskDetail:[self.taskParams getTaskDetailsParams]];
}

- (void)callBackProcess:(BaseApiManager *)manager{
    NSDictionary *dic = (NSDictionary *)manager.response.responseData;
    NSDictionary *result = dic[@"data"][@"results"][0];
    if (![result[@"sub_code"] isEqualToNumber:@0]) {
        NSString *msg = [SZUtil getChineseInString:result[@"msg"]];
        [SZAlert showInfo:msg underTitle:TARGETS_NAME];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self back];
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)callBackSuspend:(BaseApiManager *)manager{
    [self showRecallTaskAlert];
}

/// 设置当前任务附件
/// @param uid_target 原始附件如果为空，直接设置，如果存在，先撤销后设置
/// @param new_uid_target 当前设置的附件
- (void)setTaskAdjunctBy:(NSString *)uid_target newtarget:(NSString *)new_uid_target{
    BOOL polling = NO;
    if (self.taskType == task_type_new_polling || self.isPolling == YES) {
        polling = YES;
    }
    if ([SZUtil isEmptyOrNull:uid_target]) {
        self.taskParams.uid_target = new_uid_target;
        [self.taskManager api_setTaskAdjunct:[self.taskParams getTaskFileParams:polling == YES ?@"2":@"1"]];
    }else{
        self.taskParams.uid_target = uid_target;
        [self.taskManager api_repealTaskAdjunct:[self.taskParams getTaskFileParams:@"0"] callBack:^(BOOL success, id response) {
            if (success == YES) {
                self.taskParams.uid_target = new_uid_target;
                [self.taskManager api_setTaskAdjunct:[self.taskParams getTaskFileParams:polling == YES ?@"2":@"1"]];
            }
        }];
    }
}

#pragma mark - 巡检相关的操作
// 设置巡检相关的数据
- (void)setPollingFromDetail{
    if (self.taskType == task_type_new_polling ||self.isPolling == YES) {
        // 获取当前步骤
        ZHStep *currentStep = self.operabilityTools.currentSelectedStep;
        // 没有附件
        if ([currentStep.memoDocs allObjects].count <= 0) {
            // 获取上一步
            ZHStep *stepPrevious = [self.operabilityTools getPreviousStep];
            if (stepPrevious) {
                // 获取上一步的附件
                ZHTarget *targetPrevious = nil;
                if (stepPrevious.memoDocs.count >0) {
                    targetPrevious = [stepPrevious.memoDocs allObjects][0];
                }
                if (targetPrevious) {
                    [self.taskManager cloneForm:targetPrevious.uid_target callBack:^(BOOL success, id response) {
                        NSString *clone_uid_Target = (NSString *)response;
                        if (success == YES && ![SZUtil isEmptyOrNull:clone_uid_Target]) {
                            [self setTaskAdjunctBy:@"" newtarget:clone_uid_Target];
                        }
                    }];
                }
            }
        }else{
            ZHTarget *target = [currentStep.memoDocs allObjects][0];
            self.pollingFormView.formName = target.name;
            self.pollingFormView.currentStep = self.operabilityTools.currentIndex;
            if (self.operabilityTools.currentSelectedStep.state == 1 ||self.operabilityTools.currentSelectedStep.state == 3 ) {
                self.pollingFormView.needClone = NO;
            }else{
                self.pollingFormView.needClone = YES;
            }
            [self.pollingFormView getCurrentFormDetail:target.uid_target];
        }
    }
}

// 设置巡检负责人
- (void)setPollingStepUser:(NSString *)user index:(NSInteger)index{
    if (self.taskType == task_type_new_polling ||self.isPolling == YES) {
        [self.pollingFormView setPollingUser:user index:index];
        NSArray *result = [self.operabilityTools.currentSelectedStep.memoDocs allObjects];
        if (result.count > 0) {
//            self.pollingFormView.hidden = NO;
            ZHTarget *target = result[0];
            self.pollingFormView.formName = target.name;
            self.pollingFormView.currentStep = self.operabilityTools.currentIndex;
            [self.pollingFormView getCurrentFormDetail:target.uid_target];
        }else{
//            self.pollingFormView.hidden = YES;
        }
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
        if (self.taskType == task_type_detail_draft) {
            [CNAlertView showWithTitle:@"是否召回当前任务" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self.taskManager api_processTask:[self.taskParams getProcessRecallParams]];
                }
            }];
        }else{
            [CNAlertView showWithTitle:@"是否召回当前任务" message:@"需要填写手机验证码" tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    ZHUser *user = [DataManager defaultInstance].currentUser;
                    [self.taskManager api_suspendTask:@{@"phone":user.phone,@"type":@"RECALL_TASK"}];
                }
            }];
        }
    }else{
        [CNAlertView showWithTitle:@"是否终止当前任务" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self.taskManager api_processTask:[self.taskParams getProcessTerminateParams]];
            }
        }];
    }
}

#pragma mark - setting and getter

- (void)isTaskType:(TaskType)taskType{
    _taskType = taskType;
    self.operabilityTools = [[OperabilityTools alloc] initWithType:_taskType];
    self.operabilityTools.isPolling = self.isPolling;
    self.pollingFormView.hidden = !(_taskType == task_type_new_polling ||self.isPolling == YES);
    self.taskContentView.hidden = _taskType == (_taskType == task_type_new_polling ||self.isPolling == YES);
    if (_taskType == task_type_new_polling ||self.isPolling == YES) {
//            self.pollingFormView.hidden = NO;
        self.taskContentView.hidden = YES;
        [self updatePollingView:YES];
    }else{
//            self.pollingFormView.hidden = YES;
        self.taskContentView.hidden = NO;
        [self updatePollingView:NO];
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

- (PollingFormView *)pollingFormView{
    if (_pollingFormView == nil) {
        _pollingFormView = [[PollingFormView alloc] init];
    }
    return _pollingFormView;
}

#pragma mark - api init

- (UploadFileManager *)uploadManager{
    if (_uploadManager == nil) {
        _uploadManager = [[UploadFileManager alloc] init];
    }
    return _uploadManager;
}

- (TaskManager *)taskManager{
    if (_taskManager == nil) {
        _taskManager = [[TaskManager alloc] init];
        _taskManager.delegate = self;
    }
    return _taskManager;
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
            task_click_save:[self createInvocationWithSelector:@selector(alterContentTexOrTaskTitletSave:)],
            save_edit_form:[self createInvocationWithSelector:@selector(savePollingForm:)],
            polling_form_height:[self createInvocationWithSelector:@selector(updatePollingViewFrame:)]
        };
    }
    return _eventStrategy;
}

// 消息转发 NSInvocation中保存了方法所属的对象/方法名称/参数/返回值 使用可以传递多个参数
- (NSInvocation *)createInvocationWithSelector:(SEL)sel{
    NSMethodSignature  *signature = [TaskController instanceMethodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = sel;
    // target 0 selector 1 参数2
//    [invocation setArgument:&way atIndex:2];
    return invocation;
}

#pragma mark - UI

- (void)addUI{
    self.scrollView = [[UIScrollView alloc] init];
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    self.scrollView.userInteractionEnabled = YES;
    self.contentView.userInteractionEnabled = YES;
    
    // 步骤
    [self.contentView addSubview:self.stepView];
    // 任务名称
    [self.contentView addSubview:self.taskTitleView];
    // 任务内容
    [self.contentView addSubview:self.taskContentView];
    // 巡检表单
    [self.contentView addSubview:self.pollingFormView];
    // 底部操作栏
    [self.view addSubview:self.taskOperationView];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    

    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.taskContentView.mas_bottom);
    }];
    
    [self.stepView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.left.right.equalTo(0);
        make.height.equalTo(itemHeight);
    }];
    
    [self.taskTitleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.stepView.mas_bottom).offset(15);
    }];
    
    [self.taskContentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskTitleView.mas_bottom).offset(10);
        make.left.right.equalTo(0);
        make.bottom.equalTo(self.taskOperationView.mas_top);
    }];
    [self.pollingFormView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskTitleView.mas_top).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(400);
        make.bottom.equalTo(0);
    }];
    
    [self.taskOperationView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(-SafeAreaBottomHeight);
        make.height.equalTo(48);
    }];
}
- (void)updatePollingView:(BOOL)show{
    if (show == YES) {
        [self.pollingFormView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.taskTitleView.mas_bottom).offset(10);
            make.left.right.equalTo(0);
            make.height.equalTo(400);
            make.bottom.equalTo(0);
        }];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.bottom.equalTo(self.pollingFormView.mas_bottom);
        }];
    }else{
        [self.contentView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.taskContentView.mas_bottom);
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
    }
}

@end
