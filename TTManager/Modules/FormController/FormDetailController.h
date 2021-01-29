//
//  FormDetailController.h
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedTarget)(NSString * _Nullable buddy_file);

NS_ASSUME_NONNULL_BEGIN

@interface FormDetailController : UIViewController

// 是否来自taskDetail
@property (nonatomic, assign) BOOL isTaskDetail;

@property (nonatomic, copy) SelectedTarget selectedTarget;

@property (nonatomic, strong) NSString *buddy_file;

@end

NS_ASSUME_NONNULL_END
