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
#import "TaskParams.h"
#import "OperabilityTools.h"

@interface TaskController ()<APIManagerParamSource,ApiManagerCallBackDelegate,ZHCalendarViewDelegate>

@property (nonatomic,strong) UIBarButtonItem *rightButtonItem;

@property (nonatomic, strong) NSMutableArray *stepArray;
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
@property (nonatomic, strong) OperabilityTools *operabilityTools;
@property (nonatomic, strong) TaskParams *taskParams;

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
        [self newTaskStepArray];
    }
}

#pragma mark - private method
- (void)setNavbackItemAndTitle{
    if (self.operabilityTools.isDetails) {
        self.title = @"任务详情";
    }else{
        self.title = @"新任务";
    }
    self.navigationItem.rightBarButtonItem = self.rightButtonItem;
}
- (void)back{
    if (self.operabilityTools.isDetails == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
// 新任务时步骤初始化
- (void)newTaskStepArray{
    ZHUser *user = [DataManager defaultInstance].currentUser;
    [self.stepArray addObject:user];
    self.stepView.stepArray = self.stepArray;
}
- (void)addStepUserToCurrentStepArray:(ZHUser *)user{
    [self.stepArray addObject:user];
    self.stepView.stepArray = self.stepArray;
}
- (void)taskDetailStepArray{
    
}
// 设置组件的tools
- (void)setModuleViewOperabilityTools{
    self.stepView.tools = self.operabilityTools;
    self.taskTitleView.tools = self.operabilityTools;
    self.taskContentView.tools = self.operabilityTools;
    self.taskOperationView.tools = self.operabilityTools;
}
- (void)deleteCurrentSelectedStepUser:(NSInteger)index{
    NSString *string = @"";
    id data = self.stepArray[index];
    if ([data isKindOfClass:[ZHUser class]]) {
        string = ((ZHUser *)data).name;
    }else if([data isKindOfClass:[ZHStep class]]){
        string = ((ZHStep *)data).responseUser.name;
    }
    string  = [NSString stringWithFormat:@"确认删除 %@ ",string];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.stepArray removeObjectAtIndex:index];
        self.stepView.stepArray = self.stepArray;
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
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TeamController *team = (TeamController *)[sb instantiateViewControllerWithIdentifier:@"teamController"];
        team.selectedUserType = YES;
        team.selectUserBlock = ^(ZHUser * _Nonnull user) {
            NSLog(@"当前选择的用户==%@",user.name);
            [self addStepUserToCurrentStepArray:user];
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
    }else if([eventName isEqualToString:longPress_delete_index]){
        [self deleteCurrentSelectedStepUser:[userInfo[@"index"] integerValue]];
        NSLog(@"长按删除");
    }else if([eventName isEqualToString:open_document_library]){
        NSLog(@"打开文件库");
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"documentLibController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([eventName isEqualToString:selected_save_task]){
        NSLog(@"保存任务");
    }
}

#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    if (manager == self.taskNewManager) {
        params = [self.taskParams getNewTaskParams];
    }else if(manager == self.taskDetailManager){
        params = @{};
    }else if(manager == self.taskEditManager){
        
    }else if(manager == self.taskOperationsManager){
        
    }else if(manager == self.taskProcessManager){
        
    }
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
- (NSMutableArray *)stepArray{
    if (_stepArray == nil) {
        _stepArray = [NSMutableArray array];
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
- (TaskParams *)taskParams{
    if (_taskParams == nil) {
        _taskParams = [[TaskParams alloc] init];
        _taskParams.id_flow_template = self.taskType;
    }
    return _taskParams;
}
- (UIBarButtonItem *)rightButtonItem{
    if (_rightButtonItem == nil) {
        _rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"task_more"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
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

    self.taskContentView.priorityType = priority_type_highGrade;
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
