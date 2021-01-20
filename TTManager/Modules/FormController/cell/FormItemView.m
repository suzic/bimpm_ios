//
//  FormItemView.m
//  TTManager
//
//  Created by chao liu on 2021/1/20.
//

#import "FormItemView.h"
#import "FormRowView.h"

@interface FormItemView ()

@property (nonatomic ,assign) FormItemType itemType;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) FormRowView *firstRowView;
@property (nonatomic, strong) FormRowView *secondRowView;
@property (nonatomic, strong) FormRowView *thirdRowView;

@end

@implementation FormItemView

- (instancetype)initWithItemType:(FormItemType)itemType{
    self = [super init];
    if (self) {
        self.itemType = itemType;
        [self addUI:itemType];
    }
    return self;
}
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    [self addBottomBorder];
}
- (void)addBottomBorder{
    [self.firstRowView borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeBottom];
    switch (self.itemType) {
        case formItemType_name:
            [self.secondRowView borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeBottom];
            break;
        case formItemType_content:
            [self.secondRowView borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeBottom];
            break;
        case formItemType_system:
            break;
        default:
            break;
    }
}
- (void)addUI:(FormItemType)itemType{
    [self addSubview:self.headerView];
    switch (itemType) {
        case formItemType_name:
            [self addSubview:self.firstRowView];
            [self addSubview:self.secondRowView];
            [self addSubview:self.thirdRowView];
            [self.thirdRowView changeValueFieldLeft:NO];
            self.headerView.backgroundColor = [UIColor grayColor];
            break;
        case formItemType_system:
            [self addSubview:self.firstRowView];
            [self addSubview:self.secondRowView];
            self.headerView.backgroundColor = [UIColor grayColor];
            break;
        case formItemType_content:{
            [self addSubview:self.firstRowView];
            [self addSubview:self.secondRowView];
            [self addSubview:self.thirdRowView];
            self.secondRowView.formKeyTypeButton.hidden = NO;
            self.secondRowView.keyTextField.hidden = YES;
            [self.thirdRowView changeValueFieldLeft:YES];
        }
        default:
            break;
    }
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(ItemRowHeight/3*2);
    }];
    [self.firstRowView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(ItemRowHeight);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    [self.secondRowView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(ItemRowHeight);
        make.top.equalTo(self.firstRowView.mas_bottom);
    }];
    if (itemType == formItemType_content || itemType == formItemType_name) {
        [self.thirdRowView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(ItemRowHeight);
            make.top.equalTo(self.secondRowView.mas_bottom);
        }];
    }
}
#pragma mark - setter and getter
- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = RGB_COLOR(5, 125, 255);
    }
    return _headerView;
}
- (FormRowView *)firstRowView{
    if (_firstRowView == nil) {
        _firstRowView = [[FormRowView alloc] init];
    }
    return _firstRowView;
}
- (FormRowView *)secondRowView{
    if (_secondRowView == nil) {
        _secondRowView = [[FormRowView alloc] init];
    }
    return _secondRowView;
}
- (FormRowView *)thirdRowView{
    if (_thirdRowView == nil) {
        _thirdRowView = [[FormRowView alloc] init];
    }
    return _thirdRowView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
