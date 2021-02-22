//
//  UserSettingController.m
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import "UserSettingController.h"
#import "SettingCell.h"

@interface UserSettingController ()<UITableViewDelegate,UITableViewDataSource,ApiManagerCallBackDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic, strong) NSArray *settingArray;

@property (nonatomic, strong)APILogoutManager *logoutManager;

/// 当前选择切换的服务器地址 0 不切换 1 测试服务器 2 线上服务器
@property (nonatomic, assign) NSInteger selectedServiceAddress;

@end

@implementation UserSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedServiceAddress = 0;
    [self changServiceAddress];
    
}
- (void)reloadData{
    ZHUser *user = [DataManager defaultInstance].currentUser;
    [self.userImage sd_setBackgroundImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"test-1"]];
    self.userName.text = user.name;
}

#pragma mark - setting and getter

- (NSArray *)settingArray{
    if (_settingArray == nil) {
        _settingArray = @[
//        @{@"icon":@"erweima",@"title":@"二维码"},
        @{@"icon":@"about",@"title":@"关于"},
        @{@"icon":@"setting",@"title":@"设置"},
//        @{@"icon":@"share",@"title":@"表单"},
        @{@"icon":@"about",@"title":@"退出登录"}];
    }
    return _settingArray;
}
- (APILogoutManager *)logoutManager{
    if (_logoutManager == nil) {
        _logoutManager = [[APILogoutManager alloc] init];
        _logoutManager.delegate = self;
    }
    return _logoutManager;
}

#pragma mark - UITableViewDelegate  and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.settingArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    NSDictionary *dic = self.settingArray[indexPath.row];
    cell.settingIcon.image = [UIImage imageNamed:dic[@"icon"]];
    cell.settingTitle.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击用户设置中心的内容");
    if (indexPath.row == self.settingArray.count -1) {
        [self.logoutManager loadDataWithParams:@{}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiBackToMain object:indexPath];
    }
}

#pragma mark - ApiManagerCallBackDelegate

- (void)managerCallAPISuccess:(BaseApiManager *)manager
{
    if (manager == self.logoutManager) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLoginFailed object:nil];
        [[LoginUserManager defaultInstance] removeCurrentLoginUserPhone];
        [DataManager defaultInstance].currentUser = nil;
        [DataManager defaultInstance].currentProject = nil;
        [[DataManager defaultInstance].currentProjectList removeLastObject];
        [DataManager defaultInstance].currentProjectList = nil;
        [[RCIM sharedRCIM] logout];
        [AppDelegate sharedDelegate].initRongCloud = NO;
        // 切换服务器
        if (self.selectedServiceAddress != 0) {
            [self setCurrentSelectedServiceAddress];
        }
    }
}

- (void)managerCallAPIFailed:(BaseApiManager *)manager
{
    if (manager == self.logoutManager)
        [SZAlert showInfo:@"退出登录失败" underTitle:TARGETS_NAME];
}
#pragma mark - 切换服务器

- (void)changServiceAddress{
#if DEBUG
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChangeService)];
    [tap setNumberOfTapsRequired:10];
    [self.view addGestureRecognizer:tap];
#else
#endif
}
- (void)tapChangeService{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"切换服务器地址" message:@"请选择服务器地址" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *develop = [UIAlertAction actionWithTitle:@"测试地址(http://www.suzic.cn:8010)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 当前选择和上次选择一样 直接return
        if ([SelectedService isEqualToString:@"0"])
            return;

        self.selectedServiceAddress = 1;
        [self.logoutManager loadDataWithParams:@{}];
    }];
    UIAlertAction *production = [UIAlertAction actionWithTitle:@"线上地址(https://www.bim-pm.com)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 当前选择和上次选择一样 直接return
        if ([SelectedService isEqualToString:@"1"])
            return;
            
        self.selectedServiceAddress = 2;
        [self.logoutManager loadDataWithParams:@{}];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    if ([SelectedService isEqualToString:@"0"]) {
        [develop setValue:[UIColor redColor] forKey:@"titleTextColor"];
    }else if([SelectedService isEqualToString:@"1"]){
        [production setValue:[UIColor redColor] forKey:@"titleTextColor"];
    }
    
    [alert addAction:develop];
    [alert addAction:production];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setCurrentSelectedServiceAddress{
    NSString *serviceType = @"0";
    if (self.selectedServiceAddress == 1) {
        serviceType = @"0";
    }else if(self.selectedServiceAddress == 2){
        serviceType = @"1";
    }
    [[NSUserDefaults standardUserDefaults] setObject:serviceType forKey:UserDefaultsNetService];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
