//
//  MsgFooterView.m
//  TTManager
//
//  Created by chao liu on 2021/10/12.
//

#import "MsgFooterView.h"

@interface MsgFooterView ()

@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MsgFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addUI];
    }
    return self;
}
- (void)setMemo:(ZHProjectMemo *)memo{
    if (![SZUtil isEmptyOrNull:memo.last_user.name]) {
        self.authorLabel.text = [NSString stringWithFormat:@"作者:%@",memo.last_user.name];
    }else{
        self.authorLabel.text = [NSString stringWithFormat:@"作者:暂无"];
    }
    self.timeLabel.text = [SZUtil getTimeString:memo.edit_date];
}

- (void)addUI{
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.timeLabel];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:lineView];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(40);
        make.top.equalTo(0);
        make.bottom.equalTo(lineView.mas_top).offset(-5);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.4);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-24);
        make.top.equalTo(0);
        make.bottom.equalTo(lineView.mas_top).offset(-5);
        make.left.equalTo(self.authorLabel.mas_right);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.4);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(0);
        make.height.equalTo(0.5);
    }];
}

- (UILabel *)authorLabel{
    if (_authorLabel == nil) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.textColor = [UIColor whiteColor];
        _authorLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _authorLabel;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
