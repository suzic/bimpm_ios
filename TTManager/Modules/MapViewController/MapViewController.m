//
//  MapViewController.m
//  TTManager
//
//  Created by chao liu on 2021/1/17.
//

#import "MapViewController.h"

@interface MapViewController ()

//@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view addSubview:self.mapView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"地图定位";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.mapView viewWillAppear];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.mapView viewWillDisappear];
}
//-(BMKMapView *)mapView{
//    if (_mapView == nil) {
//        _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
//        _mapView.delegate = self;
//    }
//    return _mapView;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
