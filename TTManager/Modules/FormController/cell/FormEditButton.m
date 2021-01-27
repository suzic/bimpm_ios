//
//  FormEditButton.m
//  TTManager
//
//  Created by chao liu on 2021/1/27.
//

#import "FormEditButton.h"

@interface FormEditButton ()

@property (nonatomic, strong) UIButton *startEditBtn;
@property (nonatomic, strong) UISwitch *changEditStatusSwitch;

@end

@implementation FormEditButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
#pragma mark - actions
- (void)startEditForm:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startEditCurrentForm)]) {
        [self.delegate startEditCurrentForm];
    }
}
- (void)switchChange:(UISwitch *)mySwitch{
    if (mySwitch.on == YES) {
    }else if(mySwitch.on == NO){
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelEditCurrentForm)]) {
            [self.delegate cancelEditCurrentForm];
        }
    }
}
- (void)resetEditButtonStyle:(BOOL)defaultStyle{
    if (defaultStyle == YES) {
        self.startEditBtn.hidden = NO;
        self.changEditStatusSwitch.hidden = YES;
    }else{
        self.startEditBtn.hidden = YES;
        self.changEditStatusSwitch.hidden = NO;
        self.changEditStatusSwitch.on = YES;
    }
}
#pragma mark - ui
- (void)addUI{
    [self addSubview:self.startEditBtn];
    [self addSubview:self.changEditStatusSwitch];
    self.changEditStatusSwitch.hidden = YES;
    [self.startEditBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(0);
        make.width.equalTo(80);
    }];
    [self.changEditStatusSwitch makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
    }];
}
#pragma mark - setter and getter
- (UIButton *)startEditBtn{
    if (_startEditBtn == nil) {
        _startEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startEditBtn setTitle:@"开始编辑" forState:UIControlStateNormal];
        _startEditBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _startEditBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_startEditBtn addTarget:self action:@selector(startEditForm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startEditBtn;;
}
- (UISwitch *)changEditStatusSwitch{
    if (_changEditStatusSwitch == nil) {
        _changEditStatusSwitch = [[UISwitch alloc] init];
        _changEditStatusSwitch.on = YES;
        [_changEditStatusSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _changEditStatusSwitch;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
