//
//  RCDUserInfoManager.m
//  TTManager
//
//  Created by chao liu on 2021/2/23.
//

#import "RCDUserInfoManager.h"

@implementation RCDUserInfoManager

+ (void)getUserInfoFromServer:(NSString *)userId
                     complete:(void (^)(RCUserInfo *userInfo))completion{
    if ([SZUtil isEmptyOrNull:userId]) {
        if (completion) {
            RCUserInfo *userInfo = [[RCUserInfo alloc] init];
            userInfo.name = @"未知用户";
            userInfo.userId = @"";
            completion(userInfo);
        }
    }
    NSDictionary *params = @{@"data":@{@"id_user":userId},
                             @"module":@"",
                             @"priority":@"5"};
    [[ApiProxy sharedInstance] requestPOSTWithParams:params
                                             service:SERVICEADDRESS apiName:URL_USER_DETAIL success:^(LCURLResponse * _Nonnull response) {
        if (completion) {
            NSDictionary *userInfoDic = response.responseData[@"data"][@"user_info"];
            RCUserInfo *userInfo = [[RCUserInfo alloc] init];
            userInfo.name = userInfoDic[@"name"];
            userInfo.userId = [NSString stringWithFormat:@"%@",userInfoDic[@"id_user"]];
            userInfo.portraitUri = userInfoDic[@"avatar"];
            completion(userInfo);
        }
        } fail:^(LCURLResponse * _Nonnull response) {
            if (completion) {
                RCUserInfo *userInfo = [[RCUserInfo alloc] init];
                userInfo.name = @"未知用户";
                userInfo.userId = userId;
                completion(userInfo);
            }
        }];
}

@end
