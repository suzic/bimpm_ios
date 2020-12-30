//
//  NSURLSessionTask+RequestParams.h
//  textsss
//
//  Created by chao liu on 2020/12/23.
//  Copyright © 2020 liuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionTask (RequestParams)

@property (nonatomic, copy)NSDictionary *requestParams;

@end

NS_ASSUME_NONNULL_END
