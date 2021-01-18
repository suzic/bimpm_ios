//
//  UITableView+EmptyView.h
//  TTManager
//
//  Created by chao liu on 2021/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (EmptyView)

/// tableView空页面时显示的页面
/// @param count tableView的个数
/// @param type 显示空页面的图片 1:空白页面 2:任务空，3:起草任务空
- (void)showDataCount:(NSInteger)count type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
