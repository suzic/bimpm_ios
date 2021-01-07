//
//  Commons.h
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#ifndef Commons_h
#define Commons_h

#define RongCloudIMKey     @"y745wfm8yhplv"
#define RongCloudIMSecret  @"Awlfd3KNBBT"

// 添加这个宏，就不用带mas_前缀
#define MAS_SHORTHAND
// 添加这个宏，equalTo就等价于mas_equalTo
#define MAS_SHORTHAND_GLOBALS

#define FunctionCellHeight 94


#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <SDWebImage/SDWebImage.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <RongIMKit/RongIMKit.h>
#import <Aspects/Aspects.h>
#import "SZUtil.h"
#import "UIViewExt.h"
#import "SZModalAlert.h"
#import "NSString+BPUtil.h"
#import "UIView+BorderLine.h"
#import "BaseNavigationController.h"
#import "UIResponder+Router.h"
#import "NSDictionary+Extend.h"
#import "UITableView+EmptyView.h"
#import "UIViewController+ImagePicker.h"

// 获取屏幕的尺寸
#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

// 带有安全区域
#define IPHONE_X ({\
BOOL  tmp = NO;\
if (@available(iOS 11.0, *)){\
UIWindow * window = [[[UIApplication sharedApplication] delegate] window];\
tmp = window.safeAreaInsets.bottom > 0;\
}\
tmp;\
})
// 获取状态栏高度
#define STATUS_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)

//获取导航栏+状态栏的高度
#define SafeAreaTopHeight  (STATUS_HEIGHT + 44.0f)
#define SafeAreaBottomHeight (IPHONE_X == YES ? 34 : 0)

#define INT_32_TO_STRING(data) ([NSString stringWithFormat:@"%d",data])

#endif /* Commons_h */
