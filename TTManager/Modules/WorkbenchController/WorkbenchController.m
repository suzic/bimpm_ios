//
//  WorkbenchController.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "WorkbenchController.h"
#import "MessageCell.h"
#import "FunctionCell.h"
#import "TaskInforCell.h"
#import "HeaderCell.h"
#import "MoreWorkMsgController.h"
#import "TaskListController.h"
#import "MessageCell.h"
#import "TaskInforCell.h"
#import "ClockInViewController.h"
#import "BuilderDiaryController.h"
#import "WorkDiaryController.h"
#import "TaskController.h"
#import "DateCell.h"

@interface WorkbenchController ()<UITableViewDelegate,UITableViewDataSource,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *ganttInfoArray;
@property (nonatomic, assign) NSInteger selectedFunctionType;

// api
@property (nonatomic, strong) APIUTPInfoManager *UTPInfoManager;
@property (nonatomic, strong) APITargetListManager *filterTargetManager;

@end

@implementation WorkbenchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoladNetwork) name:NotiReloadHomeView object:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reoladNetwork)];
    self.selectedFunctionType = NSNotFound;
}

- (void)reoladNetwork{
    if ([DataManager defaultInstance].currentProject != nil) {
        [self.UTPInfoManager loadData];
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        default:
            return 1;
            break;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderCell *cell = nil;
    if (section == 0)
        return nil;
    else{
        cell = (HeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        cell.headerTitle.text = section == 1 ? @"常用功能" : @"我的任务";
        cell.arrows.hidden = section == 2;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                DateCell *dateCell = (DateCell *)[tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
                cell = dateCell;
            }else if(indexPath.row == 1){
                MessageCell *msgCell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
                msgCell.ganntInfoList = self.ganttInfoArray;
                cell = msgCell;
            }
        }
            break;
        case 1:{
            FunctionCell *functionCell = (FunctionCell *)[tableView dequeueReusableCellWithIdentifier:@"functionCell" forIndexPath:indexPath];
            cell = functionCell;
        }
            break;
        case 2:{
            TaskInforCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"taskInforCell" forIndexPath:indexPath];
            [infoCell reloadTaskListCount:0];
            cell = infoCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  section == 0 ? 0.1f : 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return indexPath.row == 0 ? 80.0f : 240.0f;
            break;
        case 1:
            return FunctionCellHeight;
            break;
        case 2:
            return 144.0f;
            break;
        default:
            break;
    }
    return 0;
}

#pragma mark - 筛选表单

- (void)setSelectedFunctionType:(NSInteger)selectedFunctionType{
    if (selectedFunctionType == NSNotFound) {
        return;
    }
    _selectedFunctionType = selectedFunctionType;
    [self filterTargetByType:_selectedFunctionType];
}

// 根据选择不同设置不同的筛选参数
- (void)filterTargetByType:(NSInteger)type{
    // 打卡
    switch (type) {
        // 巡检
        case 0:
            [self pushViewControllerToSelectedFunctionVC:@{}];
            break;
        // 施工日志
        case 1:
            [self setFilterParams:@"RY-SGRZ"];
            break;
        // 工作日报
        case 2:
            [self setFilterParams:@"RY-GZRB"];
            break;
        // 日常打卡
        case 3:
            [self setFilterParams:@"RY-RCDK"];
            break;
        default:
            break;
    }
}

// 设置打卡的筛选参数
- (void)setFilterParams:(NSString *)filterValue{
    // 如果当前存在筛选数据 ，先清空，后添加
    if (self.filterTargetManager.pageSize.filters.count >0) {
        [self.filterTargetManager.pageSize.filters removeAllObjects];
    }
    NSString *currentTime = [SZUtil getDateString:[NSDate date]];
    currentTime = [currentTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    // 以特定开头
    NSDictionary *fromNameFilter = @{@"key":@"name",
                             @"operator":@":",
                             @"value":filterValue,
                             @"join":@"and"};
//    // 以时间结尾
    NSDictionary *endNameFilter = @{@"key":@"name",
                             @"operator":@":",
                             @"value":currentTime,
                             @"join":@"and"};
    
    [self.filterTargetManager.pageSize.filters addObject:fromNameFilter];
    [self.filterTargetManager.pageSize.filters addObject:endNameFilter];
    [self.filterTargetManager loadData];
}

// 筛选成功之后数据的处理
- (void)filterSuccess:(NSArray *)result{
    NSDictionary *params = @{};
    // 没有查询到任务数据 则需要克隆表单
    if (result == nil || result.count <= 0) {
        params = @{@"buddy_file":[self getTemplateId],@"needClone":@1};
    }else{
        ZHUser *user = [DataManager defaultInstance].currentUser;
        NSString *buddy_file = nil;
        for (ZHTarget *target in result) {
            if (target.owner.id_user == user.id_user) {
                buddy_file = target.uid_target;
                break;
            }
        }
        // 没有查询到数据，需要克隆表单
        if ([SZUtil isEmptyOrNull:buddy_file]) {
            params = @{@"buddy_file":[self getTemplateId],@"needClone":@1};
        }
        // 有数据 直接去填充表单
        else{
            params = @{@"buddy_file":buddy_file,@"needClone":@0};
        }
    }
    [self pushViewControllerToSelectedFunctionVC:params];
}

// 跳转到各个页面以及所需要的参数
- (void)pushViewControllerToSelectedFunctionVC:(NSDictionary *)params{
    UIViewController *vc = nil;
    // 打卡
    switch (self.selectedFunctionType) {
        // 巡检
        case 0:{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Task" bundle:nil];
            TaskController *taskVC = (TaskController *)[sb instantiateViewControllerWithIdentifier:@"taskController"];
            taskVC.taskType = task_type_new_polling;
            vc = taskVC;
        }
            break;
        // 施工日志
        case 1:{
            BuilderDiaryController *builderDiaryVC = [[BuilderDiaryController alloc] init];
            builderDiaryVC.isCloneForm = [params[@"needClone"] boolValue];
            builderDiaryVC.buddy_file = params[@"buddy_file"];
            vc = builderDiaryVC;
        }
            break;
        // 工作日报
        case 2:{
            WorkDiaryController *workDailyVC = [[WorkDiaryController alloc] init];
            workDailyVC.isCloneForm = [params[@"needClone"] boolValue];
            workDailyVC.buddy_file = params[@"buddy_file"];
            vc = workDailyVC;
        }
            break;
        // 日常打卡
        case 3:{
            ClockInViewController *clockInVC = [[ClockInViewController alloc] init];
            clockInVC.buddy_file = params[@"buddy_file"];
            vc = clockInVC;
        }
            break;
        default:
            break;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSString *)getTemplateId{
    NSString *templateId = @"";
    switch (_selectedFunctionType) {
        // 巡检
        case 0:
            templateId = inspection_form_template_id;
            break;
        // 施工日志
        case 1:
            templateId = roadwork_form_template_id;
            break;
        // 工作日报
        case 2:
            templateId = work_form_template_id;
            break;
        // 日常打卡
        case 3:
            templateId = clock_form_template_id;
            break;
        default:
            break;
    }
    return templateId;
}

#pragma mark - Responder Chain

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:MoreMessage]){
        MoreWorkMsgController *moreVC = [[MoreWorkMsgController alloc] init];
        moreVC.infoArray = self.ganttInfoArray;
        moreVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:moreVC animated:YES];
    }
    else if([eventName isEqualToString:function_selected]){
        NSInteger index = [userInfo[@"index"] integerValue];
        self.selectedFunctionType = index;
    }
    else if([eventName isEqualToString:push_to_taskList]){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Task" bundle:nil];
        TaskListController *VC = (TaskListController *)[sb instantiateViewControllerWithIdentifier:@"taskListVC"];
        VC.hidesBottomBarWhenPushed = YES;
        VC.taskStatus = [self getCurrentSelectedTaskStatus:userInfo];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (TaskStatus)getCurrentSelectedTaskStatus:(NSDictionary *)dic{
    TaskStatus status = Task_list;
    if ([dic[@"selectedTaskType"] isEqualToString:@"0"]) {
        if ([dic[@"selectedTaskStatus"] isEqualToString:@"0"]) {
            status = Task_list;
        }else if([dic[@"selectedTaskStatus"] isEqualToString:@"1"]){
            status = Task_finish;
        }
    }else if([dic[@"selectedTaskType"] isEqualToString:@"1"]){
        if ([dic[@"selectedTaskStatus"] isEqualToString:@"0"]) {
            status = Task_sponsoring;
        }else if([dic[@"selectedTaskStatus"] isEqualToString:@"1"]){
            status = Task_sponsored;
        }
    }
    return status;
}

#pragma mark - APIManagerParamSource

- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    ZHProject *project = [DataManager defaultInstance].currentProject;
    if(manager == self.UTPInfoManager){
        NSString *edit_date = [NSString stringWithFormat:@"%@ 00:00:00",[SZUtil getDateString:[NSDate date]]];
        dic = @{@"id_project":INT_32_TO_STRING(project.id_project),
                @"edit_date":edit_date};
    }else if(manager == self.filterTargetManager){
        ZHProject *project = [DataManager defaultInstance].currentProject;
        dic = @{@"id_project":INT_32_TO_STRING(project.id_project),
                @"id_module":[NSNull null],
                @"uid_parent":[NSNull null],
        };
    }
    return dic;
}

