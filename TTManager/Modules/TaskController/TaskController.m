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

@interface TaskController ()
// 任务步骤
@property (nonatomic, strong) TaskStepView *stepView;
@property (nonatomic, strong) NSArray *stepArray;
// 任务名称
@property (nonatomic, strong) TaskTitleView *taskTitleView;
// 任务内容
@property (nonatomic, strong) TaskContentView *taskContentView;
// 任务操作页面
@property (nonatomic, strong) TaskOperationView *taskOperationView;

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
}
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
