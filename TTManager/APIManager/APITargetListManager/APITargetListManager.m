//
//  APITargetListManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "APITargetListManager.h"

@implementation APITargetListManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_TARGET_LIST;
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
//    dict[@"pager"] = [self.pageSize currentPage];
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
    return [self targetListCoreData:response];
}
// 本地数据库
- (id)targetListCoreData:(LCURLResponse *)response{
    NSDictionary *dict = [NSDictionary changeType:(NSDictionary*)response.responseData[@"data"]];
    self.pageSize = dict[@"page"];
    NSArray *array = [[DataManager defaultInstance] syncTargetWithInfo:dict];
    return array;
}
@end
