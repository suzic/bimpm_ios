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
#import "ZHCalendarView.h"
#import "CalendarDayModel.h"

@interface TaskController ()<APIManagerParamSource,ApiManagerCallBackDelegate,ZHCalendarViewDelegate>

@property (nonatomic, strong) NSArray *stepArray;
// 任务步骤
@property (nonatomic, strong) TaskStepView *stepView;
// 日历
@property (nonatomic, strong) ZHCalendarView *calendarView;
// 任务名称
@property (nonatomic, strong) TaskTitleView *taskTitleView;
// 任务内容
@property (nonatomic, strong) TaskContentView *taskContentView;
// 任务操作页面
@property (nonatomic, strong) TaskOperationView *taskOperationView;

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
    self.title = @"创建任务";
    if (self.taskType == TaskType_details) {
        NSLog(@"创建任务详情界面");
    }else if(self.taskType == TaskType_newTask){
        NSLog(@"创建新任务界面");
    }
    [self addUI];
    [self loadData];
}

- (void)loadData{
    if (self.taskType == TaskType_details) {
        [self.taskDetailManager loadData];
    }else if(self.taskType == TaskType_newTask){
        [self.taskNewManager loadData];
    }
}
#pragma mark - Responder Chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if([eventName isEqualToString:selected_taskStep_user]){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TeamController *team = (TeamController *)[sb instantiateViewControllerWithIdentifier:@"teamController"];
        team.selectedUserType = YES;
        team.selectUserBlock = ^(ZHUser * _Nonnull user) {
            NSLog(@"当前选择的用户==%@",user.name);
        };
        [self.navigationController pushViewController:team animated:YES];
    }else if([eventName isEqualToString:choose_adjunct_file]){
        [self pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
            NSLog(@"当前选择的图片");
        }];
    }else if([eventName isEqualToString:select_caldenar_view]){
        NSLog(@"选择日期");
        [self.calendarView showCalendarView:YES];
        self.calendarView.defaultSelectedDate = @"2021-01-29";
    }else if([eventName isEqualToString:selected_task_priority]){
        NSString *priority = userInfo[@"priority"];
        NSLog(@"当前选择的任务等级 %@",priority);
        [self.taskTitleView setTaskTitleStatusColor:[priority integerValue]];
    }
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    return params;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    
}
#pragma mark - ZHCalendarViewDelegate
- (void)ZHCalendarViewDidSelectedDate:(CalendarDayModel *)selectedDate{
    NSLog(@"当前选择的日历时间====%@",[selectedDate toString]);
}
#pragma mark -setting and getter
- (TaskStepView *)stepView{
    if (_stepView == nil) {
        _stepView = [[TaskStepView alloc] init];
    }
    return _stepView;
}

- (NSArray *)stepArray{
    if (_stepArray == nil) {
        _stepArray = @[@"1",@"2",@"3",@"4",@"5"];
    }
    return _stepArray;
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
- (ZHCalendarView *)calendarView{
    if (_calendarView == nil) {
        _calendarView = [[ZHCalendarView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        _calendarView.delegate = self;
        [_calendarView needMonth:12];
        [[AppDelegate sharedDelegate].window addSubview:_calendarView];
    }
    return _calendarView;
}
#pragma mark api init
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
    self.stepView.stepArray = self.stepArray;
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
    
    self.taskContentView.priorityType = priority_type_highGrade;
}
- (IBAction)closeVCAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
