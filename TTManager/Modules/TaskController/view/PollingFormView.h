//
//  PollingFormView.h
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveFromBlock)(BOOL success);

@interface PollingFormView : UIView

/// 当前进行中的步骤 0，1，2
@property (nonatomic, assign) NSInteger currentStep;

/// 是否修改了当前表单
@property (nonatomic, assign) BOOL isModification;

/// 是否克隆当前的表单文件
@property (nonatomic, assign) BOOL isCloneCurrentForm;

/// 克隆之后的表单id，只有在isCloneCurrentForm = YES时 才有用
@property (nonatomic, copy) NSString *clone_buddy_file;

/// 表单名称
@property (nonatomic, copy) NSString *formName;

/// 已经完成的任务不需要再次去克隆表单，表单默认都是不可编辑的
@property (nonatomic, assign) BOOL needClone;

/// 获取当前表单详情
/// @param buddy_file 表单id
- (void)getCurrentFormDetail:(NSString *)buddy_file;


/// 设置当前巡检步骤负责人
/// @param user 用户名称
/// @param index 负责的步骤
- (void)setPollingUser:(NSString *)user index:(NSInteger)index;

/// 保存表单
- (void)saveForm:(SaveFromBlock)saveBlock;

/// 改变当前巡检单状态
/// @param index 当前进行中的index
- (void)changPollingFormStatus:(NSInteger)index;

/// 表单必填参数检查
/// @param index 当前进行中的index
- (BOOL)checkPollinFormParams:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
