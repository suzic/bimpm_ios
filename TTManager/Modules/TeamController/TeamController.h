//
//  TeamController.h
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^selectedUserBlock)(ZHUser *user);

@interface TeamController : UIViewController

///selectedUserType NO 正常浏览点击进入下一步 ，YES点击会回上一页
@property (nonatomic, assign) BOOL selectedUserType;
@property (nonatomic, copy) selectedUserBlock selectUserBlock;
@end

NS_ASSUME_NONNULL_END
