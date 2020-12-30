//
//  ServiceIdentifer.h
//  textsss
//
//  Created by chao liu on 2020/12/22.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceIdentifer : NSObject

// 设置请求路径
+ (NSString *)initServiceIdentifer:(NSString *)service apiName:(NSString *)apiName;

@end

NS_ASSUME_NONNULL_END
