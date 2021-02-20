//
//  PollingFormView.m
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import "PollingFormView.h"
#import "FormEditCell.h"
#import "FormItemSectionView.h"
#import "WebController.h"
#import "FormQRCodeView.h"
#import "PollingHeaderView.h"

static NSString *textCellIndex = @"textCellIndex";
static NSString *headerCell = @"headerCell";

@interface PollingFormView ()<UITableViewDelegate,UITableViewDataSource,FormFlowManagerDelgate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FormQRCodeView *QRCodeView;

@property (nonatomic, strong) PollingHeaderView *pollingUser;

/// 当前展开的section
@property (nonatomic, strong) NSMutableArray *expandSectionArray;

/// 当前section数据
@property (nonatomic, strong) NSMutableArray *sectionArray;

// 系统名称
@property (nonatomic, strong) FormEditCell *headerView;

@property (nonatomic, strong) FormFlowManager *formFlowManager;

/// 当前表单id
@property (nonatomic, copy) NSString *buddy_file;

/// 已经加载表单成功
@property (nonatomic, assign) BOOL loadFormSuccess;

@property (nonatomic, copy) SaveFromBlock saveBlock;

@end

@implementation PollingFormView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.currentStep = NSNotFound;
        self.loadFormSuccess = NO;
        [self addUI];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *sectionString = [NSString stringWithFormat:@"%ld",section];
    BOOL isExpand = [self.expandSectionArray containsObject:sectionString];
    switch (section) {
        case 0:
            return isExpand == YES ? 6:0;
            break;
        case 1:
            return isExpand == YES ? 4:0;
            break;
        case 2:
            return isExpand == YES ? 2:0;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    FormItemSectionView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerCell];
    if (self.sectionArray.count >0) {
        NSDictionary *dic = self.sectionArray[section];
        NSInteger row = section == 0 ? 0:(section == 1 ? 7 :11);
        [headerView setIsFormEdit:NO indexPath:[NSIndexPath indexPathForRow:row inSection:0] item:dic];
        
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandSection:)];
    headerView.tag = section;
    [headerView addGestureRecognizer:tap];
    headerView.contentView.backgroundColor = [UIColor lightGrayColor];
    headerView.backgroundColor = [UIColor lightGrayColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSArray *items = self.formFlowManager.instanceDownLoadForm[@"items"];
    NSDictionary *formItem = items[indexPath.row+1];
    
    FormEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:textCellIndex];
    if (!editCell) {
        editCell = [[FormEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIndex];
    }
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    BOOL isEdit = [self getCurrentSectionEdit:indexPath.section itemData:formItem];
    [editCell setIsFormEdit:isEdit indexPath:currentIndexPath item:formItem];
    cell = editCell;
    
    return cell;
}

#pragma mark - responsder chain

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:form_edit_item]) {
        [self.formFlowManager modifyCurrentDownLoadForm:userInfo];
    }else if ([eventName isEqualToString:delete_formItem_image]) {
        [self.formFlowManager deleteImageToCurrentImageFormItem:userInfo];
    }else if([eventName isEqualToString:save_edit_form]){
        [self endEditing:YES];
        [self.formFlowManager operationsFormFill];
        if ([SZUtil isEmptyOrNull:userInfo[@"sava"]]) {
            [super routerEventWithName:save_edit_form userInfo:@{}];
        }
    }else if([eventName isEqualToString:add_formItem_image]){
        [self addImageToCurrentImageFormItem:userInfo];
    }else if([eventName isEqualToString:open_form_url]){
        self.formFlowManager.isModification = YES;
        WebController *web = [[WebController alloc] init];
        web.loadUrl = userInfo[@"url"];
        [[SZUtil getCurrentVC].navigationController pushViewController:web animated:YES];
    }
    // 修改了表单内容
    else if([eventName isEqualToString:change_form_info]){
        self.formFlowManager.isModification = YES;
    }
}

