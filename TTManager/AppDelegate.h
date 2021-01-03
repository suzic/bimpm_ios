//
//  AppDelegate.h
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;
@property (assign, nonatomic) BOOL initRongCloud;

+ (AppDelegate *)sharedDelegate;
// 初始化融云(默认初始化时可能没有uid_chat,登录成功之后再次初始化)
- (void)initRongCloudIM;

@end

