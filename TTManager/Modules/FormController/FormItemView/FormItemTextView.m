//
//  FormItemTextView.m
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import "FormItemTextView.h"

@interface FormItemTextView ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) NSDictionary *itemTypeValueDic;
@end

@implementation FormItemTextView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}

#pragma mark - public

- (void)setItemEdit:(BOOL)edit data:(NSDictionary *)data{
    self.contentTextView.enableMode = edit;
    if ([SZUtil isEmptyOrNull:data[@"instance_value"]]) {
        self.contentTextView.placeholder = self.itemTypeValueDic[[NSString stringWithFormat:@"%@",data[@"type"]]];
        self.contentTextView.text = @"";
    }else{
        if ([data[@"type"] isEqualToNumber:@1] || [data[@"type"] isEqualToNumber:@2]) {
            if (![SZUtil isEmptyOrNull:data[@"unit_char"]]) {
                self.contentTextView.text = [NSString stringWithFormat:@"%@%@",data[@"instance_value"],data[@"unit_char"]];
            }else{
                self.contentTextView.text = data[@"instance_value"];
            }
        }else{
            self.contentTextView.text = data[@"instance_value"];
        }
    }
    
}

- (void)addUI{
    [self addSubview:self.contentTextView];
    [self.contentTextView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
        make.height.greaterThanOrEqualTo(44);
        make.height.lessThanOrEqualTo(44*6);
    }];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    NSInteger height = ([self.contentTextView sizeThatFits:CGSizeMake(self.contentTextView.bounds.size.width, MAXFLOAT)].height);
    if (height <= 44) {
        height = 44;
    }else if(height > 44*6){
        textView.scrollEnabled = YES;
        height = 44*6;
    }
    [self.contentTextView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
    
    [self routerEventWithName:change_form_info userInfo:@{}];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self routerEventWithName:form_edit_item userInfo:@{@"value":self.contentTextView.text}];
}

- (UITableView *)tableView {
  UIView *tableView = self.superview;
  while (![tableView isKindOfClass:[UITableView class]] && tableView) {
    tableView = tableView.superview;
  }
  return (UITableView *)tableView;
}

#pragma mark - setter and getter

-(UITextView *)contentTextView{
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.textColor = RGB_COLOR(51, 51, 51);
        _contentTextView.placeholder = @"数据源";
        _contentTextView.placeholderColor = [UIColor lightGrayColor];
        _contentTextView.delegate = self;
        _contentTextView.textContainerInset = UIEdgeInsetsMake(13, 0, 8, 8);
//        _contentTextView.backgroundColor = [UIColor redColor];
    }
    return _contentTextView;
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
