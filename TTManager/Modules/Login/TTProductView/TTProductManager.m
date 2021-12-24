//
//  TTProductManager.m
//  TTManager
//
//  Created by chao liu on 2021/12/24.
//

#import "TTProductManager.h"

@interface TTProductManager ()

@property (nonatomic, copy) NSString *selectedType;
@property (nonatomic, copy) NSDictionary *currentProduct;

@end

@implementation TTProductManager

+ (instancetype)defaultInstance{
    static TTProductManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
        [instance getProductList];
    });
    return instance;
}
/// 设置当前选中的产品
- (void)setCurrentSelectedProduct:(NSDictionary *)dict{
    if ([SZUtil isEmptyOrNull:dict[@"type"]]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"type"] forKey:current_selected_service];
    self.selectedType = dict[@"type"];
    _currentProduct = nil;
    [self getCurrentProduc];
}

/// 当前是否有选中的产品
- (BOOL)hasCurrentSelectedProduct{
    return ![SZUtil isEmptyOrNull:self.selectedType];
}

/// 当前选中的产品地址
- (NSDictionary *)currentProduct{
    if (_currentProduct == nil) {
        _currentProduct = [NSDictionary dictionary];
        NSArray *list = product_list;
        for (NSDictionary *dict in list) {
            if ([dict[@"type"] isEqualToString: self.selectedType]) {
                _currentProduct = dict;
                break;
            }
        }
    }
    return _currentProduct;
}
- (NSDictionary *)getCurrentProduc{
    return self.currentProduct;
}
- (void)getProductList{
    self.selectedType = [[NSUserDefaults standardUserDefaults] objectForKey:current_selected_service];
    [self getCurrentProduc];
}

@end
