//
//  TaskListController.m
//  TTManager
//
//  Created by chao liu on 2020/12/28.
//

#import "TaskListController.h"
#import "TaskTabView.h"
#import "TaskListView.h"
#import "DragButton.h"
#import "TaskController.h"

@interface TaskListController ()

@property (nonatomic, strong) TaskTabView *taskTabView;
@property (nonatomic, strong) NSArray *listSattusArray;
@property (nonatomic, strong) NSArray *newTasTypeklist;
@property (nonatomic,assign)TaskType taskType;
@end

@implementation TaskListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
//    _taskStatus = Task_list;
    [self addUI];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.taskTabView changCurrentTab:self.taskStatus];
}
- (void)addUI{
    [self.view addSubview:self.taskTabView];
    [self.taskTabView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    NSMutableArray *viewArray = [NSMutableArray array];
    for (NSNumber *status in self.listSattusArray) {
        TaskListView *view = [[TaskListView alloc] init];
        view.taskStatus = [status integerValue];
        view.listTitle = [self getListTitleWithStatus:view.taskStatus];
        [viewArray addObject:view];
    }
    [self.view layoutIfNeeded];
    [self.taskTabView setChildrenViewList:viewArray];
    DragButton *dragBtn = [DragButton initDragButtonVC:self];
    [dragBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(-(SafeAreaBottomHeight == 0 ? 15 :SafeAreaBottomHeight));
        make.width.height.equalTo(49);
    }];
    
}
#pragma mark - private method
- (void)showSelectNewTaskType{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择任务类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *newTaskType in self.newTasTypeklist) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:newTaskType style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.taskType = TaskType_newTask;
            [self performSegueWithIdentifier:@"newTask" sender:nil];
        }];
        [alert addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - setter getter
- (TaskTabView *)taskTabView{
    if (_taskTabView == nil) {
        _taskTabView = [[TaskTabView alloc] init];
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
        _newTasTypeklist = @[@"任务",@"申请",@"通知",@"会审",@"巡检"];
    }
    return _newTasTypeklist;
}

- (NSString *)getListTitleWithStatus:(TaskStatus)status{
    NSString *listTitle = @"";
    switch (status) {
        case Task_list:
            listTitle = @"我的任务";
            break;
        case Task_finish:
            listTitle = @"已完成任务";
            break;
        case Task_sponsoring:
            listTitle = @"正在发起";
            break;
        case Task_sponsored:
            listTitle = @"已发起";
            break;
        default:
            break;
    }
    return listTitle;
}
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:@"Task_list_selected"]) {
        self.taskType = TaskType_details;
        [self performSegueWithIdentifier:@"newTask" sender:nil];
//        [self performSegueWithIdentifier:@"showTaskDetail" sender:nil];
    }else if([eventName isEqualToString:@"new_task_action"]){
        [self showSelectNewTaskType];
    }
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
    }
}

@end
