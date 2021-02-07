//
//  PollingViewController.m
//  TTManager
//
//  Created by chao liu on 2021/2/3.
//

#import "PollingViewController.h"
#import "TaskParams.h"
#import "FormEditCell.h"
#import "FormImageCell.h"
#import "BottomView.h"
#import "FormHeaderView.h"
#import "WebController.h"

static NSString *textCellIndex = @"textCellIndex";
static NSString *imageCellIndex = @"ImageCellIndex";

@interface PollingViewController ()<APIManagerParamSource,ApiManagerCallBackDelegate,FormFlowManagerDelgate,UITableViewDelegate,UITableViewDataSource>

/// 表格内容
@property (nonatomic, strong) UITableView *tableView;
// 系统名称
@property (nonatomic, strong) FormEditCell *headerView;
// 底部操作栏
@property (nonatomic, strong) BottomView *bottomView;

/// 是否需要克隆当前表单
@property (nonatomic, assign) BOOL isCloneForm;

@property (nonatomic, strong) APITaskNewManager *taskNewManager;
@property (nonatomic, strong) APITaskDeatilManager *taskDetailManager;
@property (nonatomic, strong) FormFlowManager *formFlowManager;

@property (nonatomic, strong) APITaskOperationsManager *taskOperationsManager;
@property (nonatomic, strong) APITaskProcessManager *taskProcessManager;
@property (nonatomic, strong) UploadFileManager *uploadManager;

@property (nonatomic, strong) TaskParams *taskParams;
@property (nonatomic, strong) ZHTask *currentTask;
/// 附件id
@property (nonatomic, copy) NSString *buddy_file;

@end

@implementation PollingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"巡检";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isCloneForm = YES;
    [self addUI];
    [self changeEditView];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initializeImagePicker];
    self.actionSheetType = 3;
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *items = self.formFlowManager.instanceDownLoadForm[@"items"];
    return items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSArray *items = self.formFlowManager.instanceDownLoadForm[@"items"];
    NSDictionary *formItem = items[indexPath.row];
    // 静态图片
    if ([formItem[@"type"] isEqualToNumber:@7] || [formItem[@"type"] isEqualToNumber:@8]) {
        FormImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:imageCellIndex];
        if (!imageCell) {
            imageCell = [[FormImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellIndex];
        }
        [imageCell setIsFormEdit:self.formFlowManager.isEditForm indexPath:indexPath item:formItem];
        cell = imageCell;
    }else{
        FormEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:textCellIndex];
        if (!editCell) {
            editCell = [[FormEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIndex];
        }
//        editCell.templateType = 2;
        [editCell setIsFormEdit:self.formFlowManager.isEditForm indexPath:indexPath item:formItem];
        cell = editCell;
    }
    return cell;
}
#pragma mark - responsder chain

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:form_edit_item]) {
        [self.formFlowManager modifyCurrentDownLoadForm:userInfo];
    }else if ([eventName isEqualToString:delete_formItem_image]) {
        [self.formFlowManager deleteImageToCurrentImageFormItem:userInfo];
    }else if([eventName isEqualToString:save_edit_form]){
        [self.view endEditing:YES];
        [self.formFlowManager operationsFormFill];
    }else if([eventName isEqualToString:add_formItem_image]){
        [self addImageToCurrentImageFormItem:userInfo];
    }else if([eventName isEqualToString:open_form_url]){
        self.formFlowManager.isModification = YES;
        WebController *web = [[WebController alloc] init];
        web.loadUrl = userInfo[@"url"];
        [self.navigationController pushViewController:web animated:YES];
    }
    // 修改了表单内容
    else if([eventName isEqualToString:change_form_info]){
        self.formFlowManager.isModification = YES;
    }
}
#pragma mark - private

- (void)loadData{
    [self.taskNewManager loadData];
}

- (void)fillHeaderView{
    self.headerView.keyLabel.text = @"系统编号";
    self.headerView.valueTextView.text = self.formFlowManager.instanceDownLoadForm[@"instance_ident"];
    self.headerView.valueTextView.editable = NO;
}

- (void)back:(UIBarButtonItem *)item{
    [self cancelEditCurrentForm];
}

- (void)cancelEditCurrentForm{
    if (self.formFlowManager.isModification == YES) {
        [CNAlertView showWithTitle:@"温馨提示" message:@"是否保存当前修改内容" cancelButtonTitle:@"放弃" otherButtonTitles:@[@"保存"] tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self.view endEditing:YES];
                [self.formFlowManager operationsFormFill];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)normalFillFormInfo{
    ZHUser *user = [DataManager defaultInstance].currentUser;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%.0f", timeInterval*1000];

    // 日期
    NSDictionary *timedic = @{@"indexPath":[NSIndexPath indexPathForRow:0 inSection:0],@"value":time};
    // 记录人
    NSDictionary *userdic = @{@"indexPath":[NSIndexPath indexPathForRow:4 inSection:0],@"value":user.name};
    NSArray *array = @[timedic,userdic];

    for (NSDictionary *itemDic in array) {
        [self.formFlowManager modifyCurrentDownLoadForm:itemDic];
    }
}

// 添加图片到表单
- (void)addImageToCurrentImageFormItem:(NSDictionary *)addDic{
    [self pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image,NSString * _Nonnull mediaType) {
        if (imageData.length/1024 <= 100) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:addDic];
            dic[@"image"] = imageData;
            [self.formFlowManager addImageToCurrentImageFormItem:dic];
        }else{
            [SZAlert showInfo:@"上传图片不能大于100k" underTitle:TARGETS_NAME];
        }
    }];
}

