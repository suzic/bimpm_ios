//
//  TaskStepView.h
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import <UIKit/UIKit.h>
#import "OperabilityTools.h"

NS_ASSUME_NONNULL_BEGIN

#define itemWidth   60.0f
#define itemHeight  70.0f

@interface TaskStepView : UIView

/// 步骤数据 数据格式@[startUser,@[stepUser,],enduUser]
/// 新建:startUser = ZHUser,详情startUser = ZHStep
@property (nonatomic, strong) NSMutableArray *stepArray;
@property (nonatomic, strong) OperabilityTools *tools;

/// 当前步骤类型
//@property (nonatomic, assign) TaskStepType currentStepType;
/// 当前页面显示的页面类型 详情 新建
//@property (nonatomic, assign) TaskViewType taskViewType;

@end

NS_ASSUME_NONNULL_END
