//
//  MsgCell.m
//  TTManager
//
//  Created by chao liu on 2021/11/25.
//

#import "MsgCell.h"

@interface MsgCell ()
@property (nonatomic, strong) UIImageView *dotImageView;
@property (nonatomic, strong) UILabel *detailsLabel;
@end

@implementation MsgCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)setMsgData:(id)msgData{
    if (_msgData != msgData) {
        _msgData = msgData;
        if ([_msgData isKindOfClass:[NSString class]])
        {
            self.detailsLabel.text = (NSString *)_msgData;
        }else if([_msgData isKindOfClass:[ZHProjectMemo class]]){
            ZHProjectMemo *memo = (ZHProjectMemo *)_msgData;
            self.detailsLabel.text = memo.line;
        }
    }
}

- (void)addUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.dotImageView];
    [self.contentView addSubview:self.detailsLabel];
    
    [self.dotImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12);
        make.top.equalTo(14);
        make.width.height.equalTo(20);
    }];
    [self.detailsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dotImageView.mas_top);
        make.left.equalTo(self.dotImageView.mas_right).offset(8);
        make.right.equalTo(-24);
        make.bottom.equalTo(-8);
    } ];
}

- (UIImageView *)dotImageView{
    if (_dotImageView == nil) {
        _dotImageView = [[UIImageView alloc] init];
        _dotImageView.image = [UIImage imageNamed:@"dot.png"];
    }
    return _dotImageView;
}

- (UILabel *)detailsLabel{
    if (_detailsLabel == nil) {
        _detailsLabel = [[UILabel alloc] init];
        _detailsLabel.font = [UIFont systemFontOfSize:14.0f];
        _detailsLabel.textColor = [UIColor whiteColor];
        _detailsLabel.numberOfLines = 0;
    }
    return _detailsLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
