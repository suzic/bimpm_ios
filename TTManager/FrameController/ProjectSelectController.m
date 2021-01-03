//
//  ProjectSelectController.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "ProjectSelectController.h"
#import "ProjectViewCell.h"

@interface ProjectSelectController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,APIManagerParamSource,ApiManagerCallBackDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *projectCollectionView;
@property (nonatomic, strong) NSMutableArray *projectList;
// api
@property (nonatomic, strong)APIUTPListManager *UTPlistManager;
@end

@implementation ProjectSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *))
        self.projectCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    else
        self.automaticallyAdjustsScrollViewInsets = NO;

}
#pragma mark - setter and getter
- (NSMutableArray *)projectList{
    _projectList = [DataManager defaultInstance].currentProjectList;
    return _projectList;
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.projectList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProjectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"projectIdentifler" forIndexPath:indexPath];
    ZHProject *project = self.projectList[indexPath.row];
    [cell.projectImage sd_setImageWithURL:[NSURL URLWithString:project.snap_image] placeholderImage:[UIImage imageNamed:@"empty_image"]];
    NSLog(@"参与的项目列表=====%@",project.snap_image);
    cell.projectName.text = project.name;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-15)/2, 300.0f);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self routerEventWithName:selectedProject userInfo:@{@"currentProject":self.projectList[indexPath.row]}];
}
#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *dic = @{};
    if (manager == self.UTPlistManager) {
        
    }
    return dic;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.UTPlistManager) {
        
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.UTPlistManager) {
        
    }
}
#pragma mark - setter and getter
- (APIUTPListManager *)UTPlistManager{
    if (_UTPlistManager == nil) {
        _UTPlistManager = [[APIUTPListManager alloc] init];
        _UTPlistManager.delegate = self;
        _UTPlistManager.paramSource = self;
    }
    return _UTPlistManager;
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
