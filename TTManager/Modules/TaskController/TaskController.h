//
//  TaskController.h
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import <UIKit/UIKit.h>
/*
 1:页面显示，页面详情、新建任务
 2:任务详情，任务步骤不能修改，状态：发起，终止，反对，同意等状态
 3:新建任务，任务完成人可修改，状态：发起，终止，
 */
// 页面显示
typedef NS_ENUM(NSInteger,TaskType){
    TaskType_details,
    TaskType_newTask
};
typedef NS_ENUM(NSInteger,TaskStepType){
    step_type_start_none_end          = 0, // 双点
    step_type_start_serial_end        = 1, // 固定顺序型(双点中有多个顺序步骤人员)
    step_type_start_parallel_end      = 2, // 固定并行(双点中有多个固定并行步骤人员)
    step_type_start_open_parallel_end = 3, // 开放并行(双点中有多个并行步骤人员)
};
NS_ASSUME_NONNULL_BEGIN

@interface TaskController : UIViewController

/// 当前任务页面显示的任务类型，详情 或 新建
@property (nonatomic,assign)TaskType taskType;

/// 当前任务的步骤类型
@property (nonatomic,assign)TaskStepType stepType;

@end

NS_ASSUME_NONNULL_END
