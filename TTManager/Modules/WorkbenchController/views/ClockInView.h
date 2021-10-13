//
//  ClockInView.h
//  TTManager
//
//  Created by chao liu on 2021/2/23.
//

#import <UIKit/UIKit.h>

#import "ClockInManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClockInView : UIView

- (instancetype)initWithManager:(ClockInManager *)manager;
// 切换打卡类型
@property (nonatomic, strong) UISegmentedControl *clockInTypeView;

/// 打卡范围
/// @param type 类型
- (void)changeClockInScope:(NSInteger)type;

-(void)setClockInViewType;

@end

NS_ASSUME_NONNULL_END
