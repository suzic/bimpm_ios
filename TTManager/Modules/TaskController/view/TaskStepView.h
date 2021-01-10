//
//  TaskStepView.h
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import <UIKit/UIKit.h>
#import "OperabilityTools.h"

NS_ASSUME_NONNULL_BEGIN

#define itemWidth   60.0f
#define itemHeight  70.0f

@interface TaskStepView : UIView

@property (nonatomic, strong) OperabilityTools *tools;

@end

NS_ASSUME_NONNULL_END
