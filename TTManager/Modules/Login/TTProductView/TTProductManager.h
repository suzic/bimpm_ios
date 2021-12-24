//
//  TTProductManager.h
//  TTManager
//
//  Created by chao liu on 2021/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTProductManager : NSObject

+ (instancetype)defaultInstance;

/// 设置当前选中的产品
/// @param dict 选中的产品
- (void)setCurrentSelectedProduct:(NSDictionary *)dict;

/// 当前是否有选中的产品
- (BOOL)hasCurrentSelectedProduct;

/// 当前选中的产品地址
- (NSDictionary *)getCurrentProduc;

@end

NS_ASSUME_NONNULL_END
