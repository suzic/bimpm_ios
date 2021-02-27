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
@property (nonatomic, strong) UIButton *operationBtn1;
// 拒绝
@property (nonatomic, strong) UIButton *operationBtn2;

@property (nonatomic, strong) BRDatePickerView *datePickerView;

@property (nonatomic, strong) NSDate *selectDate;

@end

@implementation TaskOperationView
- (instancetype)init{
    self = [super init];
    if (self) {
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

#pragma mark - 页面操作
- (void)setBottomToolsOperations:(OperabilityTools *)tools{
    
    NSInteger stepStatus = _tools.currentSelectedStep.state;
    
    // 获取任务操作按钮文本
    NSArray *operationList = [self getTaskOperationList];
    
    switch (stepStatus) {
        // 未开始 进行中
        case 0:
        case 2:
        {
            NSString *operation1 = operationList[0];
            NSString *operation2 = operationList[1];
            if (_tools.currentSelectedStep.process_type != 0) {
                if ([operation2 isEqualToString:@""]) {
                    [self.operationBtn2 approvalType:operation1];
                    self.operationBtn1.hidden = YES;
                }else{
                    [self.operationBtn1 approvalType:operation1];
                    [self.operationBtn2 opposeType:operation2];
                }
            }else{
                if (_tools.type == task_type_detail_finished) {
                    [self.operationBtn2 sengType:operation1];
                    self.operationBtn1.hidden = YES;
                }else{
                    if (_tools.task.belongFlow.state == 1 && _tools.task.belongFlow.stepFirst.state == 2) {
                        [self.operationBtn2 sengType:@"我知道了"];
                        self.operationBtn1.hidden = YES;
                    }else{
                        [self.operationBtn2 sengType:operation1];
                        self.operationBtn1.hidden = YES;
                    }
                }
            }
        }
            break;
        // 已经完成
        case 1:
        case 3:
        {
            NSString *operation1 = operationList[0];
            NSString *operation2 = operationList[1];
            
            if (_tools.currentSelectedStep.process_type == 0) {
                [self.operationBtn2 sengFinishType:operation1];
                self.operationBtn1.hidden = YES;
            }else{
                if (_tools.currentSelectedStep.decision == 1) {
                    operation1 = [NSString stringWithFormat:@"已%@",operation1];
                    if ([operation2 isEqualToString:@""]) {
                        [self.operationBtn2 approvalFinishType:operation1];
                        self.operationBtn1.hidden = YES;
                    }else{
                        [self.operationBtn1 approvalFinishType:operation1];
                        [self.operationBtn2 opposeType:operation2];
                    }
                }else if(_tools.currentSelectedStep.decision == 2){
                    if ([operation2 isEqualToString:@""]) {
                        operation2 = [NSString stringWithFormat:@"已%@",operation1];
                        [self.operationBtn2 opposeFinishType:operation2];
                        self.operationBtn1.hidden = YES;
                    }else{
                        operation2 = [NSString stringWithFormat:@"已%@",operation2];
                        [self.operationBtn1 approvalType:operation1];
                        [self.operationBtn2 opposeFinishType:operation1];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

- (NSArray *)getTaskOperationList{
    ZHStep *step = _tools.currentSelectedStep;
    // 操作按钮类型
    NSString *operationText1 = @"";
    NSString *operationText2 = @"";
    
    switch (step.process_type) {
        case 0:{
            // 任务完成时间
            NSString *end_date = [NSDate br_stringFromDate:step.end_date dateFormat:@"yyyy-MM-dd HH:mm"];
            if ([SZUtil isEmptyOrNull:end_date]) {
                operationText1 = @"发起任务";
            }else{
                operationText1 = @"已发送";
            }
            operationText2 = @"";
        }
            break;
        case 1:
            operationText1 = @"同意";
            operationText2 = @"拒绝";
            break;
        case 2:
            operationText1 = @"通过";
            operationText2 = @"拒绝";
            break;
        case 3:
            operationText1 = @"赞同";
            operationText2 = @"反对";
            break;
        case 4:
            operationText1 = @"通过";
            operationText2 = @"驳回";
            break;
        case 5:{
            operationText1 = @"确认";
            if (_tools.currentIndex > 0 && _tools.currentIndex< _tools.stepArray.count-1) {
                operationText1 = @"通过";
            }
        }
            operationText2 = @"";
            break;
        case 6:{
            operationText1 = @"完成";
            if (_tools.currentIndex > 0 && _tools.currentIndex< _tools.stepArray.count-1) {
                operationText1 = @"通过";
            }
        }
            operationText2 = @"";
            break;
        default:
            break;
    }
    return @[operationText1,operationText2];
}

- (void)setPlanEndTime{
    NSString *predictTime = [NSDate br_stringFromDate:_tools.currentSelectedStep.plan_end dateFormat:@"yyyy-MM-dd HH:mm"];
    if (![SZUtil isEmptyOrNull:predictTime]) {
        self.predictTimeLabel.text = predictTime;
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
- (UIButton *)operationBtn1{
    if (_operationBtn1 == nil) {
        _operationBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _operationBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_operationBtn1 addTarget:self action:@selector(rejectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_operationBtn1 setBackgroundColor:RGB_COLOR(0, 203, 105)];
    }
    return _operationBtn1;
}
- (UIButton *)operationBtn2{
    if (_operationBtn2 == nil) {
        _operationBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _operationBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
        [_operationBtn2 addTarget:self action:@selector(rejectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_operationBtn2 setBackgroundColor:RGB_COLOR(239, 89, 95)];
    }
    return _operationBtn2;
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
    [view addSubview:self.operationBtn1];
    [view addSubview:self.operationBtn2];
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
    
    [self.operationBtn2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(0);
        make.width.equalTo(100);
    }];
    [self.operationBtn1 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.operationBtn2.mas_left);
        make.width.equalTo(self.operationBtn2.mas_width);
        make.height.equalTo(self.operationBtn2.mas_height);
    }];
    self.operationBtn1.hidden = YES;
    self.operationBtn2.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
