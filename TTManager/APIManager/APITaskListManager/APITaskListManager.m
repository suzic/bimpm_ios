//
//  APITaskListManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "APITaskListManager.h"

@implementation APITaskListManager
- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_TASK_LIST;
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    dict[@"pager"] = [self.pageSize currentPage];
    NSDictionary *dic = @{@"data":dict,
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
    return [self taskListCoreData:response];
}
// 本地数据库
- (id)taskListCoreData:(LCURLResponse *)response{
    NSDictionary *dict = [NSDictionary changeType:(NSDictionary*)response.responseData[@"data"]];
    NSMutableArray *array = [NSMutableArray array];
    if (self.dataType == taskListDataType_none) {
        self.responsePageSize = [self.responsePageSize pageDic: dict[@"page"]];
        return nil;
    }
    NSArray *list = dict[@"list"];
    if ([list isKindOfClass:[NSArray class]]) {
        for (NSDictionary *taskDic in dict[@"list"]) {
            
            ZHTask *task = [[DataManager defaultInstance] syncTaskWithTaskInfo:taskDic];
            [array addObject:task];
        }
    }
    response.responseData = array;
    return response;
}
@end
