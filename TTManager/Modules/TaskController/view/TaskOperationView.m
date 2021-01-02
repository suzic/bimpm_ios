//
//  TaskOperationView.m
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import "TaskOperationView.h"

@interface TaskOperationView ()
// 保存
@property (nonatomic, strong) UIButton *saveBtn;
// 选择预计完成
@property (nonatomic, strong) UIButton *predictTimeBtn;
// 预计完成时间
@property (nonatomic, strong) UILabel *predictTimeLabel;
// 灰色同意 暂时不知啥操作
@property (nonatomic, strong) UIButton *grayAgreeBtn;
// 同意
@property (nonatomic, strong) UIButton *agreeBtn;
// 拒绝
@property (nonatomic, strong) UIButton *rejectBtn;

@end

@implementation TaskOperationView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)addUI{
    UIView *bgView = [[UIView alloc] init];
    [bgView addSubview:self.predictTimeBtn];
    [bgView addSubview:self.saveBtn];
    [self addSubview:bgView];
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:self.predictTimeLabel];
    [view addSubview:self.grayAgreeBtn];
    [view addSubview:self.agreeBtn];
    [view addSubview:self.rejectBtn];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_COLOR(238, 238, 238);
    [view addSubview:lineView];
    [self addSubview:view];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(self).multipliedBy(0.5);
    }];
    
    [self.predictTimeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(18);
        make.centerY.equalTo(bgView);
        make.width.equalTo(bgView).multipliedBy(0.5);
    }];
    [self.saveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-12);
        make.centerY.equalTo(bgView);
    }];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom);
        make.left.right.bottom.equalTo(0);
    }];
    [self.predictTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(18);
        make.centerY.equalTo(view);
    }];
    [self.rejectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(0);
        make.width.equalTo(70);
    }];
    [self.agreeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.grayAgreeBtn.mas_right);
        make.right.equalTo(self.rejectBtn.mas_left);
        make.width.equalTo(self.rejectBtn.mas_width);
        make.height.equalTo(self.rejectBtn.mas_height);
    }];
    [self.grayAgreeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.predictTimeLabel.mas_right);
        make.right.equalTo(self.agreeBtn.mas_left);
        make.width.equalTo(self.rejectBtn.mas_width);
        make.height.equalTo(self.rejectBtn.mas_height);
    }];
}
#pragma mark - setting and getter
- (UIButton *)saveBtn{
    if (_saveBtn == nil) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:RGB_COLOR(25, 107, 248) forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _saveBtn;
}
- (UIButton *)predictTimeBtn{
    if (_predictTimeBtn == nil) {
        _predictTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_predictTimeBtn setTitle:@"预计处理时间" forState:UIControlStateNormal];
        [_predictTimeBtn setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
        _predictTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_predictTimeBtn setImage:[UIImage imageNamed:@"task_time"] forState:UIControlStateNormal];
        _predictTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_predictTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        _predictTimeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    return _predictTimeBtn;
}
- (UILabel *)predictTimeLabel{
    if (_predictTimeLabel == nil) {
        _predictTimeLabel = [[UILabel alloc] init];
        _predictTimeLabel.font = [UIFont systemFontOfSize:13.0];
        _predictTimeLabel.textColor = RGB_COLOR(51, 51, 51);
        _predictTimeLabel.text = @"2021-1-30";
    }
    return _predictTimeLabel;
}
- (UIButton *)grayAgreeBtn{
    if (_grayAgreeBtn == nil) {
        _grayAgreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_grayAgreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_grayAgreeBtn setTitleColor:RGB_COLOR(25, 107, 248) forState:UIControlStateNormal];
        _grayAgreeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_grayAgreeBtn setBackgroundColor:RGB_COLOR(244, 244, 244)];
    }
    return _grayAgreeBtn;
}
- (UIButton *)agreeBtn{
    if (_agreeBtn == nil) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_agreeBtn setBackgroundColor:RGB_COLOR(0, 203, 105)];
    }
    return _agreeBtn;
}
- (UIButton *)rejectBtn{
    if (_rejectBtn == nil) {
        _rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rejectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rejectBtn setBackgroundColor:RGB_COLOR(239, 89, 95)];
    }
    return _rejectBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
