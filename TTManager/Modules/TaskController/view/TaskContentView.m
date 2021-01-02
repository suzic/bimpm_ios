//
//  TaskContentView.m
//  TTManager
//
//  Created by chao liu on 2021/1/2.
//

#import "TaskContentView.h"

@interface TaskContentView ()

@property (nonatomic, strong) UIView *priorityView;
@property (nonatomic, strong) NSArray *prioritybtnArray;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *adjunctFileBtn;

@end
@implementation TaskContentView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)addUI{
    [self addSubview:self.priorityView];
    
    [self addPriorityViewSubViews];
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.adjunctFileBtn];
    
    [self.priorityView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(6);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(20);
    }];
    [self.adjunctFileBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(-10);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priorityView.mas_bottom).offset(10);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.bottom.equalTo(self).offset(-10);
    }];
}
- (void)addPriorityViewSubViews{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"优先级";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = RGB_COLOR(102, 102, 102);
    [self.priorityView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
    }];
    UIButton *lastBtn = nil;
    for (int i = 0; i < self.prioritybtnArray.count; i++) {
        UIButton *btn = self.prioritybtnArray[i];
        [self.priorityView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(16);
            make.centerY.equalTo(self.priorityView);
            if (lastBtn == nil) {
                make.left.equalTo(label.mas_right).offset(10);
            }else{
                make.left.equalTo(lastBtn.mas_right).offset(10);
            }
        }];
        [self.priorityView layoutIfNeeded];
        btn.layer.cornerRadius = 8.0f;
        lastBtn = btn;
    }
}
#pragma mark - setter and getter
- (UIView *)priorityView{
    if (_priorityView == nil) {
        _priorityView = [[UIView alloc] init];
    }
    return _priorityView;
}
- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        [_contentView borderForColor:[SZUtil colorWithHex:@"#CCCCCC"] borderWidth:0.5 borderType:UIBorderSideTypeAll];
    }
    return _contentView;
}
- (UIButton *)adjunctFileBtn{
    if (_adjunctFileBtn == nil) {
        _adjunctFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_adjunctFileBtn setTitle:@"添加附件" forState:UIControlStateNormal];
        _adjunctFileBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_adjunctFileBtn setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
        [_adjunctFileBtn setImage:[UIImage imageNamed:@"task_adjunctFile"] forState:UIControlStateNormal];
        _adjunctFileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _adjunctFileBtn;
}
- (NSArray *)prioritybtnArray{
    if (_prioritybtnArray == nil) {
        NSMutableArray *result = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i +10000;
            UIColor *bgColor = RGB_COLOR(0, 183, 147);
            if (i == 0) {
                bgColor = RGB_COLOR(0, 183, 147);
            }else if(i == 1){
                bgColor = RGB_COLOR(244, 216, 2);
            }else{
                bgColor = RGB_COLOR(255, 77, 77);
            }
            [button setBackgroundColor:bgColor];
            [result addObject:button];
        }
        _prioritybtnArray = result;
    }
    return _prioritybtnArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
