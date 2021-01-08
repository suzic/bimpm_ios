//
//  TaskStepFooterView.m
//  TTManager
//
//  Created by chao liu on 2021/1/8.
//

#import "TaskStepFooterView.h"

@interface TaskStepFooterView ()

@property (nonatomic, strong) UIImageView *addImageView;

@end

@implementation TaskStepFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addUI{
    [self addSubview:self.addImageView];
    [self.addImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.right.equalTo(-10);
        make.left.equalTo(0);
        make.height.equalTo(self.addImageView.mas_width);
    }];
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
