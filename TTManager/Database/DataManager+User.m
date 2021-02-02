//
//  DataManager+User.m
//  ttmanager
//
//  Created by 苏智 on 2018/10/31.
//  Copyright © 2020年 Suzic. All rights reserved.
//

#import "DataManager+User.h"

@implementation DataManager (User)

// 通过手机号确定当前用户
- (ZHUser *)setCurrentUserByPhone:(NSString *)phone
{
    [[LoginUserManager defaultInstance] saveCurrentLoginUserPhone:phone];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phone = %@", phone];
    NSArray *findArray = [self arrayFromCoreData:@"ZHUser" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHUser *user = nil;
    if (findArray != nil && findArray.count > 0)
    {
        user = (ZHUser *)findArray[0];
    }
    else
    {
        user = (ZHUser *)[self insertIntoCoreData:@"ZHUser"];
//        self.currentUser.id_user = 0;
        user.phone = phone;
//        self.currentUser.token = @"";
//        self.currentUser.is_login = NO;
    }
    NSLog(@"%@",self.currentUser.phone);
    NSString *identifierStr = [SZUtil getUUID];
    NSLog(@"Current User has Device ID : %@", identifierStr);
    user.device = identifierStr;
    [self saveContext];
    return user;
}

- (ZHUser *)getUserFromCoredataByID:(int)userId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_user = %d", userId];
    NSArray *result = [self arrayFromCoreData:@"ZHUser" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHUser *user = nil;
    if (result != nil && result.count > 0)
        user = result[0];
    else
    {
        user = (ZHUser *)[self insertIntoCoreData:@"ZHUser"];
        user.id_user = userId;
    }
    return user;
}
- (void)cleraDepartmentFromCurrentProject:(ZHProject *)currentProject{
    for (ZHDepartment *department in currentProject.hasDepartments) {
        if (department.id_department != 0) {
            [self deleteFromCoreData:department];
        }
    }
}
- (void)cleraDepartmentUserFromCurrentDepartment:(ZHDepartment *)currentDepartment{
    for (ZHDepartmentUser *user in currentDepartment.hasUsers) {
        [self deleteFromCoreData:user];
    }
//    if (currentDepartment.id_department != 0) {
//        [self deleteFromCoreData:currentDepartment];
//    }
}
- (ZHProject *)getProjectFromCoredataById:(int)projectId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_project = %d", projectId];
    NSArray *result = [self arrayFromCoreData:@"ZHProject" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHProject *project = nil;
    if (result != nil && result.count > 0)
        project = result[0];
    else
    {
        project = (ZHProject *)[self insertIntoCoreData:@"ZHProject"];
        project.id_project = projectId;
        // 如果新建的是平台，即便没有通过网络获取，也有默认名称
        if (projectId == 1)
            project.name = TARGETS_NAME;
    }
    return project;
}
- (ZHDepartment *)getDepartMentFromCoredataById:(int)id_department{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_department = %d", id_department];
    NSArray *result = [self arrayFromCoreData:@"ZHDepartment" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHDepartment *department = nil;
    if (result != nil && result.count > 0)
        department = result[0];
    else
    {
        department = (ZHDepartment *)[self insertIntoCoreData:@"ZHDepartment"];
        department.id_department = id_department;
    }
    return department;
}
- (ZHDepartmentUser *)getDepartmentUserFromCoredataById:(int)order_index{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order_index = %d", order_index];
    NSArray *result = [self arrayFromCoreData:@"ZHDepartment" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHDepartmentUser *departmentUser = nil;
    if (result != nil && result.count > 0)
        departmentUser = result[0];
    else
    {
        departmentUser = (ZHDepartmentUser *)[self insertIntoCoreData:@"ZHDepartmentUser"];
        departmentUser.order_index = order_index;
    }
    return departmentUser;
}
- (ZHUserProject *)getUserProjectFromCoredataById:(int)upId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_user_project = %d", upId];
    NSArray *result = [self arrayFromCoreData:@"ZHUserProject" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHUserProject *userProject = nil;
    if (result != nil && result.count > 0)
        userProject = result[0];
    else
    {
        userProject = (ZHUserProject *)[self insertIntoCoreData:@"ZHUserProject"];
        userProject.id_user_project = upId;
    }
    return userProject;
}

- (ZHRole *)getRoleFromCoredataById:(int)roleId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_role = %d", roleId];
    NSArray *result = [self arrayFromCoreData:@"ZHRole" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHRole *role = nil;
    if (result != nil && result.count > 0)
        role = result[0];
    else
    {
        role = (ZHRole *)[self insertIntoCoreData:@"ZHRole"];
        role.id_role = roleId;
    }
    return role;
}

- (ZHModule *)getModuleFromCoredataById:(int)moduleId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_module = %d", moduleId];
    NSArray *result = [self arrayFromCoreData:@"ZHModule" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHModule *module = nil;
    if (result != nil && result.count > 0)
        module = result[0];
    else
    {
        module = (ZHModule *)[self insertIntoCoreData:@"ZHModule"];
        module.id_module = moduleId;
    }
    return module;
}

- (ZHUser *)syncUser:(ZHUser *)user withUserInfo:(NSDictionary *)dicData
{
    if (user == nil || dicData == nil)
        return nil;
    
    user.id_user = [dicData[@"id_user"] intValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    user.phone = dicData[@"phone"];
    if (![SZUtil isEmptyOrNull:dicData[@"lock_password"]])
        user.lock_password = dicData[@"lock_password"];
    user.name = dicData[@"name"];
    
    if (![SZUtil isEmptyOrNull:dicData[@"email"]])
        user.email = dicData[@"email"];
    else
        user.email = @"";
    
    if (![SZUtil isEmptyOrNull:dicData[@"lock_password"]])
        user.lock_password = dicData[@"lock_password"];
    if (![SZUtil isEmptyOrNull:dicData[@"avatar"]])
        user.avatar = dicData[@"avatar"];
    else
        user.avatar = @"";
    
    user.uid_chat = dicData[@"uid_chat"];
    user.status = [dicData[@"status"] intValue];
    user.gender = [dicData[@"gender"] intValue];
    [self saveContext];
    return user;
}

- (void)syncProject:(ZHProject *)project withProjectInfo:(NSDictionary *)dicData
{
    if (project == nil || dicData == nil)
        return;
    
    project.id_project = [dicData[@"id_project"] intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![SZUtil isEmptyOrNull:dicData[@"build_date"]])
        project.build_date = [dateFormatter dateFromString:dicData[@"build_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"enable_date"]])
        project.enable_date = [dateFormatter dateFromString:dicData[@"enable_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"kind_name"]])
        project.snap_image = dicData[@"kind_name"];
    if (![SZUtil isEmptyOrNull:dicData[@"info"]])
        project.info = dicData[@"info"];

    project.name = dicData[@"name"];
    if (![SZUtil isEmptyOrNull:dicData[@"snap_image"]])
        project.snap_image = dicData[@"snap_image"];
    if (![SZUtil isEmptyOrNull:dicData[@"location_lat"]])
        project.location_lat = [dicData[@"location_lat"] doubleValue];
    if (![SZUtil isEmptyOrNull:dicData[@"location_long"]])
        project.location_long = [dicData[@"location_long"] doubleValue];
    if (![SZUtil isEmptyOrNull:dicData[@"address"]])
        project.address = dicData[@"address"];
    if (![SZUtil isEmptyOrNull:dicData[@"current_manager"]])
        project.current_manager = dicData[@"current_manager"];
    project.kind = [dicData[@"kind"] intValue];
}

- (ZHUserProject *)syncUserProject:(ZHUserProject *)userProject withUDInfo:(NSDictionary *)dicData
{
    if (userProject == nil || dicData == nil)
        return nil;
    
    userProject.id_user_project = [dicData[@"id_user_project"] intValue];
    userProject.enable = [dicData[@"enable"] boolValue];
    userProject.is_default = [dicData[@"is_default"] intValue];
    userProject.in_apply = [dicData[@"in_apply"] intValue];
    userProject.in_invite = [dicData[@"in_invite"] intValue];
    userProject.invite_user = dicData[@"invite_user"];
    userProject.in_manager_invite = [dicData[@"in_manager_invite"] intValue];
    userProject.user_task_count = [dicData[@"user_task_count"] intValue];

    if (![SZUtil isEmptyOrNull:dicData[@"invite_user"]])
        userProject.invite_user = dicData[@"invite_user"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![SZUtil isEmptyOrNull:dicData[@"enter_date"]])
        userProject.enter_date = [dateFormatter dateFromString:dicData[@"enter_date"]];
    
    userProject.id_project = [dicData[@"id_project"] intValue];
//    // 同步并关联对应的用户
    ZHUser *assignUser = [[DataManager defaultInstance] getUserFromCoredataByID:[dicData[@"id_user"] intValue]];
    
    
    // 同步并关联对应的项目
    ZHProject *assignProject = [[DataManager defaultInstance] getProjectFromCoredataById:[dicData[@"id_project"] intValue]];
    
    // 同步并关联对应的角色对象
    NSDictionary *roleDic = dicData[@"role"];
    ZHRole *currentRole = [[DataManager defaultInstance] getRoleFromCoredataById:[roleDic[@"id_role"] intValue]];
    [[DataManager defaultInstance] syncRole:currentRole withRoleInfo:roleDic];
    
    
    for (ZHDepartmentUser *departmentUser in userProject.inDepartments) {
        [self deleteFromCoreData:departmentUser];
    }
    int order_index = 0;
    for (NSDictionary *departmentDic in dicData[@"department_list"]) {
        ZHDepartmentUser *departmentUser = (ZHDepartmentUser *)[self insertIntoCoreData:@"ZHDepartmentUser"];
        departmentUser.order_index = order_index;
        ZHDepartment *department = [self getDepartMentFromCoredataById:[departmentDic[@"id_department"] intValue]];
        department.name = departmentDic[@"name"];
        department.info = departmentDic[@"info"];
        departmentUser.assignUser = userProject;
        departmentUser.belongDepartment = department;
//        department.belongProject = assignProject;
        order_index++;
    }
    userProject.belongUser = assignUser;
    userProject.belongProject = assignProject;
    userProject.assignRole = currentRole;
    return userProject;
}

- (void)syncRole:(ZHRole *)role withRoleInfo:(NSDictionary *)dicData
{
    if (role == nil || dicData == nil)
        return;
    
    role.id_role = [dicData[@"id_role"] intValue];
    role.name = dicData[@"name"];
    role.info = dicData[@"info"];
    role.is_base = [dicData[@"is_base"] intValue];
    
    // 建立与衍生角色之间的关联
    if (role.is_base != 1)
    {
        NSDictionary *roleDic = dicData[@"base"];
        if ([roleDic isKindOfClass:[NSDictionary class]]){
            ZHRole *baseRole = [[DataManager defaultInstance] getRoleFromCoredataById:[roleDic[@"id_role"] intValue]];
            [[DataManager defaultInstance] syncRole:baseRole withRoleInfo:roleDic];
            role.baseRole = baseRole;
        }
    }

    // 建立与项目的外键关联
    if (dicData[@"fid_project"] != [NSNull null])
    {
        role.fid_project = [dicData[@"fid_project"] intValue];
        ZHProject *project = [[DataManager defaultInstance] getProjectFromCoredataById:role.fid_project];
        role.belongProject = project;
    }

    // 追加模块列表并建立角色和模块关联
    NSArray *moduleList = dicData[@"module_list"];
    for (NSDictionary *moduleDic in moduleList)
    {
        ZHModule *currentModule = [[DataManager defaultInstance] getModuleFromCoredataById:[moduleDic[@"id_module"] intValue]];
        [[DataManager defaultInstance] syncModule:currentModule withModuleInfo:moduleDic];
        currentModule.belongRoles = role;
    }
}

- (void)syncModule:(ZHModule *)module withModuleInfo:(NSDictionary *)dicData
{
    if (module == nil || dicData == nil)
        return;
    module.id_module = [dicData[@"id_module"] intValue];
    module.order_index = [dicData[@"order_index"] intValue];
    module.name = dicData[@"name"];
    module.route = dicData[@"route"];
    module.online = [dicData[@"online"] boolValue];
    // module.operation = [dicData[@"operation"] stringValue];
}
- (void)syncDepartMentWithInfo:(NSDictionary *)dict{
    
    ZHProject *currentProject = [DataManager defaultInstance].currentProject;
    // 清除已有的项目部门
//    [[DataManager defaultInstance] cleraDepartmentFromCurrentProject:currentProject];
    
    NSArray *department_list = dict[@"department_list"];
    for (NSDictionary *dic in department_list) {
        /*
         1:创建部门 ZHDepartment
         2:创建 ZHDepartmentUser
         3:创建 ZHUserProject
         4:查找user
         */
        ZHDepartment *department = [[DataManager defaultInstance] getDepartMentFromCoredataById:[dic[@"id_department"] intValue]];
//        [[DataManager defaultInstance] cleraDepartmentUserFromCurrentDepartment:department];

        department.fid_project = currentProject.id_project;
        department.info = dic[@"info"];
        department.name = dic[@"name"];
        NSArray *leader = dic[@"leader"];
        int order_index = 0;
        department.id_department = [dic[@"id_department"] intValue];
        
        for (NSDictionary *MPDic in dic[@"member_in_project_list"]) {
            // 获取当前userProject
            ZHUserProject *userProject = [[DataManager defaultInstance] getUserProjectFromCoredataById:[MPDic[@"id_user_project"] intValue]];
            // 部门用户
            ZHDepartmentUser *departmentUser = (ZHDepartmentUser *)[[DataManager defaultInstance] insertIntoCoreData:@"ZHDepartmentUser"];
            
            departmentUser.order_index = order_index;
            departmentUser.is_leader = [leader containsObject:MPDic[@"id_user"]];
            departmentUser.belongDepartment = department;
            departmentUser.assignUser = userProject;
                        
            NSDictionary *userDic = [self getUserInfo:dic[@"member_list"] id_user:[MPDic[@"id_user"] intValue]];
            ZHUser *user = [self getUserFromCoredataByID:[MPDic[@"id_user"] intValue]];
            user = [self syncUser:user withUserInfo:userDic];
            userProject.belongUser = user;
            order_index++;
        }
        NSLog(@"当前部门下的人数%@",department);
        department.belongProject = currentProject;
    }
}

- (void)cleanDepartmentUserByUserProject:(ZHUserProject *)userProject{
    for (ZHDepartmentUser *departmentUser in userProject.inDepartments) {
        [self deleteFromCoreData:departmentUser];
    }
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
- (void)removeCurrentUserProjects:(ZHUser *)user{
    for (ZHUserProject *userProject in user.hasProjects) {
        [self deleteFromCoreData:userProject];
    }
}
@end
