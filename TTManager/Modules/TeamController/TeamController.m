//
//  TeamController.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "TeamController.h"
#import "DocumentLibCell.h"
#import "UserInforController.h"
#import "PopViewController.h"
#import "UserInforController.h"

@interface TeamController ()<UITableViewDelegate,UITableViewDataSource,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *teamNameBtn;
@property (nonatomic, strong) NSArray *departmentUserArray;
@property (nonatomic, strong) NSArray *departmentList;
@property (nonatomic, assign) NSInteger currentSelected;
@property (nonatomic, copy) NSString *id_department;
// api
//@property (nonatomic, strong)APIDepartmentManager *departmentListManager;
@property (nonatomic, strong) APIDMDetailManager* dmDetailsManager;

@end

@implementation TeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"团队";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoladNetwork) name:NotiReloadHomeView object:nil];
    [self.teamNameBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    self.teamNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.currentSelected = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reoladNetwork)];
//    [self reoladNetwork];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)reoladNetwork{
    self.departmentUserArray = nil;
    self.dmDetailsManager.pageSize.pageIndex = 1;
    self.dmDetailsManager.pageSize.pageSize = 20;
    [self.dmDetailsManager loadData];
}
//}
#pragma mark - action
- (IBAction)changTeamAction:(id)sender
{
    [self showDepartmentActionSheets];
}
- (void)showDepartmentActionSheets{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择部门" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i= 0; i < self.departmentList.count; i++) {
        ZHDepartmentUser *departmentUser = self.departmentList[i];
        NSLog(@"部门名称 === %@",departmentUser.belongDepartment);
        UIAlertAction *action = [UIAlertAction actionWithTitle:departmentUser.belongDepartment.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.currentSelected = action.taskType;
        }];
        action.taskType = i;
        [alert addAction:action];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.departmentUserArray.count > 0) {
        NSLog(@"当前部门下的员工个数%ld",self.departmentUserArray.count);
        return self.departmentUserArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DocumentLibCell *cell = [tableView dequeueReusableCellWithIdentifier:@"documentLibCell" forIndexPath:indexPath];
    cell.currentUser = self.departmentUserArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZHUser *user = self.departmentUserArray[indexPath.row];
    if (self.selectedUserType == NO) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
        UserInforController *vc = (UserInforController *)[storyBoard instantiateViewControllerWithIdentifier:@"userInforController"];
        vc.user = user;
        vc.id_department = [self.id_department intValue];
        NSLog(@"当前的user%@",vc.user);
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (self.selectUserBlock) {
            self.selectUserBlock(user);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    if (manager == self.dmDetailsManager) {
        ZHProject *project = [DataManager defaultInstance].currentProject;
        dic = @{@"id_project":INT_32_TO_STRING(project.id_project),
                @"id_department":self.id_department,
        };
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.dmDetailsManager) {
        [self.tableView.mj_header endRefreshing];
        self.departmentUserArray = (NSMutableArray *)manager.response.responseData;
        [self.tableView showDataCount:self.departmentUserArray.count type:0];
        [self.tableView reloadData];
    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.dmDetailsManager) {
        [self.tableView.mj_header endRefreshing];
    }
}
#pragma mark - setter and getter

- (APIDMDetailManager *)dmDetailsManager{
    if (_dmDetailsManager == nil) {
        _dmDetailsManager = [[APIDMDetailManager alloc] init];
        _dmDetailsManager.delegate = self;
        _dmDetailsManager.paramSource = self;
    }
    return _dmDetailsManager;
}
- (NSArray *)departmentList{
    if (_departmentList == nil) {
        _departmentList = [NSArray array];
        ZHProject *project = [DataManager defaultInstance].currentProject;
        ZHUserProject *uProject = nil;
        for (ZHUserProject *userProject in project.hasUsers) {
            if (userProject.id_project == project.id_project) {
                uProject = userProject;
                break;
            }
        }
        NSArray *department = [uProject.inDepartments allObjects];
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"order_index" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
        _departmentList = [department sortedArrayUsingDescriptors:sortDescriptors];
        for (ZHDepartmentUser *user in _departmentList) {
            NSLog(@"部门名称 == %@",user.belongDepartment.name);
        }
    }
    return _departmentList;
}
- (NSArray *)departmentUserArray{
    if (_departmentUserArray == nil) {
        _departmentUserArray = [NSArray array];
    }
    return _departmentUserArray;
}
- (void)setCurrentSelected:(NSInteger)currentSelected{
    _currentSelected = currentSelected;

    if (_currentSelected == NSNotFound) {
        return;
    }
    ZHDepartmentUser *departmentUser = self.departmentList[_currentSelected];
    self.id_department = INT_32_TO_STRING(departmentUser.belongDepartment.id_department);
    [self.teamNameBtn setTitle:departmentUser.belongDepartment.name forState:UIControlStateNormal];
    [self reoladNetwork];
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
