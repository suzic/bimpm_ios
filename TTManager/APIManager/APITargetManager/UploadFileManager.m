//
//  UploadFileManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/16.
//

#import "UploadFileManager.h"

@interface UploadFileManager ()<APIManagerParamSource,ApiManagerCallBackDelegate>

@property (nonatomic, strong) APIUploadFileManager *uploadFileManager;
@property (nonatomic, strong) APITargetNewManager *targetNewManager;
@property (nonatomic, copy) NSString *uploadFileName;
@property (nonatomic,strong) NSData *uploadData;

@property (nonatomic, copy) NSString *uid_target;
@property (nonatomic, copy) NSString *is_file;
@property (nonatomic, copy) NSString *id_module;
@property (nonatomic, assign) id fid_parent;

@end

@implementation UploadFileManager
- (instancetype)init{
    self = [super init];
    if (self) {
        self.uploadData = nil;
        self.uid_target = @"";
        self.uploadFileName = [SZUtil getTimeNow];
    }
    return self;
}
- (void)uploadFile:(NSData *)imageData fileName:(NSString *)fileName target:(NSDictionary *)target{
    if (imageData == nil) {
        if (self.uploadResult) {
            self.uploadResult(NO, @"请选择图片后再次操作", @"");
        }
        return;
    }
    self.uploadFileName = fileName;
    self.is_file = @"1";
    self.uid_target = target[@"uid_target"];
    self.id_module = target[@"id_module"];
    if ([target[@"fid_parent"] isEqualToString:@"0"]) {
        self.fid_parent = [NSNull null];
    }else{
        self.fid_parent = target[@"fid_parent"];
    }
    self.uploadData = imageData;
    if (![SZUtil isMobileNumber:fileName]) {
        self.uploadFileName = fileName;
    }
    [self.uploadFileManager.uploadArray removeAllObjects];
    NSDictionary *upLoadDic = @{@"name":fileName,@"type":@"image",@"data":imageData};
    [self.uploadFileManager.uploadArray addObject:upLoadDic];
    [self.uploadFileManager loadData];
}
- (void)newFileGroupWithGroupName:(NSString *)fileName target:(NSDictionary *)target{
    if ([SZUtil isEmptyOrNull:fileName]) {
        [SZAlert showInfo:@"请填写文件夹名称后重试" underTitle:TARGETS_NAME];
        return;
    }
    if (target == nil) {
        [SZAlert showInfo:@"请指定当前文件夹所属目录后重试" underTitle:TARGETS_NAME];
        return;
    }
    self.uploadFileName = fileName;
    self.is_file = @"0";
    self.uid_target = target[@"uid_target"];
    self.id_module = target[@"id_module"];
    if ([target[@"fid_parent"] isEqualToString:@"0"]) {
        self.fid_parent = [NSNull null];
    }else{
        self.fid_parent = target[@"fid_parent"];
    }
    [self.targetNewManager loadData];
}

#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    ZHProject *project = [DataManager defaultInstance].currentProject;
    if (manager == self.uploadFileManager) {
        params = @{@"id_project":INT_32_TO_STRING(project.id_project)};
    }else if(manager == self.targetNewManager){
        params = @{@"target_info":@{@"uid_target":self.uid_target,
                                    @"id_module":self.id_module,
                                    @"fid_parent":self.fid_parent,
                                    @"is_file":self.is_file,
                                                 @"access_mode":@"0",@"name":self.uploadFileName,@"fid_project":INT_32_TO_STRING(project.id_project)}};
    }
    return params;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.uploadFileManager) {
        NSDictionary *dic = (NSDictionary *)manager.response.responseData;
        self.uid_target = dic[@"data"][@"uid_target"];
        if ([SZUtil isEmptyOrNull:self.uid_target]) {
            if (self.uploadResult) {
                self.uploadResult(NO, @"上传失败，请重试", @"");
            }
        }else{
            [self.targetNewManager loadData];
        }
    }else if(manager == self.targetNewManager){
        if (self.uploadResult) {
            NSDictionary *dic = manager.response.responseData[@"data"];
            self.uploadResult(YES, dic[@"target_info"][@"uid_target"], self.uid_target);
            [SZAlert showInfo:@"创建成功" underTitle:TARGETS_NAME];
        }
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (self.uploadResult) {
        self.uploadResult(NO, @"上传失败，请重试", @"");
    }
}
- (void)showAgainUpload{
    if (self.uploadData == nil) {
        [SZAlert showInfo:@"上传图片为空,请重新选择后重试" underTitle:TARGETS_NAME];
        return;
    }
    if ([SZUtil isEmptyOrNull:self.uploadFileName]) {
        [SZAlert showInfo:@"上传图片名称为空,请填写后重试" underTitle:TARGETS_NAME];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"创建失败,是否再次创建" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *again = [UIAlertAction actionWithTitle:@"再试试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![SZUtil isEmptyOrNull:self.uid_target]) {
            [self.targetNewManager loadData];
        }else{
            [self.uploadFileManager loadData];
        }
    }];
    [alert addAction:cancel];
    [alert addAction:again];
    [[SZUtil getCurrentVC] presentViewController:alert animated:YES completion:nil];
}
#pragma mark - setter and getter
- (APIUploadFileManager *)uploadFileManager{
    if (_uploadFileManager == nil) {
        _uploadFileManager = [[APIUploadFileManager alloc] init];
        _uploadFileManager.delegate = self;
        _uploadFileManager.paramSource = self;
    }
    return _uploadFileManager;
}
- (APITargetNewManager *)targetNewManager{
    if (_targetNewManager == nil) {
        _targetNewManager = [[APITargetNewManager alloc] init];
        _targetNewManager.delegate = self;
        _targetNewManager.paramSource = self;
    }
    return _targetNewManager;
}
@end
