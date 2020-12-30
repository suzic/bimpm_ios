//
//  NSDictionary+Dlog.m
//  NewRetail
//
//  Created by liuchao on 2018/3/27.
//  Copyright © 2018年 MVM. All rights reserved.
//

#import "NSDictionary+Dlog.h"

@implementation NSDictionary (Dlog)

- (NSString *)descriptionWithLocale:(id)locale{

    if (![self count]) {
        return @"";
    }
    NSString *tempStr1 =
    [[self description] stringByReplacingOccurrencesOfString:@"\\u"
                                                  withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =

    [NSPropertyListSerialization propertyListWithData:tempData
                                              options:NSPropertyListImmutable
                                               format:NULL
                                                error:NULL];
    return str;

}

@end
