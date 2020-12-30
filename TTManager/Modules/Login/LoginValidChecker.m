//
//  LoginValidChecker.m
//  classonline
//
//  Created by 苏智 on 2017/4/17.
//  Copyright © 2017年 offcn. All rights reserved.
//

#import "LoginValidChecker.h"

@implementation LoginValidChecker

// 当前系统中应用到的输入检查器
+ (bool)validString:(NSString *)string inFormat:(SPECValidStringFormat)format
{
    NSString* info = nil;
    switch (format)
    {
        case SPECVaildStringFormatUserName:
            // 先检查用户名，并根据用户名获取用户缓存值（不存在时会新建一个）
            if ([SZUtil isEmptyOrNull:string])
                info = [NSString stringWithFormat:@"未填写用户手机号码"];
            else if (![SZUtil isMobileNumber:string])
                info = [NSString stringWithFormat:@"请填写正确的手机号码（11位）"];
            break;
            
        case SPECVaildStringFormatPassword:
            if ([SZUtil isEmptyOrNull:string])
                info = @"请填写密码";
            else if (string.length > 64)
                info = @"密码长度不能超过64个字符";
            break;

        case SPECVaildStringFormatCaptcha:
            if ([SZUtil isEmptyOrNull:string])
                info = @"请填写图形验证码";
            else if (string.length != 4)
                info = @"图形验证码长度不正确";
            break;
            
        case SPECValidStringFormatVerifyCode:
        default:
            if ([SZUtil isEmptyOrNull:string])
                info = @"请填写验证码";
            else if (string.length > 16)
                info = @"验证码长度不能超过16个字符";
            break;
    }
    
    if (info != nil)
    {
        [SZAlert showInfo:info underTitle:@"众和空间"];
        return NO;
    }
    return YES;
}

@end
