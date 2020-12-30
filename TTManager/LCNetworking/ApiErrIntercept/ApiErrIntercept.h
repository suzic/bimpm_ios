//
//  ApiErrIntercept.h
//  textsss
//
//  Created by chao liu on 2020/12/26.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApiErrIntercept : NSObject
// 是否继续返回数据，可以做一些错误判断
- (BOOL)shouldCallBackByFailedOnCallingAPI:(LCURLResponse *)response;

@end

NS_ASSUME_NONNULL_END
