//
//  RequestHeaders.m
//  textsss
//
//  Created by chao liu on 2020/12/22.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import "RequestHeaders.h"

@implementation RequestHeaders

+ (NSDictionary *)requestHeaders
{
    NSString* token = @"";
    ZHUser *userLogin = [DataManager defaultInstance].currentUser;
    if (userLogin != nil && userLogin.is_login == YES)
        token = userLogin.token;
    
    NSMutableDictionary* header = [[NSMutableDictionary alloc]init];
    [header setObject:@"application/json; charset=utf-8" forKey:@"Content-Type"];
    [header setObject:token forKey:@"BIMPM-Token"];
    [header setObject:[NSString stringWithFormat:@"%@",[self timestamp]] forKey:@"Request-Datetime"];
    return header;
}
+ (NSString *)timestamp{
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",timestamp];
}
@end
