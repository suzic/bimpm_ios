//
//  NSString+Extend.h
//  TTManager
//
//  Created by chao liu on 2021/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extend)

/// url 后拼接参数
/// @param value value
/// @param key key
-(NSString *)urlAddCompnentForValue:(NSString *)value key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
