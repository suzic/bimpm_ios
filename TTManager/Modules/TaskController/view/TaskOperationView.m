//
//  TaskOperationView.m
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import "TaskOperationView.h"

@interface TaskOperationView ()
// 保存
@property (nonatomic, strong) UIButton *saveBtn;
// 选择预计完成
@property (nonatomic, strong) UIButton *predictTimeBtn;
// 预计完成时间
@property (nonatomic, strong) UILabel *predictTimeLabel;

// 同意
@property (nonatomic, strong) UIButton *agreeBtn;
// 拒绝
@property (nonatomic, strong) UIButton *rejectBtn;

@property (nonatomic, strong) BRDatePickerView *datePickerView;

@property (nonatomic, strong) NSDate *selectDate;

@end

@implementation TaskOperationView
- (instancetype)init{
    self = [super init];
    if (self) {
//        self.selectDate = [NSDate dateWithTimeIntervalSinceNow:60*60];
        [self addUI];
    }
    return self;
}
#pragma mark - Action
- (void)selectTime:(UIButton *)button{
    if (_tools.task.belongFlow.state == 1) {
        return;
    }
    ZHUser *user = [DataManager defaultInstance].currentUser;
    if (_tools.currentSelectedStep != nil && _tools.currentSelectedStep.responseUser.id_user != user.id_user) {
        return;
    }
    [self.datePickerView show];
}
// 保存
- (void)saveTask:(UIButton *)button{
    [self routerEventWithName:task_click_save userInfo:@{}];
}
- (void)rejectBtnAction:(UIButton *)button{
    NSString *decsion = @"0";
    NSArray *decsion1 = @[@"拒绝",@"反对",@"驳回"];
    NSArray *decsion2 = @[@"同意",@"通过",@"赞同",@"确认",@"完成"];
    if ([decsion1 containsObject:button.titleLabel.text]) {
        decsion = @"2";
    }else if([decsion2 containsObject:button.titleLabel.text]){
        decsion = @"1";
    }
    [self routerEventWithName:task_process_submit userInfo:@{@"operation":decsion,@"uid_target":@""}];
}
// 获取当前的状态
- (NSString *)getDecisionText:(ZHStep *)step{
    NSString *decision = @"";
    
    // 发起人
    if(step.process_type == 1 && step.decision == 1){
        decision = @"同意";
        [self setOperationStyle:2 button:self.rejectBtn];
    }else if(step.process_type == 1 && step.decision == 2){
        decision = @"拒绝";
        [self setOperationStyle:1 button:self.rejectBtn];
    }else if(step.process_type == 2 && step.decision == 1){
        decision = @"通过";
        [self setOperationStyle:2 button:self.rejectBtn];
    }else if(step.process_type == 2 && step.decision == 2){
        decision = @"通过";
        [self setOperationStyle:2 button:self.rejectBtn];
    }else if(step.process_type == 3 && step.decision == 1){
        decision = @"赞同";
        [self setOperationStyle:2 button:self.rejectBtn];
    }else if(step.process_type == 3 && step.decision == 2){
        decision = @"反对";
        [self setOperationStyle:1 button:self.rejectBtn];
    }else if(step.process_type == 4 && step.decision == 1){
        decision = @"通过";
        [self setOperationStyle:2 button:self.rejectBtn];
    }else if(step.process_type == 4 && step.decision == 2){
        decision = @"驳回";
        [self setOperationStyle:1 button:self.rejectBtn];
    }else if(step.process_type == 5 && step.decision == 1){
        if (step.hasNext.count >0) {
            decision = @"通过";
        }else{
            decision = @"确认";
        }
        [self setOperationStyle:2 button:self.rejectBtn];
    }else if(step.process_type == 6 && step.decision == 1){
        if (step.hasNext.count >0) {
            decision = @"通过";
        }else{
            decision = @"完成";
        }
        [self setOperationStyle:2 button:self.rejectBtn];
    }else if(step.process_type == 0 && step.decision == 1){
        decision = @"发起";
    }
    return decision;
}
- (void)setOperationStyle:(NSInteger)statsStyle button:(UIButton *)button{
    // 发送任务
    if (statsStyle == 0) {
        button.backgroundColor = RGB_COLOR(247, 181, 0);
    }
    // 拒绝
    else if(statsStyle == 1){
        button.backgroundColor = RGB_COLOR(239, 89, 95);
    }
    // 同意 赞同
    else if(statsStyle == 2){
        button.backgroundColor = RGB_COLOR(0, 203, 105);
    }
    // 未开始
    else if(statsStyle == 3){
        button.backgroundColor = RGB_COLOR(153, 153, 153);
    }
}
#pragma mark - 页面操作
- (void)setBottomToolsOperations:(OperabilityTools *)tools{
    switch (tools.type) {
        case task_type_new_task:
            [self newTaskOperations];
            break;
        case task_type_new_apply:
            [self newTaskOperations];
            break;
        case task_type_new_noti:
            [self newTaskOperations];
            break;
        case task_type_new_joint:
            [self newTaskOperations];
            break;
        case task_type_new_polling:
            [self newTaskOperations];
            break;
        case task_type_detail_proceeding:
            [self taskProceedingOperations];
            break;
        case task_type_detail_finished:
            [self taskFinishOperations];
            break;
        case task_type_detail_draft:
            [self newTaskOperations];
            break;
        case task_type_detail_initiate:
            [self taskInitiateOperations];
            break;
        default:
            break;
    }
}
// 新建任务(包含起草的)
- (void)newTaskOperations{
    self.saveBtn.enabled = YES;
    self.rejectBtn.hidden = NO;
    [self.rejectBtn setTitle:@"发送任务" forState:UIControlStateNormal];
    [self setOperationStyle:0 button:self.rejectBtn];
    self.agreeBtn.hidden = YES;
    self.predictTimeBtn.enabled = YES;
}
// 已经发起的
- (void)taskInitiateOperations{
    self.saveBtn.enabled = YES;
    self.rejectBtn.enabled = NO;
    self.rejectBtn.hidden = NO;
    [self.rejectBtn setTitle:@"已发送" forState:UIControlStateNormal];
    [self setOperationStyle:3 button:self.rejectBtn];
    self.agreeBtn.hidden = YES;
    self.predictTimeBtn.enabled = YES;
}

