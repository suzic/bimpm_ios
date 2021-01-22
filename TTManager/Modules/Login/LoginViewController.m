//
//  LoginViewController.m
//  TTManager
//
//  Created by chao liu on 2020/12/26.
//

#import "LoginViewController.h"
#import "LoginValidChecker.h"

@interface LoginViewController ()<ApiManagerCallBackDelegate,APIManagerParamSource>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet UIView *verificationBgView;

// API
@property (nonatomic, strong)APICaptchManager *captchManager;
@property (nonatomic, strong)NSDictionary *loginParams;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 修改占位符字体颜色
    [self changeTextFiledPlaceholderColor:self.phoneTextField.placeholder textFiled:self.phoneTextField];
    [self changeTextFiledPlaceholderColor:self.psdTextField.placeholder textFiled:self.psdTextField];
    [self changeTextFiledPlaceholderColor:self.verificationTextField.placeholder textFiled:self.verificationTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginFinish:) name:NotiUserLogined object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginFailed:) name:NotiUserLoginFailed object:nil];
    
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
#pragma mark - Action
// 获取验证码
- (IBAction)getVerificationAction:(id)sender
{
    [self.captchManager loadData];
}
// 清除输入的密码
- (IBAction)clearPassWordAction:(id)sender {
    self.psdTextField.text = @"";
}
// 明文显示密码
- (IBAction)showPassWordInforAction:(id)sender {
    self.psdTextField.secureTextEntry = !self.psdTextField.secureTextEntry;
    UIButton *button = (UIButton *)sender;
    NSString *image = self.psdTextField.secureTextEntry == YES ? @"hide_psd" : @"show_psd";
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
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

#pragma mark - private methods
- (void)changeTextFiledPlaceholderColor:(NSString *)placeholder textFiled:(UITextField *)textFiled{
     NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    textFiled.attributedPlaceholder = attributedPlaceholder;
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
#pragma mark -APIManager
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
