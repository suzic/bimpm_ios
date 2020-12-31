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

@interface WorkbenchController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeInforLabel;

@end

@implementation WorkbenchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timeLabel.text = [SZUtil getDateString:[NSDate date]];
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
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
    if ([eventName isEqualToString:@"moreMessage"])
    {
        NSLog(@"导航到更多消息页面");
        MoreWorkMsgController *moreVC = [[MoreWorkMsgController alloc] init];
        moreVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:moreVC animated:YES];
    }
    else if([eventName isEqualToString:@"Function"])
    {
        NSLog(@"当前点击的常用功能=====%@",userInfo[@"index"]);
    }
    else if([eventName isEqualToString:@"taskList"])
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
