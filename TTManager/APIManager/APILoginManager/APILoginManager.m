//
//  APILoginManager.m
//  TTManager
//
//  Created by chao liu on 2020/12/26.
//

#import "APILoginManager.h"

@implementation APILoginManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URI_SIGN_IN;
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
    return [self loginCoreData:response];
}

#pragma mark - private methods

- (id)loginCoreData:(LCURLResponse *)response{
    NSDictionary * oneData = (NSDictionary*)response.responseData[@"data"];
    
//    // 使用重置的方式获取新的登录账户
//    [DataManager defaultInstance].currentUser = nil;
    NSDictionary *userInfoDic = oneData[@"user_info"];
    [[DataManager defaultInstance] setCurrentUserByPhone:userInfoDic[@"phone"]];
    // 同步保存当前用户
    [[LoginUserManager defaultInstance] saveCurrentLoginUserPhone:userInfoDic[@"phone"]];
    ZHUser *currentUser = [DataManager defaultInstance].currentUser;
    
    // 同步用户自身信息
    currentUser.token = oneData[@"token"];
    currentUser.pass_md5 = oneData[@"password"];
//    currentUser.password = response.requestParams[@"data"][@"password"];
    currentUser.verify_code = response.requestParams[@"data"][@"verify"];
    currentUser.captcha_code = response.requestParams[@"data"][@"captcha"];
    currentUser.is_login = YES;
    [[DataManager defaultInstance] syncUser:currentUser withUserInfo:userInfoDic];
        
    // 同步用户关联的项目信息
    NSArray *projectList = oneData[@"project_list"];
    for (NSDictionary *projectDict in projectList)
    {
        ZHProject *currentProject = [[DataManager defaultInstance] getProjectFromCoredataById:[projectDict[@"id_project"] intValue]];
        [[DataManager defaultInstance] syncProject:currentProject withProjectInfo:projectDict];
    }

    // 注意，要同步用户与关联项目之间的信息，必须先确保用户和项目信息已经完成存储
    [[DataManager defaultInstance] saveContext];
    
    // 同步用户与关联项目之间的信息
    NSArray *userProjectList = oneData[@"user_project_info"];
    for (NSDictionary *UPDic in userProjectList)
    {
        ZHUserProject *currentUP = [[DataManager defaultInstance] getUserProjectFromCoredataById:[UPDic[@"id_user_project"] intValue]];
        [[DataManager defaultInstance] syncUserProject:currentUP withUDInfo:UPDic];
    }

    return response;
}
@end
