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
        @{@"icon":@"erweima",@"title":@"二维码"},
        @{@"icon":@"share",@"title":@"分享项目"},
        @{@"icon":@"setting",@"title":@"设置"},
        @{@"icon":@"about",@"title":@"关于"}];
    }
    return _settingArray;
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
