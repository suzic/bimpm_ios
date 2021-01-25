//
//  FormImageCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/25.
//

#import "FormImageCell.h"
#import "ImageCell.h"

static NSString *reuseIdentifier = @"ImageCell";

@interface FormImageCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *imageCollectionView;
@property (nonatomic, strong) UILabel *keyLabel;

@end

@implementation FormImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)addUI{
    UIView *keyBgView = [[UIView alloc] init];
    [self.contentView addSubview:keyBgView];
    [self addSubview:self.imageCollectionView];
    
    [keyBgView addSubview:self.keyLabel];
    [keyBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.height.equalTo(44);
        make.width.equalTo(self).multipliedBy(0.25);
    }];
    [self.keyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.height.equalTo(keyBgView.mas_height);
        make.top.right.equalTo(0);
    }];
    [self.imageCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-5);
        make.right.equalTo(0);
        make.top.equalTo(5);
        make.width.equalTo(self).multipliedBy(0.75);
    }];
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-10)*0.75/3, (kScreenWidth-10)*0.75/3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark - setter and getter
- (UICollectionView *)imageCollectionView{
    if (_imageCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _imageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        _imageCollectionView.dataSource = self;
        _imageCollectionView.delegate = self;
        _imageCollectionView.showsHorizontalScrollIndicator = NO;
        _imageCollectionView.showsVerticalScrollIndicator = NO;
        _imageCollectionView.bounces = NO;
        [_imageCollectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _imageCollectionView;
}
- (UILabel *)keyLabel{
    if (_keyLabel == nil) {
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.font = [UIFont systemFontOfSize:16];
        _keyLabel.textColor = RGB_COLOR(51, 51, 51);
        _keyLabel.textAlignment = NSTextAlignmentLeft;
        _keyLabel.text = @"图片集";
    }
    return _keyLabel;
}
-(CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority{
    // 在对collectionView进行布局
    self.imageCollectionView.frame = CGRectMake(0, 0, targetSize.width, 44);
    [self.imageCollectionView layoutIfNeeded];
    
    // 由于这里collection的高度是动态的，这里cell的高度我们根据collection来计算
    CGSize collectionSize = self.imageCollectionView.collectionViewLayout.collectionViewContentSize;
    CGFloat cotentViewH = collectionSize.height;
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, cotentViewH+10);
}

@end
