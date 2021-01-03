//
//  BaseApiManager.m
//  textsss
//
//  Created by chao liu on 2020/12/22.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import "BaseApiManager.h"
#import "ApiErrIntercept.h"

@interface BaseApiManager ()

@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong) ApiErrIntercept *errIntercept;

@end

@implementation BaseApiManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _paramSource = nil;
        _errorMessage = nil;
        _pageSize = [[PageSize alloc] init];
        _responsePageSize = [[PageSize alloc] init];
        if ([self conformsToProtocol:@protocol(APIManager)]) {
            self.child = (id<APIManager>)self;
        }else{
            self.child = (id <APIManager>)self;
            NSException *exception = [[NSException alloc] initWithName:@"BaseAPIManager提示" reason:[NSString stringWithFormat:@"%@没有遵循APIManager协议",self.child] userInfo:nil];
            @throw exception;
        }
    }
    return self;
}
#pragma mark - request
- (NSNumber *)request:(RequestType)requestype apiParams:(NSDictionary *)apiParams
{
    __weak typeof(self) weakSelf = self;
    NSNumber *requestId = [[ApiProxy sharedInstance] requestType:requestype
                                                          params:apiParams
                                                         service:self.child.service apiName:self.child.apiName success:^(LCURLResponse * _Nonnull response)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([response.responseData[@"code"] isEqualToNumber:@0]) {
            [strongSelf successedOnCallingAPI:response];
        }else{
            [strongSelf failedOnCallingAPI:response withErrorType:APIManagerErrorTypeDefault];
        }
    } fail:^(LCURLResponse * _Nonnull response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf failedOnCallingAPI:response withErrorType:APIManagerErrorTypeDefault];
    }];
    [self.requestIdList addObject:requestId];
    return requestId;
}
#pragma mark - public methods
- (void)cancelAllRequests
{
    [[ApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}
- (void)cancelRequestWithRequestId:(NSNumber *)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[ApiProxy sharedInstance] cancelRequestWithRequestID:requestID];
}

- (NSNumber *)loadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSNumber *requestId = [self loadDataWithParams:params];
    return requestId;
}
- (NSNumber *)loadDataWithParams:(NSDictionary *)params
{
    NSNumber *requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    // 校验参数
    if ([self.validator manager:self isCorrectWithParamsData:apiParams])
    {
        if ([self isReachable]){
            self.isLoading = YES;
            requestId = [self request:self.child.requestType apiParams:apiParams];
            return requestId;
        }
        else{
            [self failedOnCallingAPI:nil withErrorType:APIManagerErrorTypeNoNetWork];
            return requestId;;
        }
    }
    else{
        [self failedOnCallingAPI:nil withErrorType:APIManagerErrorTypeParamsError];
        return requestId;
    }
}

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}
#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSNumber *)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId isEqualToNumber:requestId]) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}
#pragma mark - api callbacks
- (void)successedOnCallingAPI:(LCURLResponse *)response
{
    self.isLoading = NO;
    self.response = response;
    [self removeRequestIdWithRequestID:response.requestId];
    // 当网络请求结束后，清空在数据管理器中存储的额外参数缓存
    [[DataManager defaultInstance].netwrokParamsCache removeAllObjects];
    // 校验返回参数的正确性 如果无需校验 直接返回YES
    if ([self.validator manager:self isCorrectWithCallBackData:response.responseData])
    {
        // 如果需要转coredata
        if (self.child.isCoreData == YES)
        {
            if (self.child && [self.child respondsToSelector:@selector(coreDataCallBackData:)]) {
               self.response.responseData = [self.child coreDataCallBackData:response];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(managerCallAPISuccess:)]) {
            [self.delegate managerCallAPISuccess:self];
        }
    }else{
        [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeNoContent];
    }
}
- (void)failedOnCallingAPI:(LCURLResponse *)response withErrorType:(APIManagerErrorType)errorType{
    self.isLoading = NO;
    self.response = response;
    BOOL needCallBack = YES;
    // 验证错误信息，是否继续下一步
    if (response != nil){
        needCallBack = [self.errIntercept shouldCallBackByFailedOnCallingAPI:response];
    }
    
    // 不需要返回的直接return
    if (!needCallBack) {
        return;
    }
    
    // 继续处理错误
    self.errorType = errorType;
    if (response)
        [self removeRequestIdWithRequestID:response.requestId];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(managerCallAPIFailed:)]) {
        [self.delegate managerCallAPIFailed:self];
    }
    
}

#pragma mark - setter and getter
- (NSMutableArray *)requestIdList{
    if (_requestIdList == nil) {
        _requestIdList = [NSMutableArray array];
    }
    return _requestIdList;
}
- (BOOL)isReachable
{
    BOOL isReachability = YES;
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        isReachability = YES;
    } else {
        isReachability = [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
    if (!isReachability) {
//        self.errorType = CTAPIManagerErrorTypeNoNetWork;
        NSLog(@"没有网络");
    }
    return isReachability;
}
- (BOOL)isLoading
{
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}
- (ApiErrIntercept *)errIntercept{
    if (_errIntercept == nil) {
        _errIntercept = [[ApiErrIntercept alloc] init];
    }
    return _errIntercept;
}
- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}
@end
