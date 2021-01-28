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
#import "UploadFileManager.h"

@interface DocumentLibController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *fileCatalogCollectionView;
@property (weak, nonatomic) IBOutlet UIView *fileContainerView;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;

@property (nonatomic, strong) UploadFileManager *uploadManager;
@property (nonatomic, strong) FileListView *rootFileView;
@property (nonatomic, strong) DragButton *dragBtn;
@end

@implementation DocumentLibController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"文件库";
    // 初始化相机，要不会有两秒延迟
    [self initializeImagePicker];
    self.actionSheetType = 2;
    self.dragBtn = [DragButton initDragButtonVC:self];
    self.dragBtn.hidden = YES;
    [self.dragBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(-15);
        make.width.height.equalTo(49);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoladNetwork) name:NotiReloadHomeView object:nil];
}
- (void)reoladNetwork{
    [self.rootFileView.navigationController popToRootViewControllerAnimated:YES];
    self.rootFileView.title = @"目录";
    [self.rootFileView reoladNetwork];
}

- (void)loadFileCatalogCollectionView{
    [self.fileCatalogCollectionView reloadData];
    
    if (self.rootFileView.navigationController.viewControllers.count == 1) {
        self.dragBtn.hidden = YES;
        [self.previousButton setImage:[UIImage imageNamed:@"document_lid_back_normal"] forState:UIControlStateNormal];
        self.actionSheetType = 2;
//        self.previousButton.enabled = NO;
    }else if (self.rootFileView.navigationController.viewControllers.count >= 6) {
        self.actionSheetType = 3;
        self.dragBtn.hidden = NO;
        [self.previousButton setImage:[UIImage imageNamed:@"document_lid_back"] forState:UIControlStateNormal];
//        self.previousButton.enabled = YES;
    }else{
        [self.previousButton setImage:[UIImage imageNamed:@"document_lid_back"] forState:UIControlStateNormal];
//        self.previousButton.enabled = YES;
        self.actionSheetType = 2;
        self.dragBtn.hidden = NO;
    }
}
- (void)fileViewListEmpty:(BOOL)empty{
    if (self.rootFileView.navigationController.viewControllers.count <=1)
        self.fileCatalogCollectionView.hidden = empty;
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.rootFileView.navigationController.viewControllers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FileCatalogCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"titleCell" forIndexPath:indexPath];
    UIViewController *vc = self.rootFileView.navigationController.viewControllers[indexPath.row];
//    NSString *titleName = [NSString stringWithFormat:@"目录%@",vc.title];
    cell.fileName.text = vc.title;
    cell.arrow.hidden = self.rootFileView.navigationController.viewControllers.count == (indexPath.row + 1);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = self.rootFileView.navigationController.viewControllers[indexPath.row];
    NSString *titleName = vc.title;
    CGRect frame = [titleName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] context:nil];
    return CGSizeMake(frame.size.width + 15 + 5, 64);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = self.rootFileView.navigationController.viewControllers[indexPath.row];
    [self.rootFileView.containerVC loadFileCatalogCollectionView];
    [self.rootFileView.navigationController popToViewController:vc animated:YES];
}
#pragma mark - responder chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if([eventName isEqualToString:new_task_action]){
        [self pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image,NSString * _Nonnull mediaType) {
            NSLog(@"打开相册");

            [self showNewFileView:0 data:imageData];
        }];
    }else if([eventName isEqualToString:target_new_file_group]){

        [self showNewFileView:1 data:nil];
    }
}
- (IBAction)previousButtonAction:(id)sender {
    if (self.rootFileView.navigationController.viewControllers.count >1) {
        [self.rootFileView.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - private
- (void)showNewFileView:(NSInteger)type data:(NSData *)data{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入文件名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSString *fileName = alertController.textFields[0].text;
        if ([SZUtil isEmptyOrNull:fileName]) {
            [CNAlertView showWithTitle:@"文件名不能为空" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self showNewFileView:type data:data];
                }
            }];
            return;
        }
        if (type == 1) {
            [self newFileGroup:fileName];
        }else if(type == 0){
            [self uploadImage:data fileName:fileName];
        }
        
    }]];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新建文件名称";
        textField.delegate = self;
    }];
    [self presentViewController:alertController animated:true completion:nil];
}
- (void)newFileGroup:(NSString *)groupName{
    if ([SZUtil isEmptyOrNull:groupName]) {
        [SZAlert showInfo:@"请填写文件名称" underTitle:TARGETS_NAME];
        return;
    }
    [self.uploadManager newFileGroupWithGroupName:groupName target:@{@"id_module":self.fileView.id_module,@"fid_parent":self.fileView.uid_parent,@"uid_target":@"",}];
    [self uploadSuccess];
}

- (void)uploadImage:(NSData *)imageData fileName:(NSString *)fileName{
    if (imageData == nil) {
        [SZAlert showInfo:@"请选择图片后重试" underTitle:TARGETS_NAME];
        return;
    }
    [self.uploadManager uploadFile:imageData fileName:fileName target:@{@"id_module":self.fileView.id_module,@"fid_parent":self.fileView.uid_parent,@"uid_target":self.fileView.uid_parent}];
    [self uploadSuccess];
    
}
- (void)uploadSuccess{
    __weak typeof(self) weakSelf = self;
    self.uploadManager.uploadResult = ^(BOOL success, NSDictionary * _Nonnull targetInfo, NSString * _Nonnull id_file) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success == YES) {
            [strongSelf.fileView reoladNetwork];
        }
    };
}
#pragma mark - setter and getter
- (UploadFileManager *)uploadManager{
    if (_uploadManager == nil) {
        _uploadManager = [[UploadFileManager alloc] init];
    }
    return _uploadManager;
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
        self.rootFileView = self.fileView;
        self.fileView.chooseTargetFile = self.chooseTargetFile;
    }
}

@end
