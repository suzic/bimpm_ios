//
//  PollingFormView.h
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PollingFormView : UIView

/// 当前进行中的步骤 0，1，2
@property (nonatomic, assign) NSInteger currentStep;

/// 是否克隆当前的表单文件
@property (nonatomic, assign) BOOL isCloneCurrentForm;

/// 克隆之后的表单id，只有在isCloneCurrentForm = YES时 才有用
@property (nonatomic, copy) NSString *clone_buddy_file;

/// 获取当前表单详情
/// @param buddy_file 表单id
- (void)getCurrentFormDetail:(NSString *)buddy_file;

@end

NS_ASSUME_NONNULL_END
