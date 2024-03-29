//
//  APIDepartmentManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "APIDepartmentManager.h"

@implementation APIDepartmentManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
        self.pageSize.pageIndex = 1;
        self.pageSize.pageSize = 20;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_DEPARTMENT_LIST;
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
    return [self departmentListCoreData:response];
}
// 本地数据库
- (id)departmentListCoreData:(LCURLResponse *)response{
    NSDictionary *dict = [NSDictionary changeType:(NSDictionary*)response.responseData[@"data"]];
    self.pageSize = dict[@"page"];
    [[DataManager defaultInstance] syncDepartMentWithInfo:dict];
    response.responseData = [DataManager defaultInstance].currentProject;
    return response;
}

@end
