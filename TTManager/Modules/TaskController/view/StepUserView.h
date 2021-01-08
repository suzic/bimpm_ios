//
//  StepUserView.h
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,StepType){
    StepType_initiator,//发起
    StepType_finish,   //完成人
    StepType_agree,    // 同意
    StepType_reject,   // 拒绝
    StepType_self,     // 自己
};

NS_ASSUME_NONNULL_BEGIN

@interface StepUserView : UIView

/// 获取详情得到的是step
@property (nonatomic, strong) ZHStep *step;
/// 创建任务获取到的是自选的user
@property (nonatomic, strong) ZHUser *user;
@end

NS_ASSUME_NONNULL_END
