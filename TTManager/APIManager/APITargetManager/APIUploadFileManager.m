//
//  APIUploadFileManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/14.
//

#import "APIUploadFileManager.h"

@implementation APIUploadFileManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.uploadArray = [NSMutableArray array];
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_UPLOAD_FILE;
}
- (NSString *)service{
    return FILESERVICEADDRESS;
}
- (RequestType)requestType{
    return REQUEST_TYPE_UPLOAD;
}

- (BOOL)isCoreData {
    return NO;
}
- (NSDictionary *)reformParams:(NSDictionary *)params{
    NSDictionary *dicItem = @{@"params":params,@"upload":self.uploadArray};
    return dicItem;
}
#pragma mark - APIManagerValidator 参数验证
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)data{
    return YES;
}
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    return YES;
}
- (id)coreDataCallBackData:(LCURLResponse *)response{
    return response;
}

@end
