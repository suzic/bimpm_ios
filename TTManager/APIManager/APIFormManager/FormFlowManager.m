//
//  FormFlowManager.m
//  TTManager
//
//  Created by chao liu on 2021/2/4.
//

#import "FormFlowManager.h"

@interface FormFlowManager ()<APIManagerParamSource,ApiManagerCallBackDelegate>

/// 下载的表单数据
@property (nonatomic, strong) NSMutableDictionary *downLoadformDic;
/// 下载克隆后的表单数据
@property (nonatomic, strong) NSMutableDictionary *downLoadCloneformDic;
/// 原始数据
@property (nonatomic, strong) NSMutableDictionary *formDic;
/// 克隆的表单
@property (nonatomic, strong) NSMutableDictionary *cloneFormDic;
/// 克隆后的buddy_file
@property (nonatomic, copy) NSString *clone_buddy_file;

/// 获取表单json
@property (nonatomic, strong) APIFileDownLoadManager *downLoadManager;
/// api表单详情
@property (nonatomic, strong) APIFormDetailManager *formDetailManager;
/// api克隆表单
@property (nonatomic, strong) APITargetCloneManager *targetCloneManager;
/// api表单操作
@property (nonatomic, strong) APIFormOperationsManager *formOperationsManager;
/// 上传表单文件
@property (nonatomic, strong) APIUploadFileManager *uploadfileManager;
/// 更新target文件
@property (nonatomic, strong) APITargetUpdateManager *targetUpdateManager;
/// 上传表单内的图片
@property (nonatomic, strong) UploadFileManager *uploadManager;

@end

@implementation FormFlowManager

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initializeParameters];
    }
    return self;
}

#pragma mark - private

- (void)initializeParameters{
    self.isCloneForm = NO;
    self.isEditForm = NO;
    self.canCloneForm = NO;
    self.isSnapshoot = NO;
}

// 获取操作后的提交的参数
- (NSMutableDictionary *)getOperationsFromParams{
    if (self.instanceFromDic.allKeys.count <= 0) {
        return [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"code":@"FILL",@"instance_ident":self.instanceFromDic[@"instance_ident"],@"id_project":self.instanceFromDic[@"buddy_file"][@"fid_project"]}];
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *formItem in self.instanceDownLoadForm[@"items"]) {
        NSString *instance_value = formItem[@"instance_value"];
        if ([SZUtil isEmptyOrNull:instance_value]) {
            instance_value = @"";
        }
        NSDictionary *itemDic = @{@"ident":formItem[@"ident"],@"instance_value":instance_value};
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
}
#pragma mark - call delegate
// 需要刷新
- (void)callReloadViewDelegate{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadView)]) {
        [self.delegate reloadView];
    }
}
/// 获取表单详情成功
- (void)callFormDetailResultDelegate:(BOOL)success{
    if (self.delegate && [self.delegate respondsToSelector:@selector(formDetailResult:)]) {
        [self.delegate formDetailResult:success];
    }
}
/// 表单下载成功
- (void)callFormDownLoadResultDelagate:(BOOL)success{
    if (self.delegate && [self.delegate respondsToSelector:@selector(formDownLoadResult:)]) {
        [self.delegate formDownLoadResult:success];
    }
}
/// 克隆表单成功
- (void)callFormCloneTargetResultDelagate:(BOOL)success{
    if (self.delegate && [self.delegate respondsToSelector:@selector(formCloneTargetResult:)]) {
        [self.delegate formCloneTargetResult:success];
    }
}
/// 表单操作完成
- (void)callFormOperationsFillResultDelagate:(BOOL)success{
    if (self.delegate && [self.delegate respondsToSelector:@selector(formOperationsFillResult:)]) {
        [self.delegate formOperationsFillResult:success];
    }
}
/// 表单更新完成
- (void)callTargetUpdateResultDelagate:(BOOL)success{
    if (self.delegate && [self.delegate respondsToSelector:@selector(targetUpdateResult:)]) {
        [self.delegate targetUpdateResult:success];
    }
//    [self exitEditorModel];
}
#pragma mark - public
// 进入编辑模式
- (void)enterEditModel{
    if (self.canEditForm == NO) {
        [self cloneCurrentFormByBuddy_file];
    }else{
        self.isEditForm = YES;
        [self callReloadViewDelegate];
    }
}
/// 退出编辑模式
- (void)exitEditorModel{
    self.isEditForm = NO;
    self.isModification = NO;
}

