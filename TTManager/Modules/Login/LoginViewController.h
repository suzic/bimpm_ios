//
//  LoginViewController.h
//  TTManager
//
//  Created by chao liu on 2020/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, LoginType)
{
    typeLoginPassword,      // 使用用户名密码登录
    typeLoginVerify,        // 使用用户名验证码登录
    typeLoginNewDevice,     // 首次登录新设备需要额外验证码
    typeLoginRetrieving,    // 找回密码
    typeLoginRegister,      // 注册
};

@interface LoginViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
