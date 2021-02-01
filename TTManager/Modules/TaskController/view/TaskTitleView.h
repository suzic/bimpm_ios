//
//  TaskTitleView.h
//  TTManager
//
//  Created by chao liu on 2021/1/2.
//

#import <UIKit/UIKit.h>
#import "OperabilityTools.h"
#import "TaskContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskTitleView : UIView

@property (nonatomic, strong) UITextView *taskTitle;

@property (nonatomic, strong) OperabilityTools *tools;

@property (nonatomic, assign) BOOL isModification;
// 改变任务名称前的颜色
- (void)setTaskTitleStatusColor:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
