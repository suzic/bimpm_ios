//
//  TaskTabView.h
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskTabView : UIView

- (void)setChildrenViewList:(NSArray *)listView;
- (void)changCurrentTab:(NSInteger)selected;

@end

NS_ASSUME_NONNULL_END
