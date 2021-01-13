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
        self.selectDate = [NSDate dateWithTimeIntervalSinceNow:60*60];
        [self addUI];
    }
    return self;
}
#pragma mark - Action
- (void)selectTime:(UIButton *)button{
    [self.datePickerView show];
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
        if (step.hasPrevs.count >0) {
            decision = @"通过";
        }else{
            decision = @"确认";
        }
    }else if(step.process_type == 6 && step.decision == 1){
        if (step.hasPrevs.count >0) {
            decision = @"通过";
        }else{
            decision = @"完成";
        }
    }
    return decision;
}
- (void)setOperationToolsButton:(OperabilityTools *)tools{
    ZHStep *step = tools.currentSelectedStep;
    NSLog(@"当前选中的步骤用户名称%@",step.responseUser.name);
    // 已经发起的智能不能再次发起
    if (tools.type == task_type_detail_initiate) {
        self.rejectBtn.hidden = NO;
        [self.rejectBtn setTitle:@"已发送" forState:UIControlStateNormal];
        self.agreeBtn.hidden = YES;
    }
    // 起草的可以修改
    else if(tools.type == task_type_detail_draft){
        self.rejectBtn.hidden = NO;
        [self.rejectBtn setTitle:@"发送任务" forState:UIControlStateNormal];
        self.agreeBtn.hidden = YES;
    }
    // 已经完成的不可以再点击
    else if(tools.type == task_type_detail_finished){
        self.rejectBtn.hidden = NO;
        self.agreeBtn.hidden = YES;
        self.rejectBtn.enabled = NO;
        [self.rejectBtn setTitle:[self getDecisionText:step] forState:UIControlStateNormal];
    }
    // 正在进行中的操作
    else if(tools.type == task_type_detail_proceeding){
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
    }
    // 新建任务
    else{
        self.rejectBtn.hidden = NO;
        [self.rejectBtn setTitle:@"发送任务" forState:UIControlStateNormal];
        self.agreeBtn.hidden = YES;
    }
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
#pragma mark - setting and getter
- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    self.saveBtn.enabled = _tools.operabilitySave;
    self.predictTimeBtn.enabled = _tools.operabilityTime;
    [self setOperationToolsButton:_tools];
    if (_tools.isDetails == YES) {
        self.predictTimeLabel.text = [NSDate br_stringFromDate:_tools.currentSelectedStep.plan_end dateFormat:@"yyyy-MM-dd HH:mm"];
    }else{
        self.predictTimeLabel.text = [NSDate br_stringFromDate:self.selectDate dateFormat:@"yyyy-MM-dd HH:mm"];
    }
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
//        _predictTimeLabel.text = @"2021-1-30";
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
