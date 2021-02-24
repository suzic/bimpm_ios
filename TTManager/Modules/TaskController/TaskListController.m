//
//  TaskListController.m
//  TTManager
//
//  Created by chao liu on 2020/12/28.
//

#import "TaskListController.h"
#import "TabListView.h"
#import "TaskListView.h"
#import "DragButton.h"
#import "TaskController.h"

@interface TaskListController ()<APIManagerParamSource,ApiManagerCallBackDelegate>

@property (nonatomic, strong) TabListView *taskTabView;
@property (nonatomic, strong) NSArray *listSattusArray;
@property (nonatomic, strong) NSArray *newTasTypeklist;
@property (nonatomic, assign) TaskType taskType;
@property (nonatomic, strong) NSMutableArray *taskListViewArray;

@property (nonatomic, strong) APITargetListManager *targetListManager;

@property (nonatomic, strong) NSDictionary *selectedTaskDic;

@end

@implementation TaskListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addUI];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.taskTabView.selectedTaskIndex = self.taskStatus;
}
#pragma mark - private method
// 选择任务类型
- (void)showSelectNewTaskType{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择任务类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    int i = 1;
    for (NSString *newTaskType in self.newTasTypeklist) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:newTaskType style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.taskType = action.taskType;
            [self performSegueWithIdentifier:@"newTask" sender:nil];
        }];
        action.taskType = i;
        [alert addAction:action];
        i++;
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
// 当前list的title
- (NSString *)getListTitleWithStatus:(TaskStatus)status{
    NSString *listTitle = @"";
    switch (status) {
        case Task_list:
            listTitle = @"进行中";
            break;
        case Task_finish:
            listTitle = @"已完成";
            break;
        case Task_sponsoring:
            listTitle = @"起草中";
            break;
        case Task_sponsored:
            listTitle = @"已发起";
            break;
        default:
            break;
    }
    return listTitle;
}
- (void)pushTaskDetailsViewController:(NSDictionary *)dict{
    self.selectedTaskDic = dict;
    ZHTask *task = dict[@"task"];
    if ([task.firstTarget.uid_target containsString:inspection_form_template_id]) {
        [self pushDetai:YES];
    }else{
        [self loadTaskTargetDetail:task.firstTarget.uid_target];
    }
}

- (void)pushDetai:(BOOL)isPolling{
    ZHTask *task = self.selectedTaskDic[@"task"];
    NSInteger taskStatus = [self.selectedTaskDic[@"taskStatus"] integerValue];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Task" bundle:nil];
    TaskController *taskVC = (TaskController *)[sb instantiateViewControllerWithIdentifier:@"taskController"];
    taskVC.id_task = task.uid_task;
    taskVC.isPolling = isPolling;
    taskVC.taskType = (taskStatus +6);
    self.taskStatus = taskStatus;
    TaskListView *listView = self.taskListViewArray[self.taskStatus];
    listView.needReloadData = YES;
    [self.navigationController pushViewController:taskVC animated:YES];
}

// 判断任务附件是不是表单任务（因为任务没有类型区分，必须获取一下targetdetail）
- (void)loadTaskTargetDetail:(NSString *)uid_target{
    // 如果当前存在筛选数据 ，先清空，后添加
    if (self.targetListManager.pageSize.filters.count >0) {
        [self.targetListManager.pageSize.filters removeAllObjects];
    }
    if (![SZUtil isEmptyOrNull:uid_target]) {
        // 以特定开头
        NSDictionary *name = @{@"key":@"uid_target",
                                 @"operator":@":",
                                 @"value":uid_target,
                                 @"join":@"and"};
        [self.targetListManager.pageSize.filters addObject:name];
        [self.targetListManager loadData];
    }else{
        [self pushDetai:NO];
    }
}

#pragma mark - APIManagerParamSource

- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = [NSDictionary dictionary];
    if (manager == self.targetListManager) {
        ZHProject *project = [DataManager defaultInstance].currentProject;
        params = @{@"id_project":INT_32_TO_STRING(project.id_project),
                @"id_module":[NSNull null],
                @"uid_parent":[NSNull null],
        };
    }
    return params;
}

#pragma mark - ApiManagerCallBackDelegate

- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    
    if (manager == self.targetListManager) {
        NSArray *result = (NSArray *)manager.response.responseData;
        ZHTarget *target = result[0];
        ZHTask *task = self.selectedTaskDic[@"task"];
        // 是表单类型 并且name符合巡检单命名规则 并且是附件不允许用户变更附件，则是巡检任务
        NSLog(@"当前任务的memo_target_list_fixed == %d",task.assignStep.memo_target_list_fixed);
        if (target.type == 11 && [target.name containsString:@"XC-XJD"] && task.assignStep.memo_target_list_fixed == YES) {
            [self pushDetai:YES];
        }else{
            [self pushDetai:NO];
        }
    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    
}

#pragma mark - setter getter

- (TabListView *)taskTabView{
    if (_taskTabView == nil) {
        _taskTabView = [[TabListView alloc] init];
    }
    return _taskTabView;
}
- (NSArray *)listSattusArray{
    if (_listSattusArray == nil) {
        _listSattusArray = @[@(Task_list),@(Task_finish),@(Task_sponsoring),@(Task_sponsored)];
    }
    return _listSattusArray;
}
- (NSArray *)newTasTypeklist{
    if (_newTasTypeklist == nil) {
        _newTasTypeklist = @[@"单独任务",@"审批",@"批量任务",@"会审"];
    }
    return _newTasTypeklist;
}

- (APITargetListManager *)targetListManager{
    if (_targetListManager == nil) {
        _targetListManager = [[APITargetListManager alloc] init];
        _targetListManager.delegate = self;
        _targetListManager.paramSource = self;
        [_targetListManager.pageSize.orders addObject:@{@"key":@"name", @"ascending":@"asc"}];
    }
    return _targetListManager;
}

#pragma mark - Responder Chain

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:Task_list_selected]) {
        [self pushTaskDetailsViewController:userInfo];
    }else if([eventName isEqualToString:new_task_action]){
        [self showSelectNewTaskType];
    }
}
#pragma mark - UI
- (void)addUI{
    [self.view addSubview:self.taskTabView];
    self.taskTabView.listType = 1;
    [self.taskTabView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    self.taskListViewArray = [NSMutableArray array];
    for (NSNumber *status in self.listSattusArray) {
        TaskListView *view = [[TaskListView alloc] init];
        view.listType = 1;
        view.currentTaskStatus = [status integerValue];
        view.listTitle = [self getListTitleWithStatus:[status integerValue]];
        view.needReloadData = YES;
        [self.taskListViewArray addObject:view];
    }
    [self.taskTabView setChildrenViewList:self.taskListViewArray];
    DragButton *dragBtn = [DragButton initDragButtonVC:self];
    [dragBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(-(SafeAreaBottomHeight == 0 ? 15 :SafeAreaBottomHeight));
        make.width.height.equalTo(49);
    }];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"newTask"]) {
        UINavigationController *nav = (UINavigationController *)[segue destinationViewController];
        TaskController *vc = (TaskController *)[nav topViewController];
        vc.taskType = self.taskType;
        TaskListView *listView = self.taskListViewArray[self.taskStatus];
        listView.needReloadData = YES;
    }
}

@end
