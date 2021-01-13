//
//  TaskTitleView.m
//  TTManager
//
//  Created by chao liu on 2021/1/2.
//

#import "TaskTitleView.h"

#define MaxTitleHeight 88.0f

@interface TaskTitleView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *taskTypeTagView;
@property (nonatomic, strong) UITextView *taskTitle;

@end

@implementation TaskTitleView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)addUI{
    [self addSubview:self.taskTypeTagView];
    [self addSubview:self.taskTitle];
    [self.taskTypeTagView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.width.equalTo(4);
        make.height.equalTo(self.mas_height).multipliedBy(0.5);
    }];
    [self.taskTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(self.taskTypeTagView.mas_right).offset(14);
        make.right.equalTo(-12);
        make.height.greaterThanOrEqualTo(30);
        make.height.lessThanOrEqualTo(90);
        make.bottom.equalTo(-10);
    }];
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
#pragma mark - setting and getter
- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    self.taskTitle.text = _tools.task.name;
    self.taskTitle.editable = _tools.operabilityTitle;
    [self textViewDidChange:self.taskTitle];
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
        [self setTextViewPlaceholder:_taskTitle];
        _taskTitle.textContainerInset = UIEdgeInsetsMake(-2, 0, 0, 0);
    }
    return _taskTitle;
}
- (void)setTextViewPlaceholder:(UITextView *)textView{
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入任务标题";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [textView addSubview:placeHolderLabel];

    textView.font = [UIFont systemFontOfSize:20.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:20.f];
    [textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    NSInteger height = ([self.taskTitle sizeThatFits:CGSizeMake(self.taskTitle.bounds.size.width, MAXFLOAT)].height);
    NSLog(@"当前textView的高度是---%ld",height);
    if (height > MaxTitleHeight) {
        textView.scrollEnabled = YES;
        height = MaxTitleHeight;
    }else if(height <= 30){
        height = 30;
    }
    [self.taskTitle updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self routerEventWithName:change_task_title userInfo:@{@"taskTitle":textView.text}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
