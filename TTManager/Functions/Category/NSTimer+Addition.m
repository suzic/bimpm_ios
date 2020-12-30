//
//  NSTimer+Addition.m
//  test
//
//  Created by new on 2017/5/31.
//  Copyright © 2017年 liuchao. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

- (void)pause
{
    if (!self.isValid) return;
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume
{
    if (!self.isValid) return;
    [self setFireDate:[NSDate date]];
}

- (void)resumeWithTimeInterval:(NSTimeInterval)time
{
    if (!self.isValid) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}

@end
