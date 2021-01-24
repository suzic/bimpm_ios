//
//  FormDetailController.m
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import "FormDetailController.h"
#import "FormEditCell.h"

@interface FormDetailController ()<UITableViewDelegate,UITableViewDataSource,ApiManagerCallBackDelegate,APIManagerParamSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FormEditCell *headerView;
@property (nonatomic, strong) NSMutableArray *formItemsArray;
@property (nonatomic, assign) BOOL isEditForm;

@property (nonatomic, strong) APIFormDetailManager *formDetailManager;
@property (nonatomic, strong) APIFormOperationsManager *formOperationsManager;

@property (nonatomic, strong) ZHForm *currentFrom;
@end

@implementation FormDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"表单详情";
    self.isEditForm = NO;
    [self addUI];
    [self.formDetailManager loadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.formItemsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headerView.keyLabel.text = @"系统编号";
    self.headerView.valueTextField.text = self.currentFrom.uid_ident;
    self.headerView.valueTextField.enabled = NO;
    return self.headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    FormEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FormEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setIsFormEdit:self.isEditForm indexPath:indexPath item:self.formItemsArray[indexPath.row]];
    return cell;
}
- (void)getFormItemInfo{
    [self.formItemsArray removeAllObjects];
    NSArray *array = [self.currentFrom.hasItems allObjects];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"order_index" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    [self.formItemsArray addObjectsFromArray:[array sortedArrayUsingDescriptors:sortDescriptors]];
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    if (manager == self.formDetailManager) {
        params = @{@"buddy_file":self.buddy_file};
    }else if(manager == self.formOperationsManager){
        params = [self getOperationsFromParams];
    }
    return params;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.formDetailManager) {
        self.currentFrom = (ZHForm *)manager.response.responseData;
        [self getFormItemInfo];
        [self.tableView reloadData];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.formDetailManager) {
        
    }
}
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    NSIndexPath *indexPath = userInfo[@"indexPath"];
    NSString *value = userInfo[@"value"];
    ZHFormItem *item = self.formItemsArray[indexPath.row];
    item.d_name = [NSString stringWithFormat:@"%@",value];
    [self.tableView reloadData];
}
#pragma mark - Action
- (void)editAction:(UIBarButtonItem *)barItem{
    if (self.isEditForm == YES) {
        [self.formOperationsManager loadData];
    }
    self.isEditForm = ! self.isEditForm;
    barItem.title = self.isEditForm == YES ? @"完成":@"编辑";
    [self.tableView reloadData];
}
#pragma mark - UI
- (void)addUI{
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(10);
        make.right.bottom.equalTo(-10);
    }];
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = RGB_COLOR(102, 102, 102).CGColor;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (NSMutableDictionary *)getOperationsFromParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"code":@"FILL",@"instance_ident":@"Lc-0008",@"id_project":INT_32_TO_STRING(self.currentFrom.belongProject.id_project)}];
    NSMutableArray *items = [NSMutableArray array];
    for (ZHFormItem *formItem in self.formItemsArray) {
        NSDictionary *itemDic = @{@"ident":formItem.uid_item,@"instance_value":formItem.d_name};
        [items addObject:itemDic];
    }
    params[@"info"] = items;
    return params;
}
#pragma mark - setter and getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;        
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
- (NSMutableArray *)formItemsArray{
    if (_formItemsArray == nil) {
        _formItemsArray = [NSMutableArray array];
    }
    return _formItemsArray;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
