//
//  TaskController.m
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import "TaskController.h"
#import "TaskStepView.h"

@interface TaskController ()

@property (nonatomic, strong) TaskStepView *stepView;
@property (nonatomic, strong) NSArray *stepArray;

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
    [self.view addSubview:self.stepView];
    [self.stepView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
        make.left.right.equalTo(0);
        make.height.equalTo(itemHeight);
    }];
    self.stepView.stepArray = self.stepArray;
    
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
