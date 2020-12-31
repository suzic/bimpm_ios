//
//  TaskListController.h
//  TTManager
//
//  Created by chao liu on 2020/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TaskStatus){
    Task_list       = 0, // 任务列表
    Task_finish     = 1, // 已完成
    Task_sponsoring = 2, // 正在发起中
    Task_sponsored  = 3, // 已经发起
};

@interface TaskListController : UIViewController

@property (nonatomic,assign)TaskStatus taskStatus;

@end

NS_ASSUME_NONNULL_END
