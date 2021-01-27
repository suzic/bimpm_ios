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
@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) NSDictionary *formItem;
@property (nonatomic, assign) BOOL isFormEdit;
@property (nonatomic, strong) NSIndexPath *indexPath;

// 图片集类型 1:内嵌图片，2:图片list
@property (nonatomic, assign) NSInteger imageType;

@end

@implementation FormImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
        make.top.equalTo(10);
        make.width.equalTo(self).multipliedBy(0.75);
        make.height.greaterThanOrEqualTo(44);
    }];
}
- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(NSDictionary *)formItem{
    self.indexPath = indexPath;
    self.isFormEdit = isFormEdit;
    self.formItem = formItem;
}
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:delete_formItem_image]) {
        NSMutableDictionary *decoratedUserInfo = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
            decoratedUserInfo[@"newParam"] = @"new param"; // 添加数据
        decoratedUserInfo[@"formItemIndex"] = self.indexPath;
        [super routerEventWithName:eventName userInfo:decoratedUserInfo];
    }
}
#pragma mark - actions
- (void)addImageAction:(UIButton *)button{
    NSLog(@"添加图片");
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.isFormEdit == YES ? self.imagesArray.count+1 :self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == self.imagesArray.count && self.isFormEdit == YES) {
        cell.addButton.hidden = NO;
        [cell.addButton addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell hideAddButton:NO];
    }else{
        NSString *data = self.imagesArray[indexPath.row];
        [cell setIsFormEdit:self.isFormEdit indexPath:indexPath item:data];
        [cell hideAddButton:YES];
    }
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
    }
    return _keyLabel;
}
- (void)setFormItem:(NSDictionary *)formItem{
    if (_formItem != formItem) {
        _formItem = formItem;
        [self.imagesArray removeAllObjects];
        if (![SZUtil isEmptyOrNull:_formItem[@"instance_value"]]) {
            [self.imagesArray addObjectsFromArray:[_formItem[@"instance_value"] componentsSeparatedByString:@","]];
        }
        self.keyLabel.text = _formItem[@"name"];
        [self.imageCollectionView reloadData];
    }
}
- (NSMutableArray *)imagesArray{
    if (_imagesArray == nil) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}
-(CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority{
    // 在对collectionView进行布局
    self.imageCollectionView.frame = CGRectMake(0, 0, targetSize.width, 44);
    [self.imageCollectionView layoutIfNeeded];
    
    // 由于这里collection的高度是动态的，这里cell的高度我们根据collection来计算
    CGSize collectionSize = self.imageCollectionView.collectionViewLayout.collectionViewContentSize;
    CGFloat cotentViewH = collectionSize.height;
    if (cotentViewH < 44) {
        cotentViewH = 44;
    }else{
        if (self.isFormEdit == YES) {
            cotentViewH = cotentViewH+10;
        }
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, cotentViewH);
}

@end
