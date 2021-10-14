//
//  UIButton+Extend.m
//  TTManager
//
//  Created by chao liu on 2021/1/23.
//

#import "UIButton+Extend.h"

static void *timerKey = @"timerKey";


@interface UIButton ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation UIButton (Extend)

- (void)startCountDown:(NSInteger)total finishTitile:(NSString *)finishTitle{
    self.userInteractionEnabled = NO;
    //倒计时时间
        __block NSInteger timeOut = total;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        //每秒执行一次
        dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{

            //倒计时结束，关闭
            if (timeOut <= 0) {
                dispatch_source_cancel(self.timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setTitle:finishTitle forState:UIControlStateNormal];
                    self.userInteractionEnabled = YES;
                });
            } else {
//                int seconds = timeOut % 60;
                NSString *timeStr = [NSString stringWithFormat:@"%0.2ld", (long)timeOut];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setTitle:[NSString stringWithFormat:@"%@",timeStr] forState:UIControlStateNormal];
                    self.userInteractionEnabled = NO;
                });
                timeOut--;
            }
        });
        dispatch_resume(self.timer);
}
- (void)stopTimer{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

-(dispatch_source_t)timer{
    return objc_getAssociatedObject(self, timerKey);
}

- (void)setTimer:(dispatch_source_t)timer{
    objc_setAssociatedObject(self, timerKey, timer, OBJC_ASSOCIATION_RETAIN);
}

/// 发送任务
- (void)sengType:(NSString *)text{
    self.backgroundColor = RGB_COLOR(247, 181, 0);
    [self setTitle:text forState:UIControlStateNormal];
    self.enabled = YES;
    self.hidden = NO;
}
/// 赞同任务样式
- (void)approvalType:(NSString *)text{
    self.backgroundColor = RGB_COLOR(0, 203, 105);
    [self setTitle:text forState:UIControlStateNormal];
    self.enabled = YES;
    self.hidden = NO;
}
/// 反对的样式
- (void)opposeType:(NSString *)text{
    self.backgroundColor = RGB_COLOR(239, 89, 95);
    [self setTitle:text forState:UIControlStateNormal];
    self.enabled = YES;
    self.hidden = NO;
}

/// 发送任务样式
- (void)sengFinishType:(NSString *)text{
    self.backgroundColor = RGB_COLOR(247, 181, 0);
    [self setTitle:text forState:UIControlStateNormal];
    self.enabled = NO;
    self.hidden = NO;
}
/// 赞同任务样式
- (void)approvalFinishType:(NSString *)text{
    self.backgroundColor = RGB_COLOR(0, 203, 105);
    [self setTitle:text forState:UIControlStateNormal];
    self.enabled = NO;
    self.hidden = NO;
}
/// 反对的样式
- (void)opposeFinishType:(NSString *)text{
    self.backgroundColor = RGB_COLOR(239, 89, 95);
    [self setTitle:text forState:UIControlStateNormal];
    self.enabled = NO;
    self.hidden = NO;
}

- (void)highlightColor{
    [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}
- (void)defaultColor{
    [self setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
}

@end
