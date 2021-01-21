//
//  ProjectSelectController.h
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import <UIKit/UIKit.h>
#import "FrameController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProjectSelectController : UIViewController

@property (nonatomic, weak)FrameController *frameVC;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