// 已经完成的任务
- (void)taskFinishOperations{
    self.saveBtn.enabled = NO;
    ZHStep *step = _tools.currentSelectedStep;
    self.rejectBtn.hidden = NO;
    self.agreeBtn.hidden = YES;
    self.rejectBtn.enabled = NO;
    NSString *text = [NSString stringWithFormat:@"已%@",[self getDecisionText:step]];
    [self.rejectBtn setTitle:text forState:UIControlStateNormal];
    self.predictTimeBtn.enabled = NO;
}

// 正在进行中的
- (void)taskProceedingOperations{
    self.saveBtn.enabled = YES;
    ZHStep *step = _tools.currentSelectedStep;
    if(step.process_type == 1){
        [self.rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
     }else if(step.process_type == 2){
         [self.rejectBtn setTitle:@"通过" forState:UIControlStateNormal];
         self.agreeBtn.hidden = YES;
     }else if(step.process_type == 3 && step.decision == 1){
         [self.rejectBtn setTitle:@"反对" forState:UIControlStateNormal];
         [self.agreeBtn setTitle:@"赞同" forState:UIControlStateNormal];
     }else if(step.process_type == 4){
         [self.rejectBtn setTitle:@"驳回" forState:UIControlStateNormal];
         [self.agreeBtn setTitle:@"通过" forState:UIControlStateNormal];
     }else if(step.process_type == 5){
         [self.rejectBtn setTitle:@"确认" forState:UIControlStateNormal];
         self.agreeBtn.hidden = YES;
     }else if(step.process_type == 6){
         [self.rejectBtn setTitle:@"完成" forState:UIControlStateNormal];
         self.agreeBtn.hidden = YES;
     }
    ZHUser *user = [DataManager defaultInstance].currentUser;
    if (_tools.currentSelectedStep.responseUser.id_user == user.id_user) {
        self.predictTimeBtn.enabled = YES;
    }else{
        self.predictTimeBtn.enabled = NO;
    }
}
- (void)setPlanEndTime{
    NSString *predictTime = [NSDate br_stringFromDate:_tools.currentSelectedStep.plan_end dateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *predictTime1 = [NSDate br_stringFromDate:self.selectDate dateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *predictTime2 = [NSDate br_stringFromDate:_tools.task.belongFlow.stepFirst.plan_end dateFormat:@"yyyy-MM-dd HH:mm"];
    if (![SZUtil isEmptyOrNull:predictTime]) {
        self.predictTimeLabel.text = predictTime;
    }else if(![SZUtil isEmptyOrNull:predictTime1]){
        self.predictTimeLabel.text = predictTime1;
    }else if(![SZUtil isEmptyOrNull:predictTime2]){
        self.predictTimeLabel.text = predictTime2;
    }else{
        self.predictTimeLabel.text = @"未设置预计完成时间";
    }
}
#pragma mark - setting and getter
- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    [self setBottomToolsOperations:_tools];
    [self setPlanEndTime];
    if (_tools.type == task_type_new_polling || _tools.isPolling == YES) {
        self.saveBtn.hidden = YES;
    }else{
        self.saveBtn.hidden = NO;
    }
}
- (UIButton *)saveBtn{
    if (_saveBtn == nil) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:RGB_COLOR(25, 107, 248) forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_saveBtn addTarget:self action:@selector(saveTask:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
- (UIButton *)predictTimeBtn{
    if (_predictTimeBtn == nil) {
        _predictTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_predictTimeBtn setTitle:@"预计处理时间" forState:UIControlStateNormal];
        [_predictTimeBtn setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
        _predictTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_predictTimeBtn setImage:[UIImage imageNamed:@"task_time"] forState:UIControlStateNormal];
        [_predictTimeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        _predictTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _predictTimeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    return _predictTimeBtn;
}
- (UILabel *)predictTimeLabel{
    if (_predictTimeLabel == nil) {
        _predictTimeLabel = [[UILabel alloc] init];
        _predictTimeLabel.font = [UIFont systemFontOfSize:13.0];
        _predictTimeLabel.textColor = RGB_COLOR(51, 51, 51);
        _predictTimeLabel.text = @"请选择预计完成时间";
    }
    return _predictTimeLabel;
}
- (UIButton *)agreeBtn{
    if (_agreeBtn == nil) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_agreeBtn addTarget:self action:@selector(rejectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_agreeBtn setBackgroundColor:RGB_COLOR(0, 203, 105)];
    }
    return _agreeBtn;
}
- (UIButton *)rejectBtn{
    if (_rejectBtn == nil) {
        _rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rejectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rejectBtn addTarget:self action:@selector(rejectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rejectBtn setBackgroundColor:RGB_COLOR(239, 89, 95)];
    }
    return _rejectBtn;
}
- (BRDatePickerView *)datePickerView{
    if (_datePickerView == nil) {
        _datePickerView = [[BRDatePickerView alloc] init];
        _datePickerView.pickerMode = BRDatePickerModeYMDHM;
        _datePickerView.title = @"请选择预计完成时间";
        _datePickerView.minDate = [NSDate dateWithTimeIntervalSinceNow:60*60];
        _datePickerView.maxDate = [[NSDate date] br_getNewDate:[NSDate date] addDays:365*3];
        _datePickerView.isAutoSelect = NO;
        _datePickerView.minuteInterval = 5;
        _datePickerView.numberFullName = YES;
        __weak typeof(self) weakSelf = self;
        _datePickerView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            __strong typeof(self) strongSelf = weakSelf;
            NSLog(@"当前选择的时间 %@",selectDate);
            strongSelf.selectDate = selectDate;
            [strongSelf routerEventWithName:select_caldenar_view userInfo:@{@"planDate":selectDate}];
        };
    }
    return _datePickerView;
}
#pragma mark - UI
- (void)addUI{
    UIView *bgView = [[UIView alloc] init];
    [bgView addSubview:self.predictTimeBtn];
    [bgView addSubview:self.saveBtn];
    [self addSubview:bgView];
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:self.predictTimeLabel];
    [view addSubview:self.agreeBtn];
    [view addSubview:self.rejectBtn];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_COLOR(238, 238, 238);
    [view addSubview:lineView];
    [self addSubview:view];
        
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(self).multipliedBy(0.5);
    }];
    
    [self.predictTimeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(18);
        make.centerY.equalTo(bgView);
        make.width.equalTo(bgView).multipliedBy(0.5);
    }];
    [self.saveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-12);
        make.centerY.equalTo(bgView);
    }];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom);
        make.left.right.bottom.equalTo(0);
    }];
    [self.predictTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(18);
        make.centerY.equalTo(view);
    }];
    [self.rejectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(0);
        make.width.equalTo(100);
    }];
    [self.agreeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rejectBtn.mas_left);
        make.width.equalTo(self.rejectBtn.mas_width);
        make.height.equalTo(self.rejectBtn.mas_height);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
