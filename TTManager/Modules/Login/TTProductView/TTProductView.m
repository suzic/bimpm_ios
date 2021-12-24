//
//  TTProductView.m
//  TTManager
//
//  Created by chao liu on 2021/12/24.
//

#import "TTProductView.h"
#import "CircleLayout.h"
#import "TTProductCell.h"

#define TTProductCellIdentifier @"TTProductCellIdentifier"

@interface TTProductView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CircleLayout *circleLayout;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *productbgImageView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NSArray *productArray;

@end

@implementation TTProductView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

#pragma - mark UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTProductCell *cell = (TTProductCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TTProductCellIdentifier forIndexPath:indexPath];
    cell.productDict = self.productArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.productArray[indexPath.row];
    NSLog(@"当前选中的产品 == %@",dic);
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:login_product_selected]) {
        [[TTProductManager defaultInstance] setCurrentSelectedProduct:userInfo];
        [self.collectionView reloadData];
        [[LCPopTool defaultInstance] closeAnimated:YES];
    }
}

- (void)reloadProductView{
    [self.collectionView reloadData];
}

#pragma - mark get && set

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.circleLayout];
        [_collectionView registerClass:[TTProductCell class] forCellWithReuseIdentifier:TTProductCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (CircleLayout *)circleLayout
{
    if (_circleLayout == nil) {
        _circleLayout = [[CircleLayout alloc] init];
    }
    return _circleLayout;
}

- (UIImageView *)logoImageView
{
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.image = [UIImage imageNamed:@"product_logo"];
    }
    return _logoImageView;
}
- (UIImageView *)productbgImageView
{
    if (_productbgImageView == nil) {
        _productbgImageView = [[UIImageView alloc] init];
        _productbgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _productbgImageView.image = [UIImage imageNamed:@"product_bg"];
    }
    return _productbgImageView;
}
- (UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.image = [UIImage imageNamed:@"product_login_bg"];
    }
    return _bgImageView;
}
- (UIImageView *)titleImageView
{
    if (_titleImageView == nil) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        _titleImageView.image = [UIImage imageNamed:@"product_title"];
    }
    return _titleImageView;
}
- (NSArray *)productArray
{
    if (_productArray == nil) {
        _productArray = product_list;
    }
    return _productArray;
}

- (void)addUI
{
    self.backgroundColor = [UIColor clearColor];
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleImageView];
    [bgView addSubview:self.productbgImageView];
    [bgView addSubview:self.collectionView];
    [bgView addSubview:self.logoImageView];
    [self addSubview:bgView];
    
    [self.bgImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(0);
    }];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.mas_width);
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY).multipliedBy(1.2);
    }];
    
    [self.productbgImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(bgView.mas_width);
        make.center.equalTo(bgView);
    }];
    
    [self.titleImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.centerX.equalTo(self.centerX);
        make.height.equalTo(self.mas_width).multipliedBy(0.15);
        make.bottom.equalTo(bgView.mas_top).offset(-kScreenWidth*0.15);
    }];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(bgView.mas_width);
        make.center.equalTo(bgView);
    }];
    
    [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self).multipliedBy(0.3);
        make.center.equalTo(bgView);
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
