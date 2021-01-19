//
//  FormController.m
//  TTManager
//
//  Created by chao liu on 2021/1/19.
//

#import "FormController.h"
#import "FormItemViewCell.h"

static NSString *reuseIdentifier = @"formItemViewCell";
static NSString *footerIdentifier = @"FooterIdentifier";
static NSString *headerIdentifier = @"headerIdentifier";

@interface FormController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *formCollectionView;
@property (nonatomic, strong) NSMutableArray *formItemsArray;

@end

@implementation FormController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUI];
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
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth, 150);
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
        _formItemsArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }
    return _formItemsArray;
}
- (UICollectionView *)formCollectionView{
    if (_formCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      
        _formCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _formCollectionView.dataSource = self;
        _formCollectionView.delegate = self;
        _formCollectionView.showsHorizontalScrollIndicator = NO;
        _formCollectionView.showsVerticalScrollIndicator = NO;
        _formCollectionView.bounces = NO;
        [_formCollectionView registerClass:[FormItemViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_formCollectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
        [_formCollectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _formCollectionView;
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