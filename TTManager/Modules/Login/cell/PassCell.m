//
//  PassCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/23.
//

#import "PassCell.h"

@implementation PassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self changeTextFiledPlaceholderColor:self.passWordtextField.placeholder textFiled:self.passWordtextField];
}
- (IBAction)cleanPassWord:(id)sender {
    self.passWordtextField.text = @"";
}
- (IBAction)showPassWordInforAction:(id)sender {
    self.passWordtextField.secureTextEntry = !self.passWordtextField.secureTextEntry;
    UIButton *button = (UIButton *)sender;
    NSString *image = self.passWordtextField.secureTextEntry == YES ? @"hide_psd" : @"show_psd";
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}
- (void)changeTextFiledPlaceholderColor:(NSString *)placeholder textFiled:(UITextField *)textFiled{

    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    textFiled.attributedPlaceholder = attributedPlaceholder;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
