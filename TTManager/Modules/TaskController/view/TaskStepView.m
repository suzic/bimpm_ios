//
//  TaskStepView.m
//  TTManager
//
//  Created by chao liu on 2020/12/30.
//

#import "TaskStepView.h"
#import "TaskStepCell.h"
#import "StepUserView.h"

static NSString *reuseIdentifier = @"StepCell";

@interface TaskStepView ()<UICollectionViewDelegate,UICollectionViewDataSource>
// 中间步骤
@property (nonatomic, strong) UICollectionView *collectionView;
// 发起人
@property (nonatomic, strong) StepUserView *initiatorStepView;
// 结束人
@property (nonatomic, strong) StepUserView *finishrStepView;

@end

@implementation TaskStepView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)addUI{
    
    // 发起人
    [self addSubview:self.initiatorStepView];
    // 中间人
    [self addSubview:self.collectionView];
    // 结束人
    [self addSubview:self.finishrStepView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_COLOR(153, 153, 153);
    [self addSubview:lineView];
    
    [self.initiatorStepView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(0);
        make.width.equalTo(itemWidth);
        make.height.equalTo(itemHeight);
    }];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(self.initiatorStepView.mas_right);
        make.width.equalTo(itemWidth);
        make.bottom.equalTo(0);
    }];
    [self.finishrStepView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionView.mas_right);
        make.top.equalTo(0);
        make.width.equalTo(itemWidth);
        make.height.equalTo(itemHeight);
    }];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
}
#pragma mark - private method
- (void)updateCollectionViewConstraints{
    CGFloat collectionW = self.stepArray.count*itemWidth;
    CGFloat maxCollectionW = kScreenWidth - 15 - itemWidth*2;
    if (collectionW > maxCollectionW) {
        collectionW = maxCollectionW;
    }
    [self.collectionView updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(collectionW);
    }];
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.stepArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TaskStepCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - setting and getter
- (void)setStepArray:(NSArray *)stepArray{
    if (_stepArray != stepArray) {
        _stepArray = stepArray;
        [self updateCollectionViewConstraints];
        [self.collectionView reloadData];
    }
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[TaskStepCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (StepUserView *)initiatorStepView{
    if (_initiatorStepView == nil) {
        _initiatorStepView = [[StepUserView alloc] init];
    }
    return _initiatorStepView;
}
- (StepUserView *)finishrStepView{
    if (_finishrStepView == nil) {
        _finishrStepView = [[StepUserView alloc] init];
    }
    return _finishrStepView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
