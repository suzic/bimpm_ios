//
//  ConversationListController.m
//  TTManager
//
//  Created by chao liu on 2020/12/31.
//

#import "ConversationListController.h"
#import "ConversationController.h"
#import "EmptyConversationView.h"

@interface ConversationListController ()

@end

@implementation ConversationListController

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM),@(ConversationType_RTC)]];
//        [self setCollectionConversationType:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM),@(ConversationType_RTC)]];
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM),@(ConversationType_RTC)]];
//        [self setCollectionConversationType:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM),@(ConversationType_RTC)]];
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoladNetwork) name:NotiReloadHomeView object:nil];
    self.emptyConversationView = [[EmptyConversationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.conversationListDataSource.count > 0) {
        self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (void)reoladNetwork{
//    [self refreshConversationTableViewIfNeeded];
    [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM),@(ConversationType_RTC)]];
}

#pragma mark - 融云会话列表代理

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    ConversationController *conversationVC = [[ConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)didDeleteConversationCell:(RCConversationModel *)model{
    if (self.conversationListDataSource.count > 0) {
        self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
