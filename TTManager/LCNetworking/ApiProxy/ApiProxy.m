//
//  ApiProxy.m
//  textsss
//
//  Created by chao liu on 2020/12/22.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import "ApiProxy.h"
#import "ServiceIdentifer.h"
#import "RequestHeaders.h"
#import "LCURLResponse.h"
#import "NSURLSessionTask+RequestParams.h"

@interface ApiProxy ()

@property (nonatomic, strong)NSMutableDictionary *dispatchTable;
@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong)NSDictionary *headers;

@end

@implementation ApiProxy

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static ApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSNumber *)requestType:(RequestType)requestType
                   params:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                    fail:(APICallback)fail
{
    NSNumber *requestID = @0;
    switch (requestType) {
        case REQUEST_TYPE_GET:
            requestID =[self requestGETWithParams:params service:service apiName:apiName success:success fail:fail];
            break;
        case REQUEST_TYPE_POST:
            requestID =[self requestPOSTWithParams:params service:service apiName:apiName success:success fail:fail];
            break;
        case REQUEST_TYPE_PUT:
            requestID =[self requestPUTWithParams:params service:service apiName:apiName success:success fail:fail];
            break;
        case REQUEST_TYPE_DELETE:
            requestID =[self requestDELETEWithParams:params service:service apiName:apiName success:success fail:fail];
            break;
        case REQUEST_TYPE_UPLOAD:
            requestID = [self requestUploadWithParams:params service:service apiName:apiName success:success fail:fail];
            break;
        default:
            break;
    }
    return requestID;
}
- (NSNumber *)requestGETWithParams:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                              fail:(APICallback)fail
{
    NSString *url = [ServiceIdentifer initServiceIdentifer:service apiName:apiName];
    NSURLSessionDataTask *dataTask = [self.sessionManager GET:url parameters:params headers:self.headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessTask:task params:params responseObject:responseObject success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self requestFailureTask:task params:params error:error failure:fail];
        }];
    NSNumber *requestId = [self saveRequestId:dataTask];
    [dataTask resume];
    return requestId;
}
- (NSNumber *)requestPOSTWithParams:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                               fail:(APICallback)fail
{
    NSString *url = [ServiceIdentifer initServiceIdentifer:service apiName:apiName];
    NSURLSessionDataTask *dataTask = [self.sessionManager POST:url parameters:params headers:self.headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessTask:task params:params responseObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureTask:task params:params error:error failure:fail];
    }];
    NSNumber *requestId = [self saveRequestId:dataTask];
    [dataTask resume];
    return requestId;
}

- (NSNumber *)requestPUTWithParams:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                              fail:(APICallback)fail
{
    NSString *url = [ServiceIdentifer initServiceIdentifer:service apiName:apiName];
    NSURLSessionDataTask *dataTask = [self.sessionManager PUT:url parameters:params headers:self.headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessTask:task params:params responseObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureTask:task params:params error:error failure:fail];
    }];
    NSNumber *requestId = [self saveRequestId:dataTask];
    [dataTask resume];
    return requestId;
}
- (NSNumber *)requestDELETEWithParams:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                                 fail:(APICallback)fail
{
    NSString *url = [ServiceIdentifer initServiceIdentifer:service apiName:apiName];
    NSURLSessionDataTask *dataTask = [self.sessionManager DELETE:url parameters:params headers:self.headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessTask:task params:params responseObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureTask:task params:params error:error failure:fail];
    }];
    NSNumber *requestId = [self saveRequestId:dataTask];
    [dataTask resume];
    return requestId;
}
- (NSNumber *)requestUploadWithParams:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                                 fail:(APICallback)fail{
    NSString *url = [ServiceIdentifer initServiceIdentifer:service apiName:apiName];
    NSDictionary *dic = params[@"params"];
    NSArray *imageArray = params[@"upload"];
    NSURLSessionDataTask * uploadtask =  [self.sessionManager POST:url parameters:dic headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSData * image in imageArray)
        {
            NSString * leadingString = [SZUtil getGUID];
            [formData appendPartWithFileData:image name:@"file" fileName:[NSString stringWithFormat:@"%@.png",leadingString] mimeType:@"image/png"];
        }
      } progress:^(NSProgress * _Nonnull uploadProgress)
      {
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
      {
        [self requestSuccessTask:task params:params responseObject:responseObject success:success];

      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
      {
        [self requestFailureTask:task params:params error:error failure:fail];

      }];
    NSNumber *requestId = [self saveRequestId:uploadtask];
//    [uploadtask resume];
    return requestId;
}

// 取消单个请求
- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}
// 取消多个请求
- (void)cancelRequestWithRequestIDList:(NSArray*)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}
// 接口返回成功
- (void)requestSuccessTask:(NSURLSessionDataTask *)task params:(NSDictionary *)params responseObject:(id)responseObject success:(APICallback)success{
    [self removeRequestId:task];
    task.requestParams = params;
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    LCURLResponse *response = [[LCURLResponse alloc] initWithResponseData:responseObject requestId:@([task taskIdentifier]) task:task status:LCURLResponseStatusSuccess];
    success ? success(response) : nil;
}
// 接口返回失败
- (void)requestFailureTask:(NSURLSessionDataTask *)task params:(NSDictionary *)params error:(NSError *)error failure:(APICallback)fail{
    [self removeRequestId:task];
    task.requestParams = params;
    LCURLResponse *response = [[LCURLResponse alloc] initWithResponseData: nil requestId:@([task taskIdentifier]) task:task error:error];
    fail ? fail(response) : nil;
    
}
// 保存requestID
- (NSNumber *)saveRequestId:(NSURLSessionDataTask *)task{
    NSNumber *requestId = @([task taskIdentifier]);
    self.dispatchTable[requestId] = task;
    return requestId;
}
// 删除requestID
- (void)removeRequestId:(NSURLSessionDataTask *)task{
    NSNumber *requestId = @([task taskIdentifier]);
    [self.dispatchTable removeObjectForKey:requestId];
}
#pragma mark - getters and setters

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable ==nil){
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager
{
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = 15.0;
        _sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    for (NSString *key in self.headers)
    {
         [_sessionManager.requestSerializer setValue:_headers[key] forHTTPHeaderField:key];
    }
    
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                   @"text/html",
                                                                                   @"text/json",
                                                                                   @"text/plain",
                                                                                   @"text/javascript",
                                                                                   @"text/xml",
                                                                                   @"image/*"]];
    return _sessionManager;
}
- (NSDictionary *)headers{
    _headers = [RequestHeaders requestHeaders];
    return _headers;
}
@end
