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
- (void)setCurrentUserByPhone:(NSString *)phone
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phone = %@", phone];
    NSArray *findArray = [self arrayFromCoreData:@"ZHUser" predicate:predicate limit:1 offset:0 orderBy:nil];
    if (findArray != nil && findArray.count > 0)
    {
        if (self.currentUser.phone != ((ZHUser *)findArray[0]).phone)
            self.currentUser = (ZHUser *)findArray[0];
    }
    else
    {
        self.currentUser = (ZHUser *)[self insertIntoCoreData:@"ZHUser"];
        self.currentUser.id_user = 0;
        self.currentUser.phone = phone;
        self.currentUser.token = @"";
        self.currentUser.is_login = NO;
    }
    NSLog(@"%@",self.currentUser.phone);
    NSString *identifierStr = [SZUtil getUUID];
    NSLog(@"Current User has Device ID : %@", identifierStr);
    self.currentUser.device = identifierStr;
    [self saveContext];
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

- (ZHProject *)getProjectFromCoredataById:(int)projectId
{
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
            project.name = @"众和空间";
    }
    return project;
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

- (void)syncUser:(ZHUser *)user withUserInfo:(NSDictionary *)dicData
{
    if (user == nil || dicData == nil)
        return;
    
    user.id_user = [dicData[@"id_user"] intValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    user.phone = dicData[@"phone"];
    if (![SZUtil isEmptyOrNull:dicData[@"lock_password"]])
        user.lock_password = dicData[@"lock_password"];
    user.name = dicData[@"name"];
    
    if (![SZUtil isEmptyOrNull:dicData[@"email"]])
        user.email = dicData[@"email"];
    if (![SZUtil isEmptyOrNull:dicData[@"lock_password"]])
        user.lock_password = dicData[@"lock_password"];
    if (![SZUtil isEmptyOrNull:dicData[@"avatar"]])
        user.avatar = dicData[@"avatar"];
    user.uid_chat = dicData[@"uid_chat"];
    user.status = [dicData[@"status"] intValue];
    user.gender = [dicData[@"gender"] intValue];
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

- (void)syncUserProject:(ZHUserProject *)userProject withUDInfo:(NSDictionary *)dicData
{
    if (userProject == nil || dicData == nil)
        return;
    
    userProject.id_user_project = [dicData[@"id_user_project"] intValue];
    userProject.is_default = [dicData[@"is_default"] intValue];
    userProject.in_apply = [dicData[@"in_apply"] intValue];
    userProject.in_invite = [dicData[@"in_invite"] intValue];
    userProject.in_manager_invite = [dicData[@"in_manager_invite"] intValue];
    if (![SZUtil isEmptyOrNull:dicData[@"invite_user"]])
        userProject.invite_user = dicData[@"invite_user"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![SZUtil isEmptyOrNull:dicData[@"enter_date"]])
        userProject.enter_date = [dateFormatter dateFromString:dicData[@"enter_date"]];
    
    // 同步并关联对应的用户
    ZHUser *assignUser = [[DataManager defaultInstance] getUserFromCoredataByID:[dicData[@"id_user"] intValue]];
    userProject.belongUser = assignUser;
    
    // 同步并关联对应的项目
    ZHProject *assignProject = [[DataManager defaultInstance] getProjectFromCoredataById:[dicData[@"id_project"] intValue]];
    userProject.belongProject = assignProject;

    // 同步并关联对应的角色对象
    NSDictionary *roleDic = dicData[@"role"];
    ZHRole *currentRole = [[DataManager defaultInstance] getRoleFromCoredataById:[roleDic[@"id_role"] intValue]];
    [[DataManager defaultInstance] syncRole:currentRole withRoleInfo:roleDic];
    userProject.assignRole = currentRole;
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
        ZHRole *baseRole = [[DataManager defaultInstance] getRoleFromCoredataById:[roleDic[@"id_role"] intValue]];
        [[DataManager defaultInstance] syncRole:baseRole withRoleInfo:roleDic];
        role.baseRole = baseRole;
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

@end
