//
//  FrameController.h
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrameController : UIViewController

//@property (assign, nonatomic) BOOL inShowLogin;

/// 刷新当前选择项目
/// @param project 当前选择的项目
- (void)reloadCurrentSelectedProject:(ZHProject *)project;

@end

NS_ASSUME_NONNULL_END
