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

@interface TeamController ()<UITableViewDelegate,UITableViewDataSource,PopViewSelectedIndexDelegate,UIPopoverPresentationControllerDelegate,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *teamNameBtn;
@property (nonatomic, strong) NSArray *teamArray;
@property (nonatomic, assign) NSInteger currentSelected;

// api
@property (nonatomic, strong)APIDepartmentManager *departmentListManager;
@property (nonatomic, strong) APIDMDetailManager* dmDetailsManager;

@end

@implementation TeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoladNetwork) name:NotiReloadHomeView object:nil];
    [self.teamNameBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    self.teamNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.currentSelected = NSNotFound;
    [self reoladNetwork];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)reoladNetwork{
    self.departmentListManager.pageSize.pageIndex = 1;
    self.departmentListManager.pageSize.pageSize = 20;
    [self.departmentListManager loadData];
}
//}
#pragma mark - action
- (IBAction)changTeamAction:(id)sender
{
    [self showPopView:(UIButton *)sender];
}
- (void)showPopView:(UIView *)sourceView
{
    PopViewController *popView = [[PopViewController alloc] init];
    popView.delegate = self;
    popView.view.alpha = 1.0;
    popView.dataList = [self departmentTitle];
    popView.modalPresentationStyle = UIModalPresentationPopover;
    
    popView.popoverPresentationController.sourceView = sourceView;
    popView.popoverPresentationController.sourceRect = CGRectMake(sourceView.frame.origin.x, sourceView.frame.origin.y, 0, 0);
    popView.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    popView.popoverPresentationController.delegate = self;
    [self presentViewController:popView animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.teamArray.count > 0) {
        ZHDepartment *department = self.teamArray[self.currentSelected];
        return department.hasUsers.count;
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
    ZHDepartment *department = self.teamArray[self.currentSelected];
    NSArray *array = [self currentUserList:department.hasUsers];
    ZHDepartmentUser *departmentUser = array[indexPath.row];
    cell.currentUser = departmentUser.assignUser.belongUser;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
    UserInforController *vc = (UserInforController *)[storyBoard instantiateViewControllerWithIdentifier:@"userInforController"];
    ZHDepartment *department = self.teamArray[self.currentSelected];
    NSArray *array = [self currentUserList:department.hasUsers];
    ZHDepartmentUser *departmentUser = array[indexPath.row];
    vc.user = departmentUser.assignUser.belongUser;
    NSLog(@"当前的user%@",vc.user);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PopViewSelectedIndexDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}
- (void)popViewControllerSelectedCellIndexContent:(NSIndexPath *)indexPath{
    self.currentSelected = indexPath.row;
    [self.tableView reloadData];
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    if (manager == self.dmDetailsManager) {
    }else if(manager == self.departmentListManager){
        ZHUser *user = [DataManager defaultInstance].currentUser;
        ZHProject *project = [DataManager defaultInstance].currentProject;
        dic = @{@"id_project":INT_32_TO_STRING(project.id_project),
                @"id_user":INT_32_TO_STRING(user.id_user)};
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.departmentListManager) {
        self.departmentListManager.response = manager.response;
        self.currentSelected = 0;
        [self.tableView reloadData];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    
}
#pragma mark - setter and getter
- (APIDepartmentManager *)departmentListManager{
    if (_departmentListManager == nil) {
        _departmentListManager = [[APIDepartmentManager alloc] init];
        _departmentListManager.delegate = self;
        _departmentListManager.paramSource = self;
    }
    return _departmentListManager;
}
- (APIDMDetailManager *)dmDetailsManager{
    if (_dmDetailsManager == nil) {
        _dmDetailsManager = [[APIDMDetailManager alloc] init];
        _dmDetailsManager.delegate = self;
        _dmDetailsManager.paramSource = self;
    }
    return _dmDetailsManager;
}
- (NSArray *)teamArray{
    _teamArray = [NSArray array];
    ZHProject *project = [DataManager defaultInstance].currentProject;
    NSSet *department = project.hasDepartments;
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"id_department" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    NSArray *userArray = [department sortedArrayUsingDescriptors:sortDescriptors];
    if (userArray.count > 0) {
        _teamArray = userArray;
    }
    return _teamArray;
}
- (void)setCurrentSelected:(NSInteger)currentSelected{
    if (currentSelected == NSNotFound) {
        return;
    }
    currentSelected = _currentSelected;
    NSArray *title = [self departmentTitle];
    if (title > 0) {
        [self.teamNameBtn setTitle:title[_currentSelected] forState:UIControlStateNormal];
    }
}
- (NSArray *)departmentTitle{
    NSMutableArray *array = [NSMutableArray array];
    for (ZHDepartment *departMent in self.teamArray) {
        [array addObject:departMent.name];
    }
    return array;
}
- (NSArray *)currentUserList:(NSSet *)set{
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"order_index" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    NSArray *result = [set sortedArrayUsingDescriptors:sortDescriptors];
    return result;
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
