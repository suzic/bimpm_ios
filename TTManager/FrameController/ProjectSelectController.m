//
//  ProjectSelectController.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "ProjectSelectController.h"
#import "ProjectViewCell.h"

@interface ProjectSelectController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *projectCollectionView;
@property (nonatomic, strong) NSArray *projectList;
@property (nonatomic, assign) NSInteger selectedIndex;

// api
@property (nonatomic, strong) APIUTPListManager *UTPlistManager;
@property (nonatomic, strong) APIUTPOperationsManager *UTPOperations;
@property (nonatomic, strong) APIUTPDetailManager *UTPDetailManager;

@end

@implementation ProjectSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *))
        self.projectCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    else
        self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.projectCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    _projectList = [NSMutableArray array];
    [self reloadData];
}
- (void)reloadData{
    self.UTPlistManager.pageSize.pageIndex = 0;
    [self.UTPlistManager loadData];
    [self.projectCollectionView reloadData];
}
#pragma mark - setter and getter
- (NSArray *)projectList{
    _projectList = [NSArray array];
    NSMutableArray *result = [DataManager defaultInstance].currentProjectList;
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"id_project" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    NSArray *array = [result sortedArrayUsingDescriptors:sortDescriptors];
    _projectList = [NSArray arrayWithArray:[self sortDefautProjectList:array]];
    return _projectList;
}
- (NSArray *)sortDefautProjectList:(NSArray *)array{
    NSMutableArray *initArray = [NSMutableArray arrayWithArray:array];
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:array];
    for (ZHUserProject *userProject in resultArray) {
        if (userProject.in_manager_invite == 1) {
            [initArray removeObject:userProject];
            [initArray insertObject:userProject atIndex:0];
        }
        if (userProject.in_apply == 1) {
            [initArray removeObject:userProject];
            [initArray insertObject:userProject atIndex:initArray.count];
        }
    }
    return initArray;
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.projectList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProjectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"projectIdentifler" forIndexPath:indexPath];
    ZHUserProject *userProject = self.projectList[indexPath.row];
    cell.userProject = userProject;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-15)/2, 300.0f);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    ZHUserProject *userProject = self.projectList[indexPath.row];
    if (userProject.in_invite == 1 ||userProject.in_manager_invite == 1 || userProject.in_apply == 1) {
        return;
    }
    [self.UTPDetailManager loadDataWithParams:@{@"id_project":INT_32_TO_STRING(userProject.belongProject.id_project)}];
}
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:user_to_project_operations]) {
        [self.UTPOperations loadDataWithParams:userInfo];
    }
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    ZHUser *user = [DataManager defaultInstance].currentUser;
    if (manager == self.UTPlistManager) {
        dic = @{@"id_user":INT_32_TO_STRING(user.id_user),@"belong_state":@"10"};
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.UTPlistManager) {
        [self.projectCollectionView.mj_header endRefreshing];
        [self.projectCollectionView reloadData];
    }else if(manager == self.UTPDetailManager){
        ZHUserProject *userProject = self.projectList[self.selectedIndex];
//        [self routerEventWithName:selectedProject userInfo:@{@"currentProject":userProject.belongProject}];
        [self.frameVC reloadCurrentSelectedProject:userProject.belongProject];
    }else if(manager == self.UTPOperations){
        [self reloadData];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.UTPlistManager) {
        [self.projectCollectionView.mj_header endRefreshing];
    }
}
#pragma mark - setter and getter
- (APIUTPListManager *)UTPlistManager{
    if (_UTPlistManager == nil) {
        _UTPlistManager = [[APIUTPListManager alloc] init];
        _UTPlistManager.delegate = self;
        _UTPlistManager.paramSource = self;
        _UTPlistManager.isNeedCoreData = YES;
    }
    return _UTPlistManager;
}
- (APIUTPDetailManager *)UTPDetailManager{
    if (_UTPDetailManager == nil) {
        _UTPDetailManager = [[APIUTPDetailManager alloc] init];
        _UTPDetailManager.delegate = self;
        _UTPDetailManager.paramSource = self;
    }
    return _UTPDetailManager;
}
- (APIUTPOperationsManager *)UTPOperations{
    if (_UTPOperations == nil) {
        _UTPOperations = [[APIUTPOperationsManager alloc] init];
        _UTPOperations.delegate = self;
        _UTPOperations.paramSource = self;
    }
    return _UTPOperations;
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
