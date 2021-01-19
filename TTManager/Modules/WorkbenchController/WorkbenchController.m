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
#import "TaskController.h"
#import "MapViewController.h"

@interface WorkbenchController ()<UITableViewDelegate,UITableViewDataSource,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeInforLabel;
@property (nonatomic, strong) NSArray *ganttInfoArray;
@property (nonatomic, assign) NSInteger currentSelectedTaskType;
// api
@property (nonatomic, strong) APIUTPGanttManager *UTPGanttManager;

@end

@implementation WorkbenchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCurrentDate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoladNetwork) name:NotiReloadHomeView object:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reoladNetwork)];
    [self reoladNetwork];

}
- (void)setCurrentDate{
    self.timeInforLabel.hidden = NO;
    self.timeLabel.text = [SZUtil getDateString:[NSDate date]];
    NSDate *date = [NSDate date];
    Solar *solarDate = [[Solar alloc] initWithDate:date];
    Lunar *lunarDate = solarDate.lunar;
    self.timeInforLabel.text = [NSString stringWithFormat:@"%@%@%@",[lunarDate ganzhiYear],lunarDate.lunarFromatterMonth, lunarDate.lunarFomatterDay];
}
- (void)reoladNetwork{
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
        case 1:{
            FunctionCell *functionCell = (FunctionCell *)[tableView dequeueReusableCellWithIdentifier:@"functionCell" forIndexPath:indexPath];
            cell = functionCell;
        }
            
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
#pragma mark - Responder Chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:MoreMessage])
    {
        NSLog(@"导航到更多消息页面");
        MoreWorkMsgController *moreVC = [[MoreWorkMsgController alloc] init];
        moreVC.infoArray = self.ganttInfoArray;
        moreVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:moreVC animated:YES];
    }
    else if([eventName isEqualToString:function_selected])
    {
        NSInteger index = [userInfo[@"index"] integerValue];
        if (index == 0) {
            NSLog(@"点击了打卡");
            [self goMapView];
        }else{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Task" bundle:nil];
            UINavigationController *nav = [sb instantiateViewControllerWithIdentifier:@"newTaskNav"];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            TaskController *taskVC = (TaskController *)nav.topViewController;
            taskVC.taskType = index == 1 ? 1:(index == 3 ? 5:3);
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    else if([eventName isEqualToString:push_to_taskList])
    {
        NSLog(@"跳转任务详情带去的参数======%@",userInfo)
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Task" bundle:nil];
        TaskListController *VC = (TaskListController *)[sb instantiateViewControllerWithIdentifier:@"taskListVC"];
        VC.hidesBottomBarWhenPushed = YES;
        VC.taskStatus = [self getCurrentSelectedTaskStatus:userInfo];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)goMapView{
    MapViewController *map = [[MapViewController alloc] init];
    map.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:map];
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
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
    if(manager == self.UTPGanttManager){
        dic = @{@"id_project":INT_32_TO_STRING(project.id_project),
                @"forward_days":@"7",
                @"gantt_type":@"0"};
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    [self.tableView.mj_header endRefreshing];
    if(manager == self.UTPGanttManager){
        self.ganttInfoArray = manager.response.responseData;
        [self.tableView reloadData];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    [self.tableView.mj_header endRefreshing];
    if(manager == self.UTPGanttManager){
        
    }
}
#pragma mark - setter and getter

- (APIUTPGanttManager *)UTPGanttManager{
    if (_UTPGanttManager == nil) {
        _UTPGanttManager = [[APIUTPGanttManager alloc] init];
        _UTPGanttManager.delegate = self;
        _UTPGanttManager.paramSource = self;
    }
    return _UTPGanttManager;
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
