//
//  UIResponder+Router.m
//  textsss
//
//  Created by chao liu on 2020/8/11.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
