//
//  ZHCalendarHeaderView.m
//  TTManager
//
//  Created by chao liu on 2021/1/7.
//

#import "ZHCalendarHeaderView.h"

@implementation ZHCalendarHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI
{
    self.backgroundColor = RGBA_COLOR(5, 125, 255, 1.0);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择预计完成时间";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeCalendarView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureCalendarView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureButton];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(0);
    }];
    [closeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.bottom.equalTo(0);
        make.width.equalTo(closeButton.mas_height);
    }];
}
- (void)closeCalendarView:(UIButton *)button{
    if (self.closeBlock) {
        self.closeBlock();
    }
}
- (void)sureCalendarView:(UIButton *)button{
    if (self.sureBlock) {
        self.sureBlock();
    }
}
- (void)addCornerRadiu{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
