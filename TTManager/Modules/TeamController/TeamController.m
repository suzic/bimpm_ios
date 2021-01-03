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

@interface TeamController ()<UITableViewDelegate,UITableViewDataSource,PopViewSelectedIndexDelegate,UIPopoverPresentationControllerDelegate,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *teamNameBtn;
@property (nonatomic, strong) NSArray *teamArray;
// api
@property (nonatomic, strong)APIDepartmentManager *departmentListManager;
@property (nonatomic, strong) APIDMDetailManager* dmDetailsManager;

@end

@implementation TeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.teamNameBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    self.teamNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.departmentListManager loadData];
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowHeaderView object:@(YES)];
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowHeaderView object:@(NO)];
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
    popView.dataList = self.teamArray;
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
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DocumentLibCell *cell = [tableView dequeueReusableCellWithIdentifier:@"documentLibCell" forIndexPath:indexPath];
    cell.documentTitle.text = self.teamNameBtn.titleLabel.text;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"userInforController"];
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
    NSLog(@"当前选择部门");
    [self.teamNameBtn setTitle:self.teamArray[indexPath.row] forState:UIControlStateNormal];
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
    if (_teamArray == nil) {
        _teamArray = @[@"市场部",@"销售部",@"采购部",@"营销部"];
    }
    return _teamArray;
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
