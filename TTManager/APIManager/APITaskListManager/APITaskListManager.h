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
    taskListDataType_my_unfinished,     // 我派发的未完成
    taskListDataType_my_finished,       // 我派发的的已完成
    taskListDataType_toMy_unfinished,   // 派送给我的未完成
    taskListDataType_toMy_finished,     // 派送给我的已完成
};

@interface APITaskListManager : BaseApiManager<APIManager,APIManagerValidator>

@property (nonatomic,assign) TaskListDataType dataType;

@end

NS_ASSUME_NONNULL_END
