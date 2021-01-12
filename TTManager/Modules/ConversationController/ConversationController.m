//
//  ConversationController.m
//  TTManager
//
//  Created by chao liu on 2021/1/12.
//

#import "ConversationController.h"

@interface ConversationController ()<RCIMUserInfoDataSource>

@end

@implementation ConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    ZHUser *user = [[LoginUserManager defaultInstance] getUserByRongIMId:userId];
    if (user != nil) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.userId = userId;
        userInfo.name = user.name;
        userInfo.portraitUri = user.avatar;
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
