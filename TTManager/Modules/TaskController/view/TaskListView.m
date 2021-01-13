//
//  TaskListView.m
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import "TaskListView.h"
#import "TaskListCell.h"
#import "TaskListController.h"

@interface TaskListView ()<UITableViewDelegate,UITableViewDataSource,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) APITaskListManager *taskListManager;
@property (nonatomic, strong) NSMutableArray *taskArray;
@property (nonatomic, assign) BOOL needReloadData;

@end

@implementation TaskListView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.needReloadData = YES;
        [self addUI];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
- (void)addUI{
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.tableView showDataCount:self.taskArray.count];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refresMoreData)];
}
#pragma mark - 下拉更新数据 上拉加载更多
- (void)refresData{
    self.taskListManager.pageSize.pageIndex = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self.taskListManager loadData];
}
- (void)refresMoreData{
    self.taskListManager.pageSize.pageIndex++;
    [self.taskListManager loadData];
}
#pragma mark - setter and getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
#warning UITableView 设置为group时，如果只设置header的高度，不设置 headerView，会出现留白
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"taskCell";
    TaskListCell *cell = (TaskListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell =[[TaskListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.currenttask = self.taskArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZHTask *task = self.taskArray[indexPath.row];
    NSLog(@"%@",task.uid_task);
    [self routerEventWithName:Task_list_selected userInfo:@{@"uid_task":task.uid_task,@"taskStatus":[NSString stringWithFormat:@"%ld",self.currentTaskStatus]}];
}
- (void)reloadDataFromNetwork{
    if (self.needReloadData == YES) {
        [self.taskListManager loadData];
    }
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    if (manager == self.taskListManager) {
        dic = [self getCurrentParamSource:self.currentTaskStatus];
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.taskListManager) {
        self.needReloadData = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (manager.responsePageSize.currentCount < self.taskListManager.pageSize.pageSize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
        }
        if (self.taskListManager.pageSize.pageIndex == 1) {
            [self.taskArray removeAllObjects];
        }
        [self.taskArray addObjectsFromArray:(NSArray *)manager.response.responseData];
        [self.tableView showDataCount:self.taskArray.count];
        [self.tableView reloadData];
        
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    
}
#pragma mark - setter and getter
- (APITaskListManager *)taskListManager{
    if (_taskListManager == nil) {
        _taskListManager = [[APITaskListManager alloc] init];
        _taskListManager.delegate = self;
        _taskListManager.paramSource = self;
        _taskListManager.pageSize.pageSize = 20;
        _taskListManager.pageSize.pageIndex = 1;
        _taskListManager.dataType = taskListDataType_default;
    }
    return _taskListManager;
}
- (NSMutableArray *)taskArray{
    if (_taskArray == nil) {
        _taskArray = [NSMutableArray array];
    }
    if (_taskArray.count <= 0) {
        
    }
    return _taskArray;
}
- (NSDictionary *)getCurrentParamSource:(TaskStatus)taskStatus{
    ZHProject *project = [DataManager defaultInstance].currentProject;
    NSString *is_starter = @"";
    NSString *is_finished = @"";
    switch (taskStatus) {
        case Task_list:
            is_starter = @"0";
            is_finished = @"0";
            break;
        case Task_finish:
            is_starter = @"0";
            is_finished = @"1";
            break;
        case Task_sponsoring:
            is_starter = @"1";
            is_finished = @"0";
            break;
        case Task_sponsored:
            is_starter = @"1";
            is_finished = @"1";
            break;
        default:
            break;
    }
    NSDictionary *dic = @{@"id_project":INT_32_TO_STRING(project.id_project),
                          @"is_starter":is_starter,
                          @"is_finished":is_finished};
    return dic;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
