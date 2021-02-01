//
//  LoginUserManager.h
//  TTManager
//
//  Created by chao liu on 2020/12/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginUserManager : NSObject

+ (instancetype)defaultInstance;
// 当前登录的用户手机号
@property (nonatomic,copy)NSString *currentLoginUserPhone;

//@property (nonatomic,copy)NSString *currentSelectedProjectId;

- (ZHUser *)getUserByRongIMId:(NSString *)uid_chat;

/// 在本地存储当前登录账号，以便于查找当前用户表(用户登录之后再操作存储)
/// @param phone 当前登录用户账号
- (void)saveCurrentLoginUserPhone:(NSString *)phone;

/// 移除当前登录账号(只在退出登录时调用)
- (void)removeCurrentLoginUserPhone;

//- (void)saveCurrentSelectedProject:(NSString *)id_project;

@end

NS_ASSUME_NONNULL_END
