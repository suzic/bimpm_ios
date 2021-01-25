//
//  FormEditCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import "FormEditCell.h"

@interface FormEditCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) NSDictionary *itemTypeValueDic;
@property (nonatomic, strong) NSMutableArray *enum_poolArray;
@property (nonatomic, strong) ZHFormItem *formItem;
@property (nonatomic, assign) BOOL isFormEdit;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) BRDatePickerView *datePickerView;

@end
@implementation FormEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUI];
        self.enum_poolArray = [NSMutableArray array];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)clickButtonAction:(UIButton *)button{
    NSLog(@"点击了我");
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    NSInteger type = [_formItem.type intValue];
    if (type == 3) {
        [self.datePickerView show];
    }
    //HH:mm:ss
    else if(type == 4){
        [self.superview.superview resignFirstResponder];
        [self.datePickerView show];
    }
    // 枚举
    else if(type == 5){
        [self.superview.superview resignFirstResponder];
        [self.enum_poolArray addObjectsFromArray:[_formItem.enum_pool componentsSeparatedByString:@","]];
        [self showActionSheets];
    }
}
#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self routerEventWithName:form_edit_item userInfo:@{@"indexPath":self.indexPath,@"value":self.valueTextField.text}];
}

#pragma mark - private

- (void)setValueTextFieldStyleByItemStatus:(BOOL)isEdit{
    if (isEdit == YES) {
        [self.valueTextField borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeAll];
        self.valueTextField.enabled = YES;
    }else{
        [self.valueTextField borderForColor:[UIColor clearColor] borderWidth:0.5 borderType:UIBorderSideTypeAll];
        self.valueTextField.enabled = NO;
    }
    NSInteger type = [_formItem.type intValue];
    // 日期 YYYY-MM-DD
    if (type == 3 ||type == 4||type == 5) {
        self.clickButton.hidden = NO;
    }
}
- (void)changeTextFiledPlaceholderColor:(NSString *)placeholder textFiled:(UITextField *)textFiled{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:RGB_COLOR(153, 153, 153 ),NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:style}];
    textFiled.layer.borderColor = RGB_COLOR(153, 153, 153).CGColor;
    textFiled.layer.cornerRadius = 2;
    textFiled.attributedPlaceholder = attri;
}
- (void)showActionSheets{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i= 0; i < self.enum_poolArray.count; i++) {
        NSString *title = self.enum_poolArray[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self routerEventWithName:form_edit_item userInfo:@{@"indexPath":self.indexPath,@"value":self.enum_poolArray[action.taskType]}];
        }];
        action.taskType = i;
        [alert addAction:action];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    [[SZUtil getCurrentVC] presentViewController:alert animated:YES completion:nil];
}
- (void)addUI{
    [self.contentView addSubview:self.valueTextField];
    [self.contentView addSubview:self.clickButton];
    self.clickButton.hidden = YES;
    
    UIView *keyBgView = [[UIView alloc] init];
    [self.contentView addSubview:keyBgView];
    
    [keyBgView addSubview:self.keyLabel];
    [keyBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.height.equalTo(44);
        make.width.equalTo(self).multipliedBy(0.25);
    }];
    [self.keyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.height.equalTo(keyBgView.mas_height);
        make.top.right.equalTo(0);
    }];
    [self.valueTextField makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(-5);
        make.top.equalTo(5);
        make.left.equalTo(keyBgView.mas_right);
    }];
    [self.clickButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(-5);
        make.top.equalTo(5);
        make.left.equalTo(keyBgView.mas_right);
    }];
}

#pragma mark - setter and getter
- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(ZHFormItem *)formItem{
    self.isFormEdit = isFormEdit;
    self.formItem = formItem;
    self.indexPath = indexPath;
}
- (void)setIsFormEdit:(BOOL)isFormEdit{
    _isFormEdit = isFormEdit;
    [self setValueTextFieldStyleByItemStatus:_isFormEdit];
}

- (void)setFormItem:(ZHFormItem *)formItem{
    _formItem = formItem;
    self.keyLabel.text = _formItem.name;
    if ([SZUtil isEmptyOrNull:_formItem.instance_value]) {
        self.valueTextField.placeholder = self.itemTypeValueDic[_formItem.type];
    }else{
        if ([_formItem.type  isEqualToString:@"1"] || [_formItem.type isEqualToString:@"2"]) {
            self.valueTextField.text = [NSString stringWithFormat:@"%@%@",_formItem.instance_value,_formItem.unit_char];
        }else{
            self.valueTextField.text = _formItem.instance_value;
        }
    }
//    [self.fromIamgeView.imageCollectionView reloadData];
//    [self.fromIamgeView.imageCollectionView layoutIfNeeded];
}

- (UILabel *)keyLabel{
    if (_keyLabel == nil) {
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.font = [UIFont systemFontOfSize:16];
        _keyLabel.textColor = RGB_COLOR(51, 51, 51);
        _keyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _keyLabel;
}
- (UITextField *)valueTextField{
    if (_valueTextField == nil) {
        _valueTextField = [[UITextField alloc] init];
        _valueTextField.placeholder = @"数据源";
        _valueTextField.font = [UIFont systemFontOfSize:16];
        _valueTextField.textColor = RGB_COLOR(51, 51, 51);
        _valueTextField.delegate = self;
        [self changeTextFiledPlaceholderColor:_valueTextField.placeholder textFiled:_valueTextField];
        UIView *leftView = [[UIView alloc] init];
        leftView.frame = CGRectMake(0, 0, 10, 10);
        leftView.backgroundColor = [UIColor clearColor];
        _valueTextField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        _valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _valueTextField.leftView = leftView;
    }
    return _valueTextField;
}
- (UIButton *)clickButton{
    if (_clickButton == nil) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickButton.backgroundColor = [UIColor clearColor];
        [_clickButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickButton;
}

- (NSDictionary *)itemTypeValueDic{
    if (_itemTypeValueDic == nil) {
        _itemTypeValueDic = @{@"0":@"字符串",
                              @"1":@"整数",
                              @"2":@"实数",
                              @"3":@"日期",
                              @"4":@"时间",
                              @"5":@"枚举",
                              @"6":@"url",
                              @"7":@"嵌入图片",
                              @"8":@"链接图片",
                              @"10":@"静态文本"};
    }
    return _itemTypeValueDic;
}
- (BRDatePickerView *)datePickerView{
    if (_datePickerView == nil) {
        _datePickerView = [[BRDatePickerView alloc] init];
        _datePickerView.pickerMode = BRDatePickerModeYMDHM;
        _datePickerView.title = @"请选择时间";
        _datePickerView.minDate = [NSDate dateWithTimeIntervalSinceNow:60*60];
        _datePickerView.maxDate = [[NSDate date] br_getNewDate:[NSDate date] addDays:365*3];
        _datePickerView.isAutoSelect = NO;
        _datePickerView.minuteInterval = 5;
        _datePickerView.numberFullName = YES;
        __weak typeof(self) weakSelf = self;
        _datePickerView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf routerEventWithName:form_edit_item userInfo:@{@"indexPath":strongSelf.indexPath,@"value":selectValue}];
            
        };
    }
    return _datePickerView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
