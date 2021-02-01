//
//  FrameController.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "FrameController.h"
#import "FrameNavView.h"
#import "UserSettingController.h"
#import "ProjectSelectController.h"
#import "SettingViewController.h"
#import "AboutViewController.h"

@interface FrameController () <APIManagerParamSource, ApiManagerCallBackDelegate, FrameNavViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *homeView;      // 主页面
@property (weak, nonatomic) IBOutlet UIView *shadowView;    // 遮罩层
@property (weak, nonatomic) IBOutlet UIView *userView;      // 抽屉视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userViewFront;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectTopLayoutConstraint;

@property (nonatomic, strong) UIViewController *homeVC;     // 主页面VC
@property (nonatomic, strong) FrameNavView *headerView;     // 导航栏
@property (nonatomic, strong) UserSettingController *settingVC;
@property (nonatomic, strong) ProjectSelectController *projectVC;
@property (nonatomic, strong) UIViewController *userVC;     // 抽屉VC

@property (nonatomic, strong) APILoginManager *loginManager;
@property (nonatomic, strong) APILoginManager *newDeviceCheckManager;
@property (nonatomic, strong) APIIMTokenManager *IMTokenManager;

@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, assign) CGPoint lastPoint;            // 拖动距离
@property (nonatomic, assign) BOOL bFirst;                  // 第一次进入

@end

@implementation FrameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self addNotification];
    self.inShowLogin = NO;
    self.bFirst = YES;    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([AppDelegate sharedDelegate].isLogin == NO && self.bFirst) {
        self.bFirst = NO;
        [self userLoginFailed:nil];
    }
//    if (self.bFirst)
//    {
//        self.bFirst = NO;
//        ZHUser *currentUser = [DataManager defaultInstance].currentUser;
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLoginNeeded object:@{@"silenceLogin":@(currentUser.is_login)}];
//    }
}

#pragma mark - init

- (void)initUI
{
    self.userViewWidth.constant = self.view.frame.size.width * 0.8f;
    self.userViewFront.constant = -self.userViewWidth.constant;
    
    self.shadowView.hidden = YES;
    [self.view insertSubview:self.headerView belowSubview:self.userView];
    
    [self showProjectListView:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.shadowView addGestureRecognizer:tapGesture];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.userView addGestureRecognizer:panGesture];
}

- (void)addNotification
{
    // 抽屉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings:) name:NotiShowSettings object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToMain:) name:NotiBackToMain object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHeaderView:) name:NotiShowHeaderView object:nil];
    // 登录相关的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucceed:) name:NotiUserLogined object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginNeeded:) name:NotiUserLoginNeeded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginFailed:) name:NotiUserLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDeviceCheck:) name:NotiUserDeviceCheck object:nil];
}

#pragma mark - Action

// 处理在显示Settings层时，前景视图上的滑动手势// 处理在显示Settings层时，前景视图上的滑动手势
- (void)handleGesture:(UIGestureRecognizer *)sender
{
    // 判断禁止左滑或者右滑
    if (![sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        CGPoint lastPoint = [pan translationInView:self.view];
        if (lastPoint.x > 0)
            return;
    }
    
    if ([sender isKindOfClass:[UITapGestureRecognizer class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiBackToMain object:self];
    else if ([sender isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        switch (pan.state)
        {
            case UIGestureRecognizerStateBegan:
            {
                self.lastPoint = [pan translationInView:self.view];
                break;
            }
                
            case UIGestureRecognizerStateChanged:
            {
                CGPoint point = [pan translationInView:self.view];
                CGFloat offset = point.x - self.lastPoint.x;
                self.lastPoint = point;
                CGRect frame = self.userView.frame;
                frame.origin.x += offset;
                frame.origin.x = fabs(frame.origin.x) > frame.size.width ? frame.size.width : frame.origin.x;
                frame.origin.x = fabs(frame.origin.x) < 0 ? 0 : frame.origin.x;
                self.userView.frame = frame;
                break;
            }
                
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                CGRect frame = self.userView.frame;
                if (fabs(self.lastPoint.x) > (frame.size.width + 5) / 2)
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotiBackToMain object:self];
                else
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSettings object:nil];
                break;
            }
                
            default:
                break;
        }
    }
}

- (void)reloadCurrentSelectedProject:(ZHProject *)project
{
    NSLog(@"选择项目");
    [self showProjectListView:NO];
    [DataManager defaultInstance].currentProject = project;
    [self.headerView reloadData];
    [[LoginUserManager defaultInstance] saveCurrentSelectedProject:INT_32_TO_STRING(project.id_project)];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiReloadHomeView object:nil];
    [self updateFrame];
}

#pragma mark - NSNotification