// 删除当前表单中的图片数据
- (void)deleteImageToCurrentImageFormItem:(NSDictionary *)deleteDic{
    
    if (self.isSnapshoot == YES) {
        [self callReloadViewDelegate];
        return;;
    }
    
    self.isModification = YES;
    // 显示的数据
    NSIndexPath *indexPath = deleteDic[@"indexPath"];
    NSIndexPath *deleteIndex = deleteDic[@"deleteIndex"];
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.instanceDownLoadForm[@"items"]];
    NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:items[indexPath.row]];
    // fill 的数据
    NSMutableArray *currentitems = [NSMutableArray arrayWithArray:self.instanceFromDic[@"items"]];
    NSMutableDictionary *currentitemDic = [NSMutableDictionary dictionaryWithDictionary:currentitems[indexPath.row]];
    
    if ([itemDic[@"type"] isEqualToNumber:@7]) {
        itemDic[@"instance_value"] = @"";
        currentitemDic[@"instance_value"] = @"";
        items[indexPath.row] = itemDic;
        self.instanceDownLoadForm[@"items"] = items;
        currentitems[indexPath.row] = currentitemDic;
        self.instanceFromDic[@"items"] = currentitems;
        
    }
    else if([itemDic[@"type"] isEqualToNumber:@8]){
        NSMutableArray *itemImageArray = nil;
        if (![SZUtil isEmptyOrNull:itemDic[@"instance_value"]]) {
            itemImageArray = [NSMutableArray arrayWithArray: [itemDic[@"instance_value"] componentsSeparatedByString:@","]];
        }else{
            itemImageArray = [NSMutableArray array];
        }
        if (itemImageArray.count > deleteIndex.row) {
            [itemImageArray removeObjectAtIndex:deleteIndex.row];
        }
        
        itemDic[@"instance_value"] = [itemImageArray componentsJoinedByString:@","];
        currentitemDic[@"instance_value"] = [itemImageArray componentsJoinedByString:@","];
        items[indexPath.row] = itemDic;
        self.instanceDownLoadForm[@"items"] = items;
        currentitems[indexPath.row] = currentitemDic;
        self.instanceFromDic[@"items"] = currentitems;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadView)]) {
        [self.delegate reloadView];
    }
}
// 修改当前编辑的数据(包含显示的form和下载的form)
- (void)modifyCurrentDownLoadForm:(NSDictionary *)modifyData{
    
    if (self.isSnapshoot == YES) {
        [self callReloadViewDelegate];
        return;;
    }
    
    self.isModification = YES;
    // 显示的数据
    NSIndexPath *indexPath = modifyData[@"indexPath"];
    NSString *value = modifyData[@"value"];
    if (value == nil) {
        value = @"";
    }
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.instanceDownLoadForm[@"items"]];
    if (items.count > 0) {
        NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:items[indexPath.row]];
        itemDic[@"instance_value"] = [NSString stringWithFormat:@"%@",value];
        items[indexPath.row] = itemDic;
        self.instanceDownLoadForm[@"items"] = items;
    }
    
    
    // fill 的数据
    NSMutableArray *currentitems = [NSMutableArray arrayWithArray:self.instanceFromDic[@"items"]];
    if (currentitems.count > 0) {
        NSMutableDictionary *currentitemDic = [NSMutableDictionary dictionaryWithDictionary:currentitems[indexPath.row]];
        currentitemDic[@"instance_value"] = [NSString stringWithFormat:@"%@",value];
        currentitems[indexPath.row] = currentitemDic;
        self.instanceFromDic[@"items"] = currentitems;
    }

    [self callReloadViewDelegate];
}
// 添加图片到表单
- (void)addImageToCurrentImageFormItem:(NSDictionary *)addDic{
    
    if (self.isSnapshoot == YES) {
        [self callReloadViewDelegate];
        return;
    }
    
    self.isModification = YES;
    // 显示的数据
    NSIndexPath *indexPath = addDic[@"indexPath"];
    NSData *imageData = addDic[@"image"];
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.instanceDownLoadForm[@"items"]];
    NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:items[indexPath.row]];

    // fill 的数据
    NSMutableArray *currentitems = [NSMutableArray arrayWithArray:self.instanceFromDic[@"items"]];
    NSMutableDictionary *currentitemDic = [NSMutableDictionary dictionaryWithDictionary:currentitems[indexPath.row]];
    
    
    if ([itemDic[@"type"] isEqualToNumber:@7] && imageData.length/1024 > 100) {
        [SZAlert showInfo:@"上传图片不能大于100k" underTitle:TARGETS_NAME];
        return;
    }
    // 内嵌图片
    if ([itemDic[@"type"] isEqualToNumber:@7]) {
        // 加密成Base64形式的NSString
        NSString *base64String = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        base64String = [NSString stringWithFormat:@"data:text/rtf;base64,%@",base64String];
        itemDic[@"instance_value"] = base64String;
        currentitemDic[@"instance_value"] = base64String;
        items[indexPath.row] = itemDic;
        self.instanceDownLoadForm[@"items"] = items;
        currentitems[indexPath.row] = currentitemDic;
        self.instanceFromDic[@"items"] = currentitems;
    }
    // 图片链接地址
    else if([itemDic[@"type"] isEqualToNumber:@8]){
        __weak typeof(self) weakSelf = self;
        [self.uploadManager uploadFile:imageData fileName:[SZUtil getTimeNow] target:@{@"id_module":@"0",@"fid_parent":@"0"}];
        self.uploadManager.uploadResult = ^(BOOL success, NSDictionary * _Nonnull targetInfo, NSString * _Nonnull id_file) {
            __strong typeof(weakSelf) strongSelf = weakSelf;

            if (success == YES) {
                NSString *link = targetInfo[@"link"];
                NSMutableArray *itemImageArray = nil;
                if (![SZUtil isEmptyOrNull:itemDic[@"instance_value"]]) {
                    itemImageArray = [NSMutableArray arrayWithArray: [itemDic[@"instance_value"] componentsSeparatedByString:@","]];
                }else{
                    itemImageArray = [NSMutableArray array];
                }
                NSString *url = [NSString stringWithFormat:@"%@/FileService/%@",FILESERVICEADDRESS,link];
                [itemImageArray addObject:url];
                itemDic[@"instance_value"] = [itemImageArray componentsJoinedByString:@","];
                currentitemDic[@"instance_value"] = [itemImageArray componentsJoinedByString:@","];
                items[indexPath.row] = itemDic;
                strongSelf.instanceDownLoadForm[@"items"] = items;
                currentitems[indexPath.row] = currentitemDic;
                strongSelf.instanceFromDic[@"items"] = currentitems;
                [self callReloadViewDelegate];
            }
        };
    }
    
    [self callReloadViewDelegate];
}

