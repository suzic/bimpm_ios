//
//  TaskParams.h
//  TTManager
//
//  Created by chao liu on 2021/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskParams : NSObject

// 新建任务的id_flow_template
@property (nonatomic, assign) NSInteger id_flow_template;
@property (nonatomic, copy) NSString *uid_task;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
// 获取新建任务的请求参数
- (NSMutableDictionary *)getNewTaskParams;
// 获取任务详情的参数
- (NSMutableDictionary *)getTaskDetailsParams;
// 获取编辑参数
- (NSMutableDictionary *)getTaskEditParams;

@end

NS_ASSUME_NONNULL_END
