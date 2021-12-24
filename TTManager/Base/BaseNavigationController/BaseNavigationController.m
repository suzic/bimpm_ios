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
//    if (@available(iOS 13.0, *)) {
//        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
//        [appearance configureWithOpaqueBackground];
//        appearance.backgroundColor = RGB_COLOR(5, 125, 255);
//        self.navigationBar.standardAppearance = appearance;
//        self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance;
//    } else {
//        // Fallback on earlier versions
//    }
   
    
//    let appearance = UINavigationBarAppearance()
//    appearance.configureWithOpaqueBackground()
//    appearance.backgroundColor = <your tint color>
//    navigationBar.standardAppearance = appearance;
//    navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIView *statusBar = [keyWindow viewWithTag:1999999];
        if (!statusBar) {
            statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
            statusBar.tag = 1999999;
             statusBar.backgroundColor = RGB_COLOR(5, 125, 255);
             [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
        }else{
            [[UIApplication sharedApplication].keyWindow insertSubview:statusBar aboveSubview:[self topViewController].view];
        }
    } else {
        // Fallback on earlier versions
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
           if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
               statusBar.backgroundColor = RGB_COLOR(5, 125, 255);
           }
    }
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
                                NSClassFromString(@"FrameController"),
                                NSClassFromString(@"LoginViewController")];
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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
