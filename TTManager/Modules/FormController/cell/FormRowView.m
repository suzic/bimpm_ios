//
//  FormRowView.m
//  TTManager
//
//  Created by chao liu on 2021/1/20.
//

#import "FormRowView.h"
#import "PopViewController.h"

@interface FormRowView ()<UIPopoverPresentationControllerDelegate,PopViewSelectedIndexDelegate>

@end

@implementation FormRowView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    [self.keyTextField borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeRight];
    [self.formKeyTypeButton borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeRight];
}
- (void)setItemRowContent:(id)data type:(FormItemType)itemType edit:(BOOL)edit{
    switch (itemType) {
        case formItemType_name:
            break;
        case formItemType_system:
            break;
        case formItemType_content:
            break;
        case formItemType_edit:
            break;
        default:
            break;
    }
}
#pragma mark - action
- (void)showKeyType:(UIButton *)button{
    PopViewController *popView = [[PopViewController alloc] init];
    popView.delegate = self;
    popView.view.alpha = 1.0;
    NSMutableArray *projectlist = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11", nil];
    popView.dataList = projectlist;
    popView.modalPresentationStyle = UIModalPresentationPopover;
    
    popView.popoverPresentationController.sourceView = button;
    popView.popoverPresentationController.sourceRect = CGRectMake(button.frame.origin.x+button.frame.size.width/2, button.frame.origin.y, 0, 0);
    popView.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown; //箭头方向
    popView.popoverPresentationController.delegate = self;
    [[SZUtil getCurrentVC] presentViewController:popView animated:YES completion:nil];
}
- (void)changeTextFiledPlaceholderColor:(NSString *)placeholder textFiled:(UITextField *)textFiled{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:RGB_COLOR(153, 153, 153 ),NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:style}];
    textFiled.layer.borderColor = RGB_COLOR(153, 153, 153).CGColor;
    textFiled.layer.cornerRadius = 2;
    textFiled.attributedPlaceholder = attri;
}
- (void)changeValueFieldLeft:(BOOL)left{
    self.keyTextField.hidden = left;
    [self.valueTextField updateConstraints:^(MASConstraintMaker *make) {
        if (left == YES) {
            make.left.equalTo(10);
        }else{
            make.left.equalTo((kScreenWidth-20)/3);
        }
    }];
}
#pragma mark - PopViewSelectedIndexDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}
- (void)popViewControllerSelectedCellIndexContent:(NSIndexPath *)indexPath{
}
#pragma mark - UI
- (void)addUI{
    [self addSubview:self.keyTextField];
    [self addSubview:self.formKeyTypeButton];
    [self addSubview:self.valueTextField];
    
    self.formKeyTypeButton.hidden = YES;
    
    [self changeTextFiledPlaceholderColor:self.keyTextField.placeholder textFiled:self.keyTextField];
    
    [self.keyTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
        make.width.equalTo(self).multipliedBy(0.3);
    }];
    [self.formKeyTypeButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
        make.width.equalTo(self).multipliedBy(0.3);
    }];
    
    [self.valueTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.left.equalTo((kScreenWidth-20)/3);
    }];
}
#pragma mark - setter and getter
- (UITextField *)keyTextField{
    if (_keyTextField == nil) {
        _keyTextField = [[UITextField alloc] init];
        _keyTextField.placeholder = @"请填写字段名称";
        _keyTextField.font = [UIFont systemFontOfSize:16];
        _keyTextField.textColor = RGB_COLOR(51, 51, 51);
        _keyTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _keyTextField;
}
- (UITextField *)valueTextField{
    if (_valueTextField == nil) {
        _valueTextField = [[UITextField alloc] init];
        _valueTextField.placeholder = @"数据源";
        _valueTextField.font = [UIFont systemFontOfSize:16];
        _keyTextField.textColor = RGB_COLOR(51, 51, 51);
    }
    return _valueTextField;
}
- (UIButton *)formKeyTypeButton{
    if (_formKeyTypeButton == nil) {
        _formKeyTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_formKeyTypeButton setTitle:@"字符串" forState:UIControlStateNormal];
        [_formKeyTypeButton setImage:[UIImage imageNamed:@"button_ down"] forState:UIControlStateNormal];
        [_formKeyTypeButton setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
        [_formKeyTypeButton addTarget:self action:@selector(showKeyType:) forControlEvents:UIControlEventTouchUpInside];
        [_formKeyTypeButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        _formKeyTypeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        _formKeyTypeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _formKeyTypeButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
