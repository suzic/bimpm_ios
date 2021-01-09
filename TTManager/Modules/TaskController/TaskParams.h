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

// 获取新建任务的请求参数
- (NSMutableDictionary *)getNewTaskParams;

@end

NS_ASSUME_NONNULL_END
