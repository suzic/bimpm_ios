//
//  BimpmMapView.m
//  TTManager
//
//  Created by chao liu on 2021/2/23.
//

#import "BimpmMapView.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface BimpmMapView ()<BMKLocationAuthDelegate,BMKLocationManagerDelegate,BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
// location
@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic, strong) CLLocationManager *cllocationManager;

@end

@implementation BimpmMapView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaiduMap];
        [self addUI];
    }
    return self;
}

- (void)addUI{
    [self addSubview:self.mapView];
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(0);
    }];
}

- (void)initBaiduMap{
    // 要使用百度地图，请先启动BaiduMapManager
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [mapManager start:BaiduKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"启动引擎失败");
    }
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiduKey authDelegate:self];
}

#pragma mark - public

- (void)bimpmMapViewWillAppear{
    [_mapView viewWillAppear];

}

- (void)bimpmMapViewWillDisappear{
    [_mapView viewWillDisappear];
}

#pragma mark - BMKLocationAuthDelegate

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    if (iError == BMKLocationAuthErrorSuccess) {
        if ([SZUtil isAllowLocationService] == NO) {
            [self openLocationSetting];
        }
        [self.cllocationManager startUpdatingLocation];
        [self.locationManager setLocatingWithReGeocode:YES];
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
    }else{
        
    }
}

#pragma mark - BMKLocationManagerDelegate

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error{
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        [SZAlert showInfo:error.localizedDescription underTitle:TARGETS_NAME];
    }else{
        [self distanceCurrentLocation:location];
    }
    if (!location) {
        return;
    }
    if (!self.userLocation) {
        self.userLocation = [[BMKUserLocation alloc] init];
    }
    self.userLocation.location = location.location;
    [self.mapView updateLocationData:self.userLocation];
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error{
    NSLog(@"定位错误");
    [SZAlert showInfo:error.localizedDescription underTitle:TARGETS_NAME];
}

// 定位SDK中，方向变更的回调
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
    return;
    }
    if (!self.userLocation) {
    self.userLocation = [[BMKUserLocation alloc] init];
    }
    self.userLocation.heading = heading;
    [self.mapView updateLocationData:self.userLocation];
}

- (void)distanceCurrentLocation:(BMKLocation *)location{
    ZHProject *project = [DataManager defaultInstance].currentProject;
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(location.location.coordinate.latitude,location.location.coordinate.longitude));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(project.location_lat,project.location_long));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    NSString *clockType = @"";
    if (distance <= 1000) {
        clockType = @"0";
    }else{
        clockType = @"1";
    }
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",location.rgcData.province,location.rgcData.city,location.rgcData.district,location.rgcData.street];
    NSLog(@"当前所处位置信息%@",address);
    [self routerEventWithName:punch_card_distance userInfo:@{@"type":clockType,@"address":address,@"distance":[NSString stringWithFormat:@"%.2lf",distance]}];
}
- (void)openLocationSetting
{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位,以便于获取打卡位置信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            }];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [[AppDelegate sharedDelegate].window.rootViewController presentViewController:alert animated:YES completion:nil];
}
#pragma mark - setter and getter

- (BMKMapView *)mapView{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectZero];
        _mapView.delegate = self;
        _mapView.zoomLevel = 15.0f;
        _mapView.showMapScaleBar = YES;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    }
    return _mapView;
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
- (CLLocationManager *)cllocationManager{
    if (!_cllocationManager) {
        _cllocationManager = [[CLLocationManager alloc] init];
        _cllocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _cllocationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
        [_cllocationManager requestWhenInUseAuthorization];
    }
    return _cllocationManager;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
