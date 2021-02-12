//
//  TaskContentView.h
//  TTManager
//
//  Created by chao liu on 2021/1/2.
//

#import <UIKit/UIKit.h>
#import "OperabilityTools.h"

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSInteger,PriorityType){
//    priority_type_low        = 1,  // 低级
//    priority_type_middle     = 5, // 中级
//    priority_type_highGrade  = 7  // 高级
//};

@interface TaskContentView : UIView

@property (nonatomic, strong) UITextView *contentView;

@property (nonatomic, strong) OperabilityTools *tools;
// 当前任务优先级
//@property (nonatomic, assign)PriorityType priorityType;

@property (nonatomic, assign) BOOL isModification;
@end

NS_ASSUME_NONNULL_END
