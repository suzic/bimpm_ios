//
//  FormItemSectionView.m
//  TTManager
//
//  Created by chao liu on 2021/2/9.
//

#import "FormItemSectionView.h"
#import "FormItemsView.h"

@interface FormItemSectionView ()

@property (nonatomic, strong) FormItemsView *itemsView;
@property (nonatomic, strong) NSDictionary *formItem;
@property (nonatomic, assign) BOOL isFormEdit;
@property (nonatomic, strong) NSIndexPath *indexPath;



@end

@implementation FormItemSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUI];
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
    if (type == 0 || type == 1 || type == 2) {
        [self.itemsView setItemView:formItemType_text edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
    }else if(type == 3 || type == 4 || type == 5 || type == 6){
        [self.itemsView setItemView:formItemType_btn edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
    }else if(type == 7 || type == 8){
        [self.itemsView setItemView:formItemType_image edit:self.isFormEdit indexPath:self.indexPath data:self.formItem];
    }
}

- (FormItemsView *)itemsView{
    if (_itemsView == nil) {
        _itemsView = [[FormItemsView alloc] init];
    }
    return _itemsView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
