//
//  ClockInViewController.m
//  TTManager
//
//  Created by chao liu on 2021/1/17.
//

#import "ClockInViewController.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface ClockInViewController ()<BMKLocationAuthDelegate,BMKLocationManagerDelegate,FormFlowManagerDelgate>


//@property (nonatomic, strong) BMKMapView *mapView;

/// 打卡类型 0 公司打卡 1 外出打卡
@property (nonatomic, assign) NSInteger clockType;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userName;

@property (nonatomic, strong) UIView *clockBgView;
@property (nonatomic, strong) UIButton *changClockType;

@property (nonatomic, strong) UILabel *clockInfo;
@property (nonatomic, strong) UIButton *clockBtn;
@property (nonatomic, strong) UILabel *clockTime;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableDictionary *clockInDic;

@property (nonatomic, strong) FormFlowManager *formflowManager;

// location
@property (nonatomic, strong) BMKLocationManager *locationManager;

@end

@implementation ClockInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view addSubview:self.mapView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"日常打卡";
    self.navigationItem.leftBarButtonItem = self.closeItem;
    
    [self addUI];
    [self addTimer];
        
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiduKey authDelegate:self];
    
    [self reloadNetwork];
}

#pragma mark - BMKLocationAuthDelegate

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    if (iError == BMKLocationAuthErrorSuccess) {
        [self.locationManager setLocatingWithReGeocode:YES];
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - BMKLocationManagerDelegate

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error{
    if (error) {
        [SZAlert showInfo:error.localizedDescription underTitle:TARGETS_NAME];
    }else{
        NSLog(@"定位成功");
        [self distanceCurrentLocation:location];
    }
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error{
    NSLog(@"定位错误");
    [SZAlert showInfo:error.localizedDescription underTitle:TARGETS_NAME];
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

// 切换打卡类型
- (void)changeClockTypeAction:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择打卡类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *type1 = [UIAlertAction actionWithTitle:@"上班打卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.changClockType setTitle:@"上班打卡" forState:UIControlStateNormal];
    }];
    UIAlertAction *type2 = [UIAlertAction actionWithTitle:@"下班打卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.changClockType setTitle:@"下班打卡" forState:UIControlStateNormal];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:type1];
    [alert addAction:type2];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)reloadNetwork{
    
    [self.formflowManager downLoadCurrentFormJsonByBuddy_file:self.buddy_file];
    ZHUser *user = [DataManager defaultInstance].currentUser;
    self.userName.text = user.name;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"test-1"]];
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSString *type = (components.hour < 12 ? @"上班打卡" : @"下班打卡");
    [self.changClockType setTitle:type forState:UIControlStateNormal];
}

- (void)addTimer{
    if (self.timer == nil) {
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)distanceCurrentLocation:(BMKLocation *)location{
    ZHProject *project = [DataManager defaultInstance].currentProject;
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(location.location.coordinate.latitude,location.location.coordinate.longitude));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(project.location_lat,project.location_long));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    self.clockInfo.text = [NSString stringWithFormat:@"当前距离项目组%.2lf米",distance];
    if (distance <= 1000) {
        self.clockType = 0;
    }else{
        self.clockType = 1;
    }
    
    self.address = [NSString stringWithFormat:@"%@%@%@%@%@",location.rgcData.province,location.rgcData.city,location.rgcData.district,location.rgcData.town,location.rgcData.street];
    NSLog(@"当前所处位置信息%@",self.address);
}

- (void)stopTimer{
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateTime{
    self.clockTime.text = [SZUtil getTimeNow];
}

- (void)closeView{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self stopTimer];
    [self.locationManager stopUpdatingLocation];
}

- (void)clockAction:(UIButton *)button{
    
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
    if ([self.changClockType.currentTitle isEqualToString:@"下班打卡"]) {
        index = 6;
    }
    
    // 打卡时间
    NSDictionary *timeDic = @{@"indexPath":[NSIndexPath indexPathForRow:index inSection:0],@"value":time};
    // 打卡地
    NSDictionary *addressDic = @{@"indexPath":[NSIndexPath indexPathForRow:index+1 inSection:0],@"value":self.address};
    // 打卡类型
    NSDictionary *typeDic = @{@"indexPath":[NSIndexPath indexPathForRow:index+2 inSection:0],@"value":self.clockType == 0 ?@"公司打卡":@"外出打卡"};
    NSArray *array = @[dic,nameDic,phoneDic,timeDic,addressDic,typeDic];
    for (NSDictionary *itemDic in array) {
        [self.formflowManager modifyCurrentDownLoadForm:itemDic];
    }
}

