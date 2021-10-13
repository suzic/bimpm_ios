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

@property (nonatomic, assign) NSInteger currentSelectedIndex;

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
        _currentStep = NSNotFound;
        self.currentSelectedIndex = NSNotFound;
        self.loadFormSuccess = NO;
        [self addUI];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView showDataCount:0 type:1];
    }
    return self;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *sectionString = [NSString stringWithFormat:@"%ld",section];
    BOOL isExpand = [self.expandSectionArray containsObject:sectionString];
    switch (section) {
        case 0:
            return isExpand == YES ? 5:0;
            break;
        case 1:
            return isExpand == YES ? 3:0;
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
        NSInteger row = section == 0 ? 0:(section == 1 ? 6 :10);
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
    NSIndexPath *currentIndexPath = [self getCurrentFormItemIndex:indexPath];
    NSDictionary *formItem = items[currentIndexPath.row];
    
    FormEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:textCellIndex];
    if (!editCell) {
        editCell = [[FormEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIndex];
    }
    editCell.isPollingTask = YES;
    BOOL isEdit = [self getCurrentSectionEdit:indexPath.section itemData:formItem];
    [editCell setIsFormEdit:isEdit indexPath:currentIndexPath item:formItem];
    cell = editCell;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        dispatch_async(dispatch_get_main_queue(),^{
            [self routerEventWithName:polling_form_height userInfo:@{@"height":[NSString stringWithFormat:@"%f",tableView.contentSize.height+220]}];
        });
    }
}
#pragma mark - responsder chain

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:form_edit_item]) {
        [self.formFlowManager modifyCurrentDownLoadForm:userInfo automatic:NO];
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
    }else if([eventName isEqualToString:polling_form_height]){
        [super routerEventWithName:polling_form_height userInfo:userInfo];
    }
}

// 添加图片到表单
- (void)addImageToCurrentImageFormItem:(NSDictionary *)addDic{
    [[SZUtil getCurrentVC] pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image,NSString * _Nonnull mediaType) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:addDic];
        dic[@"image"] = imageData;
        [self.formFlowManager addImageToCurrentImageFormItem:dic];
    }];
}

#pragma mark - FormFlowManagerDelgate
// 刷新页面数据
- (void)reloadView{
    self.hidden = NO;
    [self fillHeaderView];
    [self getHeaderData];
    [self fillPollingUser];
    [self.tableView showDataCount:self.sectionArray.count type:1];
    [self.tableView reloadData];
}

// 获取表单详情成功
- (void)formDetailResult:(BOOL)success{
    if (success == YES) {
        if (self.formFlowManager.canEditForm == NO && self.needClone == YES) {
            if ([self startPollingFormStatus] == YES) {
                [self.formFlowManager cloneCurrentFormByBuddy_file];
            }else{
                [self normalFillFormInfo];
            }
        }else{
            self.formFlowManager.isEditForm = YES;
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
}

#pragma mark - public

- (void)setPollingUser:(NSString *)user index:(NSInteger)index{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"value":user}];
    if (index == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        dic[@"indexPath"] = indexPath;
    }else if(index == 1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        dic[@"indexPath"] = indexPath;
    }else if(index == 2){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
        dic[@"indexPath"] = indexPath;
    }
    [self.formFlowManager modifyCurrentDownLoadForm:dic automatic:NO];
    [self saveForm:^(BOOL success) {
        
    }];
}
// 改变巡检单的状态
- (void)changPollingFormStatus:(NSInteger)index{
    NSArray *items = self.formFlowManager.instanceDownLoadForm[@"items"];
    NSDictionary *statusDic = items[5];
    NSString *text = statusDic[@"instance_value"];
    if (![text isEqualToString:@"未发现问题"]) {
        if (index == 0) {
            text = @"整改中";
        }else if(index == 1){
            text = @"审批中";
        }else if(index == 2){
            text = @"审批完成";
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"value":text}];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        dic[@"indexPath"] = indexPath;
        [self.formFlowManager modifyCurrentDownLoadForm:dic automatic:NO];
    }
}

- (BOOL)checkPollinFormParams:(NSInteger)index{
    BOOL isPass = YES;
    if (index == 0) {
        NSArray *items = self.formFlowManager.instanceDownLoadForm[@"items"];
        NSDictionary *statusDic = items[5];
        if ([SZUtil isEmptyOrNull: statusDic[@"instance_value"]]) {
            isPass = NO;
            [SZAlert showInfo:@"巡检状态不能为空" underTitle:TARGETS_NAME];
        }
    }
    return isPass;
}

// 判断当前巡检单是否需要整改
- (BOOL)startPollingFormStatus{
    BOOL isStartPolling = YES;
    NSArray *items = self.formFlowManager.instanceDownLoadForm[@"items"];
    NSDictionary *statusDic = items[5];
    if (self.currentStep == 0) {
        isStartPolling = YES;
    }else{
        if ([statusDic[@"instance_value"] isEqualToString:@"未发现问题"]) {
            isStartPolling = NO;
        }
    }
    return isStartPolling;
}

