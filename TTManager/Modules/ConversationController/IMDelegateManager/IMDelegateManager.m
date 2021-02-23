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
    // 2:从服务器获取用户信息
    else{
        [RCDUserInfoManager getUserInfoFromServer:userId
                                             complete:^(RCUserInfo *userInfo) {
                                                    completion(userInfo);
                
            }];
    }
    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
}

@end
