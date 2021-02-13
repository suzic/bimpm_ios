//
//  PollingHeaderView.h
//  TTManager
//
//  Created by chao liu on 2021/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PollingHeaderView : UIView


/// 设置进度情况
/// @param dic 进度数据
/// @param index 0 发起 1整改 2 确认
- (void)setFormHeaderData:(NSDictionary *)dic index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
