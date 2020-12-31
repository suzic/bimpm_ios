//
//  TaskInforCell.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "TaskInforCell.h"

@interface TaskInforCell ()
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@end

@implementation TaskInforCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat x = (kScreenWidth/2-self.myTaskBtn.titleLabel.size.width)/2;
    CGFloat w = self.myTaskBtn.titleLabel.size.width;
 
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(x);
        make.bottom.equalTo(self.tabBgView);
        make.height.equalTo(2);
        make.width.equalTo(w);
    }];
    [self changeTaskInfor:0];
    
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstTapAction:)];
    [self.firstItembgView addGestureRecognizer:firstTap];
    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondTapAction:)];
    [self.secondItembgView addGestureRecognizer:secondTap];
}
#pragma mark - Action

- (IBAction)changeTab:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger currentTag = button.tag - 10000;
    self.currentSelectedIndex = currentTag;
    
    [self changeSelecteStyle:currentTag];
    
    [self changeLineViewLocation:currentTag];
    
    [self changeTaskInfor:currentTag];
    //
}

- (void)firstTapAction:(UITapGestureRecognizer *)tap{
    NSDictionary *dic = [self getTaskStatusForTaskList:0];
    [self routerEventWithName:@"taskList" userInfo:dic];
}

- (void)secondTapAction:(UITapGestureRecognizer *)tap{
    NSDictionary *dic = [self getTaskStatusForTaskList:1];
    [self routerEventWithName:@"taskList" userInfo:dic];
}

#pragma mark - private method

- (void)changeTaskInfor:(NSInteger)currentTag{
    NSString *first = @"未完成";
    NSString *firstCount = @"8";
    UIColor *firstColor = [SZUtil colorWithHex:@"#EEF6FC"];
    NSString *second = @"已完成";
    NSString *secondCount = @"10";
    UIColor *secondColor = [SZUtil colorWithHex:@"#FFF5E4"];
    if (currentTag == 1)
    {
        first = @"进行中";
        firstCount = @"20";
        firstColor = [SZUtil colorWithHex:@"#FFF5E4"];
        
        second = @"未开始";
        secondCount = @"13";
        secondColor = [SZUtil colorWithHex:@"#EEF6FC"];
    }
    
    self.firstItembgView.backgroundColor = firstColor;
    self.firstStatusName.text = first;
    self.firstStatusCount.text = firstCount;
    
    self.secondItembgView.backgroundColor = secondColor;
    self.secondStatusName.text = second;
    self.secondStatusCount.text = secondCount;
}
- (void)changeSelecteStyle:(NSInteger)currentTag{
    if (currentTag == 0) {
        [self.myTaskBtn setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
        [self.mySendTaskBtn setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
    }else{
        [self.myTaskBtn setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
        [self.mySendTaskBtn setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
    }
}
// 改变lin位置
- (void)changeLineViewLocation:(NSInteger)currentTag{
    CGFloat x = 0;
    if (currentTag == 0) {
        x = (kScreenWidth/2-self.myTaskBtn.titleLabel.size.width)/2;
    }else{
        x = kScreenWidth/2 + (kScreenWidth/2-self.myTaskBtn.titleLabel.size.width)/2;
    }
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(x);
    }];
    [self.contentView layoutIfNeeded];
}
// 获取跳转任务对应的参数
- (NSDictionary *)getTaskStatusForTaskList:(NSInteger)selected{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // 派发给我的
    if (self.currentSelectedIndex == 0) {
        dic[@"selectedTaskType"] = @"0";
        // 未完成的
        if (selected == 0) {
            dic[@"selectedTaskStatus"] = @"0";
        }
        // 已经完成的
        else if(selected == 1){
            dic[@"selectedTaskStatus"] = @"1";
        }
    }
    // 我派发的
    else if(self.currentSelectedIndex == 1){
        dic[@"selectedTaskType"] = @"1";
        // 未完成的
        if (selected == 0) {
            dic[@"selectedTaskStatus"] = @"0";
        }
        // 已经完成的
        else if(selected == 1){
            dic[@"selectedTaskStatus"] = @"1";
        }
    }
    return dic;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