// 添加图片到表单
- (void)addImageToCurrentImageFormItem:(NSDictionary *)addDic{
    [[SZUtil getCurrentVC] pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image,NSString * _Nonnull mediaType) {
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
    [self getHeaderData];
    [self fillPollingUser];
    [self.tableView reloadData];
}

// 获取表单详情成功
- (void)formDetailResult:(BOOL)success{
    if (success == YES) {
        if (self.formFlowManager.canEditForm == NO && self.needClone == YES) {
            [self.formFlowManager cloneCurrentFormByBuddy_file];
        }else{
            [self.formFlowManager enterEditModel];
            [self normalFillFormInfo];
        }
        self.loadFormSuccess = YES;
    }else{
        self.loadFormSuccess = NO;
    }
    self.QRCodeView.QRCodeString = [self getDownLoadFormUrl];
    
    // 如果是克隆则通知页面替换附件
    if (self.formFlowManager.isCloneForm == YES) {
        [self routerEventWithName:save_edit_form userInfo:@{}];
    }
}

// 表单克隆成功
- (void)formCloneTargetResult:(BOOL)success{
    if (success == YES) {
//        [self.formFlowManager enterEditModel];
//        [self normalFillFormInfo];
//        self.taskParams.uid_target = self.formFlowManager.instanceBuddy_file;
//        [self.taskOperationsManager loadDataWithParams:[self.taskParams getTaskFileParams:YES]];
    }
}
// 表单下载成功
- (void)formDownLoadResult:(BOOL)success{
    if (success == YES) {
        
    }
}

// 表单操作完成
- (void)formOperationsFillResult:(BOOL)success{
    
}

// 表单更新完成
- (void)targetUpdateResult:(BOOL)success{
    if (self.saveBlock) {
        self.formFlowManager.isModification = NO;
        self.saveBlock(success);
    }
//    [CNAlertView showWithTitle:@"温馨提示" message:@"编辑成功,是否返回" tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];
}

#pragma mark - public

- (void)setPollingUser:(NSString *)user index:(NSInteger)index{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"value":user}];
    if (index == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        dic[@"indexPath"] = indexPath;
    }else if(index == 1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        dic[@"indexPath"] = indexPath;
    }else if(index == 2){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:11 inSection:0];
        dic[@"indexPath"] = indexPath;
    }
    [self.formFlowManager modifyCurrentDownLoadForm:dic];
    [self saveForm:^(BOOL success) {
        
    }];
}

#pragma mark - private

// 点击展开section
- (void)expandSection:(UITapGestureRecognizer *)tap{
    UIView *header = tap.view;
    NSInteger section = header.tag;
    NSString *sectionString = [NSString stringWithFormat:@"%ld",section];
    
    // 不是当前步骤并且没有负责人不允许展开
    if (self.currentStep != section) {
        NSDictionary *sectionItem = self.sectionArray[section];
        // 如果当前没有对应负责人，不允许展开
        if ([SZUtil isEmptyOrNull:sectionItem[@"instance_value"]]) {
            return;
        }
    }
    self.currentStep = section;
    // 已经展开点击收起，否则展开
    if ([self.expandSectionArray containsObject:sectionString]) {
        [self.expandSectionArray removeObject:sectionString];
    }else{
        [self.expandSectionArray addObject:sectionString];
    }
    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationFade];
    [self fillPollingUser];
}

- (NSString *)getDownLoadFormUrl{
    NSString *url = [NSString stringWithFormat:@"%@%@",FILESERVICEADDRESS,URL_FILE_DOWNLOAD(self.formFlowManager.instanceBuddy_file)];
    return url;
}

- (void)fillPollingUser{
    if (self.currentStep == NSNotFound) {
        return;
    }
    NSDictionary *sectionItem = self.sectionArray[self.currentStep];
    NSString *instance_value = @"";
    if (![SZUtil isEmptyOrNull:self.formFlowManager.instanceFromDic[@"buddy_file"][@"name"]]) {
        self.formName = self.formFlowManager.instanceFromDic[@"buddy_file"][@"name"];
    }
    if (![SZUtil isEmptyOrNull:sectionItem[@"instance_value"]]) {
        instance_value = sectionItem[@"instance_value"];
    }
    
    [self.pollingUser setFormHeaderData:@{@"code":self.formName,@"name":instance_value} index:self.currentStep];
}
- (void)fillHeaderView{
//    NSString *value = @"";
//    if (self.formFlowManager.canEditForm == NO) {
//        value = self.formFlowManager.instanceDownLoadForm[@"uid_ident"];
//    }else{
//    }
    NSString *value = self.formFlowManager.instanceDownLoadForm[@"instance_ident"];

    [self.headerView setHeaderViewData:@{@"name":@"系统编号",@"instance_value":value ==nil ? @"":value}];
}
// 获取当前表单详情
- (void)getCurrentFormDetail:(NSString *)buddy_file
{
    if (![buddy_file isEqualToString:self.buddy_file] && self.loadFormSuccess == NO) {
        self.buddy_file = buddy_file;
        [self.formFlowManager downLoadCurrentFormJsonByBuddy_file:buddy_file];
    }
}

