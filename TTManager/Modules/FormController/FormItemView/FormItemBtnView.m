//
//  FormItemBtnView.m
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import "FormItemBtnView.h"

@interface FormItemBtnView ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *downImageView;
// 时间选择器
@property (nonatomic, strong) BRDatePickerView *datePickerView;

@property (nonatomic, strong) NSMutableArray *enum_poolArray;

@property (nonatomic, strong) NSDictionary *formItem;

@property (nonatomic, strong) NSDictionary *itemTypeValueDic;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation FormItemBtnView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

#pragma mark - public

- (void)setItemEdit:(BOOL)edit data:(NSDictionary *)data indexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    self.button.enabled = edit;
    self.formItem = data;
    // 时间选择器
    if ([self.formItem[@"type"] isEqualToNumber:@3]) {
        self.datePickerView.pickerMode = BRDatePickerModeYMD;
        self.downImageView.hidden = !edit;
    }else if([self.formItem[@"type"] isEqualToNumber:@4]){
        self.datePickerView.pickerMode = BRDatePickerModeYMDHMS;
        self.downImageView.hidden = !edit;
    }
    
    [self fillData:data];
}
- (void)fillData:(NSDictionary *)data{
    NSString *instance_value = data[@"instance_value"];
    if ([SZUtil isEmptyOrNull:data[@"instance_value"]]) {
        NSString *title = self.itemTypeValueDic[[NSString stringWithFormat:@"%@",data[@"type"]]];
        [self.button setTitle:title forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        [self.button setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
        // 日期 YYYY-MM-DD
        if ([data[@"type"] isEqualToNumber:@3]) {
            if ([instance_value rangeOfString:@"-"].location == NSNotFound) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[instance_value doubleValue]/1000];
                instance_value = [NSDate br_stringFromDate:date dateFormat:@"yyyy-MM-dd"];
            }
            [self.button setTitle:instance_value forState:UIControlStateNormal];
        }
        // 时间HH:mm:ss
        else if([data[@"type"] isEqualToNumber:@4]){
            if ([instance_value rangeOfString:@":"].location == NSNotFound) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[instance_value doubleValue]/1000];
                instance_value = [NSDate br_stringFromDate:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
            }
            [self.button setTitle:instance_value forState:UIControlStateNormal];
        }
        // url
        else if([data[@"type"] isEqualToNumber:@6]){
            [self.button setTitle:instance_value forState:UIControlStateNormal];
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:instance_value];
            NSRange titleRange = {0,[title length]};
            [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
            [title addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(5, 125, 255) range:NSMakeRange(0, title.length)];
            [self.button setAttributedTitle:title forState:UIControlStateNormal];
            
        }else if([data[@"type"] isEqualToNumber:@5]){
            [self.button setTitle:instance_value forState:UIControlStateNormal];
        }else{
            [self.button setTitle:instance_value forState:UIControlStateNormal];
        }
    }
}
#pragma mark - action

- (void)clickButtonAction:(UIButton *)button{
    NSLog(@"点击了我");
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    NSInteger type = [self.formItem[@"type"] intValue];
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

- (void)showActionSheets{
    NSString *title = @"请选择";
    if (self.enum_poolArray.count<= 0) {
        title = @"无数据";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSInteger count = self.isPollingTask == YES ? 2 :self.enum_poolArray.count;
    for (int i= 0; i < count; i++) {
        NSString *title = self.enum_poolArray[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self routerEventWithName:form_edit_item userInfo:@{@"value":self.enum_poolArray[action.taskType],@"indexPath":self.indexPath}];
        }];
        action.taskType = i;
        [alert addAction:action];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    [[SZUtil getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UI

- (void)addUI{
    
    [[SZUtil getCurrentVC] initializeImagePicker];
    [SZUtil getCurrentVC].actionSheetType = 3;
    
    self.enum_poolArray = [NSMutableArray array];
    [self addSubview:self.button];
    [self addSubview:self.downImageView];
    
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
    }];
    
    [self.downImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.equalTo(20);
        make.right.equalTo(-15);
        make.left.equalTo(self.button.mas_right);
    }];
    
}

#pragma mark - setter and getter

- (UIButton *)button{
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor clearColor];
        [_button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;    }
    return _button;
}
- (UIImageView *)downImageView{
    if (_downImageView == nil) {
        _downImageView = [[UIImageView alloc] init];
        _downImageView.image = [UIImage imageNamed:@"button_ down"];
    }
    return _downImageView;
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
            NSString *time = [NSString stringWithFormat:@"%.0f", [selectDate timeIntervalSince1970]*1000];
            [strongSelf routerEventWithName:form_edit_item userInfo:@{@"value":time,@"indexPath":strongSelf.indexPath}];
        };
    }
    return _datePickerView;
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
