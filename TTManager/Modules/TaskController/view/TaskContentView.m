//
//  TaskContentView.m
//  TTManager
//
//  Created by chao liu on 2021/1/2.
//

#import "TaskContentView.h"

@interface TaskContentView ()<UITextViewDelegate>

@property (nonatomic, strong) UIButton *adjunctFileBtn;
@property (nonatomic, strong) UIButton *deleteFileBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, copy) NSString *uid_target;
@property (nonatomic, copy) NSString *targetType;
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
        [self addUI];
    }
    return self;
}
#pragma mark - 页面操作
- (void)setContentViewOperations:(OperabilityTools *)tools{
    switch (tools.type) {
        case task_type_new_task:
            [self newTaskAdjuctFile];
            break;
        case task_type_new_apply:
            [self newTaskAdjuctFile];
            break;
        case task_type_new_noti:
            [self newTaskAdjuctFile];
            break;
        case task_type_new_joint:
            [self newTaskAdjuctFile];
            break;
        case task_type_new_polling:
            [self newTaskAdjuctFile];
            break;
        case task_type_detail_proceeding:
            [self editContentText];
            [self proceedingAdjuctdFile];
            break;
        case task_type_detail_finished:
            [self finisheAdjuctdFile];
            break;
        case task_type_detail_draft:
            [self newTaskAdjuctFile];
            break;
        case task_type_detail_initiate:
            [self newTaskAdjuctFile];
            break;
        default:
            break;
    }
}
- (void)editContentText{
    
//    self.adjunctFileBtn.enabled = _tools.isCanEdit;
//    self.deleteFileBtn.enabled = _tools.isCanEdit;
    
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
        self.adjunctType = 2;
        [_adjunctFileBtn highlightColor];
    }else{
        fileName = @"当前步骤未添加附件";
        self.adjunctType = 3;
        [_adjunctFileBtn defaultColor];
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
            [_adjunctFileBtn highlightColor];
        }else{
            fileName = @"添加附件";
            self.adjunctType = 1;
            [self hideDelete:YES];
            [_adjunctFileBtn defaultColor];
        }
    }
    else{
        if(_tools.currentSelectedStep.memoDocs != nil && _tools.currentSelectedStep.memoDocs.count >0){
            ZHTarget *target = [_tools.currentSelectedStep.memoDocs allObjects][0];
            fileName = target.name;
            self.uid_target = target.uid_target;
            self.targetType = INT_32_TO_STRING(target.type);

            self.adjunctType = 2;
            [self hideDelete:YES];
            [_adjunctFileBtn highlightColor];
        }else{
            fileName = @"当前步骤未添加附件";
            self.adjunctType = 3;
            [self hideDelete:YES];
            [_adjunctFileBtn defaultColor];
        }
    }
    [self.adjunctFileBtn setTitle:fileName forState:UIControlStateNormal];
}
- (void)hideDelete:(BOOL)hide{
    self.deleteFileBtn.hidden = hide;
    if (hide == YES) {
        [_adjunctFileBtn setImage:[UIImage imageNamed:@"task_adjunctFile"] forState:UIControlStateNormal];
        [_adjunctFileBtn defaultColor];
    }else{
        [_adjunctFileBtn highlightColor];
        [_adjunctFileBtn setImage:[UIImage new] forState:UIControlStateNormal];
    }
}

#pragma mark - Actions
- (void)chooseAdjunctFile:(UIButton *)button{
    NSLog(@"button的点击事件");
    if (self.adjunctType == 3) {
        return;
    }
    
    [self routerEventWithName:choose_adjunct_file userInfo:@{@"adjunctType":[NSString stringWithFormat:@"%ld",self.adjunctType],@"uid_target":self.uid_target,@"type":self.targetType,@"canEdit":@(_tools.isCanEdit)}];
}
- (void)deleteAdjunctFile:(UIButton *)button{
    NSLog(@"删除当前文档");
    [self routerEventWithName:choose_adjunct_file userInfo:@{@"adjunctType":@"4",@"uid_target":self.uid_target}];
}
// 保存
- (void)saveTask:(UIButton *)button{
    if (_tools.isCanEdit == NO) {
        return;
    }
    [self routerEventWithName:task_click_save userInfo:@{}];
}
#pragma mark - setter and getter


- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    if (_tools.currentSelectedStep != nil) {
        self.contentView.text = _tools.currentSelectedStep.memo;
    }else{
        self.contentView.text = _tools.task.memo;
    }
    
    [self editContentText];
    [self setContentViewOperations:_tools];
}

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
        [_adjunctFileBtn defaultColor];
        [_adjunctFileBtn setImage:[UIImage imageNamed:@"task_adjunctFile"] forState:UIControlStateNormal];
        [_adjunctFileBtn addTarget:self action:@selector(chooseAdjunctFile:) forControlEvents:UIControlEventTouchUpInside];
        _adjunctFileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _adjunctFileBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _adjunctFileBtn.backgroundColor = [UIColor whiteColor];
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
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if((textView == self.contentView && _tools.isCanEdit == YES)){
        return YES;
    }
    return NO;
}

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
    self.userInteractionEnabled = YES;
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    [bgView addSubview:self.contentView];
    
    self.contentView.userInteractionEnabled = YES;
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    
    [bottomView addSubview:self.adjunctFileBtn];
    [bottomView addSubview:self.deleteFileBtn];
    [bottomView addSubview:self.saveBtn];
    
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(30);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.bottom.equalTo(0);
    }];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    [self.adjunctFileBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8);
        make.height.equalTo(20);
        make.bottom.equalTo(-5);
    }];
    [self.deleteFileBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adjunctFileBtn.mas_right).offset(4);
        make.bottom.equalTo(-10);
        make.width.height.equalTo(10);
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-12);
        make.centerY.equalTo(bottomView);
    }];
    
    [bgView borderForColor:[SZUtil colorWithHex:@"#CCCCCC"] borderWidth:0.5 borderType:UIBorderSideTypeAll];
    [bottomView borderForColor:[SZUtil colorWithHex:@"#CCCCCC"] borderWidth:0.5 borderType:UIBorderSideTypeAll];
    [self hideDelete:YES];
}

@end
