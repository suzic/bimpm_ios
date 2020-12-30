//
//  LCURLResponse.m
//  textsss
//
//  Created by chao liu on 2020/12/22.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import "LCURLResponse.h"
#import "NSURLSessionTask+RequestParams.h"

@interface LCURLResponse ()

@property (nonatomic, strong) NSError *error;

@end

@implementation LCURLResponse

#pragma mark - life cycle

- (instancetype)initWithResponseData:(id)responseDic requestId:(NSNumber *)requestId task:(NSURLSessionDataTask *)task  status:(LCURLResponseStatus)status{
    self = [super init];
    if (self) {
        self.responseData = responseDic;
        self.status = status;
        self.requestId = requestId;
        self.request = task;
        self.requestParams = task.requestParams;
        self.error = nil;
        NSLog(@"请求成功url==%@ 参数==%@ 返回数据=%@",task.currentRequest.URL,task.requestParams,responseDic);
    }
    return self;
}
- (instancetype)initWithResponseData:(id __nullable)responseDic requestId:(NSNumber *)requestId task:(NSURLSessionDataTask *)task  error:(NSError *)error{
    self = [super init];
    if (self) {
        self.responseData = @{@"code":@(error.code),@"msg":@"请检查您的网络"};
        self.status = [self responseStatusWithError:error];
        self.requestId = requestId;
        self.request = task;
        self.requestParams = task.requestParams;
        self.error = error;
        NSLog(@"请求失败url==%@ 参数==%@ 错误信息=%@",task.currentRequest.URL,task.requestParams,error.localizedDescription);
    }
    return self;
}
#pragma mark - private methods
- (LCURLResponseStatus)responseStatusWithError:(NSError *)error
{
    NSLog(@"网络请求失败code===%ld 内容==%@",(long)error.code,error.localizedDescription);
    if (error) {
        LCURLResponseStatus result = LCURLResponseStatusErrorNoNetwork;
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = LCURLResponseStatusErrorTimeout;
        }
        return result;
    } else {
        return LCURLResponseStatusSuccess;
    }
}
@end
