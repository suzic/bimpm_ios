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
@property (nonatomic,strong) MASConstraint *heightconstrain;

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
        make.height.equalTo(MaxTitleHeight);
    }];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.taskTitle.mas_bottom);
    }];
    
}
- (void)updateTextViewHeight:(NSString *)text{
    
}
#pragma mark - setting and getter
- (UIView *)taskTypeTagView{
    if (_taskTypeTagView == nil) {
        _taskTypeTagView = [[UIView alloc] init];
        _taskTypeTagView.backgroundColor = RGB_COLOR(255, 77, 77);
    }
    return _taskTypeTagView;
}
- (UITextView *)taskTitle{
    if (_taskTitle == nil) {
        _taskTitle = [[UITextView alloc] init];
        _taskTitle.textColor = RGB_COLOR(51, 51, 51);
        _taskTitle.font = [UIFont systemFontOfSize:20.0f];
        _taskTitle.text = @"任务名称9月计划图开发计划图-任务处理,任务名称9月计划图开发计划图-任务处理,任务名称9月计划图开发计划图-任务处理";
        _taskTitle.delegate = self;
        _taskTitle.textContainerInset = UIEdgeInsetsMake(-2, 0, 0, 0);
    }
    return _taskTitle;
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<= frame.size.height) {
        size.height=frame.size.height;
    }else{
        if (size.height >= MaxTitleHeight)
        {
            size.height = MaxTitleHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    [self.taskTitle updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(size.height);
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
