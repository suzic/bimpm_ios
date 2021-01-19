//
//  UserSettingController.m
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import "UserSettingController.h"
#import "SettingCell.h"

@interface UserSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic, strong) NSArray *settingArray;

@property (nonatomic, strong)APILogoutManager *logoutManager;

@end

@implementation UserSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
//        @{@"icon":@"share",@"title":@"分享项目"},
        @{@"icon":@"setting",@"title":@"设置"},
        @{@"icon":@"about",@"title":@"关于"},
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
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.logoutManager) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLoginFailed object:nil];
        [[LoginUserManager defaultInstance] removeCurrentLoginUserPhone];
        [DataManager defaultInstance].currentUser = nil;
        [DataManager defaultInstance].currentProject = nil;
        [[DataManager defaultInstance].currentProjectList removeLastObject];
        [DataManager defaultInstance].currentProjectList = nil;
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.logoutManager) {
        [SZAlert showInfo:@"退出登录失败" underTitle:TARGETS_NAME];
    }
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
