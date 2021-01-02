//
//  DocumentLibController.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "DocumentLibController.h"
#import "DocumentLibCell.h"
#import "FileCatalogCell.h"
#import "FileListView.h"

@interface DocumentLibController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *fileCatalogCollectionView;
@property (weak, nonatomic) IBOutlet UIView *fileContainerView;
@property (nonatomic, strong)FileListView *fileView;
@end

@implementation DocumentLibController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowHeaderView object:@(YES)];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowHeaderView object:@(NO)];
}

- (void)loadFileCatalogCollectionView{
    [self.fileCatalogCollectionView reloadData];
}
//#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fileView.navigationController.viewControllers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FileCatalogCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"titleCell" forIndexPath:indexPath];
    UIViewController *vc = self.fileView.navigationController.viewControllers[indexPath.row];
    NSString *titleName = [NSString stringWithFormat:@"目录%@",vc.title];
    cell.fileName.text = titleName;
    cell.arrow.hidden = self.fileView.navigationController.viewControllers.count == (indexPath.row + 1);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleName = [NSString stringWithFormat:@"目录%lu",indexPath.row];
    CGRect frame = [titleName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] context:nil];
    return CGSizeMake(frame.size.width + 15 + 5, 64);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = self.fileView.navigationController.viewControllers[indexPath.row];
    [self.fileView.navigationController popToViewController:vc animated:YES];
//    DocumentLibController *vc = (DocumentLibController *)self.navigationController.viewControllers[indexPath.row];
////    NSRange subRang = NSMakeRange(0, indexPath.row+1);
////    self.documentTitleArray = [NSMutableArray arrayWithArray:[self.documentTitleArray subarrayWithRange:subRang]];
//    vc.documentTitleArray = self.documentTitleArray;
//    [self.navigationController popToViewController:vc animated:YES];
}
//- (void)goNext{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//   animation.duration = 2;
//   animation.repeatCount = 2;
//   animation.beginTime =CACurrentMediaTime() + 1;// 1秒后执行
//   animation.fromValue = [NSValue valueWithCGPoint:self.tableView.layer.position]; // 起始帧
//   animation.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth, 0)]; // 终了帧
//   // 视图添加动画
//   [self.tableView.layer addAnimation:animation forKey:@"move-layer"];
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showFileList"]) {
        UINavigationController *nav = (UINavigationController *)[segue destinationViewController];
        self.fileView = (FileListView *)nav.topViewController;
        self.fileView.containerVC = self;
    }
}

@end
