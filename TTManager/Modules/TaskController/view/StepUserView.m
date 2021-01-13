//
//  StepUserView.m
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import "StepUserView.h"

@interface StepUserView ()

// 当前步骤用户状态
@property (nonatomic, strong) UILabel *stepStatus;
// 步骤头像
@property (nonatomic, strong) UIImageView *stepUserImage;
// 当前用户处理情况
//@property (nonatomic, strong) UILabel *stepUserDispose;
// 当前步骤用户名称
//@property (nonatomic, strong) UILabel *stepUserName;

@end

@implementation StepUserView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI{
    UIView *bgView = [[UIView alloc] init];
    [bgView addSubview:self.stepUserImage];
    [bgView addSubview:self.stepStatus];
    [self addSubview:bgView];
    
//    [self addSubview:self.stepUserDispose];
//    [self addSubview:self.stepUserName];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.right.equalTo(-10);
        make.left.equalTo(0);
        make.height.equalTo(bgView.mas_width);
    }];
    [self.stepUserImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
    [self.stepStatus makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(2);
        make.width.equalTo(30);
        make.height.equalTo(12);
    }];
//    [self.stepUserDispose makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView.mas_bottom).offset(5);
//        make.centerX.equalTo(bgView);
//    }];
//    [self.stepUserName makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.stepUserDispose.mas_bottom).offset(6);
//        make.centerX.equalTo(self.stepUserDispose);
//    }];
}
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    self.stepUserImage.clipsToBounds = YES;
    self.stepUserImage.layer.cornerRadius = _stepUserImage.frame.size.height/2;
    self.stepStatus.clipsToBounds = YES;
    self.stepStatus.layer.cornerRadius = 6.0f;
}

#pragma mark - private method
- (void)setUserInfo:(ZHUser *)user{
    [self.stepUserImage sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"test-1"]];
//    self.stepUserName.text = user.name;
}
- (void)setStepInfo:(ZHStep *)step{
    self.stepStatus.text = [self getDecisionText:step];
}
#pragma mark - setting and getter
- (void)setStep:(ZHStep *)step{
    if (_step != step) {
        _step = step;
        [self setUserInfo:_step.responseUser];
        [self setStepInfo:_step];
    }
}

// 获取当前人对任务的决策
- (NSString *)getDecisionText:(ZHStep *)step{
    NSString *decision = @"";
    // 发起人
    if (step.process_type == 0 && step.decision == 1) {
        decision = @"发起人";
        self.stepStatus.backgroundColor = [SZUtil colorWithHex:@"#F3913F"];
        self.stepStatus.textColor = [UIColor whiteColor];
    }else if(step.process_type == 1 && step.decision == 1){
        decision = @"同意";
    }else if(step.process_type == 1 && step.decision == 2){
        decision = @"拒绝";
    }else if(step.process_type == 2 && step.decision == 1){
        decision = @"通过";
    }else if(step.process_type == 2 && step.decision == 2){
        decision = @"通过";
    }else if(step.process_type == 3 && step.decision == 1){
        decision = @"赞同";
    }else if(step.process_type == 3 && step.decision == 2){
        decision = @"反对";
    }else if(step.process_type == 4 && step.decision == 1){
        decision = @"通过";
    }else if(step.process_type == 4 && step.decision == 2){
        decision = @"驳回";
    }else if(step.process_type == 5 && step.decision == 1){
        decision = @"确认";
    }else if(step.process_type == 6 && step.decision == 1){
        decision = @"完成";
    }
    return decision;
}
- (UILabel *)stepStatus{
    if (_stepStatus == nil) {
        _stepStatus = [[UILabel alloc] init];
        _stepStatus.font = [UIFont systemFontOfSize:8.0f];
        _stepStatus.textAlignment = NSTextAlignmentCenter;
    }
    return _stepStatus;
}
- (UIImageView *)stepUserImage{
    if (_stepUserImage == nil) {
        _stepUserImage = [[UIImageView alloc] init];
        _stepUserImage.image = [UIImage imageNamed:@"test-1"];
        _stepUserImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _stepUserImage;
}
//- (UILabel *)stepUserDispose{
//    if (_stepUserDispose == nil) {
//        _stepUserDispose = [[UILabel alloc] init];
//        _stepUserDispose.text = @"提出情况";
//        _stepUserDispose.textColor = [SZUtil colorWithHex:@"#4D8AF3"];
//        _stepUserDispose.font = [UIFont systemFontOfSize:9.0f];
//    }
//    return _stepUserDispose;
//}
//- (UILabel *)stepUserName{
//    if (_stepUserName == nil) {
//        _stepUserName = [[UILabel alloc] init];
//        _stepUserName.textColor = [SZUtil colorWithHex:@"#999999"];
//        _stepStatus.font = [UIFont systemFontOfSize:11.0f];
//    }
//    return _stepUserName;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
