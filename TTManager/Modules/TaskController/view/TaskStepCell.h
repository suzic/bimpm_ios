//
//  TaskStepCell.h
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import <UIKit/UIKit.h>
#import "OperabilityTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskStepCell : UICollectionViewCell

@property (nonatomic, strong) ZHStep *currentStep;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) TaskType type;
@property (nonatomic, strong) OperabilityTools *tools;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
