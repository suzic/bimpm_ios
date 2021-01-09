//
//  TaskParams.h
//  TTManager
//
//  Created by chao liu on 2021/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskParams : NSObject

@property (nonatomic, assign) NSInteger id_flow_template;
@property (nonatomic, strong) NSMutableDictionary *task_info;

@property (nonatomic, strong) ZHTask *currentTask;

- (NSDictionary *)getTaskParams;

@end

NS_ASSUME_NONNULL_END
