//
//  ConversationListController.m
//  TTManager
//
//  Created by chao liu on 2020/12/31.
//

#import "ConversationListController.h"

@interface ConversationListController ()

@end

@implementation ConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowHeaderView object:@(YES)];
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowHeaderView object:@(NO)];
//}
#pragma mark - 
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)didTapCellPortrait:(RCConversationModel *)model{
    
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
