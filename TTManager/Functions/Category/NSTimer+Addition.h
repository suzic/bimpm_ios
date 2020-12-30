//
//  NSTimer+Addition.h
//  test
//
//  Created by new on 2017/5/31.
//  Copyright © 2017年 liuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;

@end
