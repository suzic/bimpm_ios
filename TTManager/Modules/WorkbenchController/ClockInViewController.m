//
//  ClockInViewController.m
//  TTManager
//
//  Created by chao liu on 2021/1/17.
//

#import "ClockInViewController.h"
#import "BimpmMapView.h"
#import "ClockInView.h"

@interface ClockInViewController ()<FormFlowManagerDelgate>

@property (nonatomic, strong) BimpmMapView *bimpmMapView;
@property (nonatomic, strong) ClockInView *clockInView;
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
        [self clockAction:nil];
    }
}

#pragma mark - FormFlowManagerDelgate
/// 刷新页面数据
- (void)reloadView{
    
}
/// 获取表单详情成功
- (void)formDetailResult:(BOOL)success{
    
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
        [self getClockInInfor];
        [self.formflowManager operationsFormFill];
    }
}
/// 表单操作完成
- (void)formOperationsFillResult:(BOOL)success{
    
}
/// 表单更新完成
- (void)targetUpdateResult:(BOOL)success{
    [SZAlert showInfo:@"打卡成功" underTitle:TARGETS_NAME];
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
//    [self stopTimer];
//    [self.locationManager stopUpdatingLocation];
}

- (void)clockAction:(UIButton *)button{
#warning 测试暂时注释，不在范围之内也能打卡
//    if (self.clockType == 1) {
//        [SZAlert showInfo:@"不在打卡范围之内" underTitle:TARGETS_NAME];
//        return;
//    }
    if (self.formflowManager.canEditForm == NO) {
        [self.formflowManager cloneCurrentFormByBuddy_file];
    }else{
        [self getClockInInfor];
        [self.formflowManager operationsFormFill];
    }
}

// 填充当前需要打卡的数据
- (void)getClockInInfor{
    
    ZHUser *user = [DataManager defaultInstance].currentUser;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%.0f", timeInterval*1000];

    // 打卡日期
    NSDictionary *dic = @{@"indexPath":[NSIndexPath indexPathForRow:0 inSection:0],@"value":time};
    // 打卡人
    NSDictionary *nameDic = @{@"indexPath":[NSIndexPath indexPathForRow:1 inSection:0],@"value":user.name};
    // 电话
    NSDictionary *phoneDic = @{@"indexPath":[NSIndexPath indexPathForRow:2 inSection:0],@"value":user.phone};
    
    NSInteger index = 3;
    if (self.clockOutOrIn == 1) {
        index = 6;
    }
    
    // 打卡时间
    NSDictionary *timeDic = @{@"indexPath":[NSIndexPath indexPathForRow:index inSection:0],@"value":time};
    // 打卡地
    NSDictionary *addressDic = @{@"indexPath":[NSIndexPath indexPathForRow:index+1 inSection:0],@"value":self.address == nil ? @"":self.address};
    // 打卡类型
    NSDictionary *typeDic = @{@"indexPath":[NSIndexPath indexPathForRow:index+2 inSection:0],@"value":self.clockType == 0 ? @"公司打卡":@"外出打卡"};
    NSArray *array = @[dic,nameDic,phoneDic,timeDic,addressDic,typeDic];
    for (NSDictionary *itemDic in array) {
        [self.formflowManager modifyCurrentDownLoadForm:itemDic];
    }
}

#pragma mark - ui

- (void)addUI{
    
//    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.bimpmMapView];
    [self.view addSubview:self.clockInView];
    
    [self.bimpmMapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(500);
    }];
    
    [self.clockInView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bimpmMapView.mas_bottom);
        make.left.right.bottom.equalTo(0);
    }];
    
//    [self.view addSubview:self.userView];
//    [self.userView addSubview:self.userImageView];
//    [self.userView addSubview:self.userName];
//    
//    [self.view addSubview:self.clockBgView];
//    [self.clockBgView addSubview:self.changClockType];
//    [self.clockBgView addSubview:self.clockInfo];
//    [self.clockBgView addSubview:self.clockBtn];
//    [self.clockBgView addSubview:self.clockTime];
//    
//    
//    
//    [self.userView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(500);
//        make.left.equalTo(16);
//        make.right.equalTo(-16);
//        make.height.equalTo(120);
//    }];
//    
//    [self.userImageView makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(60);
//        make.left.equalTo(16);
//        make.centerY.equalTo(self.userView.mas_centerY);
//    }];
//    
//    [self.userName makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.userImageView.mas_right).offset(16);
//        make.centerY.equalTo(self.userImageView.mas_centerY);
//    }];
//    
//    [self.clockBgView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.userView.mas_bottom).offset(16);
//        make.left.equalTo(16);
//        make.right.bottom.equalTo(-16);
//    }];
//    [self.changClockType makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(16);
//        make.width.equalTo(self.clockBgView.mas_width).multipliedBy(0.5);
//        make.centerX.equalTo(self.clockBgView.mas_centerX);
//    }];
//    
//    [self.clockInfo makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(0);
//        make.top.equalTo(200);
//    }];
//    [self.clockBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.clockInfo.mas_bottom).offset(10);
//        make.width.height.equalTo(self.clockBgView.mas_width).multipliedBy(0.5);
//        make.centerX.equalTo(self.clockBgView);
//    }];
//    [self.clockTime makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(0);
//        make.top.equalTo(self.clockBtn.mas_bottom).offset(10);
//    }];
}

#pragma mark - setter and getter

- (ClockInView *)clockInView{
    if (_clockInView == nil) {
        _clockInView = [[ClockInView alloc] init];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
