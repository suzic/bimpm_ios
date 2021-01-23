//
//  VerificationCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/23.
//

#import "VerificationCell.h"

@implementation VerificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self changeTextFiledPlaceholderColor:self.verificationTextField.placeholder textFiled:self.verificationTextField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)changeTextFiledPlaceholderColor:(NSString *)placeholder textFiled:(UITextField *)textFiled{

    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    textFiled.attributedPlaceholder = attributedPlaceholder;
}
@end
