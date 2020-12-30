//
//  ApiProxy.h
//  textsss
//
//  Created by chao liu on 2020/12/22.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RequestType){
    REQUEST_TYPE_GET    = 0,// get
    REQUEST_TYPE_POST   = 1,// post
    REQUEST_TYPE_PUT    = 2,// put
    REQUEST_TYPE_DELETE = 3 // delete
};

typedef void (^APICallback)(LCURLResponse *response);

@interface ApiProxy : NSObject

+ (instancetype)sharedInstance;

- (NSNumber *)requestType:(RequestType)requestType
                   params:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                    fail:(APICallback)fail;
- (NSNumber *)requestGETWithParams:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                     fail:(APICallback)fail;
- (NSNumber *)requestPOSTWithParams:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                     fail:(APICallback)fail;
- (NSNumber *)requestPUTWithParams:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                     fail:(APICallback)fail;
- (NSNumber *)requestDELETEWithParams:(NSDictionary *)params
                  service:(NSString *)service
              apiName:(NSString *)apiName
                 success:(APICallback)success
                     fail:(APICallback)fail;

/// 根据ID取消单个请求
/// @param requestID 请求id
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

/// 取消多个请求
/// @param requestIDList 请求id列表
- (void)cancelRequestWithRequestIDList:(NSArray*)requestIDList;

@end

NS_ASSUME_NONNULL_END
