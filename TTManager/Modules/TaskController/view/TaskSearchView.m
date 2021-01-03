//
//  TaskSearchView.m
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import "TaskSearchView.h"

@interface TaskSearchView ()

@property (nonatomic, strong)UITextField *searchTextField;

@end

@implementation TaskSearchView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)addUI{
    [self addSubview:self.searchTextField];
    [self.searchTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.equalTo(5);
        make.right.equalTo(-5);
        make.bottom.equalTo(-10);
    }];
}

#pragma mark - setter and getter
- (UITextField *)searchTextField{
    if (_searchTextField == nil) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"搜索任务";
        _searchTextField.font = [UIFont systemFontOfSize:13.0f];
        _searchTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self changeTextFiledPlaceholderColor:_searchTextField.placeholder textFiled:_searchTextField];
        [_searchTextField borderForColor:RGB_COLOR(153, 153, 153) borderWidth:0.5 borderType:UIBorderSideTypeAll];
    }
    return _searchTextField;
}

- (void)changeTextFiledPlaceholderColor:(NSString *)placeholder textFiled:(UITextField *)textFiled{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:RGB_COLOR(153, 153, 153 ),NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:style}];
    textFiled.layer.borderColor = RGB_COLOR(153, 153, 153).CGColor;
    textFiled.layer.cornerRadius = 2;
    textFiled.attributedPlaceholder = attri;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