#pragma mark - private

// 点击展开section
- (void)expandSection:(UITapGestureRecognizer *)tap{
    UIView *header = tap.view;
    NSInteger section = header.tag;
    NSString *sectionString = [NSString stringWithFormat:@"%ld",section];
    
    NSDictionary *sectionItem = self.sectionArray[section];
    // 如果当前没有对应负责人，不允许展开
    if ([SZUtil isEmptyOrNull:sectionItem[@"instance_value"]]) {
        return;
    }
    
    self.currentSelectedIndex = section;
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
    if (self.currentSelectedIndex == NSNotFound) {
        return;
    }
    NSDictionary *sectionItem = self.sectionArray[self.currentSelectedIndex];
    NSString *instance_value = @"";
    if (![SZUtil isEmptyOrNull:self.formFlowManager.instanceFromDic[@"buddy_file"][@"name"]]) {
        self.formName = self.formFlowManager.instanceFromDic[@"buddy_file"][@"name"];
    }
    if (![SZUtil isEmptyOrNull:sectionItem[@"instance_value"]]) {
        instance_value = sectionItem[@"instance_value"];
    }
    
    [self.pollingUser setFormHeaderData:@{@"code":self.formName,@"name":instance_value} index:self.currentSelectedIndex];
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
    if (![buddy_file isEqualToString:self.buddy_file]) {
        self.buddy_file = buddy_file;
        [self.formFlowManager downLoadCurrentFormJsonByBuddy_file:self.buddy_file];
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
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
//    NSString *time = [NSString stringWithFormat:@"%.0f", timeInterval*1000];
    NSInteger index = NSNotFound;
    NSInteger index2 = NSNotFound;
    if (self.currentStep == 0) {
        index = 0;
        index2 = 1;
    }else if(self.currentStep == 1){
        index = 6;
        index2 = 7;
    }else if(self.currentStep == 2){
        index = 10;
        index2 = 11;
    }
    // 日期
    NSDictionary *timedic = @{@"indexPath":[NSIndexPath indexPathForRow:index2 inSection:0],@"value":[SZUtil getYYYYMMDD:[NSDate date] type:1]};
    // 记录人
    NSDictionary *userdic = @{@"indexPath":[NSIndexPath indexPathForRow:index inSection:0],@"value":user.name};
    NSArray *array = @[timedic,userdic];

    for (NSDictionary *itemDic in array) {
        [self.formFlowManager modifyCurrentDownLoadForm:itemDic automatic:YES];
    }
    [self.formFlowManager save];
    [self.expandSectionArray removeAllObjects];
    
    BOOL expand = [self.expandSectionArray containsObject:[NSString stringWithFormat:@"%ld",self.currentStep]];
    if (expand == NO) {
        if (self.currentStep == 2) {
            [self.expandSectionArray addObject:@"0"];
            [self.expandSectionArray addObject:@"1"];
            [self.expandSectionArray addObject:@"2"];
        }else{
            [self.expandSectionArray addObject:[NSString stringWithFormat:@"%ld",self.currentStep]];
        }
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentStep] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
    [self fillPollingUser];

}

- (NSMutableArray *)getHeaderData{
    NSArray *items = self.formFlowManager.instanceDownLoadForm[@"items"];
    if (items && items.count > 0) {
        [self.sectionArray removeAllObjects];
        [self.sectionArray addObject:items[0]];
        [self.sectionArray addObject:items[6]];
        [self.sectionArray addObject:items[10]];
    }
    return self.sectionArray;
    
}

- (BOOL)getCurrentSectionEdit:(NSInteger)section itemData:(NSDictionary *)formItem{
    BOOL edit = NO;
    if ([self startPollingFormStatus] == YES) {
        if (self.formFlowManager.isSnapshoot == NO) {
            NSInteger type = [formItem[@"type"] intValue];
            if (section == self.currentStep) {
                if (type != 3 && type != 4) {
                    edit = YES;
                }
            }
        }
    }
    return edit;
}

// 获取真实的表单index
- (NSIndexPath *)getCurrentFormItemIndex:(NSIndexPath *)indexPath{
    NSInteger index = 0;
    if (indexPath.section == 0) {
        index = indexPath.row+1;
    }else if(indexPath.section == 1){
        index = indexPath.row+7;
    }else if(indexPath.section == 2){
        index =indexPath.row +11;
    }
    return  [NSIndexPath indexPathForRow:index inSection:0];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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

- (void)setCurrentStep:(NSInteger)currentStep{
    if (_currentStep != currentStep) {
        _currentStep = currentStep;
        self.currentSelectedIndex = _currentStep;
    }
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
