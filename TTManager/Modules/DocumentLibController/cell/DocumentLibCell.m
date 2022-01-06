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
    _target = target;
    NSString *fileIconImage = [self getCurrentfileTypeImageView:_target];
    self.documentIcon.image = [UIImage imageNamed:fileIconImage];
    if ([SZUtil isEmptyOrNull:_target.uid_target] && _target.is_file == 0) {
        if (_target.id_module == 0) {
            self.documentTitle.text = @"文档";
        }else if(_target.id_module == 8){
            self.documentTitle.text = @"大屏配置";
        }else if(_target.id_module == 9){
            self.documentTitle.text = @"表单文件";
        }else if(_target.id_module == 10){
            self.documentTitle.text = @"任务附件";
        }else if(_target.id_module > 10){
            self.documentTitle.text = [NSString stringWithFormat:@"%@文件",_target.name];
        }
    }else{
        self.documentTitle.text = _target.name;
        }
}
- (NSString *)getCurrentfileTypeImageView:(ZHTarget *)target{
    NSString *name = @"file_group";
    // 文件夹
    if (target.is_file == 0) {
        name = @"file_group";
//        self.arrowImg.hidden = NO;
    }
    // 文件
    else if(target.is_file == 1){
        name = [NSString stringWithFormat:@"file_Image_%d",target.type];
//        self.arrowImg.hidden = YES;
    }
    return name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
