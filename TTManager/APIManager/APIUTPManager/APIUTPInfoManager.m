//
//  APIUTPInfoManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "APIUTPInfoManager.h"

@implementation APIUTPInfoManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_USER_PROJECT_INFO;
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
    return [self userToProjectInfoCoreData:response];
}
// 本地数据库
- (id)userToProjectInfoCoreData:(LCURLResponse *)response{
    NSDictionary *dict = [NSDictionary changeType:response.responseData[@"data"]];
    NSMutableArray *resultArray = [NSMutableArray array];
    NSArray *projectMemo = dict[@"project_memo"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([projectMemo isKindOfClass:[NSArray class]]) {
        for (NSDictionary *projectMemoDic in projectMemo) {
            ZHProject *project = [[DataManager defaultInstance] getProjectFromCoredataById:[projectMemoDic[@"fid_project"] intValue]];
            ZHProjectMemo *meno = (ZHProjectMemo *)[[DataManager defaultInstance] insertIntoCoreData:@"ZHProjectMemo"];
            meno.page_index = [projectMemoDic[@"order_index"] intValue];
            meno.order_index = [projectMemoDic[@"order_index"] intValue];
            meno.check = [projectMemoDic[@"check"] boolValue];
            // 去除html内包含的标签
            meno.line = [SZUtil removeHtmlWithString:projectMemoDic[@"line"]];
            
            if (![SZUtil isEmptyOrNull:projectMemoDic[@"edit_date"]]) {
                meno.edit_date = [dateFormatter dateFromString:projectMemoDic[@"edit_date"]];
            }
            if (projectMemoDic[@"last_user"]) {
                NSDictionary *last_user = projectMemoDic[@"last_user"];
                ZHUser *user = [[DataManager defaultInstance] getUserFromCoredataByID:[last_user[@"id_user"] intValue]];
               user = [[DataManager defaultInstance] syncUser:user withUserInfo:last_user];
                meno.last_user = user;
            }
            meno.assignProject = project;
            [resultArray addObject:meno];
        }
    }
    return resultArray;
}
@end
