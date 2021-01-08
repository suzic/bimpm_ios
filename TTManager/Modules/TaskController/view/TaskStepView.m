//
//  TaskStepView.m
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import "TaskStepView.h"
#import "TaskStepCell.h"
#import "StepUserView.h"
#import "TaskStepFooterView.h"
#import "SupernatantView.h"

static NSString *reuseIdentifier = @"StepCell";
static NSString *footerIdentifier = @"FooterIdentifier";

@interface TaskStepView ()<UICollectionViewDelegate,UICollectionViewDataSource>
// 中间步骤
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SupernatantView  *supernatantView;
// 发起人
//@property (nonatomic, strong) StepUserView *initiatorStepView;
// 结束人
//@property (nonatomic, strong) StepUserView *finishrStepView;
// 实际的中间步骤
//@property (nonatomic, strong) NSMutableArray *middleStepArray;

@end

@implementation TaskStepView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

#pragma mark - private method
//- (void)updateCollectionViewConstraints{
//    CGFloat collectionW = (self.middleStepArray.count+1)*itemWidth;
//    CGFloat maxCollectionW = kScreenWidth - 15 - itemWidth*2;
//    if (collectionW > maxCollectionW) {
//        collectionW = maxCollectionW;
//    }
//    [self.collectionView updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(collectionW);
//    }];
//
//    if (self.middleStepArray.count >3) {
//        [self scrollToOffside];
//    }
//}
- (void)scrollToOffside{
    CGPoint rightOffset = CGPointMake((self.collectionView.contentSize.width -     self.collectionView.bounds.size.width) + itemWidth, 0);
    if (rightOffset.x > 0) {
        [self.collectionView setContentOffset:rightOffset animated:NO];
    }
}
- (void)deleteSelecteItem:(UILongPressGestureRecognizer *)longPress{
    if(longPress.state==UIGestureRecognizerStateBegan){
        NSInteger row = longPress.view.tag;
        [self routerEventWithName:longPress_delete_index userInfo:@{@"index":[NSString stringWithFormat:@"%ld",row]}];
    }
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.stepArray.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *supplementaryView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        TaskStepFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        supplementaryView = footerView;
    }
    return supplementaryView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TaskStepCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (self.taskType == TaskType_newTask) {
        cell.user = self.stepArray[indexPath.row];
    }else if(self.taskType == TaskType_details){
        cell.currentStep = self.stepArray[indexPath.row];
    }
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteSelecteItem:)];
    [cell addGestureRecognizer:longPress];
    longPress.minimumPressDuration = 1.0;
    longPress.view.tag = indexPath.row;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemWidth, itemHeight);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    CGRect cellInCollection = [collectionView convertRect:cell.frame toView:[collectionView superview]];
    id data = self.stepArray[indexPath.row];
    NSString *name = @"";
    if ([data isKindOfClass:[ZHUser class]]) {
        name = ((ZHUser *)data).name;
    }else if([data isKindOfClass:[ZHStep class]]){
        name = ((ZHStep *)data).responseUser.name;
    }
    [self.supernatantView showframe:cellInCollection text:name];
    
//    [self routerEventWithName:selected_taskStep_user userInfo:@{}];
}

#pragma mark - setting and getter

- (void)setStepArray:(NSMutableArray *)stepArray{
    _stepArray = stepArray;
//    self.initiatorStepView.user = _stepArray.firstObject;
//    self.finishrStepView.user = _stepArray.lastObject;
//    self.middleStepArray = _stepArray[1];
//    [self updateCollectionViewConstraints];
    [self.collectionView reloadData];
    [self scrollToOffside];
}
//- (NSMutableArray *)middleStepArray{
//    if (_middleStepArray == nil) {
//        _middleStepArray = [NSMutableArray array];
//    }
//    return _middleStepArray;
//}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[TaskStepCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerClass:[TaskStepFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    }
    return _collectionView;
}
- (SupernatantView *)supernatantView{
    if (_supernatantView == nil) {
        _supernatantView = [SupernatantView initSupernatantViewInView:[self.collectionView superview]];
    }
    return _supernatantView;
}
//- (StepUserView *)initiatorStepView{
//    if (_initiatorStepView == nil) {
//        _initiatorStepView = [[StepUserView alloc] init];
//    }
//    return _initiatorStepView;
//}
//- (StepUserView *)finishrStepView{
//    if (_finishrStepView == nil) {
//        _finishrStepView = [[StepUserView alloc] init];
//    }
//    return _finishrStepView;
//}
#pragma mark - UI
- (void)addUI{
    
    // 发起人
//    [self addSubview:self.initiatorStepView];
    // 中间人
    [self addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 结束人
//    [self addSubview:self.finishrStepView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_COLOR(153, 153, 153);
    [self addSubview:lineView];
    
//    [self.initiatorStepView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(15);
//        make.top.equalTo(0);
//        make.width.equalTo(itemWidth);
//        make.height.equalTo(itemHeight);
//    }];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(0);
    }];
//    [self.finishrStepView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.collectionView.mas_right);
//        make.top.equalTo(0);
//        make.width.equalTo(itemWidth);
//        make.height.equalTo(itemHeight);
//    }];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(0.5);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
