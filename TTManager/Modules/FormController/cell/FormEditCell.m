//
//  FormEditCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import "FormEditCell.h"

@interface FormEditCell ()<UITextViewDelegate>

@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) NSDictionary *itemTypeValueDic;
@property (nonatomic, strong) NSMutableArray *enum_poolArray;
@property (nonatomic, strong) ZHFormItem *formItem;
@property (nonatomic, assign) BOOL isFormEdit;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) BRDatePickerView *datePickerView;

@end
@implementation FormEditCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
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
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (self.valueTextView.editable == YES) {
        NSInteger height = ([self.valueTextView sizeThatFits:CGSizeMake(self.valueTextView.bounds.size.width, MAXFLOAT)].height);
        NSLog(@"当前textView的高度是---%ld",height);
        textView.scrollEnabled = NO;
        if (height < 44) {
            height = 44;
        }
        [self.valueTextView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
        UITableView *tableView = [self tableView];
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self routerEventWithName:form_edit_item userInfo:@{@"indexPath":self.indexPath,@"value":self.valueTextView.text}];
}

#pragma mark - private

- (void)setValueTextFieldStyleByItemStatus:(BOOL)isEdit{
    if (isEdit == YES) {
        [self.valueTextView borderForColor:RGB_COLOR(102, 102, 102) borderWidth:0.5 borderType:UIBorderSideTypeAll];
        self.valueTextView.editable = YES;
    }else{
        [self.valueTextView borderForColor:[UIColor clearColor] borderWidth:0.5 borderType:UIBorderSideTypeAll];
        self.valueTextView.editable = NO;
    }
    NSInteger type = [_formItem.type intValue];
    // 日期 YYYY-MM-DD
    if (type == 3 ||type == 4||type == 5) {
        self.clickButton.hidden = NO;
    }
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
- (UITableView *)tableView {
  UIView *tableView = self.superview;
  while (![tableView isKindOfClass:[UITableView class]] && tableView) {
    tableView = tableView.superview;
  }
  return (UITableView *)tableView;
}
- (void)addUI{
    [self addSubview:self.valueTextView];
    [self addSubview:self.clickButton];
    self.clickButton.hidden = YES;
    
    UIView *keyBgView = [[UIView alloc] init];
    [self addSubview:keyBgView];
    
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
    [self.valueTextView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(keyBgView.mas_right);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(-5);
        make.height.greaterThanOrEqualTo(35);
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
        self.valueTextView.placeholder = self.itemTypeValueDic[_formItem.type];
    }else{
        if ([_formItem.type  isEqualToString:@"1"] || [_formItem.type isEqualToString:@"2"]) {
            self.valueTextView.text = [NSString stringWithFormat:@"%@%@",_formItem.instance_value,_formItem.unit_char];
        }else{
            self.valueTextView.text = _formItem.instance_value;
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
- (UITextView *)valueTextView{
    if (_valueTextView == nil) {
        _valueTextView = [[UITextView alloc] init];
        _valueTextView.font = [UIFont systemFontOfSize:16];
        _valueTextView.textColor = RGB_COLOR(51, 51, 51);
        _valueTextView.placeholder = @"数据源";
        _valueTextView.placeholderColor = [UIColor lightGrayColor];
//        _valueTextView.textContainerInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _valueTextView.delegate = self;
        _valueTextView.scrollEnabled = NO;
    }
    return _valueTextView;
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
//-(CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority{
//    // 在对collectionView进行布局
//    self.valueTextView.frame = CGRectMake(0, 0, targetSize.width, 44);
//    [self.valueTextView layoutIfNeeded];
//
//    // 由于这里collection的高度是动态的，这里cell的高度我们根据collection来计算
//    NSInteger height = ([self.valueTextView sizeThatFits:CGSizeMake(self.valueTextView.bounds.size.width, MAXFLOAT)].height);
//
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width, height+10);
//}
@end
