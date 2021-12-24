//
//  CircleLayout.m
//  TTManager
//
//  Created by chao liu on 2021/12/24.
//

#import "CircleLayout.h"

#define ITEM_SIZE_W kScreenWidth/4

@interface CircleLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *>*attributeAttay;
@property (nonatomic, assign) int itemCount;
@property (nonatomic, assign) CGPoint center;
@end

@implementation CircleLayout

- (void)prepareLayout
{
    [super prepareLayout];
    // 个数
    self.itemCount = (int)[self.collectionView numberOfItemsInSection:0];
    self.attributeAttay = [NSMutableArray array];
    // 半径、圆心
    self.radius =  MIN(self.collectionView.frame.size.width, self.collectionView.frame.size.height)/1.75;
    self.center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
}

// 设置内容区域的大小
- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    for (int i = 0; i < self.itemCount; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 设置 item大小
    attris.size = CGSizeMake(ITEM_SIZE_W, ITEM_SIZE_W);
    // 计算每个item圆心位置（算出来的x、y还要剪去item自身的半径大小）
    float x = self.center.x + cosf(2 * M_PI/self.itemCount * indexPath.item) * (self.radius - ITEM_SIZE_W);
    float y = self.center.y + sinf(2 * M_PI/self.itemCount * indexPath.item) * (self.radius - ITEM_SIZE_W);
    
    attris.center = CGPointMake(x, y);
    return attris;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds) || CGRectGetHeight(newBounds) != CGRectGetWidth(oldBounds)){
        return YES;
    }
    return NO;
}

@end
