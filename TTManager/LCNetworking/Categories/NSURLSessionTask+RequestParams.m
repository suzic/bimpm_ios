//
//  NSURLSessionTask+RequestParams.m
//  textsss
//
//  Created by chao liu on 2020/12/23.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import "NSURLSessionTask+RequestParams.h"
#import <objc/runtime.h>

static char *LCRequestParams = "LCRequestParams";

@implementation NSURLSessionTask (RequestParams)

- (NSDictionary *)requestParams{
    return objc_getAssociatedObject(self, LCRequestParams);
}
- (void)setRequestParams:(NSDictionary *)requestParams{
    objc_setAssociatedObject(self, LCRequestParams, requestParams, OBJC_ASSOCIATION_COPY);

}
@end
