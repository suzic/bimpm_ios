//
//  FormDetailController.m
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import "FormDetailController.h"
#import "FormEditCell.h"
#import "FormImageCell.h"
#import "BottomView.h"
#import "FormHeaderView.h"
#import "FormEditButton.h"

/**
 1:下载当前表单文件form.json,之后调用detail，如果失败，则是快照，不可编辑,直接依据form.json显示app页面，步骤到此结束，否则继续下一步
 2:模版是固化的（instance_ident==nil），实例中的历史记录版本也是固化的（通过buddy_file=uid_target进行FormDetail拿不到数据的为历史记录版本）。固化的版本不需要判断是否可编辑（multi_editable是否大于0）
 3:判断是否可编辑，如果可编辑直接编辑当前表格，
 4:如果不可编辑，TargetClone，下载clone后的表单文件clone_form.json,
 5:FormOperations-FILL，更新form.json(或者clone_form.json)，使用FileUpload上传当前form.json(或者clone_form.json)
 5:最后上传成功之后 再调用TargetUpdate 告诉更新了哪个target（clone_target）。
 */

static NSString *textCellIndex = @"textCellIndex";
static NSString *imageCellIndex = @"ImageCellIndex";

@interface FormDetailController ()<UITableViewDelegate,UITableViewDataSource,ApiManagerCallBackDelegate,APIManagerParamSource,FormEditDelegate>

// 编辑按钮
@property (nonatomic, strong) FormEditButton *editButton;
// 表格内容
@property (nonatomic, strong) UITableView *tableView;
// 系统名称
@property (nonatomic, strong) FormEditCell *headerView;
// 底部操作栏
@property (nonatomic, strong) BottomView *bottomView;
// 快照提醒
@property (nonatomic, strong) FormHeaderView *snapshootView;
// 是否是快照
@property (nonatomic, assign) BOOL isSnapshoot;
// 下载的表单数据
@property (nonatomic, strong) NSMutableDictionary *downLoadformDic;
// 下载克隆后的表单数据
@property (nonatomic, strong) NSMutableDictionary *downLoadCloneformDic;
// 原始数据
@property (nonatomic, strong) NSMutableDictionary *formDic;
// 克隆的表单
@property (nonatomic, strong) NSMutableDictionary *cloneFormDic;
// 当前表单是否可克隆
@property (nonatomic, assign) BOOL canCloneForm;
// 是否是克隆
@property (nonatomic, assign) BOOL isCloneForm;

// 当前下载的json是否可编辑
@property (nonatomic, assign) BOOL canEditForm;
// 是否是编辑状态
@property (nonatomic, assign) BOOL isEditForm;
// 克隆后的buddy_file
@property (nonatomic, copy) NSString *clone_buddy_file;
// 获取表单json
@property (nonatomic, strong) APIFileDownLoadManager *downLoadManager;
// api表单详情
@property (nonatomic, strong) APIFormDetailManager *formDetailManager;
// api克隆表单
@property (nonatomic, strong) APITargetCloneManager *targetCloneManager;
// api表单操作
@property (nonatomic, strong) APIFormOperationsManager *formOperationsManager;
// 上传表单文件
@property (nonatomic, strong) APIUploadFileManager *uploadfileManager;
// 上传表单文件
@property (nonatomic, strong) APITargetUpdateManager *targetUpdateManager;
@end

