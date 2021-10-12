//
//  TaskTitleView.m
//  TTManager
//
//  Created by chao liu on 2021/1/2.
//

#import "TaskTitleView.h"

#define MaxTitleHeight 88.0f

@interface TaskTitleView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *priorityView;
@property (nonatomic, strong) NSArray *prioritybtnArray;
@property (nonatomic, strong) UIView *taskTypeTagView;

@end

@implementation TaskTitleView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.isModification = NO;
        [self addUI];
    }
    return self;
}

- (void)setTaskTitleStatusColor:(NSInteger)index{
    UIColor *lineColor = nil;
    if (index <= 4) {
        lineColor = RGB_COLOR(0, 183, 147);
    }else if(index > 5 && index<= 9){
        lineColor = RGB_COLOR(255, 77, 77);
    }else{
        lineColor = RGB_COLOR(244, 216, 2);
    }
    self.taskTypeTagView.backgroundColor = lineColor;
}
#pragma mark - 页面操作
- (void)setStepTitleOperations:(OperabilityTools *)tools{
    
    [self editTitle];
}
- (void)editTitle{
    
    self.taskTitle.editable = _tools.isCanEdit;
}

// 改变当前选择的任务优先级状态
- (void)changePriorityStatus:(NSInteger)index{
    NSInteger actualIndex = 999;
    if (index <= 4) {
        actualIndex = 1;
    }else if( index > 5 && index<=9){
        actualIndex = 7;
    }else{
        actualIndex = 5;
    }
    for (UIButton *button in self.prioritybtnArray) {
        button.selected = (actualIndex == button.tag);
    };
}

- (void)setPriorityType:(PriorityType)priorityType{
    if (_priorityType != priorityType) {
        _priorityType = priorityType;
        [self changePriorityStatus:_priorityType];
        NSString *priority = @"1";
        if (_priorityType == priority_type_low) {
            priority = @"1";
        }else if(_priorityType == priority_type_middle){
            priority = @"5";
        }else if(_priorityType == priority_type_highGrade){
            priority = @"7";
        }
        [self routerEventWithName:selected_task_priority userInfo:@{@"priority":priority}];
    }
}

- (void)priorityAction:(UIButton *)button{
    if ( _tools.isCanEdit == NO) {
        return;
    }
    if (_tools.task.belongFlow.state == 1) {
        return;
    }
    self.priorityType = button.tag;
}

#pragma mark - setting and getter

- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    self.taskTitle.text = _tools.task.name;
    [self setStepTitleOperations:_tools];
    [self textViewDidChange:self.taskTitle];
    self.isModification = NO;
    [self changePriorityStatus:_tools.task.priority];
    [self setTaskTitleStatusColor:_tools.task.priority];
}
- (UIView *)taskTypeTagView{
    if (_taskTypeTagView == nil) {
        _taskTypeTagView = [[UIView alloc] init];
    }
    return _taskTypeTagView;
}

- (UITextView *)taskTitle{
    if (_taskTitle == nil) {
        _taskTitle = [[UITextView alloc] init];
        _taskTitle.textColor = RGB_COLOR(51, 51, 51);
        _taskTitle.font = [UIFont systemFontOfSize:20.0f];
        _taskTitle.delegate = self;
        _taskTitle.placeholder = @"请输入任务标题";
        _taskTitle.placeholderColor = [UIColor lightGrayColor];
    }
    return _taskTitle;
}

- (UIView *)priorityView{
    if (_priorityView == nil) {
        _priorityView = [[UIView alloc] init];
    }
    return _priorityView;
}

- (NSArray *)prioritybtnArray{
    if (_prioritybtnArray == nil) {
        NSMutableArray *result = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            UIColor *normalColor = nil;
            UIColor *selectColor = nil;
            if (i == 0) {
                button.tag = 1;
                normalColor = RGBA_COLOR(0, 183, 147, 0.3);
                selectColor = RGB_COLOR(0, 183, 147);
            }else if(i == 1){
                button.tag = 5;
                normalColor = RGBA_COLOR(244, 216, 2, 0.3);
                selectColor = RGB_COLOR(244, 216, 2);
            }else{
                button.tag = 7;
                normalColor = RGBA_COLOR(255, 77, 77, 0.3);
                selectColor = RGB_COLOR(255, 77, 77);
            }
            [button setBackgroundImage:[SZUtil createImageWithColor:normalColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[SZUtil createImageWithColor:selectColor] forState:UIControlStateSelected];
            [result addObject:button];
        }
        _prioritybtnArray = result;
    }
    return _prioritybtnArray;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView == self.taskTitle && _tools.isCanEdit == YES){
        return YES;
    }
    return NO;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView == self.taskTitle) {
        CGFloat height = [NSString heightFromString:textView.text withFont:[UIFont systemFontOfSize:20.0f] constraintToWidth:kScreenWidth-60];
        if (height > MaxTitleHeight) {
            textView.scrollEnabled = YES;
            height = MaxTitleHeight;
        }else if(height <= 30){
            height = 30;
        }
        [self.taskTitle updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
        self.isModification = YES;
        NSLog(@"当前的高度 %f",height);

    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.taskTitle) {
        [self routerEventWithName:change_task_title userInfo:@{@"taskTitle":textView.text}];
    }
}
#pragma mark - UI
- (void)addUI{
        
    [self addSubview:self.taskTypeTagView];
    [self addSubview:self.taskTitle];
    
    [self addSubview:self.priorityView];
    
    [self addPriorityViewSubViews];
    
    [self.taskTypeTagView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.left.equalTo(0);
        make.width.equalTo(4);
        make.height.equalTo(self.mas_height).multipliedBy(0.5);
    }];
    [self.taskTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(self.taskTypeTagView.mas_right).offset(14);
        make.right.equalTo(-12);
        make.height.greaterThanOrEqualTo(30);
        make.height.lessThanOrEqualTo(90);
    }];
    [self.priorityView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskTitle.mas_bottom).offset(5);
        make.left.equalTo(14);
        make.right.equalTo(-12);
        make.height.equalTo(20);
        make.bottom.equalTo(0);
    }];
}

- (void)addPriorityViewSubViews{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"优先级";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = RGB_COLOR(102, 102, 102);
    [self.priorityView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
    }];
    UIButton *lastBtn = nil;
    for (int i = 0; i < self.prioritybtnArray.count; i++) {
        UIButton *btn = self.prioritybtnArray[i];
        [self.priorityView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(16);
            make.centerY.equalTo(self.priorityView);
            if (lastBtn == nil) {
                make.left.equalTo(label.mas_right).offset(10);
            }else{
                make.left.equalTo(lastBtn.mas_right).offset(10);
            }
        }];
        [btn addTarget:self action:@selector(priorityAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.priorityView layoutIfNeeded];
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 8.0f;
        lastBtn = btn;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
