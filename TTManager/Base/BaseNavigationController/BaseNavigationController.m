//
//  BaseNavigationController.m
//  MangroveTree
//
//  Created by sjlh on 2017/3/15.
//  Copyright © 2017年 MVM. All rights reserved.
//

#import "BaseNavigationController.h"
#import "DocumentLibController.h"
#import "TeamController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *viewControlersList;

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (NSArray *)viewControlersList{
    if (_viewControlersList == nil) {
        /*
         NSClassFromString(@"MonitoringController"),
         NSClassFromString(@"WorkbenchController"),
         NSClassFromString(@"DocumentLibController"),
         NSClassFromString(@"ConversationListController"),
         NSClassFromString(@"TeamController"),
         */
        _viewControlersList = @[NSClassFromString(@"FileListView"),
                                NSClassFromString(@"FrameController")];
    }
    return _viewControlersList;
}
#pragma mark -- navigation delegate

//该方法可以解决popRootViewController时tabbar的bug
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self setNavigationBarHidden:[self.viewControlersList containsObject:[viewController class]] animated:YES];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray *array = @[NSClassFromString(@"MonitoringController"),
                       NSClassFromString(@"WorkbenchController"),
                       NSClassFromString(@"DocumentLibController"),
                       NSClassFromString(@"ConversationListController"),
                       NSClassFromString(@"TeamController"),
                       NSClassFromString(@"FileListView"),
                       NSClassFromString(@"FrameController")];
    if ([array containsObject:[viewController class]]) {
        BOOL hide = YES;
        if ([viewController isKindOfClass:[DocumentLibController class]])
        {
            DocumentLibController *vc = (DocumentLibController *)viewController;
            if (vc.chooseTargetFile == YES) {
                hide = NO;
            }
        }
        if ([viewController isKindOfClass:[FileListView class]]) {
            FileListView *vc = (FileListView *)viewController;
            if (vc.chooseTargetFile == YES) {
                hide = NO;
            }
        }
        if ([viewController isKindOfClass:[TeamController class]])
        {
            TeamController *vc = (TeamController *)viewController;
            if (vc.selectedUserType == YES) {
                hide = NO;
            }
        }
        else{
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowHeaderView object:@(hide)];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowHeaderView object:@(NO)];
    }
}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    if (self.viewControllers.count <= 1) {
//        return NO;
//    }
//    return YES;
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