#pragma mark - network

// 下载当前form表单
- (void)downLoadCurrentFormJsonByBuddy_file:(NSString *)buddy_file
{
    self.downLoadManager.uid_target = buddy_file;
    self.buddy_file = buddy_file;
    [self.downLoadManager loadData];
}

// 查看当前表单详情，如果没有是快照 只读，如果有则继续下一步
- (void)getFromDetailByBuddy_file{
    [self.formDetailManager loadData];
}

// 克隆当前表单，克隆成功之后 调用下载clone后的表单
- (void)cloneCurrentFormByBuddy_file{
    if (self.isSnapshoot == YES) {
        return;
    }
    [self.targetCloneManager loadData];
}

// 填充当前表单
- (void)operationsFormFill{
    [self.formOperationsManager loadData];
}

// 上传填充之后的表单
- (void)uploadFillSuccessLaterFrom{
    [self.uploadfileManager loadData];
}

// 通知服务器，我更新了哪个文件
- (void)informTargetUpdateByBuddy_file{
    [self.targetUpdateManager loadData];
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
        [self.uploadfileManager.uploadArray removeAllObjects];
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
    if (manager == self.formDetailManager)
    {
        [self getFormItemInfo:data];
        [self judgeDownLoadFormIsEditClone];
        [self callFormDetailResultDelegate:YES];
        [self callReloadViewDelegate];
    }
    else if(manager == self.formOperationsManager)
    {
        NSDictionary *dic = (NSDictionary *)manager.response.responseData;
        if ([dic[@"code"] isEqualToNumber:@0]) {
            self.isModification = NO;
//            [self uploadFillSuccessLaterFrom];
            [self callFormOperationsFillResultDelagate:YES];
            [self callTargetUpdateResultDelagate:YES];
        }
    }else if(manager == self.targetCloneManager)
    {
        self.isCloneForm = YES;
        self.isEditForm = YES;
        self.clone_buddy_file = data[@"data"][@"target_info"][@"uid_target"];
        [self callFormCloneTargetResultDelagate:YES];
        [self downLoadCurrentFormJsonByBuddy_file:self.instanceBuddy_file];
        
    }
    else if(manager == self.uploadfileManager)
    {
//        [self informTargetUpdateByBuddy_file];
    }
    else if(manager == self.targetUpdateManager)
    {
        [self callTargetUpdateResultDelagate:YES];
    }else if(manager == self.downLoadManager){
        NSLog(@"下载表单成功");
        [self setCloneFormInfo:data];
        // 获取表单详情
        [self getFromDetailByBuddy_file];
        [self callFormDownLoadResultDelagate:YES];
    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.formDetailManager) {
        [self callFormDetailResultDelegate:NO];
    }else if(manager == self.formOperationsManager){
        [self callFormOperationsFillResultDelagate:NO];
        [self callTargetUpdateResultDelagate:NO];
    }else if(manager == self.targetCloneManager){
        [self callFormCloneTargetResultDelagate:NO];
    }else if(manager == self.uploadfileManager){
    }else if(manager == self.targetUpdateManager){
        [self callTargetUpdateResultDelagate:NO];
    }else if(manager == self.downLoadManager){
    }
}

#pragma mark - setter and getter

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

- (UploadFileManager *)uploadManager{
    if (_uploadManager == nil) {
        _uploadManager = [[UploadFileManager alloc] init];
    }
    return _uploadManager;
}

@end
