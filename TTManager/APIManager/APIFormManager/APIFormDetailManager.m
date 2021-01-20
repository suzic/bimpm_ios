//
//  APIFormDetailManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/19.
//

#import "APIFormDetailManager.h"

@implementation APIFormDetailManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_FORM_DETAIL;
}
- (NSString *)service{
    return SERVICEADDRESS;
}
- (RequestType)requestType{
    return REQUEST_TYPE_POST;
}

- (BOOL)isCoreData {
    return YES;
}
- (NSDictionary *)reformParams:(NSDictionary *)params{
    NSDictionary *dic = @{@"data":params,
                          @"priority":@"5",
                          @"module":@""
    };
    return dic;
}

#pragma mark - APIManagerValidator 参数验证
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)data{
    return YES;
}

- (BOOL)manager:(BaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    return YES;
}

-(id)coreDataCallBackData:(LCURLResponse *)response{
    NSDictionary *dict = [NSDictionary changeType:(NSDictionary*)response.responseData[@"data"]];
    ZHForm *form = [[DataManager defaultInstance] syncFormWithFormInfo:dict[@"form_info"]];
    return form;
}

@end
