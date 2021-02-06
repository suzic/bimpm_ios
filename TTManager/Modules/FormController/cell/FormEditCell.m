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
@property (nonatomic, strong) NSDictionary *formItem;
@property (nonatomic, assign) BOOL isFormEdit;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) BRDatePickerView *datePickerView;
@property (nonatomic, strong) UIImageView *downImageView;
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
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (void)clickButtonAction:(UIButton *)button{
    NSLog(@"点击了我");
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    NSInteger type = [_formItem[@"type"] intValue];
    if (type == 3) {
        [self.datePickerView show];
    }
    //HH:mm:ss
    else if(type == 4){
        [self.datePickerView show];
    }
    // 枚举
    else if(type == 5){
        [self.enum_poolArray removeAllObjects];
        if (![SZUtil isEmptyOrNull:_formItem[@"enum_pool"]]) {
            [self.enum_poolArray addObjectsFromArray:[_formItem[@"enum_pool"] componentsSeparatedByString:@","]];
        }
        [self showActionSheets];
    }
    // url
    else if(type == 6){
        [self routerEventWithName:open_form_url userInfo:@{@"url":_formItem[@"instance_value"]}];
    }
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    NSInteger height = ([self.valueTextView sizeThatFits:CGSizeMake(self.valueTextView.bounds.size.width, MAXFLOAT)].height);
    NSLog(@"当前textView的高度是---%ld",height);
    if (height <= 34) {
        height = 34;
    }else if(height > 34*10){
        textView.scrollEnabled = YES;
        height = 34*10;
    }
    [self.valueTextView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
    
    [self routerEventWithName:change_form_info userInfo:@{}];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"当前的下标是 ==== %ld",self.indexPath.row);
    if (![SZUtil isEmptyOrNull:textView.text]) {
        [self routerEventWithName:form_edit_item userInfo:@{@"indexPath":self.indexPath,@"value":self.valueTextView.text}];
    }
}

#pragma mark - private

- (void)setValueTextFieldStyleByItemStatus:(BOOL)isEdit{

    if (isEdit == YES) {
        self.valueTextView.editable = YES;
        NSInteger type = [_formItem[@"type"] intValue];
        // 日期 YYYY-MM-DD
        if (type == 3 ||type == 4||type == 5) {
            self.clickButton.hidden = NO;
            self.valueTextView.editable = NO;
            self.downImageView.hidden = NO;
        }else{
            self.clickButton.hidden = YES;
            self.valueTextView.editable = YES;
            self.downImageView.hidden = YES;
        }
    }else{
        self.clickButton.hidden = YES;
        self.valueTextView.editable = NO;
        self.downImageView.hidden = YES;
    }
}

- (void)showActionSheets{
    NSString *title = @"请选择";
    if (self.enum_poolArray.count<= 0) {
        title = @"无数据";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
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
    self.userInteractionEnabled = YES;
    self.contentView.userInteractionEnabled = YES;
    [self addSubview:self.valueTextView];
    [self addSubview:self.clickButton];
    
    [self addSubview:self.downImageView];
    
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
        make.top.equalTo(0);
        make.left.equalTo(keyBgView.mas_right);
        make.bottom.equalTo(-5);
        make.right.equalTo(-5);
        make.height.greaterThanOrEqualTo(34);
        make.height.lessThanOrEqualTo(34*10);
    }];
    
    [self.clickButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(-5);
        make.top.equalTo(5);
        make.left.equalTo(keyBgView.mas_right);
    }];
    [self.downImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.equalTo(20);
        make.right.equalTo(-15);
    }];
    self.downImageView.hidden = YES;
}

