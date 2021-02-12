//
//  FormItemImageView.m
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import "FormItemImageView.h"
#import "ImageCell.h"

static NSString *reuseIdentifier = @"ImageCell";

@interface FormItemImageView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSDictionary *formItem;
@property (nonatomic, assign) BOOL isFormEdit;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UITextView *valueTextView;

// 图片集类型 1:内嵌图片，2:图片list
@property (nonatomic, assign) NSInteger imageType;

@end

@implementation FormItemImageView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

#pragma mark - public

- (void)setItemEdit:(BOOL)edit data:(NSDictionary *)data indexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    self.formItem = data;
    self.isFormEdit = edit;
    [self.imageCollectionView reloadData];
}

#pragma mark - actions

- (void)addImageAction:(UIButton *)button{
    NSLog(@"添加图片");
    [self routerEventWithName:add_formItem_image userInfo:@{}];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    NSMutableDictionary *decoratedUserInfo = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
    if ([eventName isEqualToString:delete_formItem_image]) {
        decoratedUserInfo[@"indexPath"] = self.indexPath;
    }
    [super routerEventWithName:eventName userInfo:decoratedUserInfo];
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // 不是编辑状态直接返回个数
    if (self.isFormEdit == NO) {
        return self.imagesArray.count;
    }else{
        // 多个图片集直接创建一个add在最后
        if (self.imageType == 2) {
            return self.imagesArray.count<6 ? self.imagesArray.count+1 : self.imagesArray.count;
        }else{
            // 内嵌图片存在 没有添加按钮
            if (self.imagesArray.count >0) {
                return self.imagesArray.count;
            }
            // 创建添加按钮
            else{
                return 1;
            }
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == self.imagesArray.count && self.isFormEdit == YES) {
        cell.addButton.hidden = NO;
        [cell.addButton addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell hideAddButton:NO];
    }
    else{
        NSString *data = self.imagesArray[indexPath.row];
        [cell setIsFormEdit:self.isFormEdit indexPath:indexPath item:data imageType:self.imageType];
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

#pragma mark - UI

- (void)addUI{
    
    [self addSubview:self.imageCollectionView];
    
    [self addSubview:self.valueTextView];
    
    [self.imageCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(10);
        make.width.equalTo(self);
    }];
    [self.valueTextView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.width.equalTo(self);
    }];
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

- (UITextView *)valueTextView{
    if (_valueTextView == nil) {
        _valueTextView = [[UITextView alloc] init];
        _valueTextView.font = [UIFont systemFontOfSize:16];
        _valueTextView.textColor = RGB_COLOR(51, 51, 51);
        _valueTextView.placeholderColor = [UIColor lightGrayColor];
        _valueTextView.editable = NO;
    }
    return _valueTextView;
}

- (void)setFormItem:(NSDictionary *)formItem{
    _formItem = formItem;
    [self.imagesArray removeAllObjects];
    
    if ([_formItem[@"type"] isEqualToNumber:@7]) {
        self.valueTextView.placeholder = @"小图片";
        self.imageType = 1;
        if (![SZUtil isEmptyOrNull:_formItem[@"instance_value"]]) {
            [self.imagesArray addObject:_formItem[@"instance_value"]];
        }
        
    }else if([_formItem[@"type"] isEqualToNumber:@8]){
        self.valueTextView.placeholder = @"多个图片";
        self.imageType = 2;
        if (![SZUtil isEmptyOrNull:_formItem[@"instance_value"]]) {
            [self.imagesArray addObjectsFromArray:[_formItem[@"instance_value"] componentsSeparatedByString:@","]];
        }
    }
    [self.imageCollectionView reloadData];
}
- (void)setIsFormEdit:(BOOL)isFormEdit{
    _isFormEdit = isFormEdit;
    if (_isFormEdit == YES) {
        self.valueTextView.hidden = YES;
        self.imageCollectionView.hidden = NO;
    }else{
        if (self.imagesArray.count <= 0) {
            self.valueTextView.hidden = NO;
            self.imageCollectionView.hidden = YES;
        }else{
            self.valueTextView.hidden = YES;
            self.imageCollectionView.hidden = NO;
        }
    }
}

- (NSMutableArray *)imagesArray{
    if (_imagesArray == nil) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

//-(CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority{
//    // 在对collectionView进行布局
//    self.imageCollectionView.frame = CGRectMake(0, 0, targetSize.width, 44);
//    [self.imageCollectionView layoutIfNeeded];
//    
//    // 由于这里collection的高度是动态的，这里cell的高度我们根据collection来计算
//    CGSize collectionSize = self.imageCollectionView.collectionViewLayout.collectionViewContentSize;
//    CGFloat cotentViewH = collectionSize.height;
//    if (cotentViewH < 44) {
//        cotentViewH = 44;
//    }else{
//        if (self.isFormEdit == YES) {
//            if(self.imagesArray.count >= 3){
//                cotentViewH = cotentViewH*2+10;
//            }else{
//                cotentViewH = cotentViewH+10;
//            }
//        }
//    }
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width, cotentViewH);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
