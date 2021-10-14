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
- (void)stopTimer;

/// 发送任务样式
- (void)sengType:(NSString *)text;
/// 赞同任务样式
- (void)approvalType:(NSString *)text;
/// 反对的样式
- (void)opposeType:(NSString *)text;

/// 发送任务样式
- (void)sengFinishType:(NSString *)text;
/// 赞同任务样式
- (void)approvalFinishType:(NSString *)text;
/// 反对的样式
- (void)opposeFinishType:(NSString *)text;

- (void)highlightColor;
- (void)defaultColor;
@end

NS_ASSUME_NONNULL_END
