//
//  DataManager+User.h
//  ttmanager
//
//  Created by 苏智 on 2018/10/31.
//  Copyright © 2020年 Suzic. All rights reserved.
//

#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager (User)

/// 根据id获取uiser
/// @param userId userid
- (ZHUser *)getUserFromCoredataByID:(int)userId;

/// 根据projectId获取project
/// @param projectId projectId
- (ZHProject *)getProjectFromCoredataById:(int)projectId;

/// 获取UserProject
/// @param upId upId
- (ZHUserProject *)getUserProjectFromCoredataById:(int)upId;

/// 清除当前项目下的团队人员
/// @param currentProject 当前选择的项目
- (void)cleraDepartmentFromCurrentProject:(ZHProject *)currentProject;

/// 清除DepartmentUser
/// @param currentDepartment currentDepartment
- (void)cleraDepartmentUserFromCurrentDepartment:(ZHDepartment *)currentDepartment;
/// 获取项目部门t
/// @param id_department id_department
- (ZHDepartment *)getDepartMentFromCoredataById:(int)id_department;
- (void)syncDepartMentWithInfo:(NSDictionary *)dict;
- (void)syncDepartmentDetailWithInfo:(NSDictionary *)dict;

- (ZHDepartmentUser *)getDepartmentUserFromCoredataById:(int)order_index;
/// 获取Role
/// @param roleId roleId
- (ZHRole *)getRoleFromCoredataById:(int)roleId;

/// 获取Module
/// @param moduleId moduleId
- (ZHModule *)getModuleFromCoredataById:(int)moduleId;

/// 设置当前登录用户的phone
/// @param phone phone
- (void)setCurrentUserByPhone:(NSString *)phone;

/// 同步用户数据
/// @param user 当前用户
/// @param dicData 数据
- (ZHUser *)syncUser:(ZHUser *)user withUserInfo:(NSDictionary *)dicData;

/// 同步project
/// @param project project
/// @param dicData 数据
- (void)syncProject:(ZHProject *)project withProjectInfo:(NSDictionary *)dicData;

/// 同步用户的Project
/// @param userProject userProject
/// @param dicData 数据
- (ZHUserProject *)syncUserProject:(ZHUserProject *)userProject withUDInfo:(NSDictionary *)dicData;

/// 同步role
/// @param role role
/// @param dicData 数据
- (void)syncRole:(ZHRole *)role withRoleInfo:(NSDictionary *)dicData;

/// 同步module
/// @param module module
/// @param dicData 数据
- (void)syncModule:(ZHModule *)module withModuleInfo:(NSDictionary *)dicData;

@end

NS_ASSUME_NONNULL_END
