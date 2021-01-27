//
//  ImageCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/25.
//

#import "ImageCell.h"

@interface ImageCell ()

@property (nonatomic, strong) UIImageView *fromImageView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic ,assign) BOOL isFormEdit;
@end

@implementation ImageCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
#pragma mark - ui
- (void)addUI{
    UIView *bgView = [[UIView alloc] init];
    bgView.clipsToBounds = YES;
    [self.contentView addSubview:bgView];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.bottom.right.equalTo(-10);
    }];
    [bgView addSubview:self.fromImageView];
    [bgView addSubview:self.deleteButton];
    
    [self.contentView addSubview:self.addButton];
    [self.addButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.bottom.right.equalTo(-10);
    }];
    [self.fromImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
    [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.width.height.equalTo(15);
    }];
}
#pragma mark - actions
- (void)deleteFromImageAction:(UIButton *)button{
    [self routerEventWithName:delete_formItem_image userInfo:@{@"deleteIndex":self.indexPath}];
}
- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(NSString *)imageUrl{
    self.isFormEdit = isFormEdit;
    self.indexPath = indexPath;
    [self.fromImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"user_header"]];
}
- (void)hideAddButton:(BOOL)hide{
    if (hide == YES) {
        self.deleteButton.hidden = NO;
        self.fromImageView.hidden = NO;
        self.addButton.hidden = YES;
    }else{
        self.deleteButton.hidden = YES;
        self.fromImageView.hidden = YES;
        self.addButton.hidden = NO;
    }
}
#pragma maek - setter and getter
- (UIImageView *)fromImageView{
    if (_fromImageView == nil) {
        _fromImageView = [[UIImageView alloc] init];
        _fromImageView.image = [UIImage imageNamed:@"user_header"];
        _fromImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _fromImageView;
}
- (UIButton *)deleteButton{
    if (_deleteButton == nil) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteFromImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
- (UIButton *)addButton{
    if (_addButton == nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"add_user"] forState:UIControlStateNormal];
    }
    return _addButton;
}
@end
