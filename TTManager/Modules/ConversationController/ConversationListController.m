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

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM),@(ConversationType_RTC)]];
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM),@(ConversationType_RTC)]];
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoladNetwork) name:NotiReloadHomeView object:nil];
    [RCIM sharedRCIM];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
}

- (void)reoladNetwork{
//    [self refreshConversationTableViewIfNeeded];
    [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE)]];
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
