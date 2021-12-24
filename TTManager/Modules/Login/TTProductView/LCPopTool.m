//
//  LCPopTool.m
//  TTManager
//
//  Created by chao liu on 2021/12/24.
//

#import "LCPopTool.h"
#import "TTProductView.h"

@interface LCPopTool ()

@property (nonatomic, strong)TTProductView *currentView;

@end

@implementation LCPopTool

+ (instancetype)defaultInstance{
    static LCPopTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (void)showAnimated:(BOOL)animated{
    if (!_currentView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self.currentView];
    }
    // 屏幕中心
//    CGPoint screenCenter = CGPointMake(kScreenWidth, kScreenHeight);
//    self.currentView.center = screenCenter;
    if (animated) {
        self.currentView.hidden = NO;
       // 第一步：将view宽高缩至无限小（点）
        self.currentView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                               CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:0.3 animations:^{
            self.currentView.transform =
                  CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        } completion:^(BOOL finished) {
            NSLog(@"%@", self.currentView);
        }];
     }
}

- (void)closeAnimated:(BOOL)animated{
    [UIView animateWithDuration:0.2 animations:^{
        self.currentView.transform =
    CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.currentView.transform = CGAffineTransformScale(
                  CGAffineTransformIdentity, 0.001, 0.001);
        } completion:^(BOOL finished) {
            self.currentView.hidden = YES;
        }];
    }];
}

- (TTProductView *)currentView{
    if (_currentView == nil) {
        _currentView = [[TTProductView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _currentView.hidden = YES;
    }
    return _currentView;
}
@end
