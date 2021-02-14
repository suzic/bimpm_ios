//
//  TaskListView.m
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import "TaskListView.h"
#import "TaskListCell.h"
#import "TaskListController.h"
//#import "FormViewCell.h"

@interface TaskListView ()<UITableViewDelegate,UITableViewDataSource,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) APITaskListManager *taskListManager;
@property (nonatomic, strong) APIFormListManager *formListManager;
@property (nonatomic, strong) NSMutableArray *listArray;

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
//    [self.tableView showDataCount:self.taskArray.count type:0];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refresMoreData)];
}
#pragma mark - 下拉更新数据 上拉加载更多
- (void)refresData{
    if (self.listType == 1) {
        self.taskListManager.pageSize.pageIndex = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self.taskListManager loadData];
    }else if(self.listType == 2){
        self.formListManager.pageSize.pageIndex = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self.formListManager loadData];
    }
    
}
- (void)refresMoreData{
    if (self.listType == 1) {
        self.taskListManager.pageSize.pageIndex++;
        [self.taskListManager loadData];
    }else if(self.listType == 2){
        self.formListManager.pageSize.pageIndex++;
        [self.formListManager loadData];
    }
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
    return self.listArray.count;
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
    static NSString *indentifier = @"listCell";
    UITableViewCell *itemCell = nil;
    if (self.listType == 1) {
        TaskListCell *cell = (TaskListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell =[[TaskListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        cell.currenttask = self.listArray[indexPath.row];
        itemCell = cell;
    }else if(self.listType == 2){
//        FormViewCell *cell = (FormViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
//        if (!cell) {
//            cell =[[FormViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
//        }
//        cell.currentForm = self.listArray[indexPath.row];
//        itemCell = cell;
    }
    
    return itemCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.listType == 1) {
        ZHTask *task = self.listArray[indexPath.row];
        [self routerEventWithName:Task_list_selected userInfo:@{@"task":task,@"taskStatus":[NSString stringWithFormat:@"%ld",self.currentTaskStatus]}];
    }else if(self.listType == 2){
        ZHForm *form = self.listArray[indexPath.row];
        [self routerEventWithName:form_selected_item userInfo:@{@"form":form}];
    }
}
- (void)reloadDataFromNetwork{
    if (self.needReloadData == YES) {
        if (self.listType == 1) {
            self.taskListManager.pageSize.pageIndex = 1;
            [self.tableView.mj_footer resetNoMoreData];
            [self.taskListManager loadData];
        }else if(self.listType == 2){
            self.formListManager.pageSize.pageIndex = 1;
            [self.tableView.mj_footer resetNoMoreData];
            [self.formListManager loadData];
        }
    }
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    if (manager == self.taskListManager) {
        dic = [self getCurrentParamSource:self.currentTaskStatus];
    }else if(manager == self.formListManager){
        dic = [self getCurrentFormParam:self.formType];
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    self.needReloadData = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (manager.responsePageSize.currentCount < self.taskListManager.pageSize.pageSize) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = YES;
    }
    if (self.taskListManager.pageSize.pageIndex == 1) {
        [self.listArray removeAllObjects];
    }
    [self.listArray addObjectsFromArray:(NSArray *)manager.response.responseData];
    if (manager == self.taskListManager) {
        NSInteger type = 0;
        if (self.currentTaskStatus == Task_list) {
            type = 1;
        }else if(self.currentTaskStatus == Task_sponsoring){
            type = 2;
        }
        [self.tableView showDataCount:self.listArray.count type:type];
        
    }else if(manager == self.formListManager){
        [self.tableView showDataCount:self.listArray.count type:0];
    }
    [self.tableView reloadData];
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.taskListManager || manager == self.formListManager) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
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
- (APIFormListManager *)formListManager{
    if (_formListManager == nil) {
        _formListManager = [[APIFormListManager alloc] init];
        _formListManager.delegate = self;
        _formListManager.paramSource = self;
    }
    return _formListManager;
}
- (void)setCurrentTaskStatus:(TaskStatus)currentTaskStatus{
    if (_currentTaskStatus != currentTaskStatus) {
        _currentTaskStatus = currentTaskStatus;
        [self.taskListManager.pageSize.orders removeAllObjects];
        switch (_currentTaskStatus) {
            case Task_list:
                [self.taskListManager.pageSize.orders addObject:@{@"key":@"start_date",@"ascending":@"desc"}];
                break;
            case Task_finish:
                [self.taskListManager.pageSize.orders addObject:@{@"key":@"end_date",@"ascending":@"desc"}];
                break;
            case Task_sponsoring:
                [self.taskListManager.pageSize.orders addObject:@{@"key":@"start_date",@"ascending":@"desc"}];
                break;
            case Task_sponsored:
                [self.taskListManager.pageSize.orders addObject:@{@"key":@"end_date",@"ascending":@"desc"}];
                break;
            default:
                break;
       }
    }
}
-(void)setFormType:(NSInteger)formType{
    if (_formType != formType) {
        _formType = formType;
        [self.formListManager.pageSize.orders addObject:@{@"key":@"create_date",@"ascending":@"desc"}];
    }
}
- (NSDictionary *)getCurrentFormParam:(NSInteger)type{
    NSDictionary *params = @{};
    switch (type) {
        case 1:
            params = @{@"id_project":[NSNull null],@"template":@"1"};
            break;
        case 2:{
            ZHProject *project = [DataManager defaultInstance].currentProject;
            params = @{@"id_project":INT_32_TO_STRING(project.id_project),@"template":@"1"};
        }
        default:
            break;
    }
    return params;
}
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
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
                          @"other_user_name":@"",
                          @"flow_state":@"null",
                          @"id_user":@"",
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
