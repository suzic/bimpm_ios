//
//  StepUserView.m
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import "StepUserView.h"

@interface StepUserView ()

// 步骤头像
@property (nonatomic, strong) UIImageView *stepUserImage;
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
        make.right.equalTo(-5);
        make.left.equalTo(5);
        make.height.equalTo(bgView.mas_width);
    }];
    [self.stepUserImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
    [self.stepStatus makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(2);
        make.width.equalTo(30);
        make.height.equalTo(12);
    }];
    [self.stepUserDispose makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(5);
        make.centerX.equalTo(bgView);
    }];
    [self.stepUserName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepUserDispose.mas_bottom).offset(6);
        make.centerX.equalTo(self.stepUserDispose);
    }];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    self.stepUserImage.clipsToBounds = YES;
    self.stepUserImage.layer.cornerRadius = _stepUserImage.frame.size.height/2;
    self.stepStatus.clipsToBounds = YES;
    self.stepStatus.layer.cornerRadius = 6.0f;
    
    
    self.stepUserDispose.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    self.stepUserDispose.layer.shadowOffset = CGSizeMake(0,0);
    self.stepUserDispose.layer.shadowOpacity = 1;
    self.stepUserDispose.layer.shadowRadius = 5;
    self.stepUserDispose.layer.cornerRadius = 8.5;
}

#pragma mark - private method
- (void)setUserInfo:(ZHUser *)user{
    [self.stepUserImage sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"test-1"]];
    self.stepUserName.text = user.name;
}

#pragma mark - setting and getter
- (void)setStep:(ZHStep *)step{
    _step = step;
    [self setUserInfo:_step.responseUser];
}

- (UILabel *)stepStatus{
    if (_stepStatus == nil) {
        _stepStatus = [[UILabel alloc] init];
        _stepStatus.font = [UIFont systemFontOfSize:8.0f];
        _stepStatus.textAlignment = NSTextAlignmentCenter;
    }
    return _stepStatus;
}
- (UIImageView *)stepUserImage{
    if (_stepUserImage == nil) {
        _stepUserImage = [[UIImageView alloc] init];
        _stepUserImage.image = [UIImage imageNamed:@"test-1"];
        _stepUserImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _stepUserImage;
}
- (UILabel *)stepUserDispose{
    if (_stepUserDispose == nil) {
        _stepUserDispose = [[UILabel alloc] init];
        _stepUserDispose.text = @"提出情况";
        _stepUserDispose.textColor = [SZUtil colorWithHex:@"#4D8AF3"];
        _stepUserDispose.font = [UIFont systemFontOfSize:9.0f];
        _stepUserDispose.backgroundColor = [UIColor whiteColor];
    }
    return _stepUserDispose;
}
- (UILabel *)stepUserName{
    if (_stepUserName == nil) {
        _stepUserName = [[UILabel alloc] init];
        _stepUserName.textColor = [SZUtil colorWithHex:@"#999999"];
        _stepUserName.font = [UIFont systemFontOfSize:11.0f];
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
