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

@property (nonatomic, assign) TaskStatus taskStatus;
@property (nonatomic, copy) NSString *listTitle;

@end

NS_ASSUME_NONNULL_END
