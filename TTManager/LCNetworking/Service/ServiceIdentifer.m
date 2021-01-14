//
//  ServiceIdentifer.m
//  textsss
//
//  Created by chao liu on 2020/12/22.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import "ServiceIdentifer.h"

static NSString * const serviceIdentifer = @"mws.mvmyun.com";
static NSString * const HTTP = @"http://";
static NSString * const HTTPS = @"https://";

@implementation ServiceIdentifer

+ (NSString *)initServiceIdentifer:(NSString *)service apiName:(NSString *)apiName{
    NSString *url = @"";
    if (apiName){
        url = [NSString stringWithFormat:@"%@%@",service,apiName];
    }
    return url;
}

@end
