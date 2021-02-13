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

// 当前选中的item
@property (nonatomic, assign) NSInteger currentSelectedStep;
@property (nonatomic, assign) NSInteger selfStepIndex;
@end

@implementation TaskStepView

- (instancetype)init{
    self = [super init];
    if (self) {
        _currentSelectedStep = NSNotFound;
        self.clipsToBounds = NO;
        [self addUI];
    }
    return self;
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
    cell.index = indexPath.row;
    cell.currentStep = _tools.stepArray[indexPath.row];
    cell.isSelected = self.currentSelectedStep == indexPath.row;
    cell.type = _tools.type;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZHStep *step = _tools.stepArray[indexPath.row];
//    if (_tools.type == task_type_detail_initiate || indexPath.row == 0) {
//        return;
//    }
    if (step.state == 1 || indexPath.row == self.selfStepIndex ||_tools.type == task_type_detail_initiate || _tools.type == task_type_detail_finished || _tools.type == task_type_polling_detail) {
        self.currentSelectedStep =  indexPath.row;
        _tools.currentSelectedStep = step;
        [self routerEventWithName:current_selected_step userInfo:@{@"step":step,@"indexPath":indexPath}];
        [self.collectionView reloadData];
        return;
    }
    NSLog(@"当前选择的步骤类型 %d",step.state);
    if (indexPath.row == _tools.stepArray.count-1)
    {
        if (step.response_user_fixed == 1) {
            NSLog(@"来自模版,不可修改");
            return;
        }
        [self routerEventWithName:selected_taskStep_user userInfo:@{@"addType":TO,@"indexPath":indexPath}];
    }else{
        [self routerEventWithName:selected_taskStep_user userInfo:@{@"addType":ASSIGN,@"uid_step":step.uid_step,@"indexPath":indexPath}];
    }
}
#pragma mark - 页面操作
- (void)setStepViewOperations:(OperabilityTools *)tools{
    switch (tools.type) {
        case task_type_new_task:
//            [self checkCurrentStepHasEmptyUserStep];
            break;
        case task_type_new_apply:
//            [self checkCurrentStepHasEmptyUserStep];
            break;
        case task_type_new_noti:
            [self checkCurrentStepHasEmptyUserStep];
            break;
        case task_type_new_joint:
            [self checkCurrentStepHasEmptyUserStep];
            break;
        case task_type_new_polling:
//            [self checkCurrentStepHasEmptyUserStep];
            break;
        case task_type_detail_proceeding:
            [self getCurrentDefaultSelectIndex:_tools];
            break;
        case task_type_detail_finished:
//            [self taskFinishOperations];
            [self getCurrentDefaultSelectIndex:_tools];
            break;
        case task_type_detail_draft:
//            [self newTaskOperations];
            [self checkCurrentStepHasEmptyUserStep];
            break;
        case task_type_detail_initiate:
//            [self taskInitiateOperations];
            break;
        default:
            break;
    }
}
#pragma mark - private method
- (void)scrollToOffside{
    CGPoint rightOffset = CGPointMake(self.collectionView.contentSize.width - self.collectionView.frame.size.width + itemWidth, 0);
    if (rightOffset.x > 0) {
        [self.collectionView setContentOffset:rightOffset animated:NO];
    }
}
//// 检查当前步骤中是否有空步骤
- (void)checkCurrentStepHasEmptyUserStep{
    int emptyCount = 0;
    for (ZHStep *step in _tools.stepArray) {
        if (step.responseUser == nil) {
            emptyCount++;
        }
    }
    if (_tools.stepArray.count>= 3 && emptyCount <= 1) {
        if (_tools.type != task_type_new_polling && _tools.type != task_type_polling_detail) {
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

- (void)getCurrentDefaultSelectIndex:(OperabilityTools *)tools{
    ZHUser *currentUser = [DataManager defaultInstance].currentUser;
    for (int i = 0; i < _tools.stepArray.count; i++) {
        ZHStep *step = _tools.stepArray[i];
        // 发起人不算
        if (i > 0 && step.responseUser.id_user == currentUser.id_user) {
            self.currentSelectedStep = i;
            self.selfStepIndex = i;
            NSLog(@"当前任务的备注信息%@",step.memo);
            _tools.currentSelectedStep = step;
            [self routerEventWithName:current_selected_step userInfo:@{@"step":step}];
            break;
        }
    }
    if (_tools.currentSelectedStep == nil) {
        _tools.currentSelectedStep = _tools.stepArray[0];
        self.selfStepIndex = 0;
    }
}
#pragma mark - setting and getter

- (void)setTools:(OperabilityTools *)tools{
    _tools = tools;
    [self setStepViewOperations:_tools];
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
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[TaskStepCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerClass:[TaskStepCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
        [_collectionView registerClass:[TaskStepCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _collectionView;
}

#pragma mark - UI
- (void)addUI{
    
//    self.backgroundColor = [UIColor redColor];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_COLOR(153, 153, 153);
//    [self addSubview:lineView];
    
    // 中间人
    [self addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self insertSubview:lineView atIndex:0];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(0.5);
    }];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(0);
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
