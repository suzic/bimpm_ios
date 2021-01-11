//
//  TaskParams.h
//  TTManager
//
//  Created by chao liu on 2021/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskParams : NSObject

@property (nonatomic, assign)TaskType type;

// 新建任务的id_flow_template
@property (nonatomic, assign) NSInteger id_flow_template;
@property (nonatomic, copy) NSString *uid_task;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, strong) NSString *id_user;
@property (nonatomic, strong) NSString *datePlan;
@property (nonatomic, strong) NSString *memo;

// 获取新建任务的请求参数
- (NSMutableDictionary *)getNewTaskParams;
// 获取任务详情的参数
- (NSMutableDictionary *)getTaskDetailsParams;
// 获取编辑参数
- (NSMutableDictionary *)getTaskEditParams;
// 获取设置任务优先级
- (NSMutableDictionary *)getTaskPriorityParams;
// 获取memo参数
- (NSMutableArray *)getMemoParams;
// 获取任务预计完成时间
- (NSMutableDictionary *)getTaskDatePlanParams;
// 获取附件的的参数
- (NSMutableDictionary *)getTaskFileParams;
// 获取目标人参数
- (NSMutableDictionary *)getToUserParams:(BOOL)to;
// 获取中间人参数
- (NSMutableDictionary *)getAssignUserParams;
// 提交的参数
- (NSMutableDictionary *)getProcessSubmitParams;
// 召回
- (NSMutableDictionary *)getProcessRecallParams;
// 中止
- (NSMutableDictionary *)getProcessTerminateParams;

@end

NS_ASSUME_NONNULL_END