@implementation FormDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"表单详情";
    self.isCloneForm = NO;
    self.isEditForm = NO;
    self.canCloneForm = NO;
    self.isSnapshoot = NO;
    [self addUI];
    [self downLoadCurrentFormJsonByBuddy_file:self.buddy_file];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *items = self.instanceDownLoadForm[@"items"];
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
    NSArray *items = self.instanceDownLoadForm[@"items"];
    NSDictionary *formItem = items[indexPath.row];
    // 静态图片
    if ([formItem[@"type"] isEqualToNumber:@7] || [formItem[@"type"] isEqualToNumber:@8]) {
        FormImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:imageCellIndex];
        if (!imageCell) {
            imageCell = [[FormImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellIndex];
        }
        [imageCell setIsFormEdit:self.isEditForm indexPath:indexPath item:formItem];
        cell = imageCell;
    }else{
        FormEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:textCellIndex];
        if (!editCell) {
            editCell = [[FormEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIndex];
        }
        [editCell setIsFormEdit:self.isEditForm indexPath:indexPath item:formItem];
        cell = editCell;
    }
    return cell;
}
#pragma mark - network
// 下载当前form表单
- (void)downLoadCurrentFormJsonByBuddy_file:(NSString *)buddy_file{
    self.downLoadManager.uid_target = buddy_file;
    [self.downLoadManager loadData];
}
// 查看当前表单详情，如果没有是快照 只读，如果有则继续下一步
- (void)getFromDetailByBuddy_file:(NSString *)buddy_file{
    [self.formDetailManager loadData];
}
// 克隆当前表单，克隆成功之后 调用下载clone后的表单
- (void)cloneCurrentFormByBuddy_file:(NSString *)buddy_file{
    [self.downLoadManager loadData];
}
// 填充当前表单
- (void)operationsFormFill:(NSDictionary *)params{
    [self.formOperationsManager loadData];
}
// 上传填充之后的表单
- (void)uploadFillSuccessLaterFrom:(NSDictionary *)fillFrom{
    [self.uploadfileManager loadData];
}
// 通知服务器，我更新了哪个文件
- (void)informTargetUpdateByBuddy_file:(NSString *)buddy_file{
    [self.targetUpdateManager loadData];
}
#pragma mark - FormEditDelegate
- (void)startEditCurrentForm{
    if (self.canEditForm == NO) {
        [self.targetCloneManager loadData];
    }else{
        self.isEditForm = YES;
        [self.editButton resetEditButtonStyle:NO];
        [self.tableView reloadData];
    }
}
- (void)cancelEditCurrentForm{
    self.isEditForm = NO;
    [self.editButton resetEditButtonStyle:YES];
    [self.tableView reloadData];
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    if (manager == self.formDetailManager) {
        params = @{@"buddy_file": self.instanceBuddy_file};
    }else if(manager == self.formOperationsManager){
        params = [self getOperationsFromParams];
    }else if(manager == self.targetCloneManager){
        params = @{@"clone_module":[NSNull null],
                   @"clone_parent":[NSNull null],
                   @"new_name":[NSNull null],
                   @"source_target":self.buddy_file};
    }else if(manager == self.uploadfileManager){
        NSString *data = [SZUtil convertToJsonData:self.instanceDownLoadForm];
        NSDictionary *upload = @{@"name":self.instanceDownLoadForm[@"name"],@"type":@"json",@"data":data};
        [self.uploadfileManager.uploadArray addObject: upload];
        params = @{@"id_project":[NSString stringWithFormat:@"%@",self.instanceFromDic[@"fid_project"]],
                   @"uid_target":self.instanceBuddy_file};
    }else if(manager == self.targetUpdateManager){
        params = @{@"id_project":self.instanceFromDic[@"fid_project"],@"uid_target":self.instanceBuddy_file};
    }
    return params;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    NSDictionary *data = (NSDictionary *)manager.response.responseData;
    if (manager == self.formDetailManager) {
        [self getFormItemInfo:data];
        [self fillHeaderView];
        [self judgeDownLoadFormIsEditClone];
        [self.tableView reloadData];
    }else if(manager == self.formOperationsManager){
        NSDictionary *dic = (NSDictionary *)manager.response.responseData;
        if ([dic[@"code"] isEqualToNumber:@0]) {
            [self.uploadfileManager loadData];
        }
    }else if(manager == self.targetCloneManager){
        self.isCloneForm = YES;
        self.isEditForm = YES;
        [self.editButton resetEditButtonStyle:NO];
        NSDictionary *dic = manager.response.responseData;
        self.clone_buddy_file = dic[@"data"][@"target_info"][@"uid_target"];
        [self downLoadCurrentFormJsonByBuddy_file:self.instanceBuddy_file];
        
    }else if(manager == self.uploadfileManager){
        [self.targetUpdateManager loadData];
    }else if(manager == self.targetUpdateManager){
        [SZAlert showInfo:@"TargetUpdate成功" underTitle:TARGETS_NAME];
    }else if(manager == self.downLoadManager){
        NSLog(@"下载表单成功");
        [self setCloneFormInfo:data];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.formDetailManager) {
    }else if(manager == self.formOperationsManager){
    }else if(manager == self.targetCloneManager){
    }else if(manager == self.uploadfileManager){
    }else if(manager == self.targetUpdateManager){
    }else if(manager == self.downLoadManager){
    }
}

#pragma mark - responsder chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:form_edit_item]) {
        [self modifyCurrentDownLoadForm:userInfo];
    }else if ([eventName isEqualToString:delete_formItem_image]) {
        NSIndexPath *formItemIndex = userInfo[@"formItemIndex"];
        NSIndexPath *deleteImageIndex = userInfo[@"deleteIndex"];
        NSLog(@"当前删除的formItem下标 == %ld 当前删除的图片的下标 == %ld",(long)formItemIndex.row,deleteImageIndex.row);
//        [self modifyCurrentDownLoadForm:userInfo];
    }else if([eventName isEqualToString:save_edit_form]){
        NSLog(@"保存当前编辑的表单");
        [self operationsFormFill:nil];
    }
}

