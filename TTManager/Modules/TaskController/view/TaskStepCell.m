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
- (void)setCurrentStep:(id)currentStep{
    if (_currentStep != currentStep) {
        _currentStep = currentStep;
        if ([_currentStep isKindOfClass:[ZHStep class]]) {
            self.stepView.step = (ZHStep *)_currentStep;
        }else if([_currentStep isKindOfClass:[ZHUser class]]){
            self.stepView.user = (ZHUser *)_currentStep;
        }
        if (_currentStep != nil) {
            self.stepView.hidden = NO;
            self.addImageView.hidden = YES;
        }else{
            self.stepView.hidden = YES;
            self.addImageView.hidden = NO;
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
