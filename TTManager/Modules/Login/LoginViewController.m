//
//  LoginViewController.m
//  TTManager
//
//  Created by chao liu on 2020/12/26.
//

#import "LoginViewController.h"
#import "LoginValidChecker.h"
#import "PhoneCell.h"
#import "PassCell.h"
#import "VerificationCell.h"
#import "OperationCell.h"


@interface LoginViewController ()<ApiManagerCallBackDelegate,APIManagerParamSource,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet UIView *verificationBgView;


@property (weak, nonatomic) IBOutlet UISegmentedControl *tabLoginMode;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) LoginType controllerType; // 0-密码登录，1-验证码登录，2-找回密码 3-注册
@property (retain, nonatomic) PhoneCell *phoneCell;
@property (retain, nonatomic) PassCell *passwordCell;
@property (retain, nonatomic) PassCell *confirmPasswordCell;
@property (retain, nonatomic) VerificationCell *verifyCell;
@property (retain, nonatomic) VerificationCell *captchaCell;
@property (retain, nonatomic) OperationCell *buttonCell;
@property (retain, nonatomic) OperationCell *moreButtonCell;

@property (nonatomic, assign) BOOL currentSelectedTab;

// API
@property (nonatomic, strong)APICaptchManager *captchManager;
@property (nonatomic, strong)NSDictionary *loginParams;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 修改占位符字体颜色
//    [self changeTextFiledPlaceholderColor:self.phoneTextField.placeholder textFiled:self.phoneTextField];
//    [self changeTextFiledPlaceholderColor:self.psdTextField.placeholder textFiled:self.psdTextField];
//    [self changeTextFiledPlaceholderColor:self.verificationTextField.placeholder textFiled:self.verificationTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginFinish:) name:NotiUserLogined object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginFailed:) name:NotiUserLoginFailed object:nil];
    
    self.controllerType = typeLoginPassword;
    self.currentSelectedTab = 0;
    [self initUI];
    [self showVerificationView:NO];
}
- (void)initUI{
    ZHUser *user = [DataManager defaultInstance].currentUser;
    if (user) {
        self.phoneTextField.text = user.phone;
        self.psdTextField.text = user.password;
    }
}
- (void)showVerificationView:(BOOL)show{
    self.verificationBgView.hidden = !show;
    self.verificationBtn.hidden = !show;
    if (show == YES) {
        [self.captchManager loadData];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.controllerType)
    {
        case typeLoginRetrieving:
        case typeLoginRegister:
            return 7;
        case typeLoginPassword:
        case typeLoginVerify:
        default:
            return 6;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    ZHUser *currentUser = [DataManager defaultInstance].currentUser;
    switch (self.controllerType)
    {
        case typeLoginPassword:
            switch (indexPath.row)
            {
                case 0:
                    self.phoneCell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell" forIndexPath:indexPath];
                    self.phoneCell.phoneTextField.text = currentUser.phone;
                    cell = self.phoneCell;
                    break;
                case 1:
                    self.passwordCell = [tableView dequeueReusableCellWithIdentifier:@"passCell" forIndexPath:indexPath];
//                    self.passwordCell.btnForgotPassword.hidden = NO;
//                    self.passwordCell.passwordString.text = currentUser.password;
                    cell = self.passwordCell;
                    break;
                case 2:
                    self.captchaCell = [tableView dequeueReusableCellWithIdentifier:@"verificationCell" forIndexPath:indexPath];
//                    self.captchaCell.captchLabel.text = currentUser.captcha_code;
//                    [self.captchaCell.captchCode setBackgroundImage:self.currentCaptchaImage forState:UIControlStateNormal];
                    cell = self.captchaCell;
                    break;
                case 3:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"paddingCell" forIndexPath:indexPath];
                    break;
                case 4:
                    self.buttonCell = [tableView dequeueReusableCellWithIdentifier:@"operationCell" forIndexPath:indexPath];
                    [self.buttonCell.opreationTitle setTitle:@"登   录" forState:UIControlStateNormal];
                    self.buttonCell.opreationTitle.tag = 0;
                    cell = self.buttonCell;
                    break;
                case 5:
                    self.moreButtonCell = [tableView dequeueReusableCellWithIdentifier:@"operationCell" forIndexPath:indexPath];
                    [self.moreButtonCell.opreationTitle setTitle:@"注   册" forState:UIControlStateNormal];
                    self.moreButtonCell.opreationTitle.tag = 1;
                    cell = self.moreButtonCell;
                    break;
            }
            break;
            
        case typeLoginVerify:
            switch (indexPath.row)
            {
                case 0:
                    self.phoneCell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell" forIndexPath:indexPath];
//                    self.phoneCell.phoneNumber.text = currentUser.phone;
                    cell = self.phoneCell;
                    break;
                case 1:
                    self.verifyCell = [tableView dequeueReusableCellWithIdentifier:@"verificationCell" forIndexPath:indexPath];
//                    self.verifyCell.verifyString.text = @"";
                    cell = self.verifyCell;
                    break;
                case 2:
                    self.captchaCell = [tableView dequeueReusableCellWithIdentifier:@"verificationCell" forIndexPath:indexPath];
                    cell = self.captchaCell;
                    break;
                case 3:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"paddingCell" forIndexPath:indexPath];
                    break;
                case 4:
                    self.buttonCell = [tableView dequeueReusableCellWithIdentifier:@"operationCell" forIndexPath:indexPath];
                   [self.buttonCell.opreationTitle setTitle:@"登   录" forState:UIControlStateNormal];
                    self.buttonCell.opreationTitle.tag = 0;
                    cell = self.buttonCell;
                    break;
                case 5:
                    self.moreButtonCell = [tableView dequeueReusableCellWithIdentifier:@"operationCell" forIndexPath:indexPath];
                    [self.moreButtonCell.opreationTitle setTitle:@"注   册" forState:UIControlStateNormal];
                    self.moreButtonCell.opreationTitle.tag = 1;
                    cell = self.moreButtonCell;
                    break;
            }
            break;

        case typeLoginRetrieving:
        case typeLoginRegister:
        default:
            switch (indexPath.row)
            {
                case 0:
                    self.phoneCell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell" forIndexPath:indexPath];
//                    if (self.controllerType == typeLoginRetrieving)
//                        self.phoneCell.phoneNumber.text = currentUser.phone;
                    cell = self.phoneCell;
                    break;
                case 1:
                    self.verifyCell = [tableView dequeueReusableCellWithIdentifier:@"verificationCell" forIndexPath:indexPath];
//                    self.verifyCell.verifyString.text = @"";
                    cell = self.verifyCell;
                    break;
                case 2:
                    self.passwordCell = [tableView dequeueReusableCellWithIdentifier:@"passCell" forIndexPath:indexPath];
//                    self.passwordCell.btnForgotPassword.hidden = YES;
                    cell = self.passwordCell;
                    break;
                case 3:
                    self.confirmPasswordCell = [tableView dequeueReusableCellWithIdentifier:@"passCell" forIndexPath:indexPath];
//                    self.confirmPasswordCell.passwordString.placeholder = @"请确认您的密码";
//                    self.confirmPasswordCell.btnForgotPassword.hidden = YES;
                    cell = self.confirmPasswordCell;
                    break;
                case 4:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"paddingCell" forIndexPath:indexPath];
                    break;
                case 5:
                    self.buttonCell = [tableView dequeueReusableCellWithIdentifier:@"operationCell" forIndexPath:indexPath];
                    if (self.controllerType == typeLoginRetrieving)
                        [self.buttonCell.opreationTitle setTitle:@"找   回" forState:UIControlStateNormal];
                    else
                    [self.buttonCell.opreationTitle setTitle:@"注   册" forState:UIControlStateNormal];
                    self.buttonCell.opreationTitle.tag = 0;
                    cell = self.buttonCell;
                    break;
                case 6:
                    self.moreButtonCell = [tableView dequeueReusableCellWithIdentifier:@"operationCell" forIndexPath:indexPath];
//                    [self.moreButtonCell setButtonStyle:ButtonStyleMore withTitle:@"返   回"];
                    [self.moreButtonCell.opreationTitle setTitle:@"返   回" forState:UIControlStateNormal];
                    self.moreButtonCell.opreationTitle.tag = 1;
                    cell = self.moreButtonCell;
                    break;
            }
            break;
    }
   
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.controllerType)
    {
        case typeLoginPassword:
            if (indexPath.row == 2)
                return 0.01f;
            else if (indexPath.row == 3)
                return 30.0f;
            return 50.0f;
            
        case typeLoginVerify:
            if (indexPath.row == 2)
                return 0.01f;
            else if (indexPath.row == 3)
                return 30.0f;
            return 50.0f;
            
        case typeLoginRetrieving:
        case typeLoginRegister:
        default:
            if (indexPath.row == 4)
                return 30.0f;
            return 50.0f;
    }
}
#pragma mark - Action
// 获取验证码
- (IBAction)getVerificationAction:(id)sender
{
    [self.captchManager loadData];
}

