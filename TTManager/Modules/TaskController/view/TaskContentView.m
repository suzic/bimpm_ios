//
//  TaskContentView.m
//  TTManager
//
//  Created by chao liu on 2021/1/2.
//

#import "TaskContentView.h"

@interface TaskContentView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *priorityView;
@property (nonatomic, strong) NSArray *prioritybtnArray;
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UIButton *adjunctFileBtn;

@property (nonatomic,assign) BOOL editPriority;

@end
@implementation TaskContentView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.editPriority = NO;
        [self addUI];
    }
    return self;
}
#pragma mark - 页面操作
- (void)setContentViewOperations:(OperabilityTools *)tools{
    switch (tools.type) {
        case task_type_new_task:
            self.adjunctFileBtn.enabled = YES;
            self.editPriority = YES;
            self.contentView.editable = YES;
            break;
        case task_type_new_apply:
            self.adjunctFileBtn.enabled = YES;
            self.editPriority = YES;
            self.contentView.editable = YES;
            break;
        case task_type_new_noti:
            self.adjunctFileBtn.enabled = YES;
            self.editPriority = YES;
            self.contentView.editable = YES;
            break;
        case task_type_new_joint:
            self.adjunctFileBtn.enabled = YES;
            self.editPriority = YES;
            self.contentView.editable = YES;
            break;
        case task_type_new_polling:
            self.adjunctFileBtn.enabled = YES;
            self.editPriority = YES;
            self.contentView.editable = YES;
            break;
        case task_type_detail_proceeding:
            self.editPriority = YES;
            [self editContentText];
            break;
        case task_type_detail_finished:
            self.adjunctFileBtn.enabled = NO;
            self.editPriority = NO;
            self.contentView.editable = NO;
            break;
        case task_type_detail_draft:
            self.adjunctFileBtn.enabled = YES;
            self.editPriority = YES;
            self.contentView.editable = YES;
            break;
        case task_type_detail_initiate:
            self.adjunctFileBtn.enabled = YES;
            self.editPriority = YES;
            self.contentView.editable = YES;
            break;
        default:
            break;
    }
}
- (void)editContentText{
    ZHUser *user = [DataManager defaultInstance].currentUser;
    if (_tools.currentSelectedStep.responseUser.id_user == user.id_user) {
        self.contentView.editable = YES;
        self.adjunctFileBtn.enabled = YES;
    }else{
        self.contentView.editable = NO;
        self.adjunctFileBtn.enabled = NO;
    }
}
#pragma mark - Actions
- (void)chooseAdjunctFile:(UIButton *)button{
    [self routerEventWithName:choose_adjunct_file userInfo:@{}];
}

- (void)priorityAction:(UIButton *)button{
    if (self.editPriority == NO) {
        return;
    }
    self.priorityType = button.tag;
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
- (void)setTextViewPlaceholder:(UITextView *)textView{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入任务内容";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [textView addSubview:placeHolderLabel];

    textView.font = [UIFont systemFontOfSize:13.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:13.f];
    [textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}
#pragma mark - setter and getter

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
- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    self.contentView.text = _tools.currentSelectedStep.memo;
    [self changePriorityStatus:_tools.task.priority];
    [self setContentViewOperations:_tools];
}

- (UIView *)priorityView{
    if (_priorityView == nil) {
        _priorityView = [[UIView alloc] init];
    }
    return _priorityView;
}
- (UITextView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UITextView alloc] init];
        _contentView.textColor = RGB_COLOR(51, 51, 51);
        _contentView.font = [UIFont systemFontOfSize:13.0f];
        _contentView.delegate = self;
        [self setTextViewPlaceholder:_contentView];
    }
    return _contentView;
}
- (UIButton *)adjunctFileBtn{
    if (_adjunctFileBtn == nil) {
        _adjunctFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_adjunctFileBtn setTitle:@"添加附件" forState:UIControlStateNormal];
        _adjunctFileBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_adjunctFileBtn setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
        [_adjunctFileBtn setImage:[UIImage imageNamed:@"task_adjunctFile"] forState:UIControlStateNormal];
        [_adjunctFileBtn addTarget:self action:@selector(chooseAdjunctFile:) forControlEvents:UIControlEventTouchUpInside];
        _adjunctFileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _adjunctFileBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    }
    return _adjunctFileBtn;
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
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self routerEventWithName:change_task_content userInfo:@{@"taskContent":textView.text}];
}
#pragma mark - UI
- (void)addUI{
    [self addSubview:self.priorityView];
    
    [self addPriorityViewSubViews];
    
    [self addSubview:self.contentView];
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    [bgView addSubview:self.contentView];
    [bgView addSubview:self.adjunctFileBtn];
    
//    [self addSubview:self.adjunctFileBtn];
    [self.priorityView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(6);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(20);
    }];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priorityView.mas_bottom).offset(10);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
    }];
    
    [self.adjunctFileBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.bottom.equalTo(-10);
        make.top.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    [bgView borderForColor:[SZUtil colorWithHex:@"#CCCCCC"] borderWidth:0.5 borderType:UIBorderSideTypeAll];
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
