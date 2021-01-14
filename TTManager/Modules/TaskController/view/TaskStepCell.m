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

@end

@implementation TaskStepCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
        self.backgroundColor = [UIColor whiteColor];
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
- (void)setType:(TaskType)type{
    _type = type;
    if (_type == task_type_detail_proceeding) {
        self.stepView.stepStatus.text = [self getDecisionText:self.currentStep];
    }
    switch (_type) {
        case task_type_new_task:
        case task_type_new_apply:
        case task_type_new_noti:
        case task_type_new_joint:
        case task_type_new_polling:
            break;
        case task_type_detail_proceeding:
            break;
        case task_type_detail_finished:
            break;
        case task_type_detail_draft:
            break;
        case task_type_detail_initiate:
            break;
        default:
            break;
    }
}
#pragma mark - 页面显示
// 获取当前人对任务的决策
- (NSString *)getDecisionText:(ZHStep *)step{
    NSString *decision = @"";
    self.stepView.stepStatus.backgroundColor = [SZUtil colorWithHex:@"#F3913F"];
    self.stepView.stepStatus.textColor = [UIColor whiteColor];
    // 发起人
    if (step.process_type == 0 && step.decision == 1) {
        decision = @"发起";
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
    }else{
        ZHUser *currentUser = [DataManager defaultInstance].currentUser;
        if (currentUser.id_user == step.responseUser.id_user) {
            decision = @"我";
        }else{
            decision = @"进行中";
        }
    }
    return decision;
}
#pragma mark - UI
- (void)addUI{
    
    [self.contentView addSubview:self.stepView];
    [self.contentView addSubview:self.addImageView];
    [self.stepView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
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
