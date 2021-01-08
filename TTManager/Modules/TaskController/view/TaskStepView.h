//
//  TaskStepView.h
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import <UIKit/UIKit.h>
#import "TaskController.h"

NS_ASSUME_NONNULL_BEGIN

#define itemWidth   70.0f
#define itemHeight  120.0f

@interface TaskStepView : UIView

/// 步骤数据 数据格式@[startUser,@[stepUser,],enduUser]
/// 新建:startUser = ZHUser,详情startUser = ZHStep
@property (nonatomic, strong) NSArray *stepArray;

/// 当前步骤类型
@property (nonatomic, assign) TaskStepType currentStepType;

/// 当前页面显示的页面类型 详情 新建
@property (nonatomic, assign) TaskType taskType;

@end

NS_ASSUME_NONNULL_END
