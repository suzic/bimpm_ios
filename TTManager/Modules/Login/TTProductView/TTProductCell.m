//
//  TTProductCell.m
//  TTManager
//
//  Created by chao liu on 2021/12/24.
//

#import "TTProductCell.h"

@interface TTProductCell ()

@property (nonatomic,strong) UIButton *imageView;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation TTProductCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)setProductDict:(NSDictionary *)productDict{
    _productDict = productDict;
    [self.imageView setBackgroundImage:[UIImage imageNamed:_productDict[@"image"]] forState:UIControlStateNormal];
    [self.imageView setBackgroundImage:[UIImage imageNamed:_productDict[@"image_selected"]] forState:UIControlStateHighlighted];
    [self.imageView setBackgroundImage:[UIImage imageNamed:_productDict[@"image_selected"]] forState:UIControlStateSelected];
    self.titleLabel.text = _productDict[@"title"];
    NSDictionary *dict = [[TTProductManager defaultInstance] getCurrentProduc];
    if ([[TTProductManager defaultInstance] hasCurrentSelectedProduct] == true) {
        self.imageView.selected = [dict[@"type"] isEqualToString:_productDict[@"type"]];
    }
}

- (void)tapProductAction:(UIButton *)button{
    button.selected = !button.selected;
    [self routerEventWithName:login_product_selected userInfo:self.productDict];
}

- (void)addUI{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.contentView.mas_width).multipliedBy(0.5);
        make.center.equalTo(self.contentView);
    }];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(6);
        make.width.equalTo(self.contentView.mas_width);
        make.centerX.equalTo(self.contentView.centerX);
    }];
}

- (UIButton *)imageView
{
    if (_imageView == nil) {
        _imageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView addTarget:self action:@selector(tapProductAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageView;
}
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
