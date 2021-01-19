//
//  MapViewController.m
//  TTManager
//
//  Created by chao liu on 2021/1/17.
//

#import "MapViewController.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#define BaiduKey  @"b8APw3ryF03YG2kwU35T9wuQ8nKaN4pc"

@interface MapViewController ()<BMKLocationAuthDelegate,BMKLocationManagerDelegate>

//@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) UIView *clockBgView;
@property (nonatomic, strong) UILabel *clockInfo;
@property (nonatomic, strong) UIButton *clockBtn;
@property (nonatomic, strong) UILabel *clockTime;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@property (nonatomic, strong) NSTimer *timer;

// location
@property (nonatomic, strong)BMKLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view addSubview:self.mapView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"打卡";
    self.navigationItem.leftBarButtonItem = self.closeItem;
    
    [self addUI];
    [self addTimer];
    
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiduKey authDelegate:self];
    
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
#pragma mark - private method
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
    [self dismissViewControllerAnimated:YES completion:nil];
    [self stopTimer];
    [self.locationManager stopUpdatingLocation];
}
- (void)clockAction:(UIButton *)button{
    [SZAlert showInfo:@"点击了打卡" underTitle:TARGETS_NAME];
}
#pragma mark - ui
- (void)addUI{
    [self.view addSubview:self.clockBgView];
    [self.clockBgView addSubview:self.clockInfo];
    [self.clockBgView addSubview:self.clockBtn];
    [self.clockBgView addSubview:self.clockTime];
    
    [self.clockBgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-100);
        make.width.height.equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    [self.clockInfo makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(10);
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
    }
    return _clockBgView;
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
        _clockBtn.layer.cornerRadius = kScreenWidth/8;
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
