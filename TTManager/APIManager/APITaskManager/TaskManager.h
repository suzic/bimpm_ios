//
//  TaskManager.h
//  TTManager
//
//  Created by chao liu on 2021/2/12.
//

#import <Foundation/Foundation.h>

typedef void(^TaskManagerBlock)(BOOL success,id _Nullable response);

typedef NS_ENUM(NSInteger,ApiTaskType){
    /// 任务详情
    apiTaskType_detail,
    /// 新建任务
    apiTaskType_new,
    /// 编辑任务
    apiTaskType_edit,
    /// 任务操作(包含上传附件)
    apiTaskType_operation,
    /// 进度操作
    apiTaskType_process,
    /// 终止任务发送短信
    apiTaskType_suspend,
    /// 撤销一个附件
    apiTaskType_repeal,
    /// 设置一个附件
    apiTaskType_set,
    /// 克隆一个表单
    clone_target_form,
};

@protocol TaskApiDelegate <NSObject>

/// 任务相关的网络请求成功或失败
/// @param success 成功或失败
/// @param manager 成功或失败数据
/// @param type    网络请求类型
- (void)callbackApiTaskSuccess:(BOOL)success data:(BaseApiManager *_Nullable)manager apiTaskType:(ApiTaskType)type;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TaskManager : NSObject

@property (nonatomic, weak)id<TaskApiDelegate>delegate;

/// 新建任务
/// @param params 参数
- (void)api_newTask:(NSDictionary *)params;

/// 获取任务详情
/// @param params 参数
- (void)api_getTaskDetail:(NSDictionary *)params;

/// 编辑任务
/// @param params 参数
- (void)api_editTask:(NSDictionary *)params;

/// 任务操作
/// @param params 参数
- (void)api_operationsTask:(NSDictionary *)params;

/// 任务进度处理
/// @param params 参数
- (void)api_processTask:(NSDictionary *)params;

/// 终止任务发送验证码
/// @param params  参数
- (void)api_suspendTask:(NSDictionary *)params;

/// 撤销任务附件(当前任务已经有附件了，需要再次上传附件，先撤销后上传)
/// @param params 参数
- (void)api_repealTaskAdjunct:(NSDictionary *)params callBack:(TaskManagerBlock)callBack;

/// 设置任务附件,如果不需要撤销附件 直接调用api_operationsTask效果一样
/// @param params 参数
- (void)api_setTaskAdjunct:(NSDictionary *)params;

/// 克隆表单
/// @param uid_target 需要克隆的表单文件id
/// @param callBack 返回参数
- (void)cloneForm:(NSString *)uid_target callBack:(TaskManagerBlock)callBack;

@end

NS_ASSUME_NONNULL_END