- (IBAction)textChange:(id)sender {
}
- (IBAction)sendVerifyCode:(id)sender {
}
- (IBAction)forgetPassword:(id)sender {
    if (self.controllerType == typeLoginRetrieving) {
        return;
    }
    self.controllerType = typeLoginRetrieving;
}

- (IBAction)buttonpressed:(id)sender {
    if (![self.captchManager isReachable])
    {
        [SZAlert showInfo:@"当前无网络，请检查网络线路连接以及网络服务状态。" underTitle:@"众和空间"];
        return;
    }
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1)
    {
        if (self.controllerType != typeLoginPassword && self.controllerType != typeLoginVerify)
            self.controllerType = typeLoginPassword;
        else
            self.controllerType = typeLoginRegister;
    }
    else
    {
        if (self.controllerType == typeLoginRegister)
        {
            if (![LoginValidChecker validString:self.phoneCell.phoneTextField.text inFormat:SPECVaildStringFormatUserName])
                return;
            if (![LoginValidChecker validString:self.verifyCell.verificationTextField.text inFormat:SPECValidStringFormatVerifyCode])
                return;
            if (![LoginValidChecker validString:self.passwordCell.passWordtextField.text inFormat:SPECValidStringFormatVerifyCode])
                return;
            if (![LoginValidChecker validString:self.confirmPasswordCell.passWordtextField.text inFormat:SPECValidStringFormatVerifyCode])
                return;
            
            if ([self.passwordCell.passWordtextField.text isEqualToString:self.confirmPasswordCell.passWordtextField.text] == NO)
            {
                [SZAlert showInfo:@"两次密码输入的不一致，请您再次输入" underTitle:@"众和空间"];
                return;
            }
            
            ZHUser *loginUser = [DataManager defaultInstance].currentUser;
            loginUser.phone = self.phoneCell.phoneTextField.text;
            loginUser.password = self.passwordCell.passWordtextField.text;
            loginUser.pass_md5 = loginUser.password.MD5String;
            loginUser.verify_code = self.verifyCell.verificationTextField.text;
#warning 注册
        }
        else if (self.controllerType == typeLoginPassword || self.controllerType == typeLoginVerify)
        {
            // 采集更新用户数据后再执行静默登录
            if ([self checkValid])
            {
//                [super showHud];
//                self.inRequest = YES;
//                self.ukDelay = 15;
                [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLoginNeeded object:@(YES)];
            }
        }
        else if (self.controllerType == typeLoginRetrieving) // 找回密码
        {
            if (![LoginValidChecker validString:self.phoneCell.phoneTextField.text inFormat:SPECVaildStringFormatUserName])
                return;
            if (![LoginValidChecker validString:self.verifyCell.verificationTextField.text inFormat:SPECValidStringFormatVerifyCode])
                return;
            
            ZHUser *loginUser = [DataManager defaultInstance].currentUser;
            loginUser.phone = self.phoneCell.phoneTextField.text;
            loginUser.verify_code = self.verifyCell.verificationTextField.text;
            loginUser.password = self.confirmPasswordCell.passWordtextField.text;
            loginUser.pass_md5 = loginUser.password.MD5String;
//            [self NETWORK_resetPassword];
#warning 召回密码
        }
    }
}

