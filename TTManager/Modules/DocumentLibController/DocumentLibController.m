//
//  DocumentLibController.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "DocumentLibController.h"
#import "DocumentLibCell.h"
#import "FileCatalogCell.h"

@interface DocumentLibController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *fileCatalogCollectionView;

@end

@implementation DocumentLibController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.documentTitleArray = [NSMutableArray arrayWithArray:[self.documentTitleArray subarrayWithRange:NSMakeRange(0, self.navigationController.viewControllers.count)]];
    NSLog(@"当前文件目录%@---------%ld",self.documentTitleArray,self.navigationController.viewControllers.count);
}

#pragma mark -setter and getter
- (NSMutableArray *)documentTitleArray{
    if (_documentTitleArray == nil) {
        _documentTitleArray = [NSMutableArray arrayWithArray:@[@"文档"]];
    }
    return _documentTitleArray;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DocumentLibCell *cell = [tableView dequeueReusableCellWithIdentifier:@"documentLibCell" forIndexPath:indexPath];
    cell.documentIcon.image = [UIImage imageNamed:@"file_group"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DocumentLibController *VC = (DocumentLibController *)[sb instantiateViewControllerWithIdentifier:@"documentList"];
    [self.documentTitleArray addObject:[NSString stringWithFormat:@"%lu",self.navigationController.viewControllers.count]];
    VC.documentTitleArray = self.documentTitleArray;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.documentTitleArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FileCatalogCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"titleCell" forIndexPath:indexPath];
    NSString *fileName = self.documentTitleArray[indexPath.row];
    cell.fileName.text = fileName;
    cell.arrow.hidden = self.documentTitleArray.count == (indexPath.row + 1);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleName = [NSString stringWithFormat:@"目录%lu",indexPath.row];
    CGRect frame = [titleName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] context:nil];
    return CGSizeMake(frame.size.width + 15 + 5, 64);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DocumentLibController *vc = (DocumentLibController *)self.navigationController.viewControllers[indexPath.row];
//    NSRange subRang = NSMakeRange(0, indexPath.row+1);
//    self.documentTitleArray = [NSMutableArray arrayWithArray:[self.documentTitleArray subarrayWithRange:subRang]];
    vc.documentTitleArray = self.documentTitleArray;
    [self.navigationController popToViewController:vc animated:YES];
}
- (void)goNext{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
   animation.duration = 2;
   animation.repeatCount = 2;
   animation.beginTime =CACurrentMediaTime() + 1;// 1秒后执行
   animation.fromValue = [NSValue valueWithCGPoint:self.tableView.layer.position]; // 起始帧
   animation.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth, 0)]; // 终了帧
   // 视图添加动画
   [self.tableView.layer addAnimation:animation forKey:@"move-layer"];
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
