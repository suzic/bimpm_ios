//
//  TaskController.h
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import <UIKit/UIKit.h>

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
