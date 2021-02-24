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
@property (nonatomic, strong) APIUTPListManager *UTPlistManager;
@property (nonatomic, strong) APIIMTokenManager *IMTokenManager;
@property (nonatomic, strong) NSMutableArray *infoArray;
@end

@implementation UserInforController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@的信息",self.user.name];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.bottomView borderForColor:RGB_COLOR(238, 238, 238) borderWidth:0.5 borderType:UIBorderSideTypeTop];
    [self loadData];
    [self.tableView showDataCount:self.infoArray.count type:0];
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
    [self.UTPlistManager loadData];
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
    NSDictionary *userInfo = self.infoArray[indexPath.row];
    NSDictionary *project = userInfo[@"project"];
    NSString *roleName = userInfo[@"roleName"];
    NSString *titleText = project[@"name"];
    if (![roleName isEqualToString:@""]) {
        titleText = [NSString stringWithFormat:@"%@ 中我是 %@",titleText,roleName];
    }
    cell.textLabel.attributedText = [self changTextColor:titleText changText:@[@"中我是"]];
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
    NSString *targetId = [NSString stringWithFormat:@"%d",self.user.id_user];
//    NSArray *resultArray = [targetId componentsSeparatedByString:@"@"];
//    targetId = resultArray[0];
    ConversationController *conversationVC = [[ConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:targetId];
    conversationVC.title = self.user.name;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (IBAction)goTaskAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择任务类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    int i = 1;
    for (NSString *newTaskType in self.newTasTypeklist) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:newTaskType style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Task" bundle:nil];
            UINavigationController *nav = [sb instantiateViewControllerWithIdentifier:@"newTaskNav"];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            TaskController *vc = (TaskController *)nav.topViewController;
            vc.taskType = action.taskType;
            vc.to_uid_user = INT_32_TO_STRING(self.user.id_user);
            [self presentViewController:nav animated:YES completion:nil];
        }];
        action.taskType = i;
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
    if (manager == self.UTPlistManager) {
        dic = @{@"id_user":INT_32_TO_STRING(self.user.id_user),@"belong_state":@"0"};

    }else if(manager == self.IMTokenManager){
        dic = @{@"id_user":INT_32_TO_STRING(self.user.id_user)};
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.UTPlistManager) {
        NSLog(@"获取数据成功");
        [self assemblyData:(NSDictionary *)manager.response.responseData];
        [self.tableView showDataCount:self.infoArray.count type:0];
        [self.tableView reloadData];
    }else if(manager == self.IMTokenManager){
        self.user.uid_chat = manager.response.responseData[@"data"][@"uid_chat"];
        [[DataManager defaultInstance] saveContext];
        [self goConversationView];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    
}
- (void)assemblyData:(NSDictionary *)userProjectDic{
    NSMutableArray *basicArray = userProjectDic[@"data"][@"basic"];
    NSMutableArray *to_userArray = userProjectDic[@"data"][@"to_user"];
    
    for (int i = 0; i < basicArray.count; i++) {
        NSDictionary *project = basicArray[i];
        NSDictionary *role = nil;
        if ([to_userArray isKindOfClass:[NSArray class]]) {
            if (to_userArray.count > i) {
                role  = to_userArray[i][@"role"];
    //            role = userProject.assignRole;
            }
        }
        
        NSDictionary *userInfo = @{@"project":project,@"roleName":role == nil ? @"":role[@"name"]};
        [self.infoArray addObject:userInfo];
    }
    
    NSLog(@"当前的数据个数 %ld",self.infoArray.count);
}

#pragma mark - setter and getter
- (APIUTPListManager *)UTPlistManager{
    if (_UTPlistManager == nil) {
        _UTPlistManager = [[APIUTPListManager alloc] init];
        _UTPlistManager.delegate = self;
        _UTPlistManager.paramSource = self;
        _UTPlistManager.isNeedCoreData = NO;
    }
    return _UTPlistManager;
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
        _newTasTypeklist = @[@"单独任务",@"审批",@"批量任务",@"会审"];
    }
    return _newTasTypeklist;
}
- (NSMutableArray *)infoArray{
    if (_infoArray == nil) {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}
@end
