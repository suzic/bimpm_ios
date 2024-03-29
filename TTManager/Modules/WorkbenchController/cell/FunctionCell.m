//
//  FunctionCell.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "FunctionCell.h"
#import "FuncatioCollectionCell.h"

@interface FunctionCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *functionArray;

@end

@implementation FunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (NSArray *)functionArray{
    if (_functionArray == nil) {
        _functionArray = @[
            @{@"titile":@"巡检报告",@"image":@"function_polling"},
            @{@"titile":@"施工日志",@"image":@"function_log"},
            @{@"titile":@"工作日报",@"image":@"function_task"},
            @{@"titile":@"日常打卡",@"image":@"function_daka"},
        ];
    }
    return _functionArray;
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.functionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FuncatioCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"funcatioCollectionCell" forIndexPath:indexPath];
    NSDictionary *dic = self.functionArray[indexPath.row];
    cell.functionName.text = dic[@"titile"];
    cell.funcationImage.image = [UIImage imageNamed:dic[@"image"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = (kScreenWidth - 80.0f) / 4;
    return CGSizeMake(cellWidth, FunctionCellHeight - 8.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self routerEventWithName:function_selected userInfo:@{@"index":@(indexPath.row)}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
