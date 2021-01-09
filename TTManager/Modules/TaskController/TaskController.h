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
typedef NS_ENUM(NSInteger,TaskType){
    task_type_new_task            = 1,//任务
    task_type_new_apply           = 2,// 申请
    task_type_new_noti            = 3,// 通知
    task_type_new_joint           = 4, // 会审
    task_type_new_polling         = 5,// 巡检
    task_type_detail_proceeding   = 6,// 进行中
    task_type_detail_finished     = 7,// 已经完成
    task_type_detail_draft        = 8,// 我起草的
    task_type_detail_initiate     = 9,// 已经发起
};

NS_ASSUME_NONNULL_BEGIN

@interface TaskController : UIViewController

@property (nonatomic, assign)TaskType taskType;

@end

NS_ASSUME_NONNULL_END
