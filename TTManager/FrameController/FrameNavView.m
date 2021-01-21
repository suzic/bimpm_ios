//
//  FrameNavView.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "FrameNavView.h"
#import "PopViewController.h"

@interface FrameNavView ()<APIManagerParamSource,ApiManagerCallBackDelegate>

@property (nonatomic, strong)  UIButton *userAvatar;
@property (nonatomic, strong)  UIButton *changeProjectBtn;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) APIUTPDetailManager *UTPDetailManager;
@property (nonatomic, strong) APIUTPListManager *UTPlistManager;

@end

@implementation FrameNavView

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self addUI];
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)addUI{
    self.backgroundColor = RGB_COLOR(5, 125, 255);
    [self addSubview:self.userAvatar];
    [self addSubview:self.changeProjectBtn];
    [self.userAvatar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.width.height.equalTo(32);
        make.bottom.equalTo(-8);
    }];
    [self.changeProjectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(240);
        make.centerY.equalTo(self.userAvatar.mas_centerY);
        make.centerX.equalTo(self);
        make.height.equalTo(44);
    }];
    [self layoutIfNeeded];
    self.userAvatar.clipsToBounds = YES;
    self.userAvatar.layer.cornerRadius = 16.0f;
    [self reloadData];
    
}

- (void)reloadData{
    self.hidden = NO;
    ZHUser *user = [DataManager defaultInstance].currentUser;
    [self.userAvatar sd_setBackgroundImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"test-1"]];
    ZHProject *currentProject = [DataManager defaultInstance].currentProject;
    NSString *projectTitle = TARGETS_NAME;
    if (currentProject != nil) {
        projectTitle = currentProject.name;
    }
    [self.changeProjectBtn setTitle:projectTitle forState:UIControlStateNormal];
}
- (void)reloadUserProjectList{
    self.UTPlistManager.pageSize.pageIndex = 0;
    [self.UTPlistManager loadData];
}
#pragma mark - setter and getter
- (APIUTPDetailManager *)UTPDetailManager{
    if (_UTPDetailManager == nil) {
        _UTPDetailManager = [[APIUTPDetailManager alloc] init];
        _UTPDetailManager.delegate = self;
        _UTPDetailManager.paramSource = self;
    }
    return _UTPDetailManager;
}
- (APIUTPListManager *)UTPlistManager{
    if (_UTPlistManager == nil) {
        _UTPlistManager = [[APIUTPListManager alloc] init];
        _UTPlistManager.delegate = self;
        _UTPlistManager.paramSource = self;
        _UTPlistManager.isNeedCoreData = YES;
    }
    return _UTPlistManager;
}
- (UIButton *)userAvatar{
    if (_userAvatar == nil) {
        _userAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userAvatar setBackgroundImage:[UIImage imageNamed:@"test-1"] forState:UIControlStateNormal];
        [_userAvatar addTarget:self action:@selector(clickuserAvatarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAvatar;
}
- (UIButton *)changeProjectBtn{
    if (_changeProjectBtn == nil) {
        _changeProjectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeProjectBtn setImage:[UIImage imageNamed:@"button_ down"] forState:UIControlStateNormal];
        [_changeProjectBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_changeProjectBtn addTarget:self action:@selector(changeProjectAction:) forControlEvents:UIControlEventTouchUpInside];
        _changeProjectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return _changeProjectBtn;
}
- (void)changeTabProjectStyle:(BOOL)selectable{
    if (selectable == YES) {
        [self.changeProjectBtn setImage:nil forState:UIControlStateNormal];
        self.changeProjectBtn.enabled = NO;
        [self.changeProjectBtn setTitle:TARGETS_NAME forState:UIControlStateNormal];
        
    }else{
        [self.changeProjectBtn setImage:[UIImage imageNamed:@"button_ down"] forState:UIControlStateNormal];
        self.changeProjectBtn.enabled = YES;
    }
}
- (NSArray *)projectList{
    _projectList = [NSArray array];
    NSMutableArray *result = [DataManager defaultInstance].currentProjectList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"in_apply = 0 and in_manager_invite = 0"];
    result = [NSMutableArray arrayWithArray:[result filteredArrayUsingPredicate:predicate]];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"id_project" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    _projectList = [result sortedArrayUsingDescriptors:sortDescriptors];
    return _projectList;
}
#pragma mark -setter and getter
- (void)changeProjectAction:(UIButton *)sender {
    [self reloadUserProjectList];
}
- (void)clickuserAvatarAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSettings object:nil];
}
- (void)showProjectListActionSheets{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择项目" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i= 0; i < self.projectList.count; i++) {
        ZHUserProject *userProject = self.projectList[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:userProject.belongProject.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectedIndex = action.taskType;
            ZHUserProject *userProject = self.projectList[self.selectedIndex];
            [self.UTPDetailManager loadDataWithParams:@{@"id_project":INT_32_TO_STRING(userProject.belongProject.id_project)}];
        }];
        action.taskType = i;
        [alert addAction:action];
    }
    UIAlertAction *backList = [UIAlertAction actionWithTitle:@"回到项目列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickShowProjectListView)]) {
            [self.delegate clickShowProjectListView];
        }
    }];
    [backList setValue:RGB_COLOR(243, 145, 63) forKey:@"titleTextColor"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:backList];
    [alert addAction:cancel];
    [[SZUtil getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    ZHUser *user = [DataManager defaultInstance].currentUser;
    if (manager == self.UTPlistManager) {
        dic = @{@"id_user":INT_32_TO_STRING(user.id_user),@"belong_state":@"10"};
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.UTPDetailManager) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(frameNavView:selected:)]) {
            [self.delegate frameNavView:self selected:self.selectedIndex];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiReloadHomeView object:nil];
        [self reloadData];
    }else if(manager == self.UTPlistManager){
        [self showProjectListActionSheets];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
