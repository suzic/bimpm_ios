//
//  APIDMDetailManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "APIDMDetailManager.h"

@implementation APIDMDetailManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_DEPARTMENT_DETAIL;
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
    return [self departmentDetailCoreData:response];
}
// 本地数据库
- (id)departmentDetailCoreData:(LCURLResponse *)response{
    NSDictionary *dict = [NSDictionary changeType:(NSDictionary*)response.responseData[@"data"]];
    self.pageSize = dict[@"page"];
//    [[DataManager defaultInstance] syncDepartMentWithInfo:@{@"department_list":@[dict[@"department"]]}];
    
//    response.responseData = [DataManager defaultInstance].currentProject;
    NSArray *member_list = dict[@"department"][@"member_list"];
    NSMutableArray *result = [NSMutableArray array];
    if ([member_list isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in member_list) {
            ZHUser *user = [[DataManager defaultInstance] getUserFromCoredataByID:[dic[@"id_user"] intValue]];
            [[DataManager defaultInstance] syncUser:user withUserInfo:dic];
            [result addObject:user];
        }
    }
    return result;
}
@end
