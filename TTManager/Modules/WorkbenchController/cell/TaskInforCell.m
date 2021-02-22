//
//  TaskInforCell.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "TaskInforCell.h"

@interface TaskInforCell ()<APIManagerParamSource,ApiManagerCallBackDelegate>

@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) APITaskListManager *taskfinishManager;
@property (nonatomic, strong) APITaskListManager *taskunfinishedManager;
@property (nonatomic, copy) NSString *firstCount;
@property (nonatomic, copy) NSString *secondCount;
@end

@implementation TaskInforCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.currentSelectedIndex = 0;
    self.firstCount = 0;
    self.secondCount = 0;
    CGFloat x = (kScreenWidth/2-self.myTaskBtn.titleLabel.size.width)/2;
    CGFloat w = self.myTaskBtn.titleLabel.size.width;
 
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(x);
        make.bottom.equalTo(self.tabBgView);
        make.height.equalTo(2);
        make.width.equalTo(w);
    }];
    [self changeTaskInfor:0];
    
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstTapAction:)];
    [self.firstItembgView addGestureRecognizer:firstTap];
    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondTapAction:)];
    [self.secondItembgView addGestureRecognizer:secondTap];
    
    [self requestTaskListCount:self.currentSelectedIndex];
}
#pragma mark - Action

- (IBAction)changeTab:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger currentTag = button.tag - 10000;
    self.firstCount = 0;
    self.secondCount = 0;
    [self reloadTaskListCount:currentTag];
}

- (void)reloadTaskListCount:(NSInteger)currentTag{
    self.currentSelectedIndex = currentTag;
    
    [self changeSelecteStyle:currentTag];
    
    [self changeLineViewLocation:currentTag];
    
    [self changeTaskInfor:currentTag];
    
    [self requestTaskListCount:self.currentSelectedIndex];
}

- (void)firstTapAction:(UITapGestureRecognizer *)tap{
    NSDictionary *dic = [self getTaskStatusForTaskList:0];
    [self routerEventWithName:push_to_taskList userInfo:dic];
}

- (void)secondTapAction:(UITapGestureRecognizer *)tap{
    NSDictionary *dic = [self getTaskStatusForTaskList:1];
    [self routerEventWithName:push_to_taskList userInfo:dic];
}

#pragma mark - private method

- (void)changeTaskInfor:(NSInteger)currentTag{
    NSString *first = @"进行中";
    UIColor *firstColor = [SZUtil colorWithHex:@"#EEF6FC"];
    NSString *second = @"已完成";
    UIColor *secondColor = [SZUtil colorWithHex:@"#FFF5E4"];
    if (currentTag == 1)
    {
        first = @"起草中";
        firstColor = [SZUtil colorWithHex:@"#FFF5E4"];
        
        second = @"已发起";
        secondColor = [SZUtil colorWithHex:@"#EEF6FC"];
    }
    
    self.firstItembgView.backgroundColor = firstColor;
    self.firstStatusName.text = first;
    self.firstStatusCount.text = self.firstCount;
    
    self.secondItembgView.backgroundColor = secondColor;
    self.secondStatusName.text = second;
    self.secondStatusCount.text = self.secondCount;
    
    self.secondStatusCount.textAlignment = NSTextAlignmentRight;
    self.firstStatusCount.textAlignment = NSTextAlignmentRight;
}

