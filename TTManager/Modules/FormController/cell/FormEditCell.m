//
//  FormEditCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import "FormEditCell.h"
#import "FormItemView.h"

@interface FormEditCell ()

//@property (nonatomic, strong) FormItemView *formItemView;

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UITextField *valueTextField;

@end
@implementation FormEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)setValueTextFieldStyleByItemStatus:(BOOL)isEdit{
    
}
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    [self.keyLabel borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeRight];
    [self.contentView borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeBottom];
}
- (void)addUI{
    [self addSubview:self.keyLabel];
    [self addSubview:self.valueTextField];
    
    [self.keyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
        make.width.equalTo(self).multipliedBy(0.3);
    }];
   
    [self.valueTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.left.equalTo(self.keyLabel.mas_right).offset(10);
    }];
}

#pragma mark - setter and getter
- (void)setFormItem:(ZHFormItem *)formItem{
    if (_formItem != formItem) {
        _formItem = formItem;
        self.keyLabel.text = _formItem.name;
        self.valueTextField.text = _formItem.d_name;
    }
}
- (void)setIsEdit:(BOOL)isEdit{
    if (_isEdit != isEdit) {
        _isEdit = isEdit;
        self.valueTextField.enabled = isEdit;
        [self setValueTextFieldStyleByItemStatus:isEdit];
    }
}
- (UILabel *)keyLabel{
    if (_keyLabel == nil) {
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.font = [UIFont systemFontOfSize:16];
        _keyLabel.textColor = RGB_COLOR(51, 51, 51);
        _keyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _keyLabel;
}
- (UITextField *)valueTextField{
    if (_valueTextField == nil) {
        _valueTextField = [[UITextField alloc] init];
        _valueTextField.placeholder = @"数据源";
        _valueTextField.font = [UIFont systemFontOfSize:16];
        _valueTextField.textColor = RGB_COLOR(51, 51, 51);
    }
    return _valueTextField;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
