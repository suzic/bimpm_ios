//
//  TaskListView.h
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TaskStatus){
    Task_list       = 0, // 任务列表
    Task_finish     = 1, // 已完成
    Task_sponsoring = 2, // 正在发起中
    Task_sponsored  = 3, // 已经发起
};

NS_ASSUME_NONNULL_BEGIN

@interface TaskListView : UIView

@property (nonatomic, assign) TaskStatus taskStatus;
@property (nonatomic, copy) NSString *listTitle;

@end

NS_ASSUME_NONNULL_END
