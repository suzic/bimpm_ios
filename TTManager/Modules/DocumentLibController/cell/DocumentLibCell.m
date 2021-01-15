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
        NSLog(@"%@",_currentUser.name);
    }
}
- (void)setTarget:(ZHTarget *)target{
    if (_target != target) {
        _target = target;
        NSString *fileIconImage = [self getCurrentfileTypeImageView:_target];
        self.documentIcon.image = [UIImage imageNamed:fileIconImage];
        self.documentTitle.text = _target.name;
    }
}
- (NSString *)getCurrentfileTypeImageView:(ZHTarget *)target{
    NSString *name = @"file_group";
    // 文件夹
    if (target.is_file == 0) {
        name = @"file_group";
    }
    // 文件
    else if(target.is_file == 1){
        name = [NSString stringWithFormat:@"file_Image_%d",target.type];
    }
    return name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