#pragma mark - private
// 获取操作后的提交的参数
- (NSMutableDictionary *)getOperationsFromParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"code":@"FILL",@"instance_ident":self.instanceFromDic[@"instance_ident"],@"id_project":self.instanceFromDic[@"buddy_file"][@"fid_project"]}];
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *formItem in self.instanceFromDic[@"items"]) {
        NSString *instance_value = formItem[@"instance_value"];
        if ([SZUtil isEmptyOrNull:instance_value]) {
            instance_value = @"";
        }
        NSDictionary *itemDic = @{@"ident":formItem[@"uid_item"],@"instance_value":instance_value};
        [items addObject:itemDic];
    }
    params[@"info"] = items;
    return params;
}
// 设置获取的表单详情数据
- (void)getFormItemInfo:(NSDictionary *)form{
    if (self.isCloneForm == NO) {
        if ([form[@"data"][@"form_info"] isKindOfClass:[NSDictionary class]]) {
            self.formDic = [NSMutableDictionary dictionaryWithDictionary: form[@"data"][@"form_info"]];
        }
    }else{
        self.cloneFormDic = [NSMutableDictionary dictionaryWithDictionary: form[@"data"][@"form_info"]];
    }
}
// 设置当前clong后的表单数据
- (void)setCloneFormInfo:(NSDictionary *)form{
    if (self.isCloneForm == NO) {
        self.downLoadformDic = [NSMutableDictionary dictionaryWithDictionary: form];
    }else{
        self.downLoadCloneformDic = [NSMutableDictionary dictionaryWithDictionary: form];
    }
    // 获取表单详情
    [self getFromDetailByBuddy_file:self.instanceBuddy_file];
}
// 修改当前编辑的数据(包含显示的form和下载的form)
- (void)modifyCurrentDownLoadForm:(NSDictionary *)modifyData{
    // 显示的数据
    NSIndexPath *indexPath = modifyData[@"indexPath"];
    NSString *value = modifyData[@"value"];
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.instanceDownLoadForm[@"items"]];
    NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:items[indexPath.row]];
    itemDic[@"instance_value"] = [NSString stringWithFormat:@"%@",value];
    items[indexPath.row] = itemDic;
    self.instanceDownLoadForm[@"items"] = items;
    
    // fill 的数据
    NSMutableArray *currentitems = [NSMutableArray arrayWithArray:self.instanceFromDic[@"items"]];
    NSMutableDictionary *currentitemDic = [NSMutableDictionary dictionaryWithDictionary:currentitems[indexPath.row]];
    currentitemDic[@"instance_value"] = [NSString stringWithFormat:@"%@",value];
    currentitems[indexPath.row] = currentitemDic;
    self.instanceFromDic[@"items"] = currentitems;
    
    [self.tableView reloadData];
}
// 判断当前表单是否可编辑可克隆
- (void)judgeDownLoadFormIsEditClone{
    
    // instance_ident 为nil，则不可编辑
    if ([SZUtil isEmptyOrNull:self.instanceDownLoadForm[@"instance_ident"]]) {
        self.canEditForm = NO;
        self.canCloneForm = YES;
    }else{
        // 快照，不可编辑，不可克隆
        if (self.instanceFromDic.allKeys.count <= 0) {
            self.canEditForm = NO;
            self.canCloneForm = NO;
            self.isSnapshoot = YES;
        }else{
             int multi_editable = [self.instanceFromDic[@"buddy_file"][@"multi_editable"] intValue];
            self.isSnapshoot = NO;
            self.canEditForm = multi_editable > 0;
            self.canCloneForm = YES;
        }
    }
    [self changeEditView];
    [self updateSnapshootViewLayout];
    [self.tableView reloadData];
}
#pragma mark - UI
- (void)addUI{
    [self.view addSubview:self.snapshootView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    [self.snapshootView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(0);
    }];
    
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.snapshootView.mas_bottom);
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
    [self changeEditView];
}

