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
#import "FormDetailController.h"

@interface FileListView ()<UIGestureRecognizerDelegate,UITextFieldDelegate,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (nonatomic, strong) NSMutableArray *fileListArray;
// api
@property (nonatomic, strong) APITargetListManager *targetListManager;
@property (nonatomic, strong) APITargetOperations *targetOperation;
@property (nonatomic, strong) APITargetRenameManager *targetRename;

@end

@implementation FileListView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reoladNetwork)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refresMoreData)];
    [self reoladNetwork];

}
- (void)reoladNetwork{
    self.targetListManager.pageSize.pageIndex = 1;
    self.targetListManager.pageSize.pageSize = 20;
    [self.targetListManager loadData];
}
- (void)refresMoreData{
    self.targetListManager.pageSize.pageIndex++;
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
    [self currentSelectedTargetDetail:target];
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZHTarget *target = self.fileListArray[indexPath.row];
    BOOL edit = [self currentTargetPermission:target];
    if (edit == YES) {
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"重命名" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            // 收回侧滑
            [tableView setEditing:NO animated:YES];
            [self showEditNameAlertView:target];
            NSLog(@"重新命名");
        }];

        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"删除操作");
            [CNAlertView showWithTitle:@"请确认删除当前文件" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSDictionary *params = @{@"id_project":target.fid_project,
                                             @"code":@"DELETE",
                                             @"param":@"0",
                                             @"target_list":@[target.uid_target]};
                    [self.targetOperation loadDataWithParams:params];
                }
            }];
        }];
        return @[deleteAction,editAction];
    }
    return @[];
}
#pragma mark - private
- (void)currentSelectedTargetDetail:(ZHTarget *)target{
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
        VC.title = [self setDocmentLibTitle:target];
        self.containerVC.fileView = VC;
        [self.navigationController pushViewController:VC animated:YES];
    }
    // 文件
    else if(target.is_file == 1){
        // 选择文件后返回
        if (self.containerVC.chooseTargetFile == YES) {
            if (self.containerVC.targetBlock) {
                self.containerVC.targetBlock(target);
            }
            [self.containerVC.navigationController popViewControllerAnimated:YES];
        }
        // 查看文件
        else{
            // 表单文件
            if (target.type == 11) {
                FormDetailController *formVC = [[FormDetailController alloc] init];
                formVC.buddy_file = target.uid_target;
                formVC.hidesBottomBarWhenPushed = YES;
                [self.containerVC.navigationController pushViewController:formVC animated:YES];
            }else{
                ZHUser *user = [DataManager defaultInstance].currentUser;
                WebController *webVC = [[WebController alloc] init];
                [webVC fileView:@{@"uid_target":[self get_uid_parent:target],@"t":user.token,@"m":@"0"}];
                webVC.hidesBottomBarWhenPushed = YES;
                [self.containerVC.navigationController pushViewController:webVC animated:YES];
            }
        }
    }
}
- (NSString *)get_uid_parent:(ZHTarget *)target{
    NSString *uid_parent = @"0";
    // uid_target和fid_parent 都为空顶级目录
    if ([SZUtil isEmptyOrNull:target.uid_target] &&[SZUtil isEmptyOrNull:target.fid_parent]) {
        uid_parent = @"0";
    }
    // uid_target不为空 fid_parent为空 表示第二级别目录
    else if ([SZUtil isEmptyOrNull:target.uid_target] && ![SZUtil isEmptyOrNull:target.fid_parent]){
        uid_parent = @"0";
    }else{
        uid_parent = target.uid_target;
    }
    return uid_parent;
}
- (NSString *)setDocmentLibTitle:(ZHTarget *)target{
    NSString *docmentLibTitle = @"";
    if ([SZUtil isEmptyOrNull:target.uid_target] && target.is_file == 0) {
        if (target.id_module == 0) {
            docmentLibTitle = @"文档";
        }else if(target.id_module == 8){
            docmentLibTitle = @"大屏配置";
        }else if(target.id_module == 9){
            docmentLibTitle = @"表单文件";
        }else if(target.id_module == 10){
            docmentLibTitle = @"任务附件";
        }else if(target.id_module > 10){
            docmentLibTitle = [NSString stringWithFormat:@"%@文件",target.name];
        }
    }else{
        docmentLibTitle = target.name;
    }
    return docmentLibTitle;
}
- (BOOL)currentTargetPermission:(ZHTarget *)target{
    BOOL edit = NO;
    ZHUser *user = [DataManager defaultInstance].currentUser;
    // 顶级目录都没有编辑权限
    if ([SZUtil isEmptyOrNull:target.uid_target] &&[SZUtil isEmptyOrNull:target.fid_parent]) {
        edit = NO;
    }
    //
    else{
        ZHProject *project = [DataManager defaultInstance].currentProject;
        ZHUserProject *uProject = nil;
        for (ZHUserProject *userProject in project.hasUsers) {
            if (userProject.id_project == project.id_project) {
                uProject = userProject;
                break;
            }
        }
        // 项目经理或者管理员
        if (uProject.assignRole.id_role == 3 || uProject.assignRole.id_role == 4) {
            edit = YES;
        }
        // 文件所有者是不是自己
        else{
            if (user.id_user == target.owner.id_user) {
                edit = YES;
            }
            //
            else{
                // 有权限
                if (target.access_mode == 0) {
                    // allow 存在也可能有权限
                    if (target.hasAllows.count > 0) {
                        for (ZHAllow *allow in target.hasAllows) {
                            // 有自己则有权限
                            if (allow.belongUser.id_user == user.id_user && allow.allow_level == 2) {
                                edit = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    return edit;
}
- (void)showEditNameAlertView:(ZHTarget *)target{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入文件名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        NSString *fileName = alertController.textFields[0].text;
        if ([SZUtil isEmptyOrNull:fileName]) {
            [CNAlertView showWithTitle:@"文件名不能为空" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self showEditNameAlertView:target];
                }
            }];
        }else{
            [self.targetRename loadDataWithParams:@{@"uid_target":target.uid_target,@"new_name":fileName}];
        }
    }]];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新建文件名称";
        textField.delegate = self;
    }];
    [self presentViewController:alertController animated:true completion:nil];
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
        [self.tableView.mj_footer endRefreshing];
        if (manager.responsePageSize.currentCount < self.targetListManager.pageSize.pageSize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
        }
        if (self.targetListManager.pageSize.pageIndex == 1) {
            [self.fileListArray removeAllObjects];
        }
        
        [self.fileListArray addObjectsFromArray:(NSArray *)manager.response.responseData];
        [self sortfileList];
        [self.tableView showDataCount:self.fileListArray.count type:0];
        [self.containerVC fileViewListEmpty:(self.fileListArray.count <= 0)];
        [self.containerVC loadFileCatalogCollectionView];
        [self.tableView reloadData];
    }else if(manager == self.targetRename){
        
        [self.targetListManager loadData];
        
    }else if(manager == self.targetOperation){
        NSDictionary *dic = (NSDictionary *)manager.response.responseData;
        NSDictionary *result = dic[@"data"][@"results"][0];
        if (![result[@"sub_code"] isEqualToNumber:@0]) {
            [SZAlert showInfo:result[@"msg"] underTitle:TARGETS_NAME];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.targetListManager loadData];
            }];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
        }
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
- (APITargetRenameManager *)targetRename{
    if (_targetRename == nil) {
        _targetRename = [[APITargetRenameManager alloc] init];
        _targetRename.delegate = self;
        _targetRename.paramSource = self;
    }
    return _targetRename;
}
- (APITargetOperations *)targetOperation{
    if (_targetOperation == nil) {
        _targetOperation = [[APITargetOperations alloc] init];
        _targetOperation.delegate = self;
        _targetOperation.paramSource = self;
    }
    return _targetOperation;
}
- (NSMutableArray *)fileListArray{
    if (_fileListArray == nil) {
//        NSArray *result = (NSArray *)self.targetListManager.response.responseData;
//        if (self.navigationController.viewControllers.count >1) {
//            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//            NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"is_file" ascending:YES];
//            NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1,sd, nil];
//            result = [result sortedArrayUsingDescriptors:sortDescriptors];
//        }
//        _fileListArray = [NSMutableArray arrayWithArray:result];
        _fileListArray = [NSMutableArray array];
    }
    return _fileListArray;
}
- (void)sortfileList{
    NSArray *result = [NSArray arrayWithArray:self.fileListArray];
    if (self.navigationController.viewControllers.count >1) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"is_file" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1,sd, nil];
        result = [result sortedArrayUsingDescriptors:sortDescriptors];
    }
    [self.fileListArray removeAllObjects];
    [self.fileListArray addObjectsFromArray:result];
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