- (void)saveForm:(SaveFromBlock)saveBlock{
    self.saveBlock = saveBlock;
    if (self.formFlowManager.isModification == YES && self.formFlowManager.isSnapshoot == NO) {
        [self.formFlowManager operationsFormFill];
    }else{
        self.saveBlock(YES);
    }
}

// 默认填充的数据
- (void)normalFillFormInfo{
    ZHUser *user = [DataManager defaultInstance].currentUser;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%.0f", timeInterval*1000];

    // 日期
    NSDictionary *timedic = @{@"indexPath":[NSIndexPath indexPathForRow:2 inSection:0],@"value":time};
    // 记录人
    NSDictionary *userdic = @{@"indexPath":[NSIndexPath indexPathForRow:0 inSection:0],@"value":user.name};
    NSArray *array = @[timedic,userdic];

    for (NSDictionary *itemDic in array) {
        [self.formFlowManager modifyCurrentDownLoadForm:itemDic];
    }
    self.formFlowManager.isModification = NO;
    
//    [self saveForm];
    
    [self fillPollingUser];
}

- (NSMutableArray *)getHeaderData{
    NSArray *items = self.formFlowManager.instanceDownLoadForm[@"items"];
    if (items && items.count > 0) {
        [self.sectionArray removeAllObjects];
        [self.sectionArray addObject:items[0]];
        [self.sectionArray addObject:items[7]];
        [self.sectionArray addObject:items[11]];
    }
    return self.sectionArray;
    
}

- (BOOL)getCurrentSectionEdit:(NSInteger)section itemData:(NSDictionary *)formItem{
    BOOL edit = NO;
    NSInteger type = [formItem[@"type"] intValue];
    if (section == self.currentStep) {
        if (type != 3 && type != 4) {
            edit = YES;
        }
    }
    return edit;
}

#pragma mark - UI

- (void)addUI{
    [self addSubview:self.pollingUser];
    [self addSubview:self.headerView];
    [self addSubview:self.tableView];
    [self addSubview:self.QRCodeView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_COLOR(153, 153, 153);
    [self.headerView addSubview:lineView];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.right.equalTo(self.QRCodeView.mas_left);
        make.height.equalTo(0.5);
    }];
    
    [self.pollingUser makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.right.equalTo(0);
        make.height.equalTo(88);
    }];
    [self.QRCodeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pollingUser.mas_bottom);
        make.right.equalTo(-10);
        make.width.height.equalTo(88);
    }];
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(142);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.top.equalTo(self.headerView.mas_bottom);
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
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FormItemSectionView class] forHeaderFooterViewReuseIdentifier:headerCell];
    }
    return _tableView;
}
- (PollingHeaderView *)pollingUser{
    if (_pollingUser == nil) {
        _pollingUser = [[PollingHeaderView alloc] init];
    }
    return _pollingUser;
}
- (FormQRCodeView *)QRCodeView{
    if (_QRCodeView == nil) {
        _QRCodeView = [[FormQRCodeView alloc] init];
    }
    return _QRCodeView;
}

- (FormEditCell *)headerView{
    if (_headerView == nil) {
        _headerView = [[FormEditCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (NSMutableArray *)expandSectionArray{
    if (_expandSectionArray == nil) {
        _expandSectionArray = [NSMutableArray array];
    }
    return _expandSectionArray;
}

- (NSMutableArray *)sectionArray{
    if (_sectionArray == nil) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

- (FormFlowManager *)formFlowManager{
    if (_formFlowManager == nil) {
        _formFlowManager = [[FormFlowManager alloc] init];
        _formFlowManager.delegate = self;
        _formFlowManager.buddy_file = self.buddy_file;
    }
    return _formFlowManager;
}

- (BOOL)isCloneCurrentForm{
    return self.formFlowManager.isCloneForm;
}

- (NSString *)clone_buddy_file{
    return self.formFlowManager.instanceBuddy_file;
}

- (BOOL)isModification{
    return self.formFlowManager.isModification;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
