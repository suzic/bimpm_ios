//
//  SZModalAlert.h
//  colorfloor
//
//  Created by 苏智 on 13-12-20.
//  Copyright (c) 2013年 Chujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SZModalAlert : NSObject
+ (BOOL)ask: (NSString *) question;
+ (BOOL)confirm:(NSString *) statement;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SZAlert : NSObject
+ (void)showInfo:(NSString*)info underTitle:(NSString*)title;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@class CNAlertView;
@protocol CNAlertViewDelegate <NSObject>
@optional
/**
 * @description 弹框按钮点击
 * @param alertView 自定义弹框对象
 * @param buttonIndex 点击按钮的索引
 */
- (void)alertView:(CNAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
@interface SZModalAlertDelegate : NSObject <CNAlertViewDelegate>
{
    CFRunLoopRef currentLoop;
    NSUInteger index;
}
@property (readonly) NSUInteger index;
@end
typedef void (^CNAlertViewCompletionBlock) (CNAlertView *alertView, NSInteger buttonIndex);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CNAlertView : NSObject

/** @decription 要显示的alert controller */
@property (strong, nonatomic) UIAlertController *alertController;
/** @decription alert所用代理 */
@property (weak, nonatomic) id <CNAlertViewDelegate> delegate;
/** @decription alert controller tag */
@property (assign, nonatomic) NSInteger tag;
/** @decription 弹框回调函数 */
@property (copy, nonatomic) CNAlertViewCompletionBlock tapBlock;
/** @decription alert第一个按钮索引 */
@property (assign, nonatomic) NSInteger firstOtherButtonIndex;
/** @decription alert取消按钮索引 */
@property (assign, nonatomic) NSInteger cancelButtonIndex;

/**
 * @description 显示alert view
 * @param title alert标题
 * @param message alert内容
 * @param delegate alert代理，如果为nil，则走block回调。参考tapBlock回调
 * @param cancelButtonTitle alert取消按钮的标题
 * @param otherButtonTitles alert另一个按钮，一般是确定
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id <CNAlertViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");

/**
 * @description 显示alert view，不需要指定弹框所用按钮，默认“取消”、“确定”
 * @param title alert标题
 * @param message alert内容
 * @param delegate alert代理，如果为nil，则走block回调。参考tapBlock回调
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id <CNAlertViewDelegate>)delegate;

/**
 * @description 显示alert view，不需要指定弹框所用按钮，默认“取消”、“确定”；不需要代理，走回调
 * @param title alert标题
 * @param message alert内容
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

/**
 * @decription 显示弹框
 */
- (void)show;

/**
 * @description 显示alert view，不需要指定弹框所用按钮，默认“取消”、“确定”；不需要代理，走回调
 * @param title alert标题
 * @param message alert内容
 * @param tapBlock alert点击按钮回调
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             tapBlock:(CNAlertViewCompletionBlock)tapBlock;

/**
 * @description 显示alert view，不需要代理，走回调
 * @param title alert标题
 * @param message alert内容
 * @param cancelButtonTitle alert取消按钮标题
 * @param otherButtonTitles alert按钮其他标题数组
 * @param tapBlock alert点击按钮回调
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
             tapBlock:(CNAlertViewCompletionBlock)tapBlock;

@end

