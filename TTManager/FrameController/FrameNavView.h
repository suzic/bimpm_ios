//
//  FrameNavView.h
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FrameNavView;

@protocol FrameNavViewDelegate <NSObject>

- (void)frameNavView:(FrameNavView *)navView selected:(NSInteger)currentSelectedIndex;
- (void)clickShowProjectListView;

@end

@interface FrameNavView : UIView

@property (nonatomic,weak) id<FrameNavViewDelegate>delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
