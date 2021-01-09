//
//  TaskContentView.h
//  TTManager
//
//  Created by chao liu on 2021/1/2.
//

#import <UIKit/UIKit.h>
#import "OperabilityTools.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,PriorityType){
    priority_type_low        = 0,  // 低级
    priority_type_middle     = 1, // 中级
    priority_type_highGrade  = 2  // 高级
};

@interface TaskContentView : UIView

@property (nonatomic, strong) OperabilityTools *tools;
// 当前任务优先级
@property (nonatomic, assign)PriorityType priorityType;

@end

NS_ASSUME_NONNULL_END
