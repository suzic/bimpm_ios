//
//  ClockInViewController.m
//  TTManager
//
//  Created by chao liu on 2021/1/17.
//

#import "ClockInViewController.h"
#import "BimpmMapView.h"
#import "ClockInView.h"
#import "ClockInManager.h"

@interface ClockInViewController ()<FormFlowManagerDelgate>

@property (nonatomic, strong) BimpmMapView *bimpmMapView;
@property (nonatomic, strong) ClockInView *clockInView;
@property (nonatomic, strong) ClockInManager *clockInManager;

/// 打卡类型 0 公司打卡 1 外出打卡
@property (nonatomic, assign) NSInteger clockType;
/// 上班打卡或者下班打卡
@property (nonatomic, assign) NSInteger clockOutOrIn;
/// 打卡地址
@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) UIBarButtonItem *closeItem;

@property (nonatomic, strong) NSMutableDictionary *clockInDic;

@property (nonatomic, strong) FormFlowManager *formflowManager;


@end

@implementation ClockInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"日常打卡";
    self.navigationItem.leftBarButtonItem = self.closeItem;
    self.clockInManager = [[ClockInManager alloc] init];
    [self addUI];
    
    [self reloadNetwork];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_bimpmMapView bimpmMapViewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_bimpmMapView bimpmMapViewWillDisappear];
}

#pragma mark - ResponseChain

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    // 定位回调
    if ([eventName isEqualToString:punch_card_distance]) {
        self.clockType = [userInfo[@"type"] intValue];
        self.address = userInfo[@"address"];
        [self.clockInView changeClockInScope:self.clockType];
    }
    
    // 点击打卡事件
    else if([eventName isEqualToString:punch_card_action]){
        self.clockOutOrIn = [userInfo[@"type"] intValue];
        NSLog(@"当前打卡类型 == %ld",(long)self.clockOutOrIn);
        [self clockAction:nil];
    }
}

#pragma mark - FormFlowManagerDelgate
/// 刷新页面数据
- (void)reloadView{
    
}
/// 获取表单详情成功
- (void)formDetailResult:(BOOL)success{
    NSLog(@"当前获取的表单详情");
    if (success == YES) {
        if (self.formflowManager.isCloneForm == NO && self.formflowManager.canEditForm == NO) {
            [self.formflowManager cloneCurrentFormByBuddy_file];
        }
    }
}

/// 表单下载成功
- (void)formDownLoadResult:(BOOL)success{
    if (success == YES) {
        NSLog(@"当前的表单数据 %@",self.formflowManager.instanceDownLoadForm);
//        [self.formflowManager cloneCurrentFormByBuddy_file];
    }
}
/// 克隆表单成功
- (void)formCloneTargetResult:(BOOL)success{
    if (success == YES) {
        NSLog(@"克隆表单成功");
    }
}
/// 表单操作完成
- (void)formOperationsFillResult:(BOOL)success{
    
}
/// 表单更新完成
- (void)targetUpdateResult:(BOOL)success{
    NSString *msg = @"";
    if (self.clockOutOrIn == 0) {
        [self.clockInManager goWorkClockInSuccess];
        self.clockInView.clockInTypeView.selectedSegmentIndex = 1;
        [self.clockInView setClockInViewType];
        msg = @"上班打卡成功";
    }else{
        msg = @"下班打卡成功";
    }
    [SZAlert showInfo:msg underTitle:TARGETS_NAME];
}

#pragma mark - private method

- (void)reloadNetwork{
    
    [self.formflowManager downLoadCurrentFormJsonByBuddy_file:self.buddy_file];
}

- (void)closeView{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)clockAction:(UIButton *)button{

    [self getClockInInfor];
    [self.formflowManager operationsFormFill];
}

// 填充当前需要打卡的数据
- (void)getClockInInfor{
    
    ZHUser *user = [DataManager defaultInstance].currentUser;

    // 打卡日期
    NSDictionary *dic = @{@"indexPath":[NSIndexPath indexPathForRow:0 inSection:0],@"value":[SZUtil getYYYYMMDD:[NSDate date] type:1]};
    // 打卡人
    NSDictionary *nameDic = @{@"indexPath":[NSIndexPath indexPathForRow:1 inSection:0],@"value":user.name};
    // 电话
    NSDictionary *phoneDic = @{@"indexPath":[NSIndexPath indexPathForRow:2 inSection:0],@"value":user.phone};
    
    NSInteger index = 3;
    if (self.clockOutOrIn == 1) {
        index = 6;
    }
    
    // 打卡时间
    NSDictionary *timeDic = @{@"indexPath":[NSIndexPath indexPathForRow:index inSection:0],@"value":[SZUtil getYYYYMMDD:[NSDate date] type:2]};
    // 打卡地
    NSDictionary *addressDic = @{@"indexPath":[NSIndexPath indexPathForRow:index+1 inSection:0],@"value":self.address == nil ? @"":self.address};
    // 打卡类型 ,如果地址为空 一致视为外出打卡。
    if ([SZUtil isEmptyOrNull:self.address]) {
        self.clockType = 1;
    }
    NSDictionary *typeDic = @{@"indexPath":[NSIndexPath indexPathForRow:index+2 inSection:0],@"value":self.clockType == NSNotFound ? @"1":[NSString stringWithFormat:@"%ld",(long)self.clockType]};
    NSArray *array = @[dic,nameDic,phoneDic,timeDic,addressDic,typeDic];
    for (NSDictionary *itemDic in array) {
        [self.formflowManager modifyCurrentDownLoadForm:itemDic automatic:YES];
    }
}

#pragma mark - ui

- (void)addUI{
    
    [self.view addSubview:self.bimpmMapView];
    [self.view addSubview:self.clockInView];
    
    [self.bimpmMapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
    }];
    
    [self.clockInView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bimpmMapView.mas_bottom);
        make.height.equalTo(320);
        make.left.right.bottom.equalTo(0);
    }];
}

#pragma mark - setter and getter

- (ClockInView *)clockInView{
    if (_clockInView == nil) {
        _clockInView = [[ClockInView alloc] initWithManager:self.clockInManager];
    }
    return _clockInView;
}

- (UIBarButtonItem *)closeItem{
    if (_closeItem == nil) {
        _closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeView)];
    }
    return _closeItem;
}

- (BimpmMapView *)bimpmMapView{
    if (_bimpmMapView == nil) {
        _bimpmMapView = [[BimpmMapView alloc] initWithFrame:CGRectZero];
    }
    return _bimpmMapView;
}

- (NSMutableDictionary *)clockInDic{
    if (_clockInDic == nil) {
        _clockInDic = [NSMutableDictionary dictionary];
    }
    return _clockInDic;
}

-(FormFlowManager *)formflowManager{
    if (_formflowManager == nil) {
        _formflowManager = [[FormFlowManager alloc] init];
        _formflowManager.delegate = self;
        _formflowManager.buddy_file = self.buddy_file;
    }
    return _formflowManager;
}

- (void)dealloc{
    
}
@end
