//
//  APIUTPListManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "APIUTPListManager.h"

@implementation APIUTPListManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_USER_PROJECT_LIST;
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
    return [self userToProjectListCoreData:response];
}
// 本地数据库
- (id)userToProjectListCoreData:(LCURLResponse *)response{
    NSDictionary *dict = [NSDictionary changeType:(NSDictionary*)response.responseData[@"data"]];
    NSArray *to_user = dict[@"to_user"];
    for (NSDictionary *userDic in to_user) {
        ZHUserProject *currentUP = [[DataManager defaultInstance] getUserProjectFromCoredataById:[userDic[@"id_user_project"] intValue]];
        [[DataManager defaultInstance] syncUserProject:currentUP withUDInfo:userDic];
    }
    return nil;
}
@end
