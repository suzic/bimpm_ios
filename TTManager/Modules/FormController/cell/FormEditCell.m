//
//  FormEditCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import "FormEditCell.h"
#import "FormItemsView.h"
#import "FormItemImageView.h"

@interface FormEditCell ()

@property (nonatomic, strong) FormItemsView *itemsView;

@property (nonatomic, strong) NSDictionary *formItem;
@property (nonatomic, assign) BOOL isFormEdit;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation FormEditCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

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
    
    [self.contentView addSubview:self.itemsView];
    
    [self.itemsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
}

#pragma mark - public
- (void)setHeaderViewData:(NSDictionary *)data{
    [self.itemsView setItemView:formItemType_text edit:NO indexPath:self.indexPath data:data];
}

//- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
//    NSMutableDictionary *decoratedUserInfo = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
//    if ([eventName isEqualToString:form_edit_item] ||
//        [eventName isEqualToString:add_formItem_image] ||
//        [eventName isEqualToString:delete_formItem_image]) {
//        decoratedUserInfo[@"indexPath"] = self.indexPath;
//    }
//    [super routerEventWithName:eventName userInfo:decoratedUserInfo];
//}

#pragma mark - setter and getter

- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(NSDictionary *)formItem{
    self.indexPath = indexPath;
    self.isFormEdit = isFormEdit;
    self.formItem = formItem;
    [self setFormItemViewType];
}

- (void)setFormItemViewType{
//    self.keyLabel.text = _formItem[@"name"];
    NSInteger type = [self.formItem[@"type"] intValue];
    self.itemsView.isPollingTask = self.isPollingTask;
    if (self.templateType == 1) {
        if (self.indexPath.row == 0) {
            [self.itemsView setItemView:formItemType_slider edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
        }else{
            if (type == 0 || type == 1 || type == 2) {
                [self.itemsView setItemView:formItemType_text edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
            }else if(type == 3 || type == 4 || type == 5 || type == 6){
                [self.itemsView setItemView:formItemType_btn edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
            }else if(type == 7 || type == 8){
                [self.itemsView setItemView:formItemType_image edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
            }
        }
    }
    else if(self.templateType == 2){
        if (self.indexPath.row == 0) {
            [self.itemsView setItemView:formItemType_btn edit:NO indexPath:self.indexPath data:self.formItem];
        }else{
            if (type == 0 || type == 1 || type == 2) {
                [self.itemsView setItemView:formItemType_text edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
            }else if(type == 3 || type == 4 || type == 5 || type == 6){
                [self.itemsView setItemView:formItemType_btn edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
            }else if(type == 7 || type == 8){
                [self.itemsView setItemView:formItemType_image edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
            }
        }
    }
    else{
        if (type == 0 || type == 1 || type == 2) {
            [self.itemsView setItemView:formItemType_text edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
        }else if(type == 3 || type == 4 || type == 5 || type == 6){
            [self.itemsView setItemView:formItemType_btn edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
        }else if(type == 7 || type == 8){
            [self.itemsView setItemView:formItemType_image edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
        }
    }
}

- (FormItemsView *)itemsView{
    if (_itemsView == nil) {
        _itemsView = [[FormItemsView alloc] init];
    }
    return _itemsView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority{
    
    if (self.formItem != nil && ([self.formItem[@"type"] isEqualToNumber:@7] ||[self.formItem[@"type"] isEqualToNumber:@8])) {
        FormItemImageView *imageView = (FormItemImageView *)[self.itemsView getViewByType:formItemType_image];
        // 在对collectionView进行布局
        imageView.imageCollectionView.frame = CGRectMake(0, 0, targetSize.width, 44);
        [imageView.imageCollectionView layoutIfNeeded];
        
        // 由于这里collection的高度是动态的，这里cell的高度我们根据collection来计算
        CGSize collectionSize = imageView.imageCollectionView.collectionViewLayout.collectionViewContentSize;
        CGFloat cotentViewH = collectionSize.height;
        if (cotentViewH < 44) {
            cotentViewH = 44;
        }else{
            if (self.isFormEdit == YES) {
                if(imageView.imagesArray.count >= 3){
                    cotentViewH = cotentViewH*2+10;
                }else{
                    cotentViewH = cotentViewH+10;
                }
            }
        }
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, cotentViewH);
    }
    [self.contentView layoutIfNeeded];
    
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}
@end
