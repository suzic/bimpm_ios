//
//  UIView+BorderLine.h
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, UIBorderSideType) {
    UIBorderSideTypeAll  = 0,
    UIBorderSideTypeTop = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft = 1 << 2,
    UIBorderSideTypeRight = 1 << 3,
};

@interface UIView (BorderLine)

/// 添加边框
/// @param color 边框颜色
/// @param borderWidth 宽度
/// @param borderType 添加为止
- (UIView *)borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;

- (void)startActivityIndicatorView;
- (void)stopActivityIndicatorView;

- (void)clearStatusBarColor;
- (void)defaultStatusBarColor;

@end

NS_ASSUME_NONNULL_END
