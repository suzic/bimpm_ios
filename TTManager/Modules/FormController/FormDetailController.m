//
//  FormDetailController.m
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import "FormDetailController.h"
#import "FormEditCell.h"
#import "FormImageCell.h"

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

@interface FormDetailController ()<UITableViewDelegate,UITableViewDataSource,ApiManagerCallBackDelegate,APIManagerParamSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FormEditCell *headerView;

// 当前原始表单数据
@property (nonatomic, strong) ZHForm *currentFrom;
// 原始数据
@property (nonatomic, strong) NSMutableArray *formItemsArray;
// 克隆的表单
@property (nonatomic, strong) NSMutableArray *cloneFormItemsArray;
// 是否是克隆
@property (nonatomic, assign) BOOL isCloneFormItem;
// 克隆后的buddy_file
@property (nonatomic, copy) NSString *clone_buddy_file;
// 克隆后的表单数据
@property (nonatomic, strong) ZHForm *cloneCurrentFrom;
// 是否是编辑状态
@property (nonatomic, assign) BOOL isEditForm;
// api表单详情
@property (nonatomic, strong) APIFormDetailManager *formDetailManager;
// api表单操作
@property (nonatomic, strong) APIFormOperationsManager *formOperationsManager;
// api克隆表单
@property (nonatomic, strong) APITargetCloneManager *targetCloneManager;

@end

@implementation FormDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"表单详情";
    self.isCloneFormItem = NO;
    self.isEditForm = NO;
    [self addUI];
    [self.formDetailManager loadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.instanceFromArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headerView.keyLabel.text = @"系统编号";
    self.headerView.valueTextField.text =  self.instanceFrom.instance_ident;
    self.headerView.valueTextField.enabled = NO;
    return self.headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row % 2 == 0) {
        FormEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:textCellIndex];
        if (!editCell) {
            editCell = [[FormEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIndex];
        }
        
        ZHFormItem *item = self.instanceFromArray[indexPath.row];
        [editCell setIsFormEdit:self.isEditForm indexPath:indexPath item:item];
        cell = editCell;
    }else{
        FormImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:imageCellIndex];
        if (!imageCell) {
            imageCell = [[FormImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellIndex];
        }
        cell = imageCell;
    }
    return cell;
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    if (manager == self.formDetailManager) {
        params = @{@"buddy_file": self.isCloneFormItem == YES ? self.clone_buddy_file :self.buddy_file};
    }else if(manager == self.formOperationsManager){
        params = [self getOperationsFromParams];
    }else if(manager == self.targetCloneManager){
        params = @{@"clone_module":[NSNull null],
                   @"clone_parent":[NSNull null],
                   @"new_name":[NSNull null],
                   @"source_target":self.buddy_file};
    }
    return params;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.formDetailManager) {
        if (self.isCloneFormItem == NO) {
            self.currentFrom = (ZHForm *)manager.response.responseData;
        }else if(self.isCloneFormItem == YES){
            self.cloneCurrentFrom = (ZHForm *)manager.response.responseData;
        }
        [self getFormItemInfo];
        [self.tableView reloadData];
    }else if(manager == self.formOperationsManager){
        
    }else if(manager == self.targetCloneManager){
        self.isCloneFormItem = YES;
        NSDictionary *dic = manager.response.responseData;
        self.clone_buddy_file = dic[@"data"][@"target_info"][@"uid_target"];
        [self.formDetailManager loadData];
        
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.formDetailManager) {
        
    }else if(manager == self.formOperationsManager){
        
    }else if(manager == self.targetCloneManager){
    }
}

#pragma mark - responsder chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    NSIndexPath *indexPath = userInfo[@"indexPath"];
    NSString *value = userInfo[@"value"];
    ZHFormItem *item = self.instanceFromArray[indexPath.row];
    item.instance_value = [NSString stringWithFormat:@"%@",value];
    [self.tableView reloadData];
}
#pragma mark - Action
- (void)editAction:(UIBarButtonItem *)barItem{
    if (self.isEditForm == NO) {
        [self.targetCloneManager loadData];
    }
    else if (self.isEditForm == YES) {
        [self.formOperationsManager loadData];
    }
    self.isEditForm = ! self.isEditForm;
    barItem.title = self.isEditForm == YES ? @"完成":@"编辑";
    [self.tableView reloadData];
}
- (NSMutableDictionary *)getOperationsFromParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"code":@"FILL",@"instance_ident":self.instanceFrom.instance_ident,@"id_project":INT_32_TO_STRING(self.instanceFrom.belongProject.id_project)}];
    NSMutableArray *items = [NSMutableArray array];
    for (ZHFormItem *formItem in self.instanceFromArray) {
        NSDictionary *itemDic = @{@"ident":formItem.uid_item,@"instance_value":formItem.instance_value};
        [items addObject:itemDic];
    }
    params[@"info"] = items;
    return params;
}
- (void)getFormItemInfo{
    NSArray *result = [NSArray array];
    if (self.isCloneFormItem == NO) {
        [self.formItemsArray removeAllObjects];
        result = [self.currentFrom.hasItems allObjects];
    }else if(self.isCloneFormItem == YES){
        [self.cloneFormItemsArray removeAllObjects];
        result = [self.cloneCurrentFrom.hasItems allObjects];
    }
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"order_index" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    NSArray *sortArray = [result sortedArrayUsingDescriptors:sortDescriptors];
    if (self.isCloneFormItem == NO) {
        [self.formItemsArray addObjectsFromArray:sortArray];
    }else{
        [self.cloneFormItemsArray addObjectsFromArray:sortArray];
    }
}
#pragma mark - UI
- (void)addUI{
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.right.bottom.equalTo(0);
    }];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItem = barItem;
}
#pragma mark - setter and getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //直接用估算高度
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}
- (FormEditCell *)headerView{
    if (_headerView == nil) {
        _headerView = [[FormEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
- (NSMutableArray *)instanceFromArray{
    if (self.isCloneFormItem == NO) {
        return self.formItemsArray;
    }else if(self.isCloneFormItem == YES){
        return self.cloneFormItemsArray;
    }
    return nil;
}
- (ZHForm *)instanceFrom{
    if (self.isCloneFormItem == NO) {
        return self.currentFrom;
    }else if(self.isCloneFormItem == YES){
        return  self.cloneCurrentFrom;
    }
    return nil;
}

- (NSMutableArray *)formItemsArray{
    if (_formItemsArray == nil) {
        _formItemsArray = [NSMutableArray array];
    }
    return _formItemsArray;
}
- (NSMutableArray *)cloneFormItemsArray{
    if (_cloneFormItemsArray == nil) {
        _cloneFormItemsArray = [NSMutableArray array];
    }
    return _cloneFormItemsArray;
}
- (APIFormDetailManager *)formDetailManager{
    if (_formDetailManager == nil) {
        _formDetailManager = [[APIFormDetailManager alloc] init];
        _formDetailManager.delegate = self;
        _formDetailManager.paramSource = self;
    }
    return _formDetailManager;
}
- (APIFormOperationsManager *)formOperationsManager{
    if (_formOperationsManager == nil) {
        _formOperationsManager = [[APIFormOperationsManager alloc] init];
        _formOperationsManager.delegate = self;
        _formOperationsManager.paramSource = self;
    }
    return _formOperationsManager;
}
- (APITargetCloneManager *)targetCloneManager{
    if (_targetCloneManager == nil) {
        _targetCloneManager = [[APITargetCloneManager alloc] init];
        _targetCloneManager.delegate = self;
        _targetCloneManager.paramSource = self;
    }
    return _targetCloneManager;
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
