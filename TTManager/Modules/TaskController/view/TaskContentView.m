//
//  TaskContentView.m
//  TTManager
//
//  Created by chao liu on 2021/1/2.
//

#import "TaskContentView.h"

@interface TaskContentView ()<UITextViewDelegate>

//@property (nonatomic, strong) UIView *priorityView;
//@property (nonatomic, strong) NSArray *prioritybtnArray;
@property (nonatomic, strong) UIButton *adjunctFileBtn;
@property (nonatomic, strong) UIButton *deleteFileBtn;
@property (nonatomic, copy) NSString *uid_target;
@property (nonatomic, copy) NSString *targetType;
//@property (nonatomic,assign) BOOL editPriority;
@property (nonatomic, copy) NSString *taskContent;

// 附件调整类型 1 添加附件 2 查看附件 3没有附件 4 删除附件
@property (nonatomic, assign) NSInteger adjunctType;

@end
@implementation TaskContentView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.isModification = NO;
        self.taskContent = @"";
        self.adjunctType = NSNotFound;
        self.uid_target = @"";
        self.targetType = @"";
//        self.editPriority = NO;
        [self addUI];
    }
    return self;
}
#pragma mark - 页面操作
- (void)setContentViewOperations:(OperabilityTools *)tools{
    switch (tools.type) {
        case task_type_new_task:
            self.adjunctFileBtn.enabled = YES;
//            self.editPriority = YES;
            self.contentView.editable = YES;
            [self newTaskAdjuctFile];
            break;
        case task_type_new_apply:
            self.adjunctFileBtn.enabled = YES;
//            self.editPriority = YES;
            self.contentView.editable = YES;
            [self newTaskAdjuctFile];
            break;
        case task_type_new_noti:
            self.adjunctFileBtn.enabled = YES;
//            self.editPriority = YES;
            self.contentView.editable = YES;
            [self newTaskAdjuctFile];
            break;
        case task_type_new_joint:
            self.adjunctFileBtn.enabled = YES;
//            self.editPriority = YES;
            self.contentView.editable = YES;
            [self newTaskAdjuctFile];
            break;
        case task_type_new_polling:
            self.adjunctFileBtn.enabled = YES;
//            self.editPriority = YES;
            self.contentView.editable = YES;
            [self newTaskAdjuctFile];
            break;
        case task_type_detail_proceeding:
//            self.editPriority = YES;
            [self editContentText];
            [self proceedingAdjuctdFile];
            break;
        case task_type_detail_finished:
//            self.editPriority = NO;
            self.contentView.editable = NO;
            [self finisheAdjuctdFile];
            break;
        case task_type_detail_draft:
            self.adjunctFileBtn.enabled = YES;
//            self.editPriority = YES;
            self.contentView.editable = YES;
            [self newTaskAdjuctFile];
            break;
        case task_type_detail_initiate:
            self.adjunctFileBtn.enabled = YES;
//            self.editPriority = YES;
            self.contentView.editable = YES;
            [self newTaskAdjuctFile];
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
- (void)newTaskAdjuctFile{
    NSString *fileName = @"";
    // 有附件 显示删除按钮 文件名称 查看附件
    if (![SZUtil isEmptyOrNull:_tools.task.firstTarget.uid_target]) {
        fileName = _tools.task.firstTarget.name;
        self.uid_target = _tools.task.firstTarget.uid_target;
        self.targetType = INT_32_TO_STRING(_tools.task.firstTarget.type);
        [self hideDelete:NO];
        self.adjunctType = 2;
    }else{
        fileName = @"添加附件";
        self.adjunctType = 1;
        [self hideDelete:YES];
    }
    [self.adjunctFileBtn setTitle:fileName forState:UIControlStateNormal];
}
- (void)finisheAdjuctdFile{
    NSString *fileName = @"";
    [self hideDelete:YES];
    if(_tools.currentSelectedStep.memoDocs != nil && _tools.currentSelectedStep.memoDocs.count >0){
        ZHTarget *target = [_tools.currentSelectedStep.memoDocs allObjects][0];
        fileName = target.name;
        self.uid_target = target.uid_target;
        self.targetType = INT_32_TO_STRING(target.type);
        self.adjunctFileBtn.enabled = YES;
        self.adjunctType = 2;
    }else{
        self.adjunctFileBtn.enabled = NO;
        fileName = @"当前步骤未添加附件";
        self.adjunctType = 3;
    }
    [self.adjunctFileBtn setTitle:fileName forState:UIControlStateNormal];
}
- (void)proceedingAdjuctdFile{
    NSString *fileName = @"";
    ZHUser *user = [DataManager defaultInstance].currentUser;
    if (_tools.currentSelectedStep.responseUser.id_user == user.id_user) {
        if(_tools.currentSelectedStep.memoDocs != nil && _tools.currentSelectedStep.memoDocs.count >0){
            ZHTarget *target = [_tools.currentSelectedStep.memoDocs allObjects][0];
            fileName = target.name;
            self.uid_target = target.uid_target;
            self.targetType = INT_32_TO_STRING(target.type);
            self.adjunctType = 2;
            [self hideDelete:NO];
        }else{
            fileName = @"添加附件";
            self.adjunctType = 1;
            [self hideDelete:YES];
        }
        self.adjunctFileBtn.enabled = YES;
    }
    else{
        if(_tools.currentSelectedStep.memoDocs != nil && _tools.currentSelectedStep.memoDocs.count >0){
            ZHTarget *target = [_tools.currentSelectedStep.memoDocs allObjects][0];
            fileName = target.name;
            self.uid_target = target.uid_target;
            self.targetType = INT_32_TO_STRING(target.type);

            self.adjunctType = 2;
            [self hideDelete:YES];
            self.adjunctFileBtn.enabled = YES;
        }else{
            fileName = @"当前步骤未添加附件";
            self.adjunctType = 3;
            [self hideDelete:YES];
            self.adjunctFileBtn.enabled = NO;
        }
    }
    [self.adjunctFileBtn setTitle:fileName forState:UIControlStateNormal];
}
- (void)hideDelete:(BOOL)hide{
    self.deleteFileBtn.hidden = hide;
    if (hide == YES) {
        [_adjunctFileBtn setImage:[UIImage imageNamed:@"task_adjunctFile"] forState:UIControlStateNormal];
    }else{
        [_adjunctFileBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    [self.deleteFileBtn updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hide == YES ? 15 :-10);
    }];
}

#pragma mark - Actions
- (void)chooseAdjunctFile:(UIButton *)button{
    if (self.adjunctType == 3) {
        return;
    }
    [self routerEventWithName:choose_adjunct_file userInfo:@{@"adjunctType":[NSString stringWithFormat:@"%ld",self.adjunctType],@"uid_target":self.uid_target,@"type":self.targetType}];
}
- (void)deleteAdjunctFile:(UIButton *)button{
    NSLog(@"删除当前文档");
    [self routerEventWithName:choose_adjunct_file userInfo:@{@"adjunctType":@"4",@"uid_target":self.uid_target}];
}
//- (void)priorityAction:(UIButton *)button{
//    if (self.editPriority == NO) {
//        return;
//    }
//    if (_tools.task.belongFlow.state == 1) {
//        return;
//    }
//    self.priorityType = button.tag;
//}
//// 改变当前选择的任务优先级状态
//- (void)changePriorityStatus:(NSInteger)index{
//    NSInteger actualIndex = 999;
//    if (index <= 4) {
//        actualIndex = 1;
//    }else if( index > 5 && index<=9){
//        actualIndex = 7;
//    }else{
//        actualIndex = 5;
//    }
//    for (UIButton *button in self.prioritybtnArray) {
//        button.selected = (actualIndex == button.tag);
//    };
//}

#pragma mark - setter and getter

//- (void)setPriorityType:(PriorityType)priorityType{
//    if (_priorityType != priorityType) {
//        _priorityType = priorityType;
//        [self changePriorityStatus:_priorityType];
//        NSString *priority = @"1";
//        if (_priorityType == priority_type_low) {
//            priority = @"1";
//        }else if(_priorityType == priority_type_middle){
//            priority = @"5";
//        }else if(_priorityType == priority_type_highGrade){
//            priority = @"7";
//        }
//        [self routerEventWithName:selected_task_priority userInfo:@{@"priority":priority}];
//    }
//}
- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    if (_tools.currentSelectedStep != nil) {
        self.contentView.text = _tools.currentSelectedStep.memo;
    }else{
        self.contentView.text = _tools.task.memo;
    }
    
    if (_tools.task.belongFlow.state == 1) {
        self.contentView.editable = NO;
    }
    ZHUser *user = [DataManager defaultInstance].currentUser;
    if (_tools.currentSelectedStep != nil && _tools.currentSelectedStep.responseUser.id_user != user.id_user) {
        self.contentView.editable = NO;
    }
    
//    [self changePriorityStatus:_tools.task.priority];
    [self setContentViewOperations:_tools];
}

//- (UIView *)priorityView{
//    if (_priorityView == nil) {
//        _priorityView = [[UIView alloc] init];
//    }
//    return _priorityView;
//}
- (UITextView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UITextView alloc] init];
        _contentView.textColor = RGB_COLOR(51, 51, 51);
        _contentView.font = [UIFont systemFontOfSize:13.0f];
        _contentView.delegate = self;
        _contentView.placeholder = @"请输入任务内容";
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
- (UIButton *)deleteFileBtn{
    if (_deleteFileBtn == nil) {
        _deleteFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteFileBtn setBackgroundImage:[UIImage imageNamed:@"delete_file"] forState:UIControlStateNormal];
        [_deleteFileBtn addTarget:self action:@selector(deleteAdjunctFile:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteFileBtn;
}
//- (NSArray *)prioritybtnArray{
//    if (_prioritybtnArray == nil) {
//        NSMutableArray *result = [NSMutableArray array];
//        for (int i = 0; i < 3; i++) {
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            UIColor *normalColor = nil;
//            UIColor *selectColor = nil;
//            if (i == 0) {
//                button.tag = 1;
//                normalColor = RGBA_COLOR(0, 183, 147, 0.3);
//                selectColor = RGB_COLOR(0, 183, 147);
//            }else if(i == 1){
//                button.tag = 5;
//                normalColor = RGBA_COLOR(244, 216, 2, 0.3);
//                selectColor = RGB_COLOR(244, 216, 2);
//            }else{
//                button.tag = 7;
//                normalColor = RGBA_COLOR(255, 77, 77, 0.3);
//                selectColor = RGB_COLOR(255, 77, 77);
//            }
//            [button setBackgroundImage:[SZUtil createImageWithColor:normalColor] forState:UIControlStateNormal];
//            [button setBackgroundImage:[SZUtil createImageWithColor:selectColor] forState:UIControlStateSelected];
//            [result addObject:button];
//        }
//        _prioritybtnArray = result;
//    }
//    return _prioritybtnArray;
//}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.contentView) {
        self.isModification = YES;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.contentView) {
        [self routerEventWithName:change_task_content userInfo:@{@"taskContent":textView.text}];
    }
}
#pragma mark - UI
- (void)addUI{
//    [self addSubview:self.priorityView];
    
//    self.backgroundColor = [UIColor redColor];
//    [self addPriorityViewSubViews];
    
    [self addSubview:self.contentView];
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    [bgView addSubview:self.contentView];
    [bgView addSubview:self.adjunctFileBtn];
    
    [bgView addSubview:self.deleteFileBtn];
    
//    [self.priorityView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(0);
//        make.left.equalTo(16);
//        make.right.equalTo(-16);
//        make.height.equalTo(20);
//    }];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
    }];
    [self.deleteFileBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(15);
        make.bottom.equalTo(-10);
        make.top.equalTo(self.contentView.mas_bottom);
        make.width.height.equalTo(15);
    }];
    
    [self.adjunctFileBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteFileBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.deleteFileBtn);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    [bgView borderForColor:[SZUtil colorWithHex:@"#CCCCCC"] borderWidth:0.5 borderType:UIBorderSideTypeAll];
    [self hideDelete:YES];
}
//- (void)addPriorityViewSubViews{
//    UILabel *label = [[UILabel alloc] init];
//    label.text = @"优先级";
//    label.font = [UIFont systemFontOfSize:14.0f];
//    label.textColor = RGB_COLOR(102, 102, 102);
//    [self.priorityView addSubview:label];
//    [label makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.equalTo(0);
//    }];
//    UIButton *lastBtn = nil;
//    for (int i = 0; i < self.prioritybtnArray.count; i++) {
//        UIButton *btn = self.prioritybtnArray[i];
//        [self.priorityView addSubview:btn];
//        [btn makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(16);
//            make.centerY.equalTo(self.priorityView);
//            if (lastBtn == nil) {
//                make.left.equalTo(label.mas_right).offset(10);
//            }else{
//                make.left.equalTo(lastBtn.mas_right).offset(10);
//            }
//        }];
//        [btn addTarget:self action:@selector(priorityAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.priorityView layoutIfNeeded];
//        btn.clipsToBounds = YES;
//        btn.layer.cornerRadius = 8.0f;
//        lastBtn = btn;
//    }
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
