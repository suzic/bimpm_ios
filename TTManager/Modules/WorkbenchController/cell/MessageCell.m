//
//  MessageCell.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "MessageCell.h"
#import "MessageView.h"

@interface MessageCell ()

@property (nonatomic,strong) MessageView *msgView;
@property (weak, nonatomic) IBOutlet UIView *bottomMore;
@property (weak, nonatomic) IBOutlet UIView *logsView;

@end
@implementation MessageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    // [self.bgView borderForColor:RGB_COLOR(204, 204, 204) borderWidth:1 borderType:UIBorderSideTypeAll];
    // [self.bgView borderForColor:UIColor.whiteColor borderWidth:1 borderType:UIBorderSideTypeAll];
    self.bgView.layer.cornerRadius = 4.0f;
    self.bottomMore.layer.cornerRadius = 4.0f;
    self.bgView.layer.shadowRadius = 4.0f;
    self.bgView.layer.shadowOpacity = 0.5f;
    self.bgView.layer.shadowOffset = CGSizeZero;
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    [self.moreButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    
    [self.logsView insertSubview:self.msgView atIndex:0];
    [self.msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.bottom.equalTo(-48);
    }];
}

- (IBAction)moreMessageAction:(id)sender
{
    [self routerEventWithName:MoreMessage userInfo:@{}];
}

- (void)setGanntInfoList:(NSArray *)ganntInfoList
{
    if (_ganntInfoList != ganntInfoList) {
        _ganntInfoList = ganntInfoList;
        self.msgView.messageArray = _ganntInfoList;
    }
}

- (MessageView *)msgView
{
    if (_msgView == nil) {
        _msgView = [[MessageView alloc] init];
    }
    return _msgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
