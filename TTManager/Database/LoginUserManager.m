//
//  LoginUserManager.m
//  TTManager
//
//  Created by chao liu on 2020/12/26.
//

#import "LoginUserManager.h"

NSString * const CurrentLoginUserPhone = @"CurrentLoginUserPhone";

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
- (void)saveCurrentLoginUserPhone:(NSString *)phone
{
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:CurrentLoginUserPhone];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeCurrentLoginUserPhone
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:CurrentLoginUserPhone];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
