//
//  FormItemsView.m
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import "FormItemsView.h"
#import "FormItemTextView.h"
#import "FormSliderView.h"
#import "FormItemBtnView.h"
#import "FormItemImageView.h"

@interface FormItemsView ()<UITextViewDelegate>

/// 标题
@property (nonatomic, strong) UILabel *formTitleLabel;
/// 输入框
@property (nonatomic, strong) FormItemTextView *textView;
/// 进度条
@property (nonatomic, strong) FormSliderView *sliderView;
/// button
@property (nonatomic, strong) FormItemBtnView *btnView;
/// 图片
@property (nonatomic, strong) FormItemImageView *imageView;

@property (nonatomic, assign) FormItemType itemType;

@end

@implementation FormItemsView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

#pragma mark - UI

- (void)addUI{
    
    [self addSubview:self.formTitleLabel];
    [self addSubview:self.textView];
    [self addSubview:self.sliderView];
    [self addSubview:self.imageView];
    [self addSubview:self.btnView];
    
    [self.formTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(10);
        make.width.equalTo(self).multipliedBy(0.25);
        make.height.equalTo(44);
    }];
    
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.formTitleLabel.mas_right);
        make.top.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
    
    [self.sliderView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.formTitleLabel.mas_right);
        make.top.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
    
    [self.btnView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.formTitleLabel.mas_right);
        make.top.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.formTitleLabel.mas_right);
        make.top.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
}

#pragma mark - public

- (void)setItemView:(FormItemType)type edit:(BOOL)edit data:(NSDictionary *)data{
    self.formTitleLabel.text = data[@"name"];
    // 设置页面显示
    [self setItemViewByType:type];
    // 设置页面是否可编辑
    [self setItemViewEdit:edit data:data];
}
- (UIView *)getViewByType:(FormItemType)type{
    UIView *view = nil;
    switch (self.itemType) {
        case formItemType_image:
            view = self.imageView;
            break;
        case formItemType_text:
            view = self.textView;
            break;
        case formItemType_btn:
            view = self.btnView;
            break;
        case formItemType_slider:
            view = self.sliderView;
            break;
        default:
            break;
    }
    return view;
}
#pragma mark - private

// 设置页面的显示和隐藏
- (void)setItemViewByType:(FormItemType)type{
    self.itemType = type;
    self.imageView.hidden = !(type == formItemType_image);
    self.textView.hidden = !(type == formItemType_text);
    self.btnView.hidden = !(type == formItemType_btn);
    self.sliderView.hidden = !(type == formItemType_slider);
}
// 设置当前item是否可编辑
- (void)setItemViewEdit:(BOOL)edit data:(NSDictionary *)data{
    switch (self.itemType) {
        case formItemType_image:
            [self.imageView setItemEdit:edit data:data];
            break;
        case formItemType_text:
            [self.textView setItemEdit:edit data:data];
            break;
        case formItemType_btn:
            [self.btnView setItemEdit:edit data:data];
            break;
        case formItemType_slider:
            [self.sliderView setItemEdit:edit data:data];
            break;
        default:
            break;
    }
}

#pragma mark - setter and getter

- (UILabel *)formTitleLabel{
    if (_formTitleLabel == nil) {
        _formTitleLabel = [[UILabel alloc] init];
        _formTitleLabel.font = [UIFont systemFontOfSize:16];
        _formTitleLabel.textColor = RGB_COLOR(51, 51, 51);
        _formTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _formTitleLabel;
}

- (FormItemTextView *)textView{
    if (_textView == nil) {
        _textView = [[FormItemTextView alloc] init];
    }
    return _textView;
}

- (FormItemBtnView *)btnView{
    if (_btnView == nil) {
        _btnView = [[FormItemBtnView alloc] init];
    }
    return _btnView;
}

- (FormItemImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[FormItemImageView alloc] init];
    }
    return _imageView;
}

- (FormSliderView *)sliderView{
    if (_sliderView == nil) {
        _sliderView = [[FormSliderView alloc] init];
    }
    return _sliderView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
