//
//  TaskController.h
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import <UIKit/UIKit.h>
/*
 1:页面显示，页面详情、新建任务
 2:任务详情，任务步骤不能修改，状态：发起，终止，反对，同意等状态
 3:新建任务，任务完成人可修改，状态：发起，终止，
 */
// 页面显示
typedef NS_ENUM(NSInteger,TaskType){
    TaskType_details,
    TaskType_newTask
};

NS_ASSUME_NONNULL_BEGIN

@interface TaskController : UIViewController

@property (nonatomic,assign)TaskType taskType;

@end

NS_ASSUME_NONNULL_END