- (void)fillHeaderView{
    self.headerView.keyLabel.text = @"系统编号";
    if ([SZUtil isEmptyOrNull:self.instanceDownLoadForm[@"instance_ident"]]) {
        self.headerView.valueTextView.text = self.instanceDownLoadForm[@"uid_ident"];
    }else{
        self.headerView.valueTextView.text = self.instanceDownLoadForm[@"instance_ident"];
    }
    self.headerView.valueTextView.editable = NO;
}
- (void)changeEditView{
    // 快照直接不显示
    if (self.isSnapshoot == YES) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        UIBarButtonItem *rightCustomView = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
        self.navigationItem.rightBarButtonItem = rightCustomView;    }
}
- (void)updateSnapshootViewLayout{
    CGFloat snapshootViewH = self.isSnapshoot == YES ? 44 : 0;
    [self.snapshootView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(snapshootViewH);
    }];
}
#pragma mark - setter and getter
- (FormEditButton *)editButton{
    if (_editButton == nil) {
        _editButton = [[FormEditButton alloc] init];
        _editButton.frame = CGRectMake(0, 0, 80, 44);
        _editButton.delegate = self;
    }
    return _editButton;
}
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

- (FormHeaderView *)snapshootView{
    if (_snapshootView == nil) {
        _snapshootView = [[FormHeaderView alloc] init];
    }
    return _snapshootView;
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
- (NSMutableDictionary *)downLoadformDic{
    if (_downLoadformDic == nil) {
        _downLoadformDic = [NSMutableDictionary dictionary];
    }
    return _downLoadformDic;
}
- (NSMutableDictionary *)downLoadCloneformDic{
    if (_downLoadCloneformDic == nil) {
        _downLoadCloneformDic = [NSMutableDictionary dictionary];
    }
    return _downLoadCloneformDic;
}
- (NSMutableDictionary *)formDic{
    if (_formDic == nil) {
        _formDic = [NSMutableDictionary dictionary];
    }
    return _formDic;
}
- (NSMutableDictionary *)cloneFormDic{
    if (_cloneFormDic == nil) {
        _cloneFormDic = [NSMutableDictionary dictionary];
    }
    return _cloneFormDic;
}
- (NSMutableDictionary *)instanceFromDic{
    if (self.isCloneForm == NO) {
        return self.formDic;
    }else if(self.isCloneForm == YES){
        return self.cloneFormDic;
    }
    return nil;
}
- (NSMutableDictionary *)instanceDownLoadForm{
    if (self.isEditForm == NO) {
        return self.downLoadformDic;
    }else if(self.isEditForm == YES && self.isCloneForm == NO){
        return self.downLoadformDic;
    }else if(self.isEditForm == YES && self.isCloneForm == YES){
        return self.downLoadCloneformDic;
    }
    return nil;
}
- (NSString *)instanceBuddy_file{
    if (self.isEditForm == NO) {
        return self.buddy_file;
    }else if(self.isEditForm == YES && self.isCloneForm == NO){
        return self.buddy_file;
    }
    else{
        return self.clone_buddy_file;
    }
}
#pragma mark - api
-(APIFileDownLoadManager *)downLoadManager{
    if (_downLoadManager == nil) {
        _downLoadManager = [[APIFileDownLoadManager alloc] init];
        _downLoadManager.delegate = self;
        _downLoadManager.paramSource = self;
    }
    return _downLoadManager;
}
- (APIFormDetailManager *)formDetailManager{
    if (_formDetailManager == nil) {
        _formDetailManager = [[APIFormDetailManager alloc] init];
        _formDetailManager.delegate = self;
        _formDetailManager.paramSource = self;
    }
    return _formDetailManager;
}
- (APITargetCloneManager *)targetCloneManager{
    if (_targetCloneManager == nil) {
        _targetCloneManager = [[APITargetCloneManager alloc] init];
        _targetCloneManager.delegate = self;
        _targetCloneManager.paramSource = self;
    }
    return _targetCloneManager;
}
- (APIFormOperationsManager *)formOperationsManager{
    if (_formOperationsManager == nil) {
        _formOperationsManager = [[APIFormOperationsManager alloc] init];
        _formOperationsManager.delegate = self;
        _formOperationsManager.paramSource = self;
    }
    return _formOperationsManager;
}
- (APIUploadFileManager *)uploadfileManager{
    if (_uploadfileManager == nil) {
        _uploadfileManager = [[APIUploadFileManager alloc] init];
        _uploadfileManager.delegate = self;
        _uploadfileManager.paramSource = self;
    }
    return _uploadfileManager;
}
- (APITargetUpdateManager *)targetUpdateManager{
    if (_targetUpdateManager == nil) {
        _targetUpdateManager = [[APITargetUpdateManager alloc] init];
        _targetUpdateManager.delegate = self;
        _targetUpdateManager.paramSource = self;
    }
    return _targetUpdateManager;
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
