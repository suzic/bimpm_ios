//
//  APIFileDownLoadManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/25.
//

#import "APIFileDownLoadManager.h"

@implementation APIFileDownLoadManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_FILE_DOWNLOAD(self.uid_target);
}
- (NSString *)service{
    return FILESERVICEADDRESS;
}
- (RequestType)requestType{
    return REQUEST_TYPE_GET;
}

- (BOOL)isCoreData {
    return NO;
}
- (NSDictionary *)reformParams:(NSDictionary *)params{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
//    dict[@"pager"] = [self.pageSize currentPage];
    NSDictionary *dic = @{@"data":dict};
    return dic;
}
#pragma mark - APIManagerValidator 参数验证
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)data{
    return YES;
}
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    return YES;
}

@end
