//
//  PhoneCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/23.
//

#import "PhoneCell.h"

@implementation PhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self changeTextFiledPlaceholderColor:self.phoneTextField.placeholder textFiled:self.phoneTextField];
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
