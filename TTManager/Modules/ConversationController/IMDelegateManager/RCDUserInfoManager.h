//
//  RCDUserInfoManager.h
//  TTManager
//
//  Created by chao liu on 2021/2/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCDUserInfoManager : NSObject

/// 根据user获取用户信息
/// @param userId userid
/// @param completion 完成的回掉
+ (void)getUserInfoFromServer:(NSString *)userId
                     complete:(void (^)(RCUserInfo *userInfo))completion;

@end

NS_ASSUME_NONNULL_END
