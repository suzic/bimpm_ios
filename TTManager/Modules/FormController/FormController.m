//
//  FormController.m
//  TTManager
//
//  Created by chao liu on 2021/1/19.
//

#import "FormController.h"
#import "FormItemViewCell.h"
#import "FormTitleView.h"

static NSString *reuseIdentifier = @"formItemViewCell";
static NSString *footerIdentifier = @"FooterIdentifier";
static NSString *headerIdentifier = @"headerIdentifier";

@interface FormController ()<UICollectionViewDelegate,UICollectionViewDataSource,ApiManagerCallBackDelegate,APIManagerParamSource>

@property (nonatomic, strong) UICollectionView *formCollectionView;
@property (nonatomic, strong) NSMutableArray *formItemsArray;

@property (nonatomic, strong) APIFormDetailManager *formDetailManager;
@property (nonatomic, strong) ZHForm *currentFrom;

@end

@implementation FormController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"表单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addUI];
    [self setUpLongPressGes];
    
    [self loadNetWork];
}
- (void)loadNetWork{
    
    [self.formDetailManager loadData];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.formItemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FormItemViewCell *cell = (FormItemViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.formItem = self.formItemsArray[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth, ItemRowHeight*3 + ItemRowHeight/3*2+10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, ItemRowHeight*5+20+ItemRowHeight/3*2*2);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        FormTitleView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        titleView.currentFrom = self.currentFrom;
        reusableView = titleView;
    }
    return reusableView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.formItemsArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

#pragma mark - 添加长按手势
- (void)setUpLongPressGes {
    UILongPressGestureRecognizer *longPresssGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    [self.formCollectionView addGestureRecognizer:longPresssGes];
}
- (void)longPressMethod:(UILongPressGestureRecognizer *)longPressGes {
    // 判断手势状态
    switch (longPressGes.state) {
        case UIGestureRecognizerStateBegan: {
            // 判断手势落点位置是否在路径上(长按cell时,显示对应cell的位置,如path = 1 - 0,即表示长按的是第1组第0个cell). 点击除了cell的其他地方皆显示为null
            NSIndexPath *indexPath = [self.formCollectionView indexPathForItemAtPoint:[longPressGes locationInView:self.formCollectionView]];
            // 如果点击的位置不是cell,break
            if (nil == indexPath) {
                break;
            }
            NSLog(@"%@",indexPath);
            // 在路径上则开始移动该路径上的cell
            [self.formCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            // 移动过程当中随时更新cell位置
            [self.formCollectionView updateInteractiveMovementTargetPosition:[longPressGes locationInView:self.formCollectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            // 移动结束后关闭cell移动
            [self.formCollectionView endInteractiveMovement];
            break;
        default:
            [self.formCollectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark - private

- (void)getFormItemInfo{
    [self.formItemsArray removeAllObjects];
    NSArray *array = [self.currentFrom.hasItems allObjects];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"order_index" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    [self.formItemsArray addObjectsFromArray:[array sortedArrayUsingDescriptors:sortDescriptors]];
}

#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager{
    NSDictionary *params = @{};
    if (manager == self.formDetailManager) {
        params = @{@"uid_form":self.uid_form,
                   @"uid_ident":self.uid_ident,
                   @"buddy_file":self.buddy_file};
    }
    return params;
}
#pragma mark - ApiManagerCallBackDelegate
- (void)managerCallAPISuccess:(BaseApiManager *)manager{
    if (manager == self.formDetailManager) {
        self.currentFrom = (ZHForm *)manager.response.responseData;
        [self getFormItemInfo];
        [self.formCollectionView reloadData];
    }
}
- (void)managerCallAPIFailed:(BaseApiManager *)manager{
    if (manager == self.formDetailManager) {
        
    }
}
#pragma mark - UI
- (void)addUI{
    [self.view addSubview:self.formCollectionView];
    [self.formCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
}
#pragma mark - setter and getter
- (NSMutableArray *)formItemsArray{
    if (_formItemsArray == nil) {
        _formItemsArray = [NSMutableArray array];
    }
    return _formItemsArray;
}
- (UICollectionView *)formCollectionView{
    if (_formCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
      
        _formCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _formCollectionView.dataSource = self;
        _formCollectionView.delegate = self;
        _formCollectionView.showsHorizontalScrollIndicator = NO;
        _formCollectionView.showsVerticalScrollIndicator = NO;
        _formCollectionView.bounces = NO;
        _formCollectionView.backgroundColor = [UIColor whiteColor];
        [_formCollectionView registerClass:[FormItemViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_formCollectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
        [_formCollectionView registerClass:[FormTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _formCollectionView;
}
- (APIFormDetailManager *)formDetailManager{
    if (_formDetailManager == nil) {
        _formDetailManager = [[APIFormDetailManager alloc] init];
        _formDetailManager.delegate = self;
        _formDetailManager.paramSource = self;
    }
    return _formDetailManager;
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
