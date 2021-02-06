//
//  BuilderDiaryController.h
//  TTManager
//
//  Created by chao liu on 2021/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuilderDiaryController : UIViewController

/// 是否需要克隆当前表单
@property (nonatomic, assign) BOOL isCloneForm;
/// 表单buddy_file
@property (nonatomic, strong) NSString *buddy_file;

@end

NS_ASSUME_NONNULL_END