// 显示个人中心
- (void)showSettings:(NSNotification *)notification
{
    self.shadowView.hidden = NO;
    self.userView.hidden = NO;
    CGRect rect = self.userView.frame;
    rect.origin.x = 0;
    [self setUserViewShadowLayer:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.userView.frame = rect;
        self.shadowView.alpha = 0.5;
    }];
}

// 返回home
- (void)backToMain:(NSNotification *)notification
{
    CGRect rect = self.userView.frame;
    rect.origin.x = -kScreenWidth * 4 / 5 - 5;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.userView.frame = rect;
        self.shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
        self.userView.hidden = YES;
    }];
    [self showUserSetting:[notification object]];
}

- (void)showUserSetting:(NSObject *)obj
{
    if (obj != nil && [obj isKindOfClass:[NSIndexPath class]])
    {
        NSIndexPath *indexPath = (NSIndexPath *)obj;
        switch (indexPath.row) {
            case 0:
            {
                AboutViewController *vc = [[AboutViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                SettingViewController *vc = [[SettingViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (void)showHeaderView:(NSNotification *)notification
{
    BOOL showHeader = [notification.object boolValue];
    self.headerView.hidden = !showHeader;
}

// 默认情况下静默登录（silence = YES）；可通过notification.object参数@(NO)指定显式登录
- (void)userLoginNeeded:(NSNotification *)notification
{
    // 存在两种情况，1:登录页面直接带参数通知需要登录（params有值的时候），调用loadDataWithParams:(走此方法时不调用paramsForApi:获取参数)
    // 2:不带params 直接通知需要登录，此时请求参数paramsForApi:获取参数
    NSDictionary *notiData = (NSDictionary *)notification.object;
    BOOL silenceLogin = notiData[@"silenceLogin"] == nil ? YES : [((NSNumber *)notiData[@"silenceLogin"]) boolValue];
    
    if (notiData[@"params"] != nil){
        [self.loginManager loadDataWithParams:notiData[@"params"]];
    }else{
        ZHUser *currentUser = [DataManager defaultInstance].currentUser;
        // 在当前用户有密码（系统创建的默认用户是没有密码的）的情况下，才考虑静默登录过程
        if (silenceLogin && currentUser.phone != nil && ![currentUser.phone isEqualToString:@""])
            [self.loginManager loadData];
        // 否则，使用登录失败的方式呼叫出登录窗口
        else
            [self userLoginFailed:nil];
    }
}

// 执行用户登录失败
- (void)userLoginFailed:(NSNotification *)notification
{
    if (self.inShowLogin == YES)
        return;
    self.inShowLogin = YES;
    
//    ZHUser *currentUser = [DataManager defaultInstance].currentUser;
//    currentUser.is_login = NO;
//    [[DataManager defaultInstance] saveContext];
#warning 登录太麻烦了 暂时注销
    [self performSegueWithIdentifier:@"tologin" sender:nil];
}

// 检查用户设备验证
- (void)userDeviceCheck:(NSNotification *)notification
{
    NSString *verifyCode = (NSString *)notification.object;
    if (![SZUtil isEmptyOrNull:verifyCode])
    {
        self.verifyCode = verifyCode;
        [self.newDeviceCheckManager loadData];
    }
}

// 执行用户登录成功
- (void)userLoginSucceed:(NSNotification *)notification
{
//    ZHUser *currentUser = [DataManager defaultInstance].currentUser;
//    currentUser.is_login = YES;
//    [[DataManager defaultInstance] saveContext];
    
    // 登录成功后必然会结束登录界面（尽管这里没有明显的指定，可作为Assert理解）
    self.inShowLogin = NO;
    [self updateFrame];
}

#pragma mark - private

// 添加阴影层
- (void)setUserViewShadowLayer:(BOOL)show
{
    self.userView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.userView.layer.shadowOffset = CGSizeMake(show ? 5:0, 0);
//    self.UserView.layer.masksToBounds = NO;
    self.userView.layer.shadowRadius = show ? 3.0f : 0.0f;
    self.userView.layer.shadowOpacity = show ? 0.5 : 0.0f;
}

- (void)showProjectListView:(BOOL)show
{
    if (show == YES) {
        [self performSegueWithIdentifier:@"project" sender:self];
    }
    else {
        [self.projectVC dismissViewControllerAnimated:YES completion:nil];
    }
    [self.headerView changeTabProjectStyle:show];
}

// 处理页面
- (void)updateFrame
{
    self.headerView.hidden = NO;
    [self.headerView reloadData];
    [self.settingVC reloadData];
    NSString *id_project = [LoginUserManager defaultInstance].currentSelectedProjectId;
    if ([SZUtil isEmptyOrNull:id_project]) {
        [self showProjectListView:YES];
    }else{
        [self showProjectListView:NO];
    }
    [self.projectVC reloadData];
}

#pragma mark - FrameNavViewDelegate

- (void)clickShowProjectListView{
    [self showProjectListView:YES];
}

- (void)frameNavView:(FrameNavView *)navView selected:(NSInteger)currentSelectedIndex{
    [self showProjectListView:NO];
    ZHUserProject *userProject =  self.headerView.projectList[currentSelectedIndex];
    
    [DataManager defaultInstance].currentProject = userProject.belongProject;
    
    [[LoginUserManager defaultInstance] saveCurrentSelectedProject:INT_32_TO_STRING(userProject.belongProject.id_project)];
    
    NSLog(@"当前选择的项目名称===%@",userProject.belongProject.name);
    [self updateFrame];
}

#pragma mark - ApiManagerCallBackDelegate

- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.loginManager || manager == self.newDeviceCheckManager) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLogined object:nil];
        ZHUser *currentUser = [DataManager defaultInstance].currentUser;
        if (![SZUtil isEmptyOrNull:currentUser.uid_chat]) {
            if ([AppDelegate sharedDelegate].initRongCloud == NO) {
                [[AppDelegate sharedDelegate] initRongCloudIM];
            }
        }else{
            [self.IMTokenManager loadData];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiReloadHomeView object:nil];
        [self updateFrame];
    }else if(manager == self.IMTokenManager){
        ZHUser *currentUser = [DataManager defaultInstance].currentUser;
        if (![SZUtil isEmptyOrNull:currentUser.uid_chat]) {
            currentUser.uid_chat = manager.response.responseData[@"data"][@"uid_chat"];
            [[DataManager defaultInstance] saveContext];
            
            if ([AppDelegate sharedDelegate].initRongCloud == NO) {
                [[AppDelegate sharedDelegate] initRongCloudIM];
            }
        }
    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.loginManager || manager == self.newDeviceCheckManager) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLoginFailed object:@{@"code":manager.response.responseData[@"code"], @"msg":manager.response.responseData[@"msg"]}];
    }
}

#pragma mark - APIManagerParamSource

- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    ZHUser *currentUser = [DataManager defaultInstance].currentUser;
    NSString *deviceType = [SZUtil deviceVersion];
    if (manager == self.loginManager){
        NSString *savedPassword = @"";
        if ([SZUtil isEmptyOrNull:currentUser.verify_code] == YES){
            if (![SZUtil isEmptyOrNull:currentUser.password])
                savedPassword = currentUser.password.MD5String;
        }
       params = @{@"phone":currentUser.phone,
                 @"password":savedPassword,
                 @"verify":currentUser.verify_code == nil ? @"" : currentUser.verify_code,
                 @"captcha":@"",
                 @"device_id":currentUser.device,
                  @"device_name":deviceType};
    }else if(manager == self.newDeviceCheckManager){
       params = @{@"phone":currentUser.phone,
                 @"password":currentUser.pass_md5,
                 @"verify":self.verifyCode,
                 @"captcha":@"",
                 @"device_id":currentUser.device,
          @"device_name":deviceType};
    }else if(manager == self.IMTokenManager){
        params = @{@"id_user":INT_32_TO_STRING(currentUser.id_user)};
    }
    NSLog(@"请求参数%@",params);
    return params;
}

#pragma mark - setter and getter

- (APILoginManager *)loginManager{
    if (_loginManager == nil) {
        _loginManager = [[APILoginManager alloc] init];
        _loginManager.delegate = self;
        _loginManager.paramSource = self;
    }
    return _loginManager;
}
- (APIIMTokenManager *)IMTokenManager{
    if (_IMTokenManager == nil) {
        _IMTokenManager = [[APIIMTokenManager alloc] init];
        _IMTokenManager.delegate = self;
        _IMTokenManager.paramSource = self;
    }
    return _IMTokenManager;
}
- (APILoginManager *)newDeviceCheckManager{
    if (_newDeviceCheckManager == nil) {
        _newDeviceCheckManager = [[APILoginManager alloc] init];
        _newDeviceCheckManager.delegate = self;
        _newDeviceCheckManager.paramSource = self;
    }
    return _newDeviceCheckManager;
}
- (FrameNavView *)headerView{
    if (_headerView == nil) {
        _headerView = [[FrameNavView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, SafeAreaTopHeight);
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toUser"])
    {
        UINavigationController * navi = [segue destinationViewController];
        self.userVC = (UIViewController *)[navi topViewController];
    }
    else if ([segue.identifier isEqualToString:@"toMap"])
    {
        UINavigationController * navi = [segue destinationViewController];
        self.homeVC = (UIViewController *)[navi topViewController];
    }else if ([segue.identifier isEqualToString:@"setting"]) {
        self.settingVC = (UserSettingController *)[segue destinationViewController];
    }else if([segue.identifier isEqualToString:@"project"]){
        UINavigationController *navi = [segue destinationViewController];
        self.projectVC = (ProjectSelectController *)[navi topViewController] ;
        self.projectVC.frameVC = self;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
