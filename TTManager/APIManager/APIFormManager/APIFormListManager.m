//
//  APIFormListManager.m
//  TTManager
//
//  Created by chao liu on 2021/1/19.
//

#import "APIFormListManager.h"

@implementation APIFormListManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;;
}
#pragma mark - APIManager
- (NSString *)apiName{
    return URL_FORM_LIST;
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    dict[@"pager"] = [self.pageSize currentPage];
    NSDictionary *dic = @{@"data":dict,
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
- (id)coreDataCallBackData:(LCURLResponse *)response{
    NSDictionary *dict = [NSDictionary changeType:(NSDictionary*)response.responseData[@"data"]];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *list = dict[@"list"];
    if ([list isKindOfClass:[NSArray class]]) {
        for (NSDictionary *formkDic in dict[@"list"]) {
            ZHForm *form = [[DataManager defaultInstance] syncFormWithFormInfo:formkDic];
            [array addObject:form];
        }
    }
    return array;

}
@end
