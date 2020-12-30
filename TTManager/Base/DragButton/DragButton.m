//
//  DragButton.m
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import "DragButton.h"

#define ErrorLogButtonHigt 49.0f

@interface DragButton ()

@property (nonatomic, strong)UIViewController *currentVC;

@end

@implementation DragButton

+ (DragButton *)initDragButtonVC:(UIViewController *)VC
{
    DragButton *button = [DragButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(MainScreenWidth-ErrorLogButtonHigt, MainScreenHeight-ErrorLogButtonHigt, ErrorLogButtonHigt, ErrorLogButtonHigt);
    button.currentVC = VC;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"new_task"] forState:UIControlStateNormal];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = ErrorLogButtonHigt/2;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    [button addTarget:button action:@selector(logButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:button action:@selector(handlePan:)];
    [button addGestureRecognizer:pan];
    [button.currentVC.view addSubview:button];
    
    return button;
}

- (void)logButtonAction:(DragButton *)button
{
    [self routerEventWithName:@"new_task_action" userInfo:@{}];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self.currentVC.view];
    
    CGFloat offsetY = pan.view.center.y + point.y;
    CGFloat offsetX = pan.view.center.x + point.x;
    
    CGFloat minOffsetY = ErrorLogButtonHigt/2;
    CGFloat maxOffsetY = kScreenHeight - ErrorLogButtonHigt/2-SafeAreaBottomHeight;
    
    CGFloat minOffsetX = ErrorLogButtonHigt/2;
    CGFloat maxOffsetX = kScreenWidth - ErrorLogButtonHigt/2;
    
    offsetY = offsetY < minOffsetY ? minOffsetY : (offsetY > maxOffsetY ? maxOffsetY : offsetY);
    offsetX = offsetX < minOffsetX ? minOffsetX : (offsetX > maxOffsetX ? maxOffsetX :offsetX);
    
    pan.view.center = CGPointMake(offsetX, offsetY);
    [pan setTranslation:CGPointMake(0, 0) inView:self.currentVC.view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
