//
//  PollingHeaderView.m
//  TTManager
//
//  Created by chao liu on 2021/2/13.
//

#import "PollingHeaderView.h"

@interface PollingHeaderView ()

@property (nonatomic, strong) UILabel *pollingUserlabel;
@property (nonatomic, strong) UIButton *saveFormBtn;
@property (nonatomic, strong) UILabel *pollingFormCode;

@end

@implementation PollingHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)setFormHeaderData:(NSDictionary *)dic index:(NSInteger)index{
    self.pollingFormCode.text = dic[@"code"];
    switch (index) {
        case 0:
            self.pollingUserlabel.text = [NSString stringWithFormat:@"%@发起巡检",dic[@"name"]];
            break;
        case 1:
            self.pollingUserlabel.text = [NSString stringWithFormat:@"%@进行整改",dic[@"name"]];
            break;
        case 2:
            self.pollingUserlabel.text = [NSString stringWithFormat:@"%@进行情况确认",dic[@"name"]];
            break;
        default:
            break;
    }
}

- (void)saveFormAction:(UIButton *)button{
    [self routerEventWithName:save_edit_form userInfo:@{@"save":@(1)}];
}
- (void)addUI{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bgView];
    
    [self addSubview:self.pollingFormCode];
    
    [bgView addSubview:self.pollingUserlabel];
    [bgView addSubview:self.saveFormBtn];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(self).multipliedBy(0.5);
    }];
    
    [self.pollingFormCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(bgView.mas_bottom);
        make.bottom.equalTo(0);
    }];
    
    [self.pollingUserlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(10);
        make.bottom.equalTo(0);
    }];
    
    [self.saveFormBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(-10);
    }];
}

#pragma mark - setter and getter

- (UILabel *)pollingUserlabel{
    if (_pollingUserlabel == nil) {
        _pollingUserlabel = [[UILabel alloc] init];
        _pollingUserlabel.font = [UIFont systemFontOfSize:16];
        _pollingUserlabel.textColor = RGB_COLOR(51, 51, 51);
        _pollingUserlabel.textAlignment = NSTextAlignmentLeft;
    }
    return _pollingUserlabel;
}

- (UIButton *)saveFormBtn{
    if (_saveFormBtn == nil) {
        _saveFormBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveFormBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveFormBtn setTitleColor:RGB_COLOR(25, 107, 248) forState:UIControlStateNormal];
        _saveFormBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_saveFormBtn addTarget:self action:@selector(saveFormAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveFormBtn;
}
- (UILabel *)pollingFormCode{
    if (_pollingFormCode == nil) {
        _pollingFormCode = [[UILabel alloc] init];
        _pollingFormCode.font = [UIFont systemFontOfSize:16];
        _pollingFormCode.textColor = RGB_COLOR(51, 51, 51);
        _pollingFormCode.textAlignment = NSTextAlignmentLeft;
    }
    return _pollingFormCode;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
