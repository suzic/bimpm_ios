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

@interface WorkbenchController ()<UITableViewDelegate,UITableViewDataSource,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeInforLabel;
@property (nonatomic, strong) NSArray *ganttInfoArray;
// api
@property (nonatomic, strong) APIUTPListManager *UTPListManager;
@property (nonatomic, strong) APIUTPInfoManager *UTPInfoManager;
@property (nonatomic, strong) APITaskListManager *taskListManager;
@property (nonatomic, strong) APIUTPGanttManager *UTPGanttManager;

@end

@implementation WorkbenchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timeLabel.text = [SZUtil getDateString:[NSDate date]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoladNetwork) name:NotiReloadHomeView object:nil];
    [self reoladNetwork];

}
- (void)reoladNetwork{
    [self.UTPListManager loadData];
    [self.UTPInfoManager loadData];
    [self.taskListManager loadData];
    [self.UTPGanttManager loadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
            MessageCell *msgCell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
            msgCell.ganntInfoList = self.ganttInfoArray;
            cell = msgCell;
        }
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"functionCell" forIndexPath:indexPath];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"taskInforCell" forIndexPath:indexPath];
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
            return 170.0f;
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

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:MoreMessage])
    {
        NSLog(@"导航到更多消息页面");
        MoreWorkMsgController *moreVC = [[MoreWorkMsgController alloc] init];
        moreVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:moreVC animated:YES];
    }
    else if([eventName isEqualToString:function_selected])
    {
        NSLog(@"当前点击的常用功能=====%@",userInfo[@"index"]);
    }
    else if([eventName isEqualToString:taskList_selected])
    {
        NSLog(@"跳转任务详情带去的参数======%@",userInfo)
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
    if (manager == self.taskListManager) {
        
    }else if(manager == self.UTPListManager){
        
    }else if(manager == self.UTPInfoManager){
        
    }else if(manager == self.UTPGanttManager){
        dic = @{@"id_project":INT_32_TO_STRING(project.id_project),
                @"forward_days":@"7",
                @"gantt_type":@"0"};
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.taskListManager) {
        
    }else if(manager == self.UTPListManager){
        
    }else if(manager == self.UTPInfoManager){
        
    }else if(manager == self.UTPGanttManager){
        self.ganttInfoArray = manager.response.responseData;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadData];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.taskListManager) {
        
    }else if(manager == self.UTPListManager){
        
    }else if(manager == self.UTPInfoManager){
        
    }else if(manager == self.UTPGanttManager){
        
    }
}
#pragma mark - setter and getter
- (APITaskListManager *)taskListManager{
    if (_taskListManager == nil) {
        _taskListManager = [[APITaskListManager alloc] init];
        _taskListManager.delegate = self;
        _taskListManager.paramSource = self;
    }
    return _taskListManager;
}
- (APIUTPGanttManager *)UTPGanttManager{
    if (_UTPGanttManager == nil) {
        _UTPGanttManager = [[APIUTPGanttManager alloc] init];
        _UTPGanttManager.delegate = self;
        _UTPGanttManager.paramSource = self;
    }
    return _UTPGanttManager;
}
- (APIUTPInfoManager *)UTPInfoManager{
    if (_UTPInfoManager == nil) {
        _UTPInfoManager = [[APIUTPInfoManager alloc] init];
        _UTPInfoManager.delegate = self;
        _UTPInfoManager.paramSource = self;
    }
    return _UTPInfoManager;
}
- (APIUTPListManager *)UTPListManager{
    if (_UTPListManager == nil) {
        _UTPListManager = [[APIUTPListManager alloc] init];
        _UTPListManager.delegate = self;
        _UTPListManager.paramSource = self;
    }
    return _UTPListManager;
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
