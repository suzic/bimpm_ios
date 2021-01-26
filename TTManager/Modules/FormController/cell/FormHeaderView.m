//
//  FormHeaderView.m
//  TTManager
//
//  Created by chao liu on 2021/1/26.
//

#import "FormHeaderView.h"

@interface FormHeaderView ()<UITextViewDelegate>

//@property (nonatomic, strong) UITextView *formTitleTextView;
// 快照
@property (nonatomic, strong) UIView *snapshootView;
@property (nonatomic, strong) UILabel *snapshootInfoLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;

@end

@implementation FormHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)addUI{
    [self addSnapshootView];
}
//- (void)addTextView{
//    [self addSubview:self.formTitleTextView];
//    [self.formTitleTextView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(8);
//        make.right.equalTo(-5);
//        make.top.equalTo(10);
//        make.bottom.equalTo(0);
//        make.height.greaterThanOrEqualTo(44);
//        make.height.lessThanOrEqualTo(44*3);
//    }];
//}
- (void)addSnapshootView{
    [self addSubview:self.snapshootView];
    [self.snapshootView addSubview:self.snapshootInfoLabel];
    [self.snapshootView addSubview:self.updateTimeLabel];
    [self.snapshootView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
    [self.snapshootInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [self.updateTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(-5);
        make.bottom.equalTo(0);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
}
//#pragma mark - UITextViewDelegate
//-(void)textViewDidChange:(UITextView *)textView{
//
//    NSInteger height = ([self.formTitleTextView sizeThatFits:CGSizeMake(self.formTitleTextView.bounds.size.width, MAXFLOAT)].height);
//    NSLog(@"当前textView的高度是---%ld",height);
//    if (height > 44*3) {
//        textView.scrollEnabled = YES;
//        height = 44*3;
//    }else if(height <= 44){
//        height = 44;
//    }
//    [self.formTitleTextView updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(height);
//    }];
//}
#pragma mark - setter and getter
//- (void)setShowTextView:(BOOL)showTextView{
//    _showTextView = showTextView;
//    if (_showTextView == YES) {
//        [self addTextView];
//    }else{
//        [self addSnapshootView];
//    }
//}
//- (UITextView *)formTitleTextView{
//    if (_formTitleTextView == nil) {
//        _formTitleTextView = [[UITextView alloc] init];
//        _formTitleTextView.font = [UIFont systemFontOfSize:16];
//        _formTitleTextView.textColor = RGB_COLOR(51, 51, 51);
//        _formTitleTextView.placeholderColor = [UIColor lightGrayColor];
//        _formTitleTextView.delegate = self;
//        _formTitleTextView.placeholder = @"表单名称";
//        [self textViewDidChange:_formTitleTextView];
//    }
//    return _formTitleTextView;
//}
- (UIView *)snapshootView{
    if (_snapshootView == nil) {
        _snapshootView = [[UIView alloc] init];
    }
    return _snapshootView;
}
- (UILabel *)snapshootInfoLabel{
    if (_snapshootInfoLabel == nil) {
        _snapshootInfoLabel = [[UILabel alloc] init];
        _snapshootInfoLabel.font = [UIFont systemFontOfSize:16];
        _snapshootInfoLabel.text = @"这是一份历史快照";
        _snapshootInfoLabel.textColor = [UIColor redColor];
    }
    return _snapshootInfoLabel;
}
- (UILabel *)updateTimeLabel{
    if (_updateTimeLabel == nil) {
        _updateTimeLabel = [[UILabel alloc] init];
        _updateTimeLabel.font = [UIFont systemFontOfSize:16];
        _updateTimeLabel.textColor = RGB_COLOR(25, 107, 248);
        _updateTimeLabel.text = [SZUtil getTimeNow];
        _updateTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _updateTimeLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
