//
//  IMDelegateManager.m
//  TTManager
//
//  Created by chao liu on 2021/2/23.
//

#import "IMDelegateManager.h"
#import "RCDUserInfoManager.h"

@interface IMDelegateManager ()<RCIMUserInfoDataSource>

@end

@implementation IMDelegateManager

+ (instancetype)manager{
    static IMDelegateManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

#pragma mark - RCIMUserInfoDataSource

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    // 1:从cache中获取用户信息
    RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:userId];
    if (userInfo.name && ![userInfo.name isEqualToString:@"未知用户"]) {
        if (completion) {
            completion(userInfo);
        }
    }
    else{
        // 2:从本地数据库查询
        ZHUser *user = [[LoginUserManager defaultInstance] getUserByRongIMId:userId];
        if (user && ![SZUtil isEmptyOrNull:user.name]) {
            RCUserInfo *userInfo = [[RCUserInfo alloc] init];
            userInfo.name = user.name;
            userInfo.userId = [NSString stringWithFormat:@"%d",user.id_user];
            userInfo.portraitUri = user.avatar;
            completion(userInfo);
        }else{
            // 3:从服务器获取用户信息
            [RCDUserInfoManager getUserInfoFromServer:userId
                                                 complete:^(RCUserInfo *userInfo) {
                                                        completion(userInfo);
                    
                }];
        }
    }
    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
}

@end
