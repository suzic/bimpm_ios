//
//  TaskStepView.m
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import "TaskStepView.h"
#import "TaskStepCell.h"
#import "StepUserView.h"
#import "SupernatantView.h"

static NSString *reuseIdentifier = @"StepCell";
static NSString *footerIdentifier = @"FooterIdentifier";
static NSString *headerIdentifier = @"headerIdentifier";

@interface TaskStepView ()<UICollectionViewDelegate,UICollectionViewDataSource>
// 中间步骤
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SupernatantView  *supernatantView;
@property (nonatomic, strong) NSMutableArray *stepArray;
@property (nonatomic, strong) ZHUser *finishUser;

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
        self.finishUser = nil;
        self.stepArray = [NSMutableArray array];
        [self addUI];
    }
    return self;
}

#pragma mark - private method
- (void)scrollToOffside{
    CGPoint rightOffset = CGPointMake(self.collectionView.contentSize.width - self.collectionView.frame.size.width + itemWidth, 0);
    if (rightOffset.x > 0) {
        [self.collectionView setContentOffset:rightOffset animated:NO];
    }
}
- (void)deleteSelecteItem:(UILongPressGestureRecognizer *)longPress{
    if (self.stepArray.count == 1 && self.finishUser == nil)
        return;
    if (self.tools.operabilityStep == NO) {
        return;
    }
    if(longPress.state==UIGestureRecognizerStateBegan){
        CGPoint point = [longPress locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        [self routerEventWithName:longPress_delete_index userInfo:@{@"indexPath":indexPath}];
    }
}
// 添加中间步骤负责人
- (void)addUserToStep:(UITapGestureRecognizer *)tap{
    if (self.tools.type == task_type_new_noti || self.tools.type == task_type_new_joint) {
        [self routerEventWithName:selected_taskStep_user userInfo:@{@"addType":@"1"}];
    }else{
        [self routerEventWithName:selected_taskStep_user userInfo:@{@"addType":@"0"}];
    }
}
// 添加结束步骤负责人
- (void)addFinishUserToStep:(UITapGestureRecognizer *)tap{
    [self routerEventWithName:selected_taskStep_user userInfo:@{@"addType":@"0"}];
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.tools.isDetails == YES) {
        return 1;
    }
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.tools.isDetails == YES) {
        return self.stepArray.count;
    }else{
        if (section == 0) {
            return self.tools.twoStep == YES ? 1:self.stepArray.count;
        }
        return self.finishUser != nil ? 1 : 0;
    }
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *supplementaryView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        TaskStepCell *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        footerView.currentStep = nil;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addUserToStep:)];
        [self addGestureRecognizer:tap];
        [footerView addGestureRecognizer:tap];
        supplementaryView = footerView;
    }else{
        TaskStepCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        headerView.currentStep = self.finishUser;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFinishUserToStep:)];
        [self addGestureRecognizer:tap];
        [headerView addGestureRecognizer:tap];
        supplementaryView = headerView;
    }
    return supplementaryView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TaskStepCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (self.stepArray.count >0) {
            cell.currentStep = self.stepArray[indexPath.row];
        }
    }else{
        cell.currentStep = self.finishUser;
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
    if (self.tools.isDetails == YES) {
        return CGSizeZero;
    }
    if (section == 1) {
        return CGSizeZero;
    }else{
        if (self.tools.twoStep == YES){
            return CGSizeZero;
        }else{
            return CGSizeMake(itemWidth, itemHeight);
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.tools.isDetails == YES) {
        return CGSizeZero;
    }
    else
    {
        if (section == 0)
        {
            return CGSizeZero;
        }
        else if(section == 1)
        {
            if (self.tools.type == task_type_new_polling || self.finishUser != nil) {
                return CGSizeZero;
            }else{
                return CGSizeMake(itemWidth, itemHeight);
            }
        }
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    CGRect cellInCollection = [collectionView convertRect:cell.frame toView:[collectionView superview]];
    id data;
    if (indexPath.section == 0) {
        data = self.stepArray[indexPath.row];
    }else{
        data = self.finishUser;
    }
    NSString *name = @"";
    if ([data isKindOfClass:[ZHUser class]]) {
        name = ((ZHUser *)data).name;
    }else if([data isKindOfClass:[ZHStep class]]){
        name = ((ZHStep *)data).responseUser.name;
    }
    [self.supernatantView showframe:cellInCollection text:name];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.supernatantView.hidden = YES;
    NSLog(@"当前的滚动量%f",scrollView.contentOffset.x);
}
#pragma mark - setting and getter

- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    self.stepArray = _tools.stepArray;
    self.finishUser = _tools.finishUser;
    [self.collectionView reloadData];
    [self scrollToOffside];
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[TaskStepCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerClass:[TaskStepCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
        [_collectionView registerClass:[TaskStepCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
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
