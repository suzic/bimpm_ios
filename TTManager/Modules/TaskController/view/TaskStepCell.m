//
//  TaskStepCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import "TaskStepCell.h"
#import "StepUserView.h"

@interface TaskStepCell ()

@property (nonatomic, strong) StepUserView *stepView;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;

// 0 发起 1 赞同 2 同意 3 通过 4 完成  5 驳回 6 反对
@property (nonatomic, assign) NSInteger statsStyle;

@end

@implementation TaskStepCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        self.contentView.clipsToBounds = NO;
    }
    return self;
}
- (void)setCurrentStep:(ZHStep *)currentStep{
    _currentStep = currentStep;
    self.stepView.step = _currentStep;
    if (_currentStep.responseUser != nil) {
        self.stepView.hidden = NO;
        self.addImageView.hidden = YES;
    }else{
        self.stepView.hidden = YES;
        self.addImageView.hidden = NO;
    }
//    [self setFlowStatus:_currentStep];
//    [self setStepStatus:_currentStep];
    self.stepView.stepUserDispose.text = _currentStep.name;
    self.stepView.stepStatus.text = [self getDecisionText:_currentStep];
}
- (void)setIsSelected:(BOOL)isSelected{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        if (_isSelected == YES) {
            [self showLineView];
        }else{
            [self hiddeenLineView];
        }
    }
}
//- (void)setFlowStatus:(ZHStep *)step{
//    NSInteger flowStatus = step.asCurrent.state;
//    if (flowStatus == 0) {
//        NSLog(@"当前流程未开始");
//    }else if(flowStatus == 1){
//        NSLog(@"当前流程已经完成");
//    }else if(flowStatus == 2){
//        NSLog(@"当前流程进行中");
//    }else if(flowStatus == 3){
//        NSLog(@"当前流程中断");
//    }else if(flowStatus == 4){
//        NSLog(@"当前流程等待前置流程");
//    }
//}
//- (void)setStepStatus:(ZHStep *)step{
//    NSInteger status = step.state;
//    if (status == 0) {
//        NSLog(@"当前步骤未开始");
//    }else if(status == 1){
//        NSLog(@"当前步骤已经完成");
//    }else if(status == 2){
//        NSLog(@"当前步骤进行中");
//    }else if(status == 3){
//        NSLog(@"当前步骤中断");
//    }
//}
//- (void)setType:(TaskType)type{
//    _type = type;
//    if (_type == task_type_detail_proceeding) {
//        self.stepView.stepStatus.text = [self getDecisionText:self.currentStep];
//    }
//    switch (_type) {
//        case task_type_new_task:
//        case task_type_new_apply:
//        case task_type_new_noti:
//        case task_type_new_joint:
//        case task_type_new_polling:
//            break;
//        case task_type_detail_proceeding:
//            break;
//        case task_type_detail_finished:
//            break;
//        case task_type_detail_draft:
//            break;
//        case task_type_detail_initiate:
//            break;
//        default:
//            break;
//    }
//}
#pragma mark - 页面显示
- (NSString *)getDecisionText:(ZHStep *)step{
    NSString *decision = @"";
    if (self.index == 0) {
        decision = @"发起";
        self.statsStyle = 0;
    }else{
        if (step.state == 0) {
            decision = @"未开始";
            self.statsStyle = 4;
        }else if(step.state == 1){
            // 发起人
            if (step.process_type == 0 && step.decision == 1) {
                decision = @"发起";
                self.statsStyle = 0;
            }
            else if(step.process_type == 1 && step.decision == 1){
                decision = @"同意";
                self.statsStyle = 2;
            }else if(step.process_type == 1 && step.decision == 2){
                decision = @"拒绝";
                self.statsStyle = 1;
            }else if(step.process_type == 2 && step.decision == 1){
                decision = @"通过";
                self.statsStyle = 3;
            }else if(step.process_type == 2 && step.decision == 2){
                decision = @"通过";
                self.statsStyle = 3;
            }else if(step.process_type == 3 && step.decision == 1){
                decision = @"赞同";
                self.statsStyle = 3;
            }else if(step.process_type == 3 && step.decision == 2){
                decision = @"反对";
                self.statsStyle = 1;
            }else if(step.process_type == 4 && step.decision == 1){
                decision = @"通过";
                self.statsStyle = 3;
            }else if(step.process_type == 4 && step.decision == 2){
                decision = @"驳回";
                self.statsStyle = 1;
            }else if(step.process_type == 5 && step.decision == 1){
                if (step.hasNext.count >0) {
                    decision = @"通过";
                    self.statsStyle = 3;
                }else{
                    decision = @"确认";
                    self.statsStyle = 3;
                }
            }else if(step.process_type == 6 && step.decision == 1){
                if (step.hasNext.count >0) {
                    decision = @"通过";
                    self.statsStyle = 3;
                }else{
                    decision = @"完成";
                    self.statsStyle = 3;
                }
            }
        }else if(step.state == 2){
            decision = @"进行中";
            self.statsStyle = 3;
        }else if(step.state == 3){
            decision = @"已中断";
            self.statsStyle = 1;
        }
    }
    return decision;
}
- (void)setStatsStyle:(NSInteger)statsStyle{
    _statsStyle = statsStyle;
        UIColor *bgColor = nil;
        BOOL border = NO;
        UIColor *borderColor = nil;
        UIColor *textColor = nil;
        switch (_statsStyle) {
                // 发起
            case 0:
                bgColor = RGB_COLOR(243, 145, 63);
                textColor = [UIColor whiteColor];
                border = NO;
                break;
                // 反对
            case 1:
                bgColor = [UIColor whiteColor];
                border = YES;
                borderColor = RGB_COLOR(246, 115, 115);
                textColor = RGB_COLOR(246, 115, 115);
                break;
                // 同意
            case 2:
                bgColor = RGB_COLOR(0, 203, 105);
                textColor = [UIColor whiteColor];
                break;
                // 赞同
            case 3:
                bgColor = [UIColor whiteColor];
                textColor = RGB_COLOR(0, 203, 105);
                border = YES;
                borderColor = RGB_COLOR(0, 203, 105);
                break;
                // 未开始
            case 4:
                bgColor = RGB_COLOR(153, 153, 153);
                textColor = [UIColor whiteColor];
                border = NO;
                break;
                break;
            default:
                break;
        }
        
        self.stepView.stepStatus.backgroundColor = bgColor;
        self.stepView.stepStatus.textColor = textColor;
        if (border == YES) {
            self.stepView.stepStatus.layer.borderWidth = 0.5;
            self.stepView.stepStatus.layer.borderColor = borderColor.CGColor;
        }else{
            self.stepView.stepStatus.layer.borderWidth = 0;
            self.stepView.stepStatus.layer.borderColor = [UIColor clearColor].CGColor;
        }
}
#pragma mark - UI
- (void)addUI{
    
    [self.contentView addSubview:self.stepView];
    [self.contentView addSubview:self.addImageView];
    [self.stepView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    [self.addImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.right.equalTo(-10);
        make.left.equalTo(0);
        make.height.equalTo(self.addImageView.mas_width);
    }];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = RGB_COLOR(153, 153, 153);
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = RGB_COLOR(153, 153, 153);
    [self.contentView addSubview:self.topLine];
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    self.leftLine = [[UIView alloc] init];
    self.leftLine.backgroundColor = RGB_COLOR(153, 153, 153);
    [self.contentView addSubview:self.leftLine];
    [self.leftLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.bottom.equalTo(0);
        make.width.equalTo(0.5);
    }];
    
    self.rightLine = [[UIView alloc] init];
    self.rightLine.backgroundColor = RGB_COLOR(153, 153, 153);
    [self.contentView addSubview:self.rightLine];
    [self.rightLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(0);
        make.bottom.equalTo(0);
        make.width.equalTo(0.5);
    }];
    [self hiddeenLineView];
}
- (void)hiddeenLineView{
    self.bottomLine.hidden = NO;
    self.topLine.hidden = YES;
    self.leftLine.hidden = YES;
    self.rightLine.hidden = YES;
}
- (void)showLineView{
    self.bottomLine.hidden = YES;
    self.topLine.hidden = NO;
    self.leftLine.hidden = NO;
    self.rightLine.hidden = NO;
}
#pragma mark - setting and getter
- (StepUserView *)stepView{
    if (_stepView == nil) {
        _stepView = [[StepUserView alloc] init];
    }
    return _stepView;
}
- (UIImageView *)addImageView{
    if (_addImageView == nil) {
        _addImageView = [[UIImageView alloc] init];
        _addImageView.contentMode = UIViewContentModeScaleAspectFit;
        _addImageView.image = [UIImage imageNamed:@"add_user"];
    }
    return _addImageView;
}

@end
