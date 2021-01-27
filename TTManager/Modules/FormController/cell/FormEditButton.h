//
//  FormEditButton.h
//  TTManager
//
//  Created by chao liu on 2021/1/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FormEditButton;

@protocol FormEditDelegate <NSObject>

- (void)startEditCurrentForm;
- (void)cancelEditCurrentForm;

@end

@interface FormEditButton : UIView

@property (nonatomic, assign)id<FormEditDelegate>delegate;

/// 重置编辑按钮样式
/// @param defaultStyle 是否是默认模式
- (void)resetEditButtonStyle:(BOOL)defaultStyle;

@end

NS_ASSUME_NONNULL_END
