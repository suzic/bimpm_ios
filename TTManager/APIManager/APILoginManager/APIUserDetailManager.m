//
//  APIUserDetailManager.m
//  TTManager
//
//  Created by chao liu on 2021/2/23.
//

#import "APIUserDetailManager.h"

@implementation APIUserDetailManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_USER_DETAIL;
}
- (NSString *)service{
    return SERVICEADDRESS;
}
- (RequestType)requestType{
    return REQUEST_TYPE_POST;
}

- (BOOL)isCoreData {
    return NO;
}
- (NSDictionary *)reformParams:(NSDictionary *)params{
    NSDictionary *dic = @{@"data":params,
                          @"module":@"",
                          @"priority":@"5"};
    return dic;
}
#pragma mark - APIManagerValidator 参数验证
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)data{
    return YES;
}
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    return YES;
}

@end