#pragma mark - FormFlowManagerDelgate
// 刷新页面数据
- (void)reloadView{
    [self fillHeaderView];
    [self.tableView reloadData];
}

// 获取表单详情成功
- (void)formDetailResult:(BOOL)success{
    if (success == YES && self.isCloneForm == NO) {
        [self.formFlowManager enterEditModel];
//        [self normalFillFormInfo];
    }
}
// 表单克隆成功
- (void)formCloneTargetResult:(BOOL)success{
    if (success == YES && self.isCloneForm == YES) {
//        [self.formFlowManager enterEditModel];
//        [self normalFillFormInfo];
        self.taskParams.uid_target = self.formFlowManager.instanceBuddy_file;
        [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskFileParams:YES]];
    }
}
// 表单下载成功
- (void)formDownLoadResult:(BOOL)success{
    
}

// 表单操作完成
- (void)formOperationsFillResult:(BOOL)success{
    
}

// 表单更新完成
- (void)targetUpdateResult:(BOOL)success{
    
//    [CNAlertView showWithTitle:@"温馨提示" message:@"编辑成功,是否返回" tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];
}

#pragma mark - APIManagerParamSource

- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    if (manager == self.taskNewManager) {
        params = [self.taskParams getNewTaskParams];
    }else if(manager == self.taskDetailManager){
        params = [self.taskParams getTaskDetailsParams];
    }
    return params;
}

#pragma mark - ApiManagerCallBackDelegate

- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.taskNewManager) {
        self.currentTask = (ZHTask *)manager.response.responseData;
        self.taskParams.uid_task = self.currentTask.uid_task;
        self.formFlowManager.buddy_file = self.currentTask.firstTarget.uid_target;
        [self.formFlowManager cloneCurrentFormByBuddy_file];
    }
    else if(manager == self.taskDetailManager){
        
    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    
}

#pragma mark - ui
- (void)addUI{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
    [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.equalTo(44);
        make.left.right.equalTo(0);
        make.bottom.equalTo(-SafeAreaBottomHeight);
    }];
}

- (void)changeEditView{
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

#pragma mark - setter and getter

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //直接用估算高度
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (FormEditCell *)headerView{
    if (_headerView == nil) {
        _headerView = [[FormEditCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.valueTextView.placeholder = @"";
    }
    return _headerView;
}

- (BottomView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[BottomView alloc] init];
    }
    return _bottomView;
}
-(APITaskNewManager *)taskNewManager{
    if (_taskNewManager == nil) {
        _taskNewManager = [[APITaskNewManager alloc] init];
        _taskNewManager.delegate = self;
        _taskNewManager.paramSource = self;
    }
    return _taskNewManager;
}

-(APITaskDeatilManager *)taskDetailManager{
    if (_taskDetailManager == nil) {
        _taskDetailManager = [[APITaskDeatilManager alloc] init];
        _taskDetailManager.delegate = self;
        _taskDetailManager.paramSource = self;
    }
    return _taskDetailManager;
}

- (APITaskProcessManager *)taskProcessManager{
    if (_taskProcessManager == nil) {
        _taskProcessManager = [[APITaskProcessManager alloc] init];
        _taskProcessManager.delegate = self;
        _taskProcessManager.paramSource = self;
    }
    return _taskProcessManager;
}

- (APITaskOperationsManager *)taskOperationsManager{
    if (_taskOperationsManager == nil) {
        _taskOperationsManager = [[APITaskOperationsManager alloc] init];
        _taskOperationsManager.delegate = self;
        _taskOperationsManager.paramSource = self;
    }
    return _taskOperationsManager;
}

- (UploadFileManager *)uploadManager{
    if (_uploadManager == nil) {
        _uploadManager = [[UploadFileManager alloc] init];
    }
    return _uploadManager;
}

- (FormFlowManager *)formFlowManager{
    if (_formFlowManager == nil) {
        _formFlowManager = [[FormFlowManager alloc] init];
        _formFlowManager.delegate = self;
#warning 缺少一个文件id
//        _formFlowManager.buddy_file = self.buddy_file;
    }
    return _formFlowManager;
}

- (TaskParams *)taskParams{
    if (_taskParams == nil) {
        _taskParams = [[TaskParams alloc] init];
        _taskParams.id_flow_template = 5;
    }
    return _taskParams;
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
