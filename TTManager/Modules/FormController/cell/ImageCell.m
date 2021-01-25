//
//  ImageCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/25.
//

#import "ImageCell.h"

@interface ImageCell ()

@property (nonatomic, strong) UIImageView *fromImageView;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation ImageCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
#pragma mark - ui
- (void)addUI{
    UIView *bgView = [[UIView alloc] init];
    bgView.clipsToBounds = YES;
    [self.contentView addSubview:bgView];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.bottom.right.equalTo(-10);
    }];
    [bgView addSubview:self.fromImageView];
    [bgView addSubview:self.deleteButton];
    
    [self.fromImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
    [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.width.height.equalTo(15);
    }];
}
#pragma mark - actions
- (void)deleteFromImageAction:(UIButton *)button{
    
}
#pragma maek - setter and getter
- (UIImageView *)fromImageView{
    if (_fromImageView == nil) {
        _fromImageView = [[UIImageView alloc] init];
        _fromImageView.image = [UIImage imageNamed:@"user_header"];
        _fromImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _fromImageView;
}
- (UIButton *)deleteButton{
    if (_deleteButton == nil) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteFromImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
@end
