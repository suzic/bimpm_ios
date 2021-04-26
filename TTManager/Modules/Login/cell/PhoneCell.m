//
//  PhoneCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/23.
//

#import "PhoneCell.h"

@interface PhoneCell ()<UITextFieldDelegate>

@end

@implementation PhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.phoneTextField.delegate = self;
    [self changeTextFiledPlaceholderColor:self.phoneTextField.placeholder textFiled:self.phoneTextField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self routerEventWithName:phone_change userInfo:@{@"phone":textField.text}];
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
