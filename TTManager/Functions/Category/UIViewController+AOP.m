//
//  UIViewController+AOP.m
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "UIViewController+AOP.h"

@implementation UIViewController (AOP)
+ (void)load{
    NSError *error;
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        UIViewController *vc = aspectInfo.instance;
        NSArray *arguments = aspectInfo.arguments;
        [vc AOP_viewWillAppear:arguments[0]];
    } error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
//        UIViewController *vc = aspectInfo.instance;
//        NSArray *arguments = aspectInfo.arguments;
//        [vc AOP_viewDidAppear:arguments[0]];
    } error:&error];
    
}
#pragma mark - AOP
- (void)AOP_viewWillAppear:(BOOL)animated{
    NSArray *array = @[NSClassFromString(@"MonitoringController"),
                       NSClassFromString(@"WorkbenchController"),
                       NSClassFromString(@"DocumentLibController"),
                       NSClassFromString(@"ConversationListController"),
                       NSClassFromString(@"TeamController"),
                       NSClassFromString(@"FileListView"),
                       NSClassFromString(@"PopViewController")];
    if ([array containsObject:[self class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowHeaderView object:@(YES)];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowHeaderView object:@(NO)];
    }
}

@end
