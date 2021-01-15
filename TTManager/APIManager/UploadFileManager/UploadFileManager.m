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
@property (nonatomic, copy) NSString *uid_target;
@property (nonatomic, copy) NSString *uploadFileName;
@property (nonatomic,strong) NSData *uploadData;
@property (nonatomic, copy) NSString *is_file;
@property (nonatomic, copy) NSString *id_module;
@property (nonatomic,copy) NSString *fid_project;

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
    self.id_module = target[@"id_module"];
    self.fid_project = target[@"fid_project"];
    self.uploadData = imageData;
    if (![SZUtil isMobileNumber:fileName]) {
        self.uploadFileName = fileName;
    }
    [self.uploadFileManager.uploadArray removeAllObjects];
    [self.uploadFileManager.uploadArray addObject:imageData];
    [self.uploadFileManager loadData];
}
- (void)newFileGroupWithGroupName:(NSString *)fileName target:(NSDictionary *)target{
    if ([SZUtil isEmptyOrNull:fileName]) {
        [SZAlert showInfo:@"请填写文件夹名称后重试" underTitle:@"众和空间"];
        return;
    }
    if (target == nil) {
        [SZAlert showInfo:@"请指定当前文件夹所属目录后重试" underTitle:@"众和空间"];
        return;
    }
    self.uploadFileName = fileName;
    self.is_file = @"0";
    self.id_module = target[@"id_module"];
    self.fid_project = target[@"fid_project"];
    [self.targetNewManager loadData];
}

#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    ZHProject *project = [DataManager defaultInstance].currentProject;
    if (manager == self.uploadFileManager) {
        params = @{@"id_project":INT_32_TO_STRING(project.id_project)};
    }else if(manager == self.targetNewManager){
        params = @{@"target_info":@{@"uid_target":self.uid_target,@"id_module":self.id_module,@"is_file":self.is_file,
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
            self.uploadResult(YES, @"", self.uid_target);
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
        [SZAlert showInfo:@"上传图片为空,请重新选择后重试" underTitle:@"众和空间"];
        return;
    }
    if ([SZUtil isEmptyOrNull:self.uploadFileName]) {
        [SZAlert showInfo:@"上传图片名称为空,请填写后重试" underTitle:@"众和空间"];
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
