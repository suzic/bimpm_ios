//
//  MonitoringController.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "MonitoringController.h"
#import "ProjectViewCell.h"
#import "WebController.h"
//#import "FrameNavView.h"

@interface MonitoringController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (nonatomic, strong)FrameNavView *headerView;
@end

@implementation MonitoringController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.titleView = self.headerView;
//    [self.view addSubview:self.headerView];
    
    if (@available(iOS 11.0, *))
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    else
        self.automaticallyAdjustsScrollViewInsets = NO;
}
//- (FrameNavView *)headerView
//{
//    if (_headerView == nil) {
//        _headerView = [FrameNavView initFrameNavView];
//        _headerView.frame = CGRectMake(0, 0, kScreenWidth, SafeAreaTopHeight);
//        _headerView.delegate = self;
//    }
//    return _headerView;
//}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProjectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"projectIdentifler" forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-15)/3, 300.0f);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WebController *webVC = [[WebController alloc] init];
    webVC.loadUrl = @"http://www.baidu.com";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

/*
#pragma mark - Navaigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
