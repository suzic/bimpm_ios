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

@end
@implementation TaskContentView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

#pragma mark - Actions
- (void)chooseAdjunctFile:(UIButton *)button{
    if (_tools.type == task_type_detail_initiate) {
        return;
    }
    [self routerEventWithName:choose_adjunct_file userInfo:@{}];
}

- (void)priorityAction:(UIButton *)button{
    if (_tools.type == task_type_detail_initiate) {
        return;
    }
    self.priorityType = button.tag;
}
// 改变当前选择的任务优先级状态
- (void)changePriorityStatus:(PriorityType)type{
    
    for (UIButton *button in self.prioritybtnArray) {
        button.selected = (type == button.tag);
    };
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
        btn.tag = i;
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
#pragma mark - setter and getter

- (void)setPriorityType:(PriorityType)priorityType{
    if (_priorityType != priorityType) {
        _priorityType = priorityType;
        [self changePriorityStatus:_priorityType];
        NSString *priority = @"1";
        if (_priorityType == priority_type_low) {
            priority = @"1";
        }else if(_priorityType == priority_type_middle){
            priority = @"4";
        }else if(_priorityType == priority_type_highGrade){
            priority = @"7";
        }
        [self routerEventWithName:selected_task_priority userInfo:@{@"priority":priority}];
    }
}
- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    self.adjunctFileBtn.enabled = _tools.operabilityAdjunct;
    self.contentView.editable = _tools.operabilityContent;
    self.contentView.text = _tools.currentSelectedStep.memo;
    [self changePriorityStatus:_tools.task.priority];
//    if (_tools.type == task_type_detail_initiate) {
//        self.contentView.editable = NO;
//    }
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
            button.tag = i +10000;
            UIColor *normalColor = nil;
            UIColor *selectColor = nil;
            if (i == 0) {
                normalColor = RGBA_COLOR(0, 183, 147, 0.3);
                selectColor = RGB_COLOR(0, 183, 147);
            }else if(i == 1){
                normalColor = RGBA_COLOR(244, 216, 2, 0.3);
                selectColor = RGB_COLOR(244, 216, 2);
            }else{
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
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self routerEventWithName:change_task_content userInfo:@{@"taskContent":textView.text}];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
