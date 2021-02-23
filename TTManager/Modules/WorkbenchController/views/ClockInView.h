//
//  ClockInView.h
//  TTManager
//
//  Created by chao liu on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClockInView : UIView


/// 打卡范围
/// @param type 类型
- (void)changeClockInScope:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
