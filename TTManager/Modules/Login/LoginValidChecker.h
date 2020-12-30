//
//  LoginValidChecker.h
//  classonline
//
//  Created by 苏智 on 2017/4/17.
//  Copyright © 2017年 offcn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _SPECValidStringFormat
{
    SPECVaildStringFormatUserName = 0,
    SPECVaildStringFormatPassword = 1,
    SPECValidStringFormatVerifyCode = 2,
    SPECVaildStringFormatCaptcha = 3
} SPECValidStringFormat;

@interface LoginValidChecker : NSObject

+ (bool)validString:(NSString *)string inFormat:(SPECValidStringFormat)format;

@end
