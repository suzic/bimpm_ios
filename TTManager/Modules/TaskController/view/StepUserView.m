//
//  StepUserView.m
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import "StepUserView.h"

@interface StepUserView ()

// 当前步骤用户状态
@property (nonatomic, strong) UILabel *stepStatus;
// 步骤头像
@property (nonatomic, strong) UIImageView *stepUserImage;
// 当前用户处理情况
@property (nonatomic, strong) UILabel *stepUserDispose;
// 当前步骤用户名称
@property (nonatomic, strong) UILabel *stepUserName;

@end

@implementation StepUserView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)addUI{
    UIView *bgView = [[UIView alloc] init];
    [bgView addSubview:self.stepUserImage];
    [bgView addSubview:self.stepStatus];
    [self addSubview:bgView];
    
    [self addSubview:self.stepUserDispose];
    [self addSubview:self.stepUserName];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.right.equalTo(-10);
        make.left.equalTo(0);
        make.height.equalTo(bgView.mas_width);
    }];
    [self.stepUserImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
    [self.stepStatus makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.left.equalTo(2);
        make.right.equalTo(5);
    }];
    [self.stepUserDispose makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom);
        make.centerX.equalTo(bgView);
    }];
    [self.stepUserName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepUserDispose.mas_bottom).offset(6);
        make.centerX.equalTo(self.stepUserDispose);
    }];
    
}
#pragma mark - setting and getter
- (UILabel *)stepStatus{
    if (_stepStatus == nil) {
        _stepStatus = [[UILabel alloc] init];
        _stepStatus.text = @"反对";
        _stepStatus.font = [UIFont systemFontOfSize:8.0f];
        // 圆角6
    }
    return _stepStatus;
}
- (UIImageView *)stepUserImage{
    if (_stepUserImage == nil) {
        _stepUserImage = [[UIImageView alloc] init];
        _stepUserImage.image = [UIImage imageNamed:@"test-1"];
    }
    return _stepUserImage;
}
- (UILabel *)stepUserDispose{
    if (_stepUserDispose == nil) {
        _stepUserDispose = [[UILabel alloc] init];
        _stepUserDispose.text = @"提出情况";
        _stepUserDispose.textColor = [SZUtil colorWithHex:@"#4D8AF3"];
        _stepUserDispose.font = [UIFont systemFontOfSize:9.0f];
    }
    return _stepUserDispose;
}
- (UILabel *)stepUserName{
    if (_stepUserName == nil) {
        _stepUserName = [[UILabel alloc] init];
        _stepUserName.text = @"刘超";
        _stepUserName.textColor = [SZUtil colorWithHex:@"#999999"];
        _stepStatus.font = [UIFont systemFontOfSize:11.0f];
    }
    return _stepUserName;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