#pragma mark - ApiManagerCallBackDelegate

- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    [self.tableView.mj_header endRefreshing];
    if(manager == self.UTPInfoManager){
        self.ganttInfoArray = manager.response.responseData;
        [self.tableView reloadData];
    }else if(manager == self.filterTargetManager){
        [self filterSuccess:(NSArray *)manager.response.responseData];
    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    [self.tableView.mj_header endRefreshing];
    if(manager == self.UTPInfoManager){
        
    }else if(manager == self.filterTargetManager){
        
    }
}

#pragma mark - setter and getter

- (APIUTPInfoManager *)UTPInfoManager{
    if (_UTPInfoManager == nil) {
        _UTPInfoManager = [[APIUTPInfoManager alloc] init];
        _UTPInfoManager.delegate = self;
        _UTPInfoManager.paramSource = self;
    }
    return _UTPInfoManager;
}

- (APITargetListManager *)filterTargetManager{
    if (_filterTargetManager == nil) {
        _filterTargetManager = [[APITargetListManager alloc] init];
        _filterTargetManager.delegate = self;
        _filterTargetManager.paramSource = self;
        _filterTargetManager.pageSize.pageIndex = 0;
    }
    return _filterTargetManager;
}

- (NSArray *)ganttInfoArray{
    if (_ganttInfoArray == nil) {
        _ganttInfoArray = [NSArray array];
    }
    return _ganttInfoArray;
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
