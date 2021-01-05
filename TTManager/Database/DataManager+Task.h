//
//  DataManager+Task.h
//  TTManager
//
//  Created by chao liu on 2021/1/5.
//

#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager (Task)


/// 根据当前任务id 获取
/// @param uid_task <#uid_task description#>
- (ZHTask *)getTaskFromCoredataByID:(int)uid_task;
- (ZHFlow *)getFlowStepFromCoredataByID:(int)uid_flow;
- (ZHStep *)getStepFromCoredataByID:(int)uid_step;
/// 同步任务
/// @param info 当前任务信息
- (ZHTask *)syncTaskWithTaskInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
