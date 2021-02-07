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

@property (weak, nonatomic) IBOutlet UISegmentedControl *tabLoginMode;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIButton *verifyBtn;

@property (assign, nonatomic) LoginType controllerType; // 0-密码登录，1-验证码登录，2-找回密码 3-注册
@property (retain, nonatomic) PhoneCell *phoneCell;
@property (retain, nonatomic) PassCell *passwordCell;
@property (retain, nonatomic) PassCell *confirmPasswordCell;
// 验证码
@property (retain, nonatomic) VerificationCell *verifyCell;
// 图形验证码
@property (retain, nonatomic) VerificationCell *captchaCell;

@property (retain, nonatomic) OperationCell *buttonCell;
@property (retain, nonatomic) OperationCell *moreButtonCell;

// 当前选择的增禄方式 0 密码登录 1 验证码登录
@property (nonatomic, assign) BOOL currentSelectedTab;
// 显示图形验证码
@property (nonatomic, assign) BOOL showCaptch;
// API
@property (nonatomic, strong) APICaptchManager *captchManager;
@property (nonatomic, strong) APIResetManager*resetManager;
@property (nonatomic, strong) APIRegisterManager *registerManager;
@property (nonatomic, strong) APIVerifyPhoneManager *verifyManager;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *verify;
@property (nonatomic, copy) NSString *captch;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginFinish:) name:NotiUserLogined object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginFailed:) name:NotiUserLoginFailed object:nil];
    
    self.controllerType = typeLoginPassword;
    self.currentSelectedTab = 0;
    self.showCaptch = NO;
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
    switch (self.controllerType)
    {
        case typeLoginPassword:
            switch (indexPath.row)
            {
                case 0:
                    self.phoneCell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell" forIndexPath:indexPath];
                    self.phoneCell.phoneTextField.text = self.phone;
                    cell = self.phoneCell;
                    break;
                case 1:
                    self.passwordCell = [tableView dequeueReusableCellWithIdentifier:@"passCell" forIndexPath:indexPath];
                    self.passwordCell.passWordtextField.text = self.password;
                    cell = self.passwordCell;
                    break;
                case 2:
                    self.captchaCell = [tableView dequeueReusableCellWithIdentifier:@"verificationCell" forIndexPath:indexPath];
                    [self.captchaCell.getVerificationBtn setTitle:@"" forState:UIControlStateNormal];
                    self.captchaCell.verificationTextField.text = @"";
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
                    self.phoneCell.phoneTextField.text = self.phone;
                    cell = self.phoneCell;
                    break;
                case 1:
                    self.verifyCell = [tableView dequeueReusableCellWithIdentifier:@"verificationCell" forIndexPath:indexPath];
                    [self.verifyCell.getVerificationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    self.verifyCell.verificationTextField.text = @"";
                    [self.verifyCell.getVerificationBtn setBackgroundImage:nil forState:UIControlStateNormal];
                    cell = self.verifyCell;
                    break;
                case 2:
                    self.captchaCell = [tableView dequeueReusableCellWithIdentifier:@"verificationCell" forIndexPath:indexPath];
                    [self.captchaCell.getVerificationBtn setTitle:@"" forState:UIControlStateNormal];
                    self.captchaCell.verificationTextField.text = @"";
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
                    if (self.controllerType == typeLoginRetrieving)
                        self.phoneCell.phoneTextField.text = self.phone;
                    cell = self.phoneCell;
                    break;
                case 1:
                    self.verifyCell = [tableView dequeueReusableCellWithIdentifier:@"verificationCell" forIndexPath:indexPath];
                    [self.verifyCell.getVerificationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    [self.verifyCell.getVerificationBtn setBackgroundImage:nil forState:UIControlStateNormal];
                    self.verifyCell.verificationTextField.text = @"";
                    cell = self.verifyCell;
                    break;
                case 2:
                    self.passwordCell = [tableView dequeueReusableCellWithIdentifier:@"passCell" forIndexPath:indexPath];
                    cell = self.passwordCell;
                    break;
                case 3:
                    self.confirmPasswordCell = [tableView dequeueReusableCellWithIdentifier:@"passCell" forIndexPath:indexPath];
                    self.confirmPasswordCell.passWordtextField.placeholder = @"请确认您的密码";
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
            if (indexPath.row == 2 && self.showCaptch == NO)
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

- (IBAction)textChange:(id)sender {
}
- (IBAction)sendVerifyCode:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.showCaptch == YES && self.controllerType == typeLoginPassword) {
        [self.captchManager loadData];
    }else{
        self.verifyBtn = button;
        if (![LoginValidChecker validString:self.phoneCell.phoneTextField.text inFormat:SPECVaildStringFormatUserName])
            return;
        NSString *codeString = @"";
        if (self.controllerType == typeLoginRegister)
            codeString = @"REGIST";
        else if (self.controllerType == typeLoginNewDevice)
            codeString = @"NEW_DEVICE";
        else if (self.controllerType == typeLoginRetrieving)
            codeString = @"RESET";
        else if (self.controllerType == typeLoginVerify)
            codeString = @"LOGIN";
        [self.verifyManager loadDataWithParams:@{@"phone":self.phoneCell.phoneTextField.text,@"type":codeString}];
    }
}
- (IBAction)forgetPassword:(id)sender {
    if (self.controllerType == typeLoginRetrieving) {
        return;
    }
    self.showCaptch = NO;
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
        self.phone = self.phoneCell.phoneTextField.text;
        self.password = self.passwordCell.passWordtextField.text;
        self.verify  = self.verifyCell.verificationTextField.text;
        self.captch = self.captchaCell.verificationTextField.text;
        
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
            
            [self.registerManager loadData];
            
        }
        else if (self.controllerType == typeLoginPassword || self.controllerType == typeLoginVerify)
        {
            // 采集更新用户数据后再执行静默登录
            if ([self checkValid])
            {
                [self loginAction];
            }
        }
        else if (self.controllerType == typeLoginRetrieving) // 找回密码
        {
            if (![LoginValidChecker validString:self.phoneCell.phoneTextField.text inFormat:SPECVaildStringFormatUserName])
                return;
            if (![LoginValidChecker validString:self.verifyCell.verificationTextField.text inFormat:SPECValidStringFormatVerifyCode])
                return;
            
//            self.resetParams =
            [self.resetManager loadData];
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
- (void)loginAction{
    if ([self.captchManager isReachable])
    {
        
        NSString *pass = self.controllerType == typeLoginPassword ? self.password.MD5String : @"";
        NSString *verify = self.controllerType == typeLoginPassword ? @"" :self.verify;
        NSString *captchaCode = self.showCaptch == YES ? self.captch : @"";
        NSDictionary *loginPrams = @{@"phone":self.phone,
                                             @"password":pass,
                                             @"verify":verify,
                                             @"captcha":captchaCode,
                                             @"device_id":[SZUtil getUUID],
                                             @"device_name":[SZUtil deviceVersion]};
        
        ZHUser *user = [[DataManager defaultInstance] setCurrentUserByPhone:self.phone];
        user.password = self.password;
        user.pass_md5 = pass;
        user.verify_code = verify;
        user.captcha_code = captchaCode;
        [[DataManager defaultInstance] saveContext];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLoginNeeded object:@{@"silenceLogin":@(YES),@"params":loginPrams}];
    }else{
        [SZAlert showInfo:@"当前无网络，请检查网络线路连接以及网络服务状态。" underTitle:TARGETS_NAME];
    }
}
- (BOOL)checkValid{
    
    if (![LoginValidChecker validString:self.phoneCell.phoneTextField.text inFormat:SPECVaildStringFormatUserName])
        return NO;
    
    // 验证码登录检查
    if (self.controllerType == typeLoginVerify)
    {
        if (![LoginValidChecker validString:self.verifyCell.verificationTextField.text inFormat:SPECValidStringFormatVerifyCode])
            return NO;
    }
    // 密码登录检查
    else if (self.controllerType == typeLoginPassword)
    {
        if (![LoginValidChecker validString:self.passwordCell.passWordtextField.text inFormat:SPECVaildStringFormatPassword])
            return NO;
    }
    if (self.showCaptch && ![LoginValidChecker validString:self.captchaCell.verificationTextField.text inFormat:SPECVaildStringFormatCaptcha])
        return NO;
    return YES;
}
#pragma mark - APIManager
- (void)managerCallAPIStart:(BaseApiManager *)manager{
    NSLog(@"请求开始");
}
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.captchManager){
        [self.captchaCell.getVerificationBtn setBackgroundImage:(UIImage *)manager.response.responseData forState:UIControlStateNormal];
    }else if(manager == self.verifyManager){
        [SZAlert showInfo:@"已发送成功，请查收短信。" underTitle:TARGETS_NAME];
        [self.verifyCell.getVerificationBtn startCountDown:60 finishTitile:@"发送验证码"];
    }else if (manager == self.resetManager){
        [SZAlert showInfo:@"重设密码成功！" underTitle:TARGETS_NAME];
        self.controllerType = typeLoginPassword;
    }else if(manager == self.registerManager){
        self.controllerType = typeLoginPassword;
        self.showCaptch = NO;
        [SZAlert showInfo:@"注册成功，将为您切换到登录界面。" underTitle:TARGETS_NAME];
    }
    NSLog(@"成功的数据%@",manager.response.responseData);
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    NSLog(@"请求失败");
    NSLog(@"失败的数据%@",manager.response.responseData);
    [SZAlert showInfo:manager.response.responseData[@"msg"] underTitle:TARGETS_NAME];
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    
    NSString *identifierStr = [SZUtil getUUID];
    NSString *deviceType = [SZUtil deviceVersion];

    if (manager == self.captchManager){
        params = @{@"device_id":identifierStr,
                   @"device_name":deviceType};
    }else if(manager == self.registerManager){
        params = @{@"phone":self.phone,
                   @"password":self.password.MD5String,
                   @"verify":self.verify,
                   @"device_id":identifierStr,
                   @"device_name":deviceType};
    }else if(manager == self.resetManager){
        params = @{@"phone":self.phone,
                   @"new_password":self.password.MD5String,
                   @"verify":self.verify,
                   @"device_id":identifierStr,
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
    [self.verifyCell.getVerificationBtn stopTimer];
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
-(APIResetManager *)resetManager{
    if (_resetManager == nil) {
        _resetManager = [[APIResetManager alloc] init];
        _resetManager.delegate = self;
        _resetManager.paramSource = self;
    }
    return _resetManager;
}
- (APIRegisterManager *)registerManager{
    if (_registerManager == nil) {
        _registerManager = [[APIRegisterManager alloc] init];
        _registerManager.delegate = self;
        _registerManager.paramSource = self;
    }
    return _registerManager;
}
-(APIVerifyPhoneManager *)verifyManager{
    if (_verifyManager == nil) {
        _verifyManager = [[APIVerifyPhoneManager alloc] init];
        _verifyManager.delegate = self;
        _verifyManager.paramSource = self;
    }
    return _verifyManager;
}
#pragma mark - Notification
- (void)userLoginFinish:(NSNotification *)notification
{
//    ZHUser *user = [DataManager defaultInstance].currentUser;
//    user.phone = self.phoneCell.phoneTextField.text;
//    [[DataManager defaultInstance] saveContext];
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
        self.showCaptch = YES;
        [self.captchManager loadData];
        [self.tableView reloadData];
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
