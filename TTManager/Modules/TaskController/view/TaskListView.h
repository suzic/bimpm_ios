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

@property (nonatomic, copy) NSString *listTitle;
@property (nonatomic, assign) BOOL needReloadData;
@property (nonatomic, assign) TaskStatus currentTaskStatus;
- (void)reloadDataFromNetwork;

@end

NS_ASSUME_NONNULL_END
