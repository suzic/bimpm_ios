//
//  TaskStepCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import "TaskStepCell.h"
#import "StepUserView.h"

@interface TaskStepCell ()

@property (nonatomic, strong) StepUserView *stepView;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;

@end

@implementation TaskStepCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setCurrentStep:(ZHStep *)currentStep{
    _currentStep = currentStep;
    self.stepView.step = _currentStep;
    NSLog(@"当前步骤的用户 %@",_currentStep.responseUser.name);
    if (_currentStep.responseUser != nil) {
        self.stepView.hidden = NO;
        self.addImageView.hidden = YES;
    }else{
        self.stepView.hidden = YES;
        self.addImageView.hidden = NO;
    }
}
- (void)setIsSelected:(BOOL)isSelected{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        if (_isSelected == YES) {
            [self showLineView];
        }else{
            [self hiddeenLineView];
        }
    }
}
- (void)addUI{
    
    [self.contentView addSubview:self.stepView];
    [self.contentView addSubview:self.addImageView];
    [self.stepView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
    
    [self.addImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.right.equalTo(-10);
        make.left.equalTo(0);
        make.height.equalTo(self.addImageView.mas_width);
    }];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = RGB_COLOR(153, 153, 153);
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = RGB_COLOR(153, 153, 153);
    [self.contentView addSubview:self.topLine];
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    self.leftLine = [[UIView alloc] init];
    self.leftLine.backgroundColor = RGB_COLOR(153, 153, 153);
    [self.contentView addSubview:self.leftLine];
    [self.leftLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.bottom.equalTo(0);
        make.width.equalTo(0.5);
    }];
    
    self.rightLine = [[UIView alloc] init];
    self.rightLine.backgroundColor = RGB_COLOR(153, 153, 153);
    [self.contentView addSubview:self.rightLine];
    [self.rightLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(0);
        make.bottom.equalTo(0);
        make.width.equalTo(0.5);
    }];
    [self hiddeenLineView];
}
- (void)hiddeenLineView{
    self.bottomLine.hidden = NO;
    self.topLine.hidden = YES;
    self.leftLine.hidden = YES;
    self.rightLine.hidden = YES;
}
- (void)showLineView{
    self.bottomLine.hidden = YES;
    self.topLine.hidden = NO;
    self.leftLine.hidden = NO;
    self.rightLine.hidden = NO;
}
#pragma mark - setting and getter
- (StepUserView *)stepView{
    if (_stepView == nil) {
        _stepView = [[StepUserView alloc] init];
    }
    return _stepView;
}
- (UIImageView *)addImageView{
    if (_addImageView == nil) {
        _addImageView = [[UIImageView alloc] init];
        _addImageView.contentMode = UIViewContentModeScaleAspectFit;
        _addImageView.image = [UIImage imageNamed:@"add_user"];
    }
    return _addImageView;
}

@end
