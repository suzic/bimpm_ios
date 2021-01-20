//
//  FormTitleView.m
//  TTManager
//
//  Created by chao liu on 2021/1/20.
//

#import "FormTitleView.h"
#import "FormItemView.h"

@interface FormTitleView ()
@property (nonatomic, strong) FormItemView *nameItemView;
@property (nonatomic, strong) FormItemView *systemItemView;
@end

@implementation FormTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    [self.nameItemView borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeAll];
    [self.systemItemView borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeAll];
}
#pragma mark - UI
- (void)addUI{
    [self addSubview:self.nameItemView];
    [self addSubview:self.systemItemView];
    
    [self.nameItemView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(ItemRowHeight*3+ItemRowHeight/3*2);
    }];
    [self.systemItemView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameItemView.mas_bottom).offset(10);
        make.height.equalTo(ItemRowHeight*2+ItemRowHeight/3*2);
        make.left.equalTo(10);
        make.right.equalTo(-10);
    }];
}

#pragma setter and getter

- (FormItemView *)nameItemView{
    if (_nameItemView == nil) {
        _nameItemView = [[FormItemView alloc] initWithItemType:formItemType_name];
    }
    return _nameItemView;
}
- (FormItemView *)systemItemView{
    if (_systemItemView == nil) {
        _systemItemView = [[FormItemView alloc] initWithItemType:formItemType_system];
    }
    return _systemItemView;
}
@end
