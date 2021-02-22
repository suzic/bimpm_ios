//
//  EmptyConversationView.m
//  TTManager
//
//  Created by chao liu on 2021/2/22.
//

#import "EmptyConversationView.h"

@interface EmptyConversationView ()

@property (nonatomic, strong) UILabel *emptyLabel;

@end

@implementation EmptyConversationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI{
    [self addSubview:self.emptyLabel];
    [self.emptyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)emptyLabel{
    if (_emptyLabel == nil) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.text = @"暂无会话列表";
        _emptyLabel.font = [UIFont systemFontOfSize:24.0f];
        _emptyLabel.textColor = [UIColor blackColor];
    }
    return _emptyLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
