//
//  ConversationListController.m
//  TTManager
//
//  Created by chao liu on 2020/12/31.
//

#import "ConversationListController.h"
#import "ConversationController.h"

@interface ConversationListController ()<RCIMUserInfoDataSource>

@end

@implementation ConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoladNetwork) name:NotiReloadHomeView object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
}
- (void)reoladNetwork{
    [self refreshConversationTableViewIfNeeded];
}
#pragma mark - 
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    ConversationController *conversationVC = [[ConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    ZHUser *user = [[LoginUserManager defaultInstance] getUserByRongIMId:userId];
    if (user != nil) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.userId = userId;
        userInfo.name = user.name;
        userInfo.portraitUri = user.avatar;
        return completion(userInfo);
    }else{
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.name = @"未知用户";
        userInfo.userId = userId;
        return completion(userInfo);
    }
    return completion(nil);
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
