//
//  FileListView.m
//  TTManager
//
//  Created by chao liu on 2020/12/31.
//

#import "FileListView.h"
#import "DocumentLibCell.h"
#import "DocumentLibController.h"
#import "WebController.h"

@interface FileListView ()<UIGestureRecognizerDelegate,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (nonatomic, strong) NSArray *fileListArray;
// api
@property (nonatomic, strong)APITargetListManager *targetListManager;

@end

@implementation FileListView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoladNetwork) name:NotiReloadHomeView object:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reoladNetwork)];
    [self reoladNetwork];

}
- (void)reoladNetwork{
    self.targetListManager.pageSize.pageIndex = 1;
    self.targetListManager.pageSize.pageSize = 20;
    [self.targetListManager loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //隐藏导航栏造成的返回手势失效
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.containerVC loadFileCatalogCollectionView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fileListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DocumentLibCell *cell = [tableView dequeueReusableCellWithIdentifier:@"documentLibCell" forIndexPath:indexPath];
    ZHTarget *target = self.fileListArray[indexPath.row];
    cell.target = target;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZHTarget *target = self.fileListArray[indexPath.row];
    // 文件夹
    if (target.is_file == 0)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *nav = [sb instantiateViewControllerWithIdentifier:@"documentList"];
        FileListView *VC = (FileListView *)[nav topViewController];
        VC.containerVC = self.containerVC;
        VC.uid_parent = [self get_uid_parent:target];
        VC.id_module = INT_32_TO_STRING(target.id_module);
        VC.chooseTargetFile = self.chooseTargetFile;
        VC.title = target.name;
        self.containerVC.fileView = VC;
        [self.navigationController pushViewController:VC animated:YES];
    }else if(target.is_file == 1){
        if (self.containerVC.chooseTargetFile == YES) {
            if (self.containerVC.targetBlock) {
                self.containerVC.targetBlock(target);
            }
            [self.containerVC.navigationController popViewControllerAnimated:YES];
        }else{
            ZHUser *user = [DataManager defaultInstance].currentUser;
            WebController *webVC = [[WebController alloc] init];
//            webVC.loadUrl = target.link;
            [webVC fileView:@{@"uid_target":[self get_uid_parent:target],@"t":user.token,@"m":@"1",@"f":@"0"}];
            webVC.hidesBottomBarWhenPushed = YES;
            [self.containerVC.navigationController pushViewController:webVC animated:YES];
        }
    }
}
- (NSString *)get_uid_parent:(ZHTarget *)target{
    NSString *uid_parent = @"0";
    if ([target.name isEqualToString:@"Pub"]) {
        uid_parent = @"0";
    }else if([target.name isEqualToString:@"Monitor"]){
        uid_parent = @"0";
    }else if([target.name isEqualToString:@"Form"]){
        uid_parent = @"0";
    }else if([target.name isEqualToString:@"Task"]){
        uid_parent = @"0";
    }else{
        uid_parent = target.uid_target;
    }
    return uid_parent;
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    if (manager == self.targetListManager) {
        ZHProject *project = [DataManager defaultInstance].currentProject;
        dic = @{@"id_project":INT_32_TO_STRING(project.id_project),
                @"id_module":self.id_module,
                @"uid_parent":self.uid_parent,
        };
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.targetListManager) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView showDataCount:self.fileListArray.count type:0];
        [self.containerVC fileViewListEmpty:(self.fileListArray.count <= 0)];
//        self.title = @"";
        [self.containerVC loadFileCatalogCollectionView];
        [self.tableView reloadData];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.targetListManager) {
        [self.tableView.mj_header endRefreshing];
        self.title = @"";
        [self.tableView showDataCount:0 type:0];
        [self.containerVC loadFileCatalogCollectionView];
    }
}
#pragma mark - setter and getter
- (APITargetListManager *)targetListManager{
    if (_targetListManager == nil) {
        _targetListManager = [[APITargetListManager alloc] init];
        _targetListManager.delegate = self;
        _targetListManager.paramSource = self;
    }
    return _targetListManager;
}
- (NSArray *)fileListArray{
    NSArray *result = (NSArray *)self.targetListManager.response.responseData;
    if (self.navigationController.viewControllers.count >1) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
        result = [result sortedArrayUsingDescriptors:sortDescriptors];
    }
    _fileListArray = result;
    return _fileListArray;
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    //判断是否为rootViewController
    if (self.navigationController && self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}

@end
