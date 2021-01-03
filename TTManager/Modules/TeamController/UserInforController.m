//
//  UserInforController.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "UserInforController.h"

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

@end

@implementation UserInforController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.bottomView borderForColor:RGB_COLOR(238, 238, 238) borderWidth:0.5 borderType:UIBorderSideTypeTop];
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
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inforCell"];
    NSMutableAttributedString *attributedStr = [self changTextColor:@"一共参与了11个项目" changText:@[@"一共参与了",@"个项目"]];
    cell.textLabel.attributedText = attributedStr;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inforCell" forIndexPath:indexPath];
    cell.textLabel.attributedText = [self changTextColor:@"众和空间 中我是 管理员" changText:@[@"中我是"]];
    return cell;
}
#pragma mark - Action
- (IBAction)goConversationAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"conversationController"];
    [self.navigationController pushViewController:vc animated:YES];
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
    if (manager == self.dmDetailsManager) {
        
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    
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
- (NSArray *)newTasTypeklist{
    if (_newTasTypeklist == nil) {
        _newTasTypeklist = @[@"任务",@"申请",@"通知",@"会审",@"巡检"];
    }
    return _newTasTypeklist;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
