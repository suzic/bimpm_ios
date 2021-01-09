//
//  UIAlertAction+Extend.h
//  TTManager
//
//  Created by chao liu on 2021/1/9.
//

#import <UIKit/UIKit.h>
#import "TaskController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertAction (Extend)

@property (nonatomic, assign)TaskType taskType;

@end

NS_ASSUME_NONNULL_END
