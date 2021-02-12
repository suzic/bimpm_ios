//
//  FormQRCodeView.m
//  TTManager
//
//  Created by chao liu on 2021/2/12.
//

#import "FormQRCodeView.h"

@interface FormQRCodeView ()

@property (nonatomic, strong) UIImageView *QRCodeImageView;

@end

@implementation FormQRCodeView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI{
    [self addSubview:self.QRCodeImageView];
    [self.QRCodeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
}

#pragma mark - setter and getter

- (void)setQRCodeString:(NSString *)QRCodeString{
    if (_QRCodeString != QRCodeString) {
        _QRCodeString = QRCodeString;
        self.QRCodeImageView.image = [SZUtil createNonInterpolatedUIImageFormCIImage:[SZUtil createQRForString:_QRCodeString] withSize:88];
    }
}

- (UIImageView *)QRCodeImageView{
    if (_QRCodeImageView == nil) {
        _QRCodeImageView = [[UIImageView alloc] init];
        _QRCodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _QRCodeImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
