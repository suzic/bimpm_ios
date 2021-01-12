//
//  UserInforController.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "UserInforController.h"
#import "ConversationController.h"

@interface UserInforController ()<UITableViewDelegate,UITableViewDataSource,APIManagerParamSource,ApiManagerCallBackDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userSex;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *userEmali;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *newTasTypeklist;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

// api
@property (nonatomic, strong) APIDMDetailManager* dmDetailsManager;
@property (nonatomic, strong) APIIMTokenManager *IMTokenManager;
@property (nonatomic, strong) NSArray *infoArray;
@end

@implementation UserInforController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.bottomView borderForColor:RGB_COLOR(238, 238, 238) borderWidth:0.5 borderType:UIBorderSideTypeTop];
    [self loadData];
    [self.tableView showDataCount:self.infoArray.count];
}
- (void)loadData{
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"test-1"]];
    self.username.text = self.user.name;
    NSString *email = @"";
    NSString *phone = @"";
    NSString *sex = @"未知";

    if ([SZUtil isEmptyOrNull:self.user.email]) {
        email = [NSString stringWithFormat:@"电子邮箱: %@",@"暂未"];
    }else{
        email = [NSString stringWithFormat:@"电子邮箱: %@",self.user.email];
    }
    
    if ([SZUtil isEmptyOrNull:self.user.phone]) {
        phone = [NSString stringWithFormat:@"手机号码: %@",@"暂未"];
    }else{
        phone = [NSString stringWithFormat:@"手机号码: %@",self.user.phone];
    }
    if (self.user.gender == 1) {
        sex = @"男";
    }else if(self.user.gender == 2){
        sex = @"女";
    }
    
    self.userEmali.text = email;
    self.userPhone.text = phone;
    self.userSex.text = sex;
    [self.dmDetailsManager loadData];
}
// 改变字体颜色
- (NSMutableAttributedString *)changTextColor:(NSString *)text changText:(NSArray *)changeText{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(77, 138, 243) range:NSMakeRange(0, text.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, text.length)];
    for (NSString *str in changeText) {
        NSRange rang = [text rangeOfString:str];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(153, 153, 153) range:rang];
    }
    return attributedStr;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.infoArray.count >0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inforCell"];
        NSString *textTitle = [NSString stringWithFormat:@"一共参与了%ld个项目",self.infoArray.count];
        NSMutableAttributedString *attributedStr = [self changTextColor:textTitle changText:@[@"一共参与了",@"个项目"]];
        cell.textLabel.attributedText = attributedStr;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        return cell;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inforCell" forIndexPath:indexPath];
    ZHUserProject *userProject = self.infoArray[indexPath.row];
    NSString *titleText = [NSString stringWithFormat:@"项目名称: %@",userProject.belongProject.name];
    cell.textLabel.attributedText = [self changTextColor:titleText changText:@[@"项目名称:"]];
    return cell;
}
#pragma mark - Action
- (IBAction)goConversationAction:(id)sender {
    NSLog(@"融云im%@",self.user.uid_chat);
    if (![SZUtil isEmptyOrNull:self.user.uid_chat]) {
        [self goConversationView];
    }else{
        [self.IMTokenManager loadData];
    }
}
- (void)goConversationView{
    NSString *targetId = self.user.uid_chat;
    NSArray *resultArray = [targetId componentsSeparatedByString:@"@"];
    targetId = resultArray[0];
    ConversationController *conversationVC = [[ConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:targetId];
    conversationVC.title = self.user.name;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
- (IBAction)goTaskAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择任务类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *newTaskType in self.newTasTypeklist) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:newTaskType style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Task" bundle:nil];
            UINavigationController *nav = [sb instantiateViewControllerWithIdentifier:@"newTaskNav"];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }];
        [alert addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    ZHProject *project = [DataManager defaultInstance].currentProject;
    if (manager == self.dmDetailsManager) {
        dic=@{@"id_project":INT_32_TO_STRING(project.id_project),
              @"id_department":INT_32_TO_STRING(self.id_department)};
    }else if(manager == self.IMTokenManager){
        dic = @{@"id_user":INT_32_TO_STRING(self.user.id_user)};
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.dmDetailsManager) {
        NSLog(@"获取数据成功");
        [self assemblyData];
        [self.tableView showDataCount:self.infoArray.count];
        [self.tableView reloadData];
    }else if(manager == self.IMTokenManager){
        self.user.uid_chat = manager.response.responseData[@"data"][@"uid_chat"];
        [[DataManager defaultInstance] saveContext];
        [self goConversationView];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    
}
- (void)assemblyData{
    ZHUser *user = [DataManager defaultInstance].currentUser;
    NSSet *department = user.hasProjects;
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"id_user_project" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    self.infoArray = [department sortedArrayUsingDescriptors:sortDescriptors];
}
- (BOOL)isleader:(ZHDepartment *)department{
    ZHUser *currentUser = [DataManager defaultInstance].currentUser;
    for (ZHDepartmentUser *user in department.hasUsers) {
        if (user.assignUser.belongUser.id_user == currentUser.id_user && user.is_leader == YES) {
            return YES;
            break;;
        }
    }
    return NO;
}
#pragma mark - setter and getter
- (APIDMDetailManager *)dmDetailsManager{
    if (_dmDetailsManager == nil) {
        _dmDetailsManager = [[APIDMDetailManager alloc] init];
        _dmDetailsManager.delegate = self;
        _dmDetailsManager.paramSource = self;
    }
    return _dmDetailsManager;
}
- (APIIMTokenManager *)IMTokenManager{
    if (_IMTokenManager == nil) {
        _IMTokenManager = [[APIIMTokenManager alloc] init];
        _IMTokenManager.delegate = self;
        _IMTokenManager.paramSource = self;
    }
    return _IMTokenManager;
}
- (NSArray *)newTasTypeklist{
    if (_newTasTypeklist == nil) {
        _newTasTypeklist = @[@"任务",@"申请",@"通知",@"会审",@"巡检"];
    }
    return _newTasTypeklist;
}
- (NSArray *)infoArray{
    if (_infoArray == nil) {
        _infoArray = [NSArray array];
    }
    return _infoArray;
}
@end
