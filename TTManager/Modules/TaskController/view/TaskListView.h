//
//  TaskListView.h
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import "TaskListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskListView : UIView

/// 1 任务 2 表单
@property (nonatomic, assign) NSInteger listType;

@property (nonatomic, copy) NSString *listTitle;
@property (nonatomic, assign) BOOL needReloadData;
@property (nonatomic, assign) TaskStatus currentTaskStatus;

@property (nonatomic, assign) NSInteger formType;
- (void)reloadDataFromNetwork;

@end

NS_ASSUME_NONNULL_END
