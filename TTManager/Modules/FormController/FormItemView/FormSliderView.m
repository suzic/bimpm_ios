//
//  FormSliderView.m
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import "FormSliderView.h"

@interface FormSliderView ()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *sliderValueLabel;

@end

@implementation FormSliderView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

#pragma mark - public

- (void)setItemEdit:(BOOL)edit data:(NSDictionary *)data{
    self.slider.enabled = edit;
    
    if ([SZUtil isEmptyOrNull:data[@"instance_value"]]) {
        self.slider.value = 0;
    }else{
        self.slider.value = [data[@"instance_value"] intValue];
    }
    self.sliderValueLabel.text = [NSString stringWithFormat:@"%.02f%%",self.slider.value];
}

#pragma mark - action

- (void)sliderValueDidChanged:(UISlider *)slider{
    NSString *string = [NSString stringWithFormat:@"%.02f%%",slider.value];
    self.sliderValueLabel.text = string;
}

- (void)sliderValueDidEnd:(UISlider *)slider{
    NSLog(@"当前拖动的距离 %f",slider.value);
    NSString *string = [NSString stringWithFormat:@"%.02f%%",slider.value];
    [self routerEventWithName:form_edit_item userInfo:@{@"value":string}];
}

- (void)addUI{
    [self addSubview:self.slider];
    [self addSubview:self.sliderValueLabel];
    
    [self.slider makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
    }];
    
    [self.sliderValueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.equalTo(70);
        make.right.equalTo(-15);
        make.left.equalTo(self.slider.mas_right);
    }];
    
}

#pragma mark - setter and getter

- (UISlider *)slider{
    if (_slider == nil) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 100;
        [_slider setContinuous:YES];
        [_slider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderValueDidEnd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}

- (UILabel *)sliderValueLabel{
    if (_sliderValueLabel == nil) {
        _sliderValueLabel = [[UILabel alloc] init];
        _sliderValueLabel.font = [UIFont systemFontOfSize:16];
        _sliderValueLabel.textColor = RGB_COLOR(51, 51, 51);
    }
    return _sliderValueLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
