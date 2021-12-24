//
//  AppDelegate.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "AppDelegate.h"
#import "IMDelegateManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 初始化数据库实例
    [DataManager defaultInstance];
    
    [TTProductManager defaultInstance];
    // 初始化键盘
    [self initIQKeyBoard];
    // 初始化融云
    [self initRongCloudIM];
    
    [self setAppearanceStyle];
    
    [self setCurrentService];
    
    return YES;
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[RCIMClient sharedRCIMClient] setDeviceTokenData:deviceToken];
}

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (void)setCurrentService{
#if DEBUG
    NSString *service = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsNetService];
    // debug模式下默认是正式服务器
    if ([SZUtil isEmptyOrNull:service]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:UserDefaultsNetService];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
#else
#endif
}
- (void)initRongCloudIM{
    self.initRongCloud = NO;
    [[RCIM sharedRCIM] initWithAppKey:RongCloudIMKey];
    ZHUser *user = [DataManager defaultInstance].currentUser;
    
    [[RCIM sharedRCIM] setUserInfoDataSource:[IMDelegateManager manager]];
    
    NSLog(@"%@",user.uid_chat);
    if (user.uid_chat) {
        [[RCIM sharedRCIM] connectWithToken:user.uid_chat dbOpened:^(RCDBErrorCode code) {
            NSLog(@"本地消息数据库打开的回调 %ld",code);
            } success:^(NSString *userId) {
                NSLog(@"连接融云IM成功");
                self.initRongCloud = YES;
            } error:^(RCConnectErrorCode errorCode) {
                NSLog(@"连接融云IM失败");
            }];
    }
    // 聊天信息本地存储
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
}
- (BOOL)isLogin{
    ZHUser *user = [DataManager defaultInstance].currentUser;
    if (user == nil) {
        return NO;
    }else{
        if (user.is_login == NO) {
            return NO;;
        }
    }
    return YES;
}
#pragma mark - initIQKeyBoard
- (void)initIQKeyBoard
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 控制整个功能是否启用
    keyboardManager.enable = YES;
    // 控制点击背景是否收起键盘
    keyboardManager.shouldResignOnTouchOutside = YES;
    // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    // 有多个输入框时，可以通过点击Toolbar上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    // 控制是否显示键盘上的工具条
    keyboardManager.enableAutoToolbar = YES;
    // 是否显示占位文字
    keyboardManager.shouldShowToolbarPlaceholder = YES;
    // 设置占位文字的字体
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17];
    // 输入框距离键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}
- (void)setAppearanceStyle
{
    // 定义系统状态栏默认风格
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UINavigationBar appearance] setBackgroundImage:[SZUtil createImageWithColor:RGBA_COLOR(5, 125, 255, 1.0)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:RGB_COLOR(5, 125, 255)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName,nil]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UINavigationBar appearance].translucent = NO;
}

@end