- (IBAction)tabLoginModeAction:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    self.currentSelectedTab = segment.selectedSegmentIndex;
    if ((self.currentSelectedTab == 0 && self.controllerType != typeLoginVerify)
        || (self.currentSelectedTab == 1 && self.controllerType == typeLoginVerify))
        return;
    
    if (self.controllerType == typeLoginPassword)
        self.controllerType = typeLoginVerify;
    else if (self.controllerType == typeLoginVerify)
        self.controllerType = typeLoginPassword;
    [self.tableView reloadData];
}

// 登录操作
- (IBAction)loginAction:(id)sender {
    if ([self.captchManager isReachable])
    {
        if ([self checkValid]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLoginNeeded object:@{@"silenceLogin":@(YES),@"params":self.loginParams}];
        }
    }else{
        [SZAlert showInfo:@"当前无网络，请检查网络线路连接以及网络服务状态。" underTitle:TARGETS_NAME];
    }
}
- (BOOL)checkValid{
    
    if (![LoginValidChecker validString:self.phoneTextField.text inFormat:SPECVaildStringFormatUserName])
        return NO;
    
//    [DataManager defaultInstance].currentUser = nil;
//    [[DataManager defaultInstance] setCurrentUserByPhone:self.phoneTextField.text];
//    ZHUser *loginUser = [DataManager defaultInstance].currentUser;
//    loginUser.phone = self.phoneTextField.text;
    if (![LoginValidChecker validString:self.psdTextField.text inFormat:SPECVaildStringFormatPassword])
        return NO;
//    loginUser.password = self.psdTextField.text;
//    NSLog(@"输入的密码%@",self.psdTextField.text);
//    loginUser.pass_md5 = loginUser.password.MD5String;
//    loginUser.verify_code = @""; // 密码登录必须保证验证码是空的
//    loginUser.captcha_code = self.verificationTextField.text;
//    [[DataManager defaultInstance] saveContext];
    NSLog(@"图形验证码%@",self.verificationTextField.text);
//    if (![LoginValidChecker validString:self.verificationTextField.text inFormat:SPECVaildStringFormatCaptcha])
//        return NO;
    self.loginParams = @{@"phone":self.phoneTextField.text,
                                  @"password":self.psdTextField.text.MD5String,
                                  @"verify":@"",
                                  @"captcha":self.verificationTextField.text,
                                  @"device_id":[SZUtil getUUID],
                                   @"device_name":[SZUtil deviceVersion]};
    return YES;
}
#pragma mark - APIManager
- (void)managerCallAPIStart:(BaseApiManager *)manager{
    NSLog(@"请求开始");
}
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.captchManager){
        [self.verificationBtn setBackgroundImage:(UIImage *)manager.response.responseData forState:UIControlStateNormal];
    }
    NSLog(@"成功的数据%@",manager.response.responseData);
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    NSLog(@"请求失败");
    NSLog(@"失败的数据%@",manager.response.responseData);
    [SZAlert showInfo:manager.response.responseData[@"msg"] underTitle:TARGETS_NAME];
}
#pragma mark -APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    ZHUser *currentUser = [DataManager defaultInstance].currentUser;
    NSString *identifierStr = @"";
    if (currentUser == nil) {
        identifierStr = [SZUtil getUUID];
    }else{
        identifierStr = currentUser.device;
    }
    if (manager == self.captchManager){
        NSString *deviceType = [SZUtil deviceVersion];
        params = @{@"device_id":identifierStr,
                   @"device_name":deviceType};
    }
    return params;
}
#pragma mark - setter and getter
- (void)setControllerType:(LoginType)controllerType
{
    if (_controllerType == controllerType)
        return;
    _controllerType = controllerType;
    switch (_controllerType) {
        case typeLoginRegister:
            [self.tabLoginMode removeAllSegments];
            [self.tabLoginMode insertSegmentWithTitle:@"用户注册" atIndex:0 animated:NO];
            self.tabLoginMode.selectedSegmentIndex = 0;
            break;
        case typeLoginRetrieving:
            [self.tabLoginMode removeAllSegments];
            [self.tabLoginMode insertSegmentWithTitle:@"找回密码" atIndex:0 animated:NO];
            self.tabLoginMode.selectedSegmentIndex = 0;
            break;
        default:
            [self.tabLoginMode removeAllSegments];
            [self.tabLoginMode insertSegmentWithTitle:@"密码登录" atIndex:0 animated:NO];
            [self.tabLoginMode insertSegmentWithTitle:@"验证码登录" atIndex:1 animated:NO];
            self.tabLoginMode.selectedSegmentIndex = self.currentSelectedTab;
            [self tabLoginModeAction:self.tabLoginMode];
            break;
    }
    [self.tableView reloadData];
}
- (APICaptchManager *)captchManager{
    if (_captchManager == nil) {
        _captchManager = [[APICaptchManager alloc] init];
        _captchManager.delegate = self;
        _captchManager.paramSource = self;
    }
    return _captchManager;
}
#pragma mark - Notification
- (void)userLoginFinish:(NSNotification *)notification
{
    ZHUser *user = [DataManager defaultInstance].currentUser;
    user.password = self.psdTextField.text;
    [[DataManager defaultInstance] saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)userLoginFailed:(NSNotification *)notification
{
    ZHUser *currentUser = [DataManager defaultInstance].currentUser;
    currentUser.is_login = NO;
    [[DataManager defaultInstance] saveContext];
    
    NSDictionary *dic = (NSDictionary *)notification.object;
    if ([dic[@"code"] intValue] == 102 || [dic[@"code"] intValue] == 103 || [dic[@"code"] intValue] == 105) // 连续5次以上登录失败
    {
//        [self.captchManager loadData];
        [self showVerificationView:YES];
    }
//    else if ([dic[@"code"] intValue] == 105)
//    {
//        [self NETWORK_verifyCode:@"NEW_DEVICE"];
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"正在登录新设备"
//                                                                                 message:@"您正在新的设备上登录，为保证您的账户安全，我们已向您的账户手机发送了验证码，请在下方填写进行验证"
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField) {
//            self.deviceVerifyCode = @"";
//            textField.placeholder = [NSString stringWithFormat:@"请在此输入您收到的验证码"];
//            textField.delegate = self;
//        }];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"提交验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserDeviceCheck object:self.deviceVerifyCode];
//        }]];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
    else
    {
        if ([dic[@"code"] intValue] == 413)
        {
            [self.captchManager loadData];
        }
        NSString *errorInfo = [NSString stringWithFormat:@"登录失败: %@", dic[@"msg"]];
        [SZAlert showInfo:errorInfo underTitle:TARGETS_NAME];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
