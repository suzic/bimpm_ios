//
//  UIResponder+Router.h
//  textsss
//
//  Created by chao liu on 2020/8/11.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (Router)

/// 根据响应者传递事件
/// @param eventName 事件名称
/// @param userInfo 传递的参数
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