- (void)changeSelecteStyle:(NSInteger)currentTag{
    if (currentTag == 0) {
        [self.myTaskBtn setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
        [self.mySendTaskBtn setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
    }else{
        [self.myTaskBtn setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
        [self.mySendTaskBtn setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
    }
}
// 改变lin位置
- (void)changeLineViewLocation:(NSInteger)currentTag{
    CGFloat x = 0;
    if (currentTag == 0) {
        x = (kScreenWidth/2-self.myTaskBtn.titleLabel.size.width)/2;
    }else{
        x = kScreenWidth/2 + (kScreenWidth/2-self.myTaskBtn.titleLabel.size.width)/2;
    }
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(x);
    }];
    [self layoutIfNeeded];
}
// 获取跳转任务对应的参数
- (NSDictionary *)getTaskStatusForTaskList:(NSInteger)selected{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // 派发给我的
    if (self.currentSelectedIndex == 0) {
        dic[@"selectedTaskType"] = @"0";
        // 未完成的
        if (selected == 0) {
            dic[@"selectedTaskStatus"] = @"0";
        }
        // 已经完成的
        else if(selected == 1){
            dic[@"selectedTaskStatus"] = @"1";
        }
    }
    // 我派发的
    else if(self.currentSelectedIndex == 1){
        dic[@"selectedTaskType"] = @"1";
        // 未完成的
        if (selected == 0) {
            dic[@"selectedTaskStatus"] = @"0";
        }
        // 已经完成的
        else if(selected == 1){
            dic[@"selectedTaskStatus"] = @"1";
        }
    }
    return dic;
}
// 请求任务个数 0 派发给我的，1 我派发的
// is_starter 是否是发起型任务 0-不是 1-是发起型。
// is_finished /是否是已经完成/发起的任务 0-未完成/未发起  1-完成/发起
- (void)requestTaskListCount:(NSInteger)type{
    if ([DataManager defaultInstance].currentProject == nil) {
        return;
    }
    [self.firstStatusCount startActivityIndicatorView];
    [self.secondStatusCount startActivityIndicatorView];
    ZHProject *project = [DataManager defaultInstance].currentProject;
    [self.taskunfinishedManager loadDataWithParams:@{@"id_project":INT_32_TO_STRING(project.id_project),
                                               @"is_starter":[NSString stringWithFormat:@"%ld",type],
                                               @"is_finished":@"0"}];
    [self.taskfinishManager loadDataWithParams:@{@"id_project":INT_32_TO_STRING(project.id_project),
                                               @"is_starter":[NSString stringWithFormat:@"%ld",type],
                                               @"is_finished":@"1"}];
}

#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    return @{};
}

#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.taskfinishManager) {
        self.secondCount = [NSString stringWithFormat:@"%ld",self.taskfinishManager.responsePageSize.total_row];
        [self changeTaskInfor:self.currentSelectedIndex];
        [self.secondStatusCount stopActivityIndicatorView];
    }else if(manager == self.taskunfinishedManager){
        self.firstCount = [NSString stringWithFormat:@"%ld",self.taskunfinishedManager.responsePageSize.total_row];
        [self changeTaskInfor:self.currentSelectedIndex];
        [self.firstStatusCount stopActivityIndicatorView];

    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.taskfinishManager) {
        [self.firstStatusCount stopActivityIndicatorView];
    }else if(manager == self.taskunfinishedManager){
        [self.secondStatusCount stopActivityIndicatorView];
    }
}

#pragma mark - setter and getter
// 包含派发给我的 和我派发的
- (APITaskListManager *)taskfinishManager{
    if (_taskfinishManager == nil) {
        _taskfinishManager = [[APITaskListManager alloc] init];
        _taskfinishManager.delegate = self;
        _taskfinishManager.paramSource = self;
        _taskfinishManager.pageSize.pageIndex = 0;
        _taskfinishManager.pageSize.pageSize = 0;
        _taskfinishManager.dataType = taskListDataType_none;
    }
    return _taskfinishManager;
}
// 包含派发给我的 和我派发的
- (APITaskListManager *)taskunfinishedManager{
    if (_taskunfinishedManager == nil) {
        _taskunfinishedManager = [[APITaskListManager alloc] init];
        _taskunfinishedManager.delegate = self;
        _taskunfinishedManager.paramSource = self;
        _taskunfinishedManager.pageSize.pageIndex = 0;
        _taskunfinishedManager.pageSize.pageSize = 0;
        _taskfinishManager.dataType = taskListDataType_none;
    }
    return _taskunfinishedManager;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
