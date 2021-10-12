//
//  ApiErrIntercept.m
//  textsss
//
//  Created by chao liu on 2020/12/26.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import "ApiErrIntercept.h"
#import "ApiProxy.h"

@implementation ApiErrIntercept

// 默认都是YES 如果是一些权限相关的可以直接返回no 不处理
- (BOOL)shouldCallBackByFailedOnCallingAPI:(LCURLResponse *)response {
    BOOL result = YES;
    NSDictionary *dataDic = response.responseData;
    NSNumber *status = dataDic[@"code"];
    if ([dataDic isKindOfClass:[NSDictionary class]] && status == nil) {
        return result;
    }else{
        // 需要重新登录 抛出登录通知，继续下一步操作
        if ([status isEqualToNumber:@1]||[status isEqualToNumber:@2] ||[status isEqualToNumber:@3]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLoginFailed object:@{}];
        }else{
            NSString *msg = dataDic[@"msg"];
            NSString *url = [response.request.currentRequest.URL absoluteString];
            if ([url rangeOfString:URI_SIGN_IN].location !=NSNotFound && [status isEqualToNumber:@105]) {
                msg = @"在新的设备上登录，请输入图片中验证码";
            }
            [SZAlert showInfo:msg underTitle:TARGETS_NAME];
        }
    }
    return result;
}
@end
