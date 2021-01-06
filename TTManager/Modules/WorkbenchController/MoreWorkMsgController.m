//
//  MoreWorkMsgController.m
//  TTManager
//
//  Created by chao liu on 2020/12/28.
//

#import "MoreWorkMsgController.h"
#import "MessageView.h"

@interface MoreWorkMsgController ()<APIManagerParamSource,ApiManagerCallBackDelegate>

@property (nonatomic, strong) APIUTPInfoManager *UTPInfoManager;
@property (nonatomic, strong) MessageView *messageView;
@property (nonatomic, strong) MessageView *projectInfoView;

@end

@implementation MoreWorkMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息详情";
    [self.UTPInfoManager loadData];
    [self addUI];
}
- (void)addUI{
    [self.view addSubview:self.messageView];
    [self.view addSubview:self.projectInfoView];
    
    [self.messageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(self.view).multipliedBy(0.5);
    }];
    
    [self.projectInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageView.mas_bottom);
        make.left.bottom.right.equalTo(0);
    }];
    self.messageView.messageArray = self.infoArray;
}

#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    ZHProject *project = [DataManager defaultInstance].currentProject;
    if(manager == self.UTPInfoManager){
        dic = @{@"id_project":INT_32_TO_STRING(project.id_project),@"edit_date":@"",};
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if(manager == self.UTPInfoManager){
        NSArray *projectInfoArray = (NSArray *)(manager.response.responseData);
        self.projectInfoView.messageArray = projectInfoArray;
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if(manager == self.UTPInfoManager){
        
    }
}
#pragma mark - setter and getter
- (MessageView *)messageView{
    if (_messageView == nil) {
        _messageView = [[MessageView alloc] init];
        _messageView.backgroundColor = RGB_COLOR(72, 147, 241);
    }
    return _messageView;
}
- (MessageView *)projectInfoView{
    if (_projectInfoView == nil) {
        _projectInfoView = [[MessageView alloc] init];
        _projectInfoView.backgroundColor = [UIColor whiteColor];
    }
    return _projectInfoView;
}
- (APIUTPInfoManager *)UTPInfoManager{
    if (_UTPInfoManager == nil) {
        _UTPInfoManager = [[APIUTPInfoManager alloc] init];
        _UTPInfoManager.delegate = self;
        _UTPInfoManager.paramSource = self;
    }
    return _UTPInfoManager;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
