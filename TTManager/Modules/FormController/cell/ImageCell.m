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
- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(NSString *)imageUrl imageType:(NSInteger)type{
    self.isFormEdit = isFormEdit;
    self.indexPath = indexPath;
    if (type == 1) {
        [self imageData:imageUrl];
    }else if(type == 2){
        [self.fromImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"empty_url_image"]];
    }
}
- (void)imageData:(NSString *)imageData{
    NSArray *imageDataArray = [imageData componentsSeparatedByString:@","];
    if (imageDataArray.count > 1) {
        NSString *imageString = imageDataArray[1];
        NSString *imageEncrypt = imageDataArray[0];
        NSArray *encrypt = [imageEncrypt componentsSeparatedByString:@";"];
        if (encrypt.count >1) {
            NSString *encryptType = encrypt[1];
            if ([encryptType isEqualToString:@"base64"]) {
                // Base64形式的字符串为data
                NSData *data = [[NSData alloc] initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
                self.fromImageView.image = [UIImage imageWithData:data];
                CGImageRef cgref = [self.fromImageView.image CGImage];
                CIImage *cim = [self.fromImageView.image CIImage];
                if (cim == nil && cgref == NULL)
                {
                    self.fromImageView.image = [UIImage imageNamed:@"empty_url_image"];
                }
            }
        }
    }
}
- (void)hideAddButton:(BOOL)hide{
    if (hide == YES) {
        self.deleteButton.hidden = !self.isFormEdit;
        self.fromImageView.hidden = NO;
        self.addButton.hidden = YES;
    }else{
        self.deleteButton.hidden = !self.isFormEdit;
        self.fromImageView.hidden = YES;
        self.addButton.hidden = NO;
    }
}
#pragma maek - setter and getter
- (UIImageView *)fromImageView{
    if (_fromImageView == nil) {
        _fromImageView = [[UIImageView alloc] init];
        _fromImageView.image = [UIImage imageNamed:@"empty_url_image"];
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
        [_addButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    }
    return _addButton;
}
@end
