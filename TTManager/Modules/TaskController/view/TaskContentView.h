//
//  TaskContentView.h
//  TTManager
//
//  Created by chao liu on 2021/1/2.
//

#import <UIKit/UIKit.h>
#import "OperabilityTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskContentView : UIView

@property (nonatomic, strong) UITextView *contentView;

@property (nonatomic, strong) OperabilityTools *tools;

@property (nonatomic, assign) BOOL isModification;
@end

NS_ASSUME_NONNULL_END
