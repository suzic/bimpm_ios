//
//  LCPopTool.h
//  TTManager
//
//  Created by chao liu on 2021/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCPopTool : NSObject

+ (instancetype)defaultInstance;

- (void)showAnimated:(BOOL)animated;

- (void)closeAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
