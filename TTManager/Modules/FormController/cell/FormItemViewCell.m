//
//  FormItemViewCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/19.
//

#import "FormItemViewCell.h"
#import "FormItemView.h"

@interface FormItemViewCell ()

@property (nonatomic, strong)FormItemView *itemView;

@end
@implementation FormItemViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
//    [self.itemView borderForColor:[UIColor redColor] borderWidth:0.5 borderType:UIBorderSideTypeAll];
}
- (void)setFormItem:(ZHFormItem *)formItem{
    if (_formItem != formItem) {
        _formItem = formItem;
        self.itemView.formItem = _formItem;
    }
}
#pragma mark - UI
- (void)addUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.itemView];
    [self.itemView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(ItemRowHeight*3 + ItemRowHeight/3*2);
//        make.edges.equalTo(0);
    }];
    
    self.itemView.layer.borderWidth = 0.5;
    self.itemView.layer.borderColor = RGB_COLOR(102, 102, 102).CGColor;
}
- (FormItemView *)itemView{
    if (_itemView == nil) {
        _itemView = [[FormItemView alloc] initWithItemType:formItemType_content];
        _itemView.isEdit = NO;
    }
    return _itemView;
}
@end
