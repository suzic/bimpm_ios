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
#import "DragButton.h"

@interface DocumentLibController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *fileCatalogCollectionView;
@property (weak, nonatomic) IBOutlet UIView *fileContainerView;
@property (nonatomic, strong)FileListView *fileView;

@end

@implementation DocumentLibController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件库";
    // 初始化相机，要不会有两秒延迟
    [self initializeImagePicker];
    self.actionSheetType = 2;
    DragButton *dragBtn = [DragButton initDragButtonVC:self];
    [dragBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(-15);
        make.width.height.equalTo(49);
    }];
}

- (void)loadFileCatalogCollectionView{
    [self.fileCatalogCollectionView reloadData];
}
- (void)fileViewListEmpty:(BOOL)empty{
    if (self.fileView.navigationController.viewControllers.count <=1)
        self.fileCatalogCollectionView.hidden = empty;
}
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
//    NSString *titleName = [NSString stringWithFormat:@"目录%@",vc.title];
    cell.fileName.text = vc.title;
    cell.arrow.hidden = self.fileView.navigationController.viewControllers.count == (indexPath.row + 1);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = self.fileView.navigationController.viewControllers[indexPath.row];
    NSString *titleName = vc.title;
    CGRect frame = [titleName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] context:nil];
    return CGSizeMake(frame.size.width + 15 + 5, 64);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = self.fileView.navigationController.viewControllers[indexPath.row];
    [self.fileView.containerVC loadFileCatalogCollectionView];
    [self.fileView.navigationController popToViewController:vc animated:YES];
}
#pragma mark - responder chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if([eventName isEqualToString:new_task_action]){
        [self pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
            NSLog(@"打开相册");
        }];
    }else if([eventName isEqualToString:target_new_file_group]){
        [self showNewFileGroupView];
    }
}
#pragma mark - private
- (void)showNewFileGroupView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入文件夹名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSString *fileName = alertController.textFields[0].text;
        [SZAlert showInfo:fileName underTitle:@"众和空间"];

    }]];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新建文件夹名称";
        textField.delegate = self;
    }];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showFileList"]) {
        UINavigationController *nav = (UINavigationController *)[segue destinationViewController];
        self.fileView = (FileListView *)nav.topViewController;
        self.fileView.title = @"目录";
        self.fileView.containerVC = self;
        self.fileView.uid_parent = [NSNull null];
        self.fileView.id_module = @"0";
    }
}

@end
