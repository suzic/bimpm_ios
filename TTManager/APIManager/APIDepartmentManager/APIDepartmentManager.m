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
    ZHProject *currentProject = [DataManager defaultInstance].currentProject;
    // 清除已有的项目部门
    [[DataManager defaultInstance] cleraDepartmentFromCurrentProject:currentProject];
    
    NSArray *department_list = dict[@"department_list"];
    for (NSDictionary *dic in department_list) {
        // 部门列表
        ZHDepartment *department = [[DataManager defaultInstance] getDepartMentFromCoredataById:[dic[@"id_department"] intValue]];
        department.fid_project = currentProject.id_project;
        department.info = dic[@"info"];
        department.name = dic[@"name"];
        NSArray *leader = dic[@"leader"];
        int order_index = 0;
        department.id_department = [dic[@"id_department"] intValue];
        [[DataManager defaultInstance] cleraDepartmentUserFromCurrentDepartment:department];
        
        for (NSDictionary *MPDic in dic[@"member_in_project_list"]) {
        
            // 部门用户
            ZHDepartmentUser *departmentUser = (ZHDepartmentUser *)[[DataManager defaultInstance] insertIntoCoreData:@"ZHDepartmentUser"];
            departmentUser.order_index = order_index;
            // 判断是否是领导
            departmentUser.is_leader = [leader containsObject:MPDic[@"id_user_project"]];
            // 获取当前userProject
            ZHUserProject *userProject = [[DataManager defaultInstance] getUserProjectFromCoredataById:[MPDic[@"id_user_project"] intValue]];
            [[DataManager defaultInstance] syncUserProject:userProject withUDInfo:MPDic];
            userProject.order_index = order_index;
            
            // user 数据
            ZHUser *user = [[DataManager defaultInstance] getUserFromCoredataByID:[MPDic[@"id_user"] intValue]];
            // user数据
            NSDictionary *userInfo = [self getUserInfo:dic[@"member_list"] id_user:[MPDic[@"id_user"] intValue]];
            [[DataManager defaultInstance] syncUser:user withUserInfo:userInfo];
            
            userProject.belongUser = user;
            
            departmentUser.assignUser = userProject;
            
            departmentUser.belongDepartment = department;
            order_index++;
        }
        
        department.belongProject = currentProject;
    }
    response.responseData = currentProject;
    return response;
}
- (NSDictionary *)getUserInfo:(NSArray *)userList id_user:(int)id_user{
    NSDictionary *userDic = nil;
    for (NSDictionary *dic in userList) {
        if ([dic[@"id_user"] intValue] == id_user) {
            userDic = dic;
            break;
        }
    }
    return userDic;
}
@end
