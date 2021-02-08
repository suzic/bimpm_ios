//
//  FormItemBtnView.h
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormItemBtnView : UIView

/// 设置当前item数据以及是否可编辑
/// @param edit 是否可编辑
/// @param data 页面数据
- (void)setItemEdit:(BOOL)edit data:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
