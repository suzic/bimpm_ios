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
//@property (nonatomic, strong) SupernatantView  *supernatantView;
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
- (void)scrollToOffside{
    CGPoint rightOffset = CGPointMake(self.collectionView.contentSize.width - self.collectionView.frame.size.width + itemWidth, 0);
    if (rightOffset.x > 0) {
        [self.collectionView setContentOffset:rightOffset animated:NO];
    }
}
//- (void)deleteSelecteItem:(UILongPressGestureRecognizer *)longPress{
//    if (_tools.stepArray.count == 1 && _tools.finishStep == nil)
//        return;
//    if (self.tools.operabilityStep == NO) {
//        return;
//    }
//    if(longPress.state==UIGestureRecognizerStateBegan){
//        CGPoint point = [longPress locationInView:self.collectionView];
//        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
//        ZHStep *step = _tools.stepArray[indexPath.row];
//        [self routerEventWithName:longPress_delete_index userInfo:@{@"delete":step}];
//    }
//}

//// 检查当前步骤中是否有空步骤
- (void)checkCurrentStepHasEmptyUserStep{
    int emptyCount = 0;
    for (ZHStep *step in _tools.stepArray) {
        if (step.responseUser == nil) {
            emptyCount++;
        }
    }
    if (_tools.stepArray.count>= 3 && emptyCount <= 1) {
        if (_tools.type != task_type_new_polling) {
            [self insertEmptyStepToCurrentStep];
        }
    }
}
// 插入一条空的步骤数据
- (void)insertEmptyStepToCurrentStep{
    ZHStep *step = (ZHStep *)[[DataManager defaultInstance] getStepFromCoredataByID:[SZUtil getGUID]];
    NSLog(@"当前步骤的个数%ld",_tools.stepArray.count);
    [_tools.stepArray insertObject:step atIndex:_tools.stepArray.count-1];
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _tools.stepArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TaskStepCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.currentStep = _tools.stepArray[indexPath.row];
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteSelecteItem:)];
//    [cell addGestureRecognizer:longPress];
//    longPress.minimumPressDuration = 1.0;
//    longPress.view.tag = indexPath.row;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    CGRect cellInCollection = [collectionView convertRect:cell.frame toView:[collectionView superview]];
    ZHStep *step = _tools.stepArray[indexPath.row];
//    NSString *name = step.responseUser.name;
    if (_tools.type == task_type_detail_initiate || indexPath.row == 0) {
        return;
    }
    if (indexPath.row == _tools.stepArray.count-1)
    {
        [self routerEventWithName:selected_taskStep_user userInfo:@{@"addType":TO}];
    }else{
        [self routerEventWithName:selected_taskStep_user userInfo:@{@"addType":ASSIGN,@"uid_step":step.uid_step}];
    }
//    if (step.responseUser == nil) {
//
//    }else{
//        [self.supernatantView showframe:cellInCollection text:name];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.supernatantView.hidden = YES;
}
#pragma mark - setting and getter

- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    [self checkCurrentStepHasEmptyUserStep];
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
//- (SupernatantView *)supernatantView{
//    if (_supernatantView == nil) {
//        _supernatantView = [SupernatantView initSupernatantViewInView:[self.collectionView superview]];
//    }
//    return _supernatantView;
//}
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
