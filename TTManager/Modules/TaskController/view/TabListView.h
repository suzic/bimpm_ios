//
//  TabListView.h
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabListView : UIView

@property(nonatomic, assign) NSInteger selectedTaskIndex;
@property(nonatomic, assign) NSInteger listType;
- (void)setChildrenViewList:(NSArray *)listView;

@end

NS_ASSUME_NONNULL_END
