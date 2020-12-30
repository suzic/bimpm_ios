//
//  APICaptchManager.m
//  TTManager
//
//  Created by chao liu on 2020/12/26.
//

#import "APICaptchManager.h"

@implementation APICaptchManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URI_VERIFY_CAPTCHA;
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
- (id)coreDataCallBackData:(LCURLResponse *)response{
    NSDictionary *dataDic = (NSDictionary *)response.responseData[@"data"];
    NSData *dataObject = [[NSData alloc] initWithBase64EncodedString:dataDic[@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:dataObject];;
}
@end
