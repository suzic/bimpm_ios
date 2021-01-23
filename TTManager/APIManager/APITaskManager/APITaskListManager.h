//
//  APITaskListManager.h
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "BaseApiManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TaskListDataType){
    taskListDataType_none,
    taskListDataType_default,
};

@interface APITaskListManager : BaseApiManager<APIManager,APIManagerValidator>

@property (nonatomic,assign) TaskListDataType dataType;

@end

NS_ASSUME_NONNULL_END
