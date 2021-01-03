//
//  BaseApiManager.h
//  textsss
//
//  Created by chao liu on 2020/12/22.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCURLResponse.h"
#import "ApiProxy.h"
#import "PageSize.h"

@class BaseApiManager;

typedef NS_ENUM(NSInteger,APIManagerErrorType){
    APIManagerErrorTypeDefault,// 默认
    APIManagerErrorTypeSuccess,// 成功
    APIManagerErrorTypeNoContent,// 成功但数据错误
    APIManagerErrorTypeParamsError,// 参数错误
    CTAPIManagerErrorTypeTimeout,// 超时
    APIManagerErrorTypeNoNetWork// 无网络
};

NS_ASSUME_NONNULL_BEGIN

// 让manager获取到api需要的参数
@protocol APIManagerParamSource <NSObject>
@required
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager;
@end
// 参数和返回数据校验
@protocol APIManagerValidator <NSObject>
// 数据一般都会校验，如果无需校验直接返回YES
@required
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)data;

@end
// 必须实现的方法，一个请求必要的数据
@protocol APIManager <NSObject>
@required
// API名字
- (NSString *)apiName;
// 服务器地址
- (NSString *)service;
// 请求类型
- (RequestType)requestType;
// 是否coredata
- (BOOL)isCoreData;

@optional
// 添加参数(不能修改原有数据)，比如分页
- (NSDictionary *)reformParams:(NSDictionary *)params;
// 子类如果实现次方法，则子类自己实现网络
- (NSNumber *)loadDataWithParams:(NSDictionary *)params;
// 如果需要coredata数据子类实现此方法
- (id)coreDataCallBackData:(LCURLResponse *)response;
@end

@protocol ApiManagerCallBackDelegate <NSObject>
@optional
- (void)managerCallAPIStart:(BaseApiManager *)manager;
@required
- (void)managerCallAPISuccess:(BaseApiManager *)manager;
- (void)managerCallAPIFailed:(BaseApiManager *)manager;
@end

@interface BaseApiManager : NSObject
// api回掉
@property (nonatomic, weak)id<ApiManagerCallBackDelegate>delegate;
// api参数
@property (nonatomic, weak)id<APIManagerParamSource>paramSource;
// 校验
@property (nonatomic, weak)id<APIManagerValidator>validator;
// 子类
@property (nonatomic, weak)NSObject<APIManager>*child;

@property (nonatomic, strong) PageSize *pageSize;
// 返回数据
@property (nonatomic, strong) LCURLResponse *response;
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, assign) APIManagerErrorType errorType;
@property (nonatomic, assign) BOOL isReachable;
@property (nonatomic, assign) BOOL isLoading;


/// 获取当前API数据
- (NSNumber *)loadData;

/// 取消所有请求
- (void)cancelAllRequests;

/// 根据ID取消单个请求
/// @param requestID 任务id
- (void)cancelRequestWithRequestId:(NSNumber *)requestID;

// 一般不使用
- (NSDictionary *)reformParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
