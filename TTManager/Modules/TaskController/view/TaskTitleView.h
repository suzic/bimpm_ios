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

typedef NS_ENUM(NSInteger,PriorityType){
    priority_type_low        = 1,  // 低级
    priority_type_middle     = 5, // 中级
    priority_type_highGrade  = 7  // 高级
};

@interface TaskTitleView : UIView

@property (nonatomic, strong) UITextView *taskTitle;

@property (nonatomic, strong) OperabilityTools *tools;

// 当前任务优先级
@property (nonatomic, assign)PriorityType priorityType;

@property (nonatomic, assign) BOOL isModification;
// 改变任务名称前的颜色
- (void)setTaskTitleStatusColor:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