#pragma mark - setter and getter
- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(NSDictionary *)formItem{
    self.formItem = formItem;
    self.isFormEdit = isFormEdit;
    self.indexPath = indexPath;
    [self layoutIfNeeded];
    [self textViewDidChange:self.valueTextView];
}
- (void)setIsFormEdit:(BOOL)isFormEdit{
    _isFormEdit = isFormEdit;
    [self setValueTextFieldStyleByItemStatus:_isFormEdit];
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
- (void)setFormItem:(NSDictionary *)formItem{
    _formItem = formItem;
    self.keyLabel.text = _formItem[@"name"];
    // 时间选择器
    if ([_formItem[@"type"] isEqualToNumber:@3]) {
        self.datePickerView.pickerMode = BRDatePickerModeYMD;
        self.downImageView.hidden = !self.isFormEdit;
    }else if([_formItem[@"type"] isEqualToNumber:@4]){
        self.datePickerView.pickerMode = BRDatePickerModeHMS;
        self.downImageView.hidden = !self.isFormEdit;
    }
    
    // 数据
    if ([SZUtil isEmptyOrNull:_formItem[@"instance_value"]]) {
        self.valueTextView.placeholder = self.itemTypeValueDic[[NSString stringWithFormat:@"%@",_formItem[@"type"]]];
        self.valueTextView.text = @"";
    }else{
        if ([_formItem[@"type"] isEqualToNumber:@1] || [_formItem[@"type"] isEqualToNumber:@2]) {
            if (![SZUtil isEmptyOrNull:_formItem[@"unit_char"]]) {
                self.valueTextView.text = [NSString stringWithFormat:@"%@%@",_formItem[@"instance_value"],_formItem[@"unit_char"]];
            }else{
                self.valueTextView.text = _formItem[@"instance_value"];
            }
        }else{
            NSString *instance_value = _formItem[@"instance_value"];
            // 日期 YYYY-MM-DD
            if ([_formItem[@"type"] isEqualToNumber:@3]) {
                if ([instance_value rangeOfString:@"-"].location == NSNotFound) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[instance_value intValue]];
                    instance_value = [NSDate br_stringFromDate:date dateFormat:@"yyyy-MM-dd"];
                }
                self.valueTextView.text = instance_value;
            }
            // 时间HH:mm:ss
            else if([_formItem[@"type"] isEqualToNumber:@4]){
                if ([instance_value rangeOfString:@":"].location == NSNotFound) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[instance_value intValue]];
                    instance_value = [NSDate br_stringFromDate:date dateFormat:@"HH:mm:ss"];
                }
                self.valueTextView.text = instance_value;
            }
            // url
            else if([_formItem[@"type"] isEqualToNumber:@6]){
                self.valueTextView.hidden = YES;
                self.clickButton.hidden = NO;
                [self.clickButton setTitle:instance_value forState:UIControlStateNormal];
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:instance_value];
                NSRange titleRange = {0,[title length]};
                [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
                [title addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(5, 125, 255) range:NSMakeRange(0, title.length)];
                [self.clickButton setAttributedTitle:title forState:UIControlStateNormal];
            }
            else{
                self.valueTextView.text = instance_value;
            }
        }
    }
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
        _valueTextView.delegate = self;
        _valueTextView.textContainerInset = UIEdgeInsetsMake(12, 0, 8, 8);
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
        _datePickerView.title = @"请选择时间";
        _datePickerView.selectDate = [NSDate date];
        _datePickerView.isAutoSelect = NO;
        _datePickerView.minuteInterval = 5;
        _datePickerView.numberFullName = YES;
        __weak typeof(self) weakSelf = self;
        _datePickerView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            __strong typeof(self) strongSelf = weakSelf;
            NSString *time = [NSString stringWithFormat:@"%.0f", [selectDate timeIntervalSince1970]];
            [strongSelf routerEventWithName:form_edit_item userInfo:@{@"indexPath":strongSelf.indexPath,@"value":time}];
        };
    }
    return _datePickerView;
}
- (UIImageView *)downImageView{
    if (_downImageView == nil) {
        _downImageView = [[UIImageView alloc] init];
        _downImageView.image = [UIImage imageNamed:@"button_ down"];
    }
    return _downImageView;
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
