//
//  DocumentLibCell.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "DocumentLibCell.h"

@implementation DocumentLibCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCurrentUser:(ZHUser *)currentUser{
    if (_currentUser != currentUser) {
        _currentUser = currentUser;
        [self.documentIcon sd_setImageWithURL:[NSURL URLWithString:_currentUser.avatar] placeholderImage:[UIImage imageNamed:@"test-1"]];
        self.documentTitle.text = _currentUser.name;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
