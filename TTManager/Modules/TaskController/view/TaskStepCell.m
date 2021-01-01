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

- (void)addUI{
    [self.contentView addSubview:self.stepView];
    [self.stepView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
}
#pragma mark - setting and getter
- (StepUserView *)stepView{
    if (_stepView == nil) {
        _stepView = [[StepUserView alloc] init];
    }
    return _stepView;
}
@end
