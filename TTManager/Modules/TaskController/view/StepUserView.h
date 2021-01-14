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

// 当前步骤用户状态
@property (nonatomic, strong) UILabel *stepStatus;
// 当前用户处理情况
@property (nonatomic, strong) UILabel *stepUserDispose;
/// 获取详情得到的是step
@property (nonatomic, strong) ZHStep *step;

@end

NS_ASSUME_NONNULL_END
