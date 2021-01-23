//
//  UIButton+Extend.h
//  TTManager
//
//  Created by chao liu on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extend)

- (void)startCountDown:(NSInteger)total finishTitile:(NSString *)finishTitle;

@end

NS_ASSUME_NONNULL_END
