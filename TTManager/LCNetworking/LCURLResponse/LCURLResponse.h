//
//  LCURLResponse.h
//  textsss
//
//  Created by chao liu on 2020/12/22.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LCURLResponseStatus)
{
    LCURLResponseStatusSuccess        = 0,// 成功
    LCURLResponseStatusErrorTimeout   = 1,// 超时
    LCURLResponseStatusErrorNoNetwork = 2 // 默认除了超时以外都是无网络错误
};

NS_ASSUME_NONNULL_BEGIN

@interface LCURLResponse : NSObject

@property (nonatomic, assign) LCURLResponseStatus status;
@property (nonatomic, strong) id responseData;
@property (nonatomic, strong) NSNumber *requestId;
@property (nonatomic, strong) NSURLSessionDataTask *request;
@property (nonatomic, strong) NSDictionary *requestParams;

// 初始化成功数据
- (instancetype)initWithResponseData:(id)responseDic requestId:(NSNumber *)requestId task:(NSURLSessionDataTask *)task status:(LCURLResponseStatus)status;
// 初始化失败数据
- (instancetype)initWithResponseData:(id __nullable)responseDic requestId:(NSNumber *)requestId task:(NSURLSessionDataTask *)task error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