#pragma mark - ui

- (void)addUI{
    [self.view addSubview:self.userView];
    [self.userView addSubview:self.userImageView];
    [self.userView addSubview:self.userName];
    
    [self.view addSubview:self.clockBgView];
    [self.clockBgView addSubview:self.changClockType];
    [self.clockBgView addSubview:self.clockInfo];
    [self.clockBgView addSubview:self.clockBtn];
    [self.clockBgView addSubview:self.clockTime];
    
    [self.userView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(120);
    }];
    
    [self.userImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(60);
        make.left.equalTo(16);
        make.centerY.equalTo(self.userView.mas_centerY);
    }];
    
    [self.userName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(16);
        make.centerY.equalTo(self.userImageView.mas_centerY);
    }];
    
    [self.clockBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userView.mas_bottom).offset(16);
        make.left.equalTo(16);
        make.right.bottom.equalTo(-16);
    }];
    [self.changClockType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(16);
        make.width.equalTo(self.clockBgView.mas_width).multipliedBy(0.5);
        make.centerX.equalTo(self.clockBgView.mas_centerX);
    }];
    
    [self.clockInfo makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(200);
    }];
    [self.clockBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clockInfo.mas_bottom).offset(10);
        make.width.height.equalTo(self.clockBgView.mas_width).multipliedBy(0.5);
        make.centerX.equalTo(self.clockBgView);
    }];
    [self.clockTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.clockBtn.mas_bottom).offset(10);
    }];
}

#pragma mark - setter and getter

- (UIView *)clockBgView{
    if (_clockBgView == nil) {
        _clockBgView = [[UIView alloc] init];
        _clockBgView.backgroundColor = [UIColor whiteColor];
        _clockBgView.layer.cornerRadius = 8.0f;
    }
    return _clockBgView;
}
- (UIView *)userView{
    if (_userView == nil) {
        _userView = [[UIView alloc] init];
        _userView.backgroundColor = [UIColor whiteColor];
        _userView.layer.cornerRadius = 8.0f;
    }
    return _userView;
}
- (UIImageView *)userImageView{
    if (_userImageView == nil) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.image = [UIImage imageNamed:@"test-1"];
    }
    return _userImageView;
}
- (UILabel *)userName{
    if (_userName == nil) {
        _userName = [[UILabel alloc] init];
        _userName.font = [UIFont systemFontOfSize:15.0f];
        _userName.text = @"刘超";
    }
    return _userName;
}
- (UIButton *)changClockType{
    if (_changClockType == nil) {
        _changClockType = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changClockType setImage:[UIImage imageNamed:@"button_ down"] forState:UIControlStateNormal];
        [_changClockType setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_changClockType addTarget:self action:@selector(changeClockTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        _changClockType.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_changClockType setTitle:@"上班打卡" forState:UIControlStateNormal];
        [_changClockType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _changClockType;
}
- (UILabel *)clockInfo{
    if (_clockInfo == nil) {
        _clockInfo = [[UILabel alloc] init];
        _clockInfo.textAlignment = NSTextAlignmentCenter;
        _clockInfo.numberOfLines = 0;
        _clockInfo.text = @"当前距离项目组1000米,属于项目外打卡";
    }
    return _clockInfo;
}

- (UIButton *)clockBtn{
    if (_clockBtn == nil) {
        _clockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clockBtn setTitle:@"打卡" forState:UIControlStateNormal];
        [_clockBtn setBackgroundColor:[UIColor orangeColor]];
        _clockBtn.clipsToBounds = YES;
        [_clockBtn addTarget:self action:@selector(clockAction:) forControlEvents:UIControlEventTouchUpInside];
        _clockBtn.layer.cornerRadius = (kScreenWidth-32)/4;
    }
    return _clockBtn;
}

- (UILabel *)clockTime{
    if (_clockTime == nil) {
        _clockTime = [[UILabel alloc] init];
        _clockTime.textAlignment = NSTextAlignmentCenter;
        _clockTime.text = [SZUtil getTimeNow];
    }
    return _clockTime;
}

- (UIBarButtonItem *)closeItem{
    if (_closeItem == nil) {
        _closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeView)];
    }
    return _closeItem;
}

- (BMKLocationManager *)locationManager{
    if (_locationManager == nil) {
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
//        _locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 8;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 8;
    }
    return _locationManager;
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
