//
//  BuilderDiaryController.m
//  TTManager
//
//  Created by chao liu on 2021/2/4.
//

#import "BuilderDiaryController.h"
#import "FormEditCell.h"
#import "BottomView.h"
#import "FormHeaderView.h"
#import "WebController.h"

static NSString *textCellIndex = @"textCellIndex";
static NSString *imageCellIndex = @"ImageCellIndex";

@interface BuilderDiaryController ()<UITableViewDelegate,UITableViewDataSource,FormFlowManagerDelgate>

/// 表格操作步骤
@property (nonatomic, strong)FormFlowManager *formFlowManager;
/// 表格内容
@property (nonatomic, strong) UITableView *tableView;
/// 系统名称
@property (nonatomic, strong) FormEditCell *headerView;
/// 底部操作栏
@property (nonatomic, strong) BottomView *bottomView;
/// 快照提醒
@property (nonatomic, strong) FormHeaderView *snapshootView;
@end

@implementation BuilderDiaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"施工日志";
    [self addUI];
    [self changeEditView];
    [self reloadNetwork];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initializeImagePicker];
    self.actionSheetType = 3;
}

- (void)reloadNetwork{
    if (self.isCloneForm == NO) {
        [self.formFlowManager downLoadCurrentFormJsonByBuddy_file:self.buddy_file];
    }else{
        [self.formFlowManager cloneCurrentFormByBuddy_file];
    }
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
    FormEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:textCellIndex];
    if (!editCell) {
        editCell = [[FormEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIndex];
    }
    editCell.templateType = 1;
    [editCell setIsFormEdit:self.formFlowManager.isEditForm indexPath:indexPath item:formItem];
    cell = editCell;
    return cell;
}
#pragma mark - FormFlowManagerDelgate
// 刷新页面数据
- (void)reloadView{
    [self fillHeaderView];
    [self.tableView reloadData];
}

// 获取表单详情成功
- (void)formDetailResult:(BOOL)success{
    if (success == YES) {
        [self.formFlowManager enterEditModel];
        [self normalFillFormInfo];
        
    }
}
// 表单克隆成功
- (void)formCloneTargetResult:(BOOL)success{
//    if (success == YES && self.isCloneForm == YES) {
//        [self.formFlowManager enterEditModel];
//        [self normalFillFormInfo];
//    }
}
// 表单下载成功
- (void)formDownLoadResult:(BOOL)success{
    
}

// 表单操作完成
- (void)formOperationsFillResult:(BOOL)success{
    
}

// 表单更新完成
- (void)targetUpdateResult:(BOOL)success{
    
    [CNAlertView showWithTitle:@"温馨提示" message:@"编辑成功,是否返回" tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - responsder chain

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:form_edit_item]) {
        [self.formFlowManager modifyCurrentDownLoadForm:userInfo automatic:NO];
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
- (void)normalFillFormInfo{
    ZHUser *user = [DataManager defaultInstance].currentUser;
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
//    NSString *time = [NSString stringWithFormat:@"%.0f", timeInterval*1000];

    // 星期
    NSDictionary *weekDic = @{@"indexPath":[NSIndexPath indexPathForRow:3 inSection:0],@"value":[SZUtil getCurrentWeekDay]};
    // 日期
    NSDictionary *timedic = @{@"indexPath":[NSIndexPath indexPathForRow:8 inSection:0],@"value":[SZUtil getYYYYMMDD:[NSDate date] type:1]};
    // 记录人
    NSDictionary *userdic = @{@"indexPath":[NSIndexPath indexPathForRow:10 inSection:0],@"value":user.name};
    NSArray *array = @[weekDic,timedic,userdic];

    for (NSDictionary *itemDic in array) {
        [self.formFlowManager modifyCurrentDownLoadForm:itemDic automatic:YES];
    }
}
- (void)back:(UIBarButtonItem *)item{
    [self cancelEditCurrentForm];
}

- (void)changeEditView{
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

// 添加图片到表单
- (void)addImageToCurrentImageFormItem:(NSDictionary *)addDic{
    [self pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image,NSString * _Nonnull mediaType) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:addDic];
        dic[@"image"] = imageData;
        [self.formFlowManager addImageToCurrentImageFormItem:dic];
    }];
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
}

- (void)fillHeaderView{
    NSString *value = @"";
    if (self.formFlowManager.canEditForm == NO) {
        value = self.formFlowManager.instanceDownLoadForm[@"uid_ident"];
    }else{
        value = self.formFlowManager.instanceDownLoadForm[@"instance_ident"];
    }
    [self.headerView setHeaderViewData:@{@"name":@"系统编号",@"instance_value":value == nil ? @"":value}];
}

- (void)updateSnapshootViewLayout{
    CGFloat snapshootViewH = self.formFlowManager.isSnapshoot == YES ? 44 : 0;
    self.snapshootView.update_date = self.formFlowManager.instanceDownLoadForm[@"update_date"];
    [self.snapshootView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(snapshootViewH);
    }];
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
    }
    return _headerView;
}

- (BottomView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[BottomView alloc] init];
    }
    return _bottomView;
}
- (FormFlowManager *)formFlowManager{
    if (_formFlowManager == nil) {
        _formFlowManager = [[FormFlowManager alloc] init];
        _formFlowManager.delegate = self;
        _formFlowManager.buddy_file = self.buddy_file;
    }
    return _formFlowManager;
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
