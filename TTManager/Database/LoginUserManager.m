//
//  LoginUserManager.m
//  TTManager
//
//  Created by chao liu on 2020/12/26.
//

#import "LoginUserManager.h"

NSString * const CurrentLoginUserPhone = @"CurrentLoginUserPhone";
NSString * const CurrentSelectedProject = @"CurrentSelectedProject";

@implementation LoginUserManager

// 单例模式下的默认实例的创建
+ (instancetype)defaultInstance
{
    static LoginUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}
- (NSString *)currentLoginUserPhone{
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserPhone];
    _currentLoginUserPhone = phone;
    return _currentLoginUserPhone;
}
- (NSString *)currentSelectedProjectId{
    if (_currentSelectedProjectId == nil) {
        NSString *id_project = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentSelectedProject];
        _currentSelectedProjectId = id_project;
    }
    return _currentSelectedProjectId;
}
- (void)saveCurrentLoginUserPhone:(NSString *)phone
{
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:CurrentLoginUserPhone];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeCurrentLoginUserPhone
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:CurrentLoginUserPhone];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:CurrentSelectedProject];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)saveCurrentSelectedProject:(NSString *)id_project{
    [[NSUserDefaults standardUserDefaults] setObject:id_project forKey:CurrentSelectedProject];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (ZHUser *)getUserByRongIMId:(NSString *)uid_chat{
    ZHUser *user = nil;
    NSArray *result = [[DataManager defaultInstance] arrayFromCoreData:@"ZHUser" predicate:nil limit:NSIntegerMax offset:0 orderBy:nil];
    for (ZHUser *userItem in result) {
        if ([userItem.uid_chat containsString:uid_chat]) {
            user = userItem;
            break;
        }
    }
    return user;
}
@end
