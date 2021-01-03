//
//  BaseNavigationController.m
//  MangroveTree
//
//  Created by sjlh on 2017/3/15.
//  Copyright © 2017年 MVM. All rights reserved.
//

#import "BaseNavigationController.h"

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
        _viewControlersList = @[NSClassFromString(@"FileListView")];
    }
    return _viewControlersList;
}
#pragma mark -- navigation delegate

//该方法可以解决popRootViewController时tabbar的bug
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self setNavigationBarHidden:[self.viewControlersList containsObject:[viewController class]] animated:YES];

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
