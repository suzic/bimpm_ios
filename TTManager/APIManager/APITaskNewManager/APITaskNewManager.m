//
//  APITaskNewManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "APITaskNewManager.h"

@implementation APITaskNewManager
- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_TASK_NEW;
}
- (NSString *)service{
    return SERVICEADDRESS;
}
- (RequestType)requestType{
    return REQUEST_TYPE_POST;
}

- (BOOL)isCoreData {
    return YES;
}
- (NSDictionary *)reformParams:(NSDictionary *)params{
    NSDictionary *dic = @{@"data":params,
                          @"module":@"",
                          @"priority":@"5"};
    return dic;
}
#pragma mark - APIManagerValidator 参数验证
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)data{
    return YES;
}
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    return YES;
}
- (id)coreDataCallBackData:(LCURLResponse *)response{
    return [self taskNewCoreData:response];
}
// 本地数据库
- (id)taskNewCoreData:(LCURLResponse *)response{
    NSDictionary *task_info = response.responseData[@"data"][@"task_info"];
    task_info = [NSDictionary changeType:task_info];
    ZHTask *task = [[DataManager defaultInstance] syncTaskWithTaskInfo:task_info];
    return task;
}
@end
