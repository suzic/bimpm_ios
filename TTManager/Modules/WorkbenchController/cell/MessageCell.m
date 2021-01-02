//
//  MessageCell.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "MessageCell.h"
#import "MessageView.h"

@interface MessageCell ()

@property (nonatomic,strong)MessageView *msgView;

@end
@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView borderForColor:RGB_COLOR(204, 204, 204) borderWidth:1 borderType:UIBorderSideTypeAll];
    [self.moreButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.bgView insertSubview:self.msgView atIndex:0];
    [self.msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgView);
        make.trailing.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
    }];
}
- (IBAction)moreMessageAction:(id)sender {
    [self routerEventWithName:MoreMessage userInfo:@{}];
}

- (MessageView *)msgView{
    if (_msgView == nil) {
        _msgView = [[MessageView alloc] init];
    }
    return _msgView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
