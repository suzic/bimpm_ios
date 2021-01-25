//
//  BottomView.m
//  TTManager
//
//  Created by chao liu on 2021/1/25.
//

#import "BottomView.h"

@interface BottomView ()
@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)saveButtonAction:(UIButton *)button{
    [self routerEventWithName:save_edit_form userInfo:@{}];
}
- (void)addUI{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self addSubview:self.saveButton];
    [self.saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.top.bottom.equalTo(0);
        make.width.equalTo(self).multipliedBy(0.25);
    }];
}
- (UIButton *)saveButton{
    if (_saveButton == nil) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.backgroundColor = RGB_COLOR(25, 107, 248);
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _saveButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
