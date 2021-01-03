//
//  FrameController.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "FrameController.h"
#import "FrameNavView.h"

@interface FrameController ()<APIManagerParamSource,ApiManagerCallBackDelegate,FrameNavViewDelegate>

// 主页面view
@property (weak, nonatomic) IBOutlet UIView *homeView;
// 遮罩层
@property (weak, nonatomic) IBOutlet UIView *shadowView;
// 选择项目的view
@property (weak, nonatomic) IBOutlet UIView *projectView;
// 抽屉视图view
@property (weak, nonatomic) IBOutlet UIView *userView;
// 拖动距离
@property (nonatomic, assign) CGPoint lastPoint;

// 主页面VC
@property (nonatomic, strong) UIViewController *homeVC;
// 导航栏
@property (nonatomic, strong) FrameNavView *headerView;
// 抽屉VC
@property (nonatomic, strong) UIViewController *userVC;

// api
@property (nonatomic, strong)APILoginManager *loginManager;
@property (nonatomic, strong)APILoginManager *newDeviceCheckManager;
@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic,assign) BOOL bFirst;
@end

@implementation FrameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self addNotification];
    // 初始化
    self.inShowLogin = NO;
    self.bFirst = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.bFirst)
    {
        self.bFirst = NO;
        ZHUser *currentUser = [DataManager defaultInstance].currentUser;
        BOOL is_login = NO;
        if (currentUser != nil){
            is_login = currentUser.is_login;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLoginNeeded object:@{@"silenceLogin":@(is_login)}];
    }
}

#pragma mark - init
- (void)initUI
{
    [self.view insertSubview:self.headerView belowSubview:self.userView];
    self.projectView.hidden = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.shadowView addGestureRecognizer:tapGesture];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.userView addGestureRecognizer:panGesture];
}
- (void)addNotification{
    // 抽屉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings:) name:NotiShowSettings object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToMain:) name:@"NotiBackToMain" object:nil];
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
        {
            return;
        }
    }
    
    if ([sender isKindOfClass:[UITapGestureRecognizer class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiBackToMain" object:self];
    else if ([sender isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        switch (pan.state)
        {
            case UIGestureRecognizerStateBegan:
                self.lastPoint = [pan translationInView:self.view];
                break;
                
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
            }
                break;
                
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                CGRect frame = self.userView.frame;
                if (fabs(self.lastPoint.x) > (frame.size.width + 5) / 2)
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiBackToMain" object:self];
                else
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiShowSettings" object:nil];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:selectedProject]) {
        NSLog(@"选择项目");
        self.projectView.hidden = YES;
        [DataManager defaultInstance].currentProject = userInfo[@"currentProject"];
        [self.headerView setCurrentProjectTitle];
        [self updateFrame];
    }
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
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
        self.userView.hidden = YES;
    }];
}
- (void)showHeaderView:(NSNotification *)notification{
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

// 处理页面
- (void)updateFrame
{
}
#pragma mark - FrameNavViewDelegate
- (void)clickShowProjectListView{
    self.projectView.hidden = NO;
}
- (void)frameNavView:(FrameNavView *)navView selected:(NSInteger)currentSelectedIndex{
    self.projectView.hidden = YES;
    NSMutableArray *array = [DataManager defaultInstance].currentProjectList;
    [DataManager defaultInstance].currentProject = array[currentSelectedIndex];
    [self updateFrame];
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.loginManager || manager == self.newDeviceCheckManager) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLogined object:nil];
        if ([AppDelegate sharedDelegate].initRongCloud == NO) {
            [[AppDelegate sharedDelegate] initRongCloudIM];
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
                savedPassword = currentUser.password;
        }
       params = @{@"phone":currentUser.phone,
                 @"password":savedPassword.MD5String,
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
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
