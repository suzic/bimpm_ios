//
//  TaskListCell.m
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import "TaskListCell.h"

@interface TaskListCell ()

@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIImageView *userImage;

@property (nonatomic, strong) UILabel *flowStatusLabel;
@property (nonatomic, strong) UILabel *taskName;
@property (nonatomic, strong) UILabel *predictTime;

@end

@implementation TaskListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    self.userImage.clipsToBounds = YES;
    self.userImage.layer.cornerRadius = _userImage.frame.size.height/2;
}
- (void)setCurrenttask:(ZHTask *)currenttask{
    _currenttask = currenttask;
    
    if (self.type == 0 || self.type == 1) {
        self.taskName.text = [NSString stringWithFormat:@"%@-%@",_currenttask.flow_name, _currenttask.name];
    }else{
        self.taskName.text = [NSString stringWithFormat:@"%@",_currenttask.name];
    }
    
    if (self.type == 0) {
        NSString *plan_end = [SZUtil getTimeString:_currenttask.assignStep.plan_end];
        if ([SZUtil isEmptyOrNull:plan_end]) {
            self.predictTime.text = @"暂无预计完成时间";
        }else{
            self.predictTime.text = [NSString stringWithFormat:@"预计完成于 %@",plan_end];
        }
    }else if(self.type == 1){
        NSString *endDate = [SZUtil getTimeString:_currenttask.end_date];
        self.predictTime.text = [NSString stringWithFormat:@"已完成于 %@",endDate];
    }else if(self.type == 2){
        if ([_currenttask.flow_state intValue] == 0) {
            NSString *endDate = [SZUtil getTimeString:_currenttask.assignStep.start_date];
            self.predictTime.text = [NSString stringWithFormat:@"创建于 %@",endDate];
        }else if([_currenttask.flow_state intValue] == 1){
            NSString *endDate = [SZUtil getTimeString:_currenttask.assignStep.end_date];
            self.predictTime.text = [NSString stringWithFormat:@"已完成于 %@",endDate];
        }
    }else if(self.type == 3){
        NSString *endDate = [SZUtil getTimeString:_currenttask.assignStep.end_date];
        self.predictTime.text = [NSString stringWithFormat:@"已发起于 %@",endDate];
    }
    
    
//    NSString *endDate = [SZUtil getTimeString:_currenttask.end_date];
//    if ([SZUtil isEmptyOrNull:endDate]) {
//        endDate = @"暂无完成时间";
//    }
//    self.predictTime.text = endDate;
    
    NSString *flowText = @"";
    if ([_currenttask.flow_state intValue] == 0) {
        flowText = @"流程未开始";
        self.flowStatusLabel.textColor = [UIColor lightGrayColor];
    }else if([_currenttask.flow_state intValue] == 1){
        flowText = @"流程已完成";
        self.flowStatusLabel.textColor = [SZUtil colorWithHex:@"#00CB69"];
    }else if([_currenttask.flow_state intValue] == 2){
        flowText = @"流程进行中";
        self.flowStatusLabel.textColor = [SZUtil colorWithHex:@"#196BF8"];
    }else if([_currenttask.flow_state intValue] == 3){
        flowText = @"流程已中断";
        self.flowStatusLabel.textColor = [UIColor redColor];
    }else if([_currenttask.flow_state intValue] == 4){
        flowText = @"流程等待中";
        self.flowStatusLabel.textColor = [SZUtil colorWithHex:@"#196BF8"];
    }
    self.flowStatusLabel.text = flowText;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:_currenttask.responseUser.avatar] placeholderImage:[UIImage imageNamed:@"test-1"]];
    self.lineView.backgroundColor = [self setLineViewColor:_currenttask];
}

- (UIColor *)setLineViewColor:(ZHTask *)task{
    UIColor *color = nil;
    if (task.priority <= 4) {
        color = RGB_COLOR(0, 183, 147);
    }else if(task.priority > 5 && task.priority <=9){
        color = RGB_COLOR(255, 77, 77);
    }else{
        color = RGB_COLOR(244, 216, 2);
    }
    return color;
}
- (void)addUI{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.flowStatusLabel];
    [self.contentView addSubview:self.taskName];
    [self.contentView addSubview:self.predictTime];
    [self.contentView addSubview:self.userImage];
    self.lineView.backgroundColor = [SZUtil colorWithHex:@"#04BA90"];

    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(0);
    }];
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(12);
        make.bottom.equalTo(-12);
        make.width.equalTo(4);
    }];
    [self.flowStatusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_top);
        make.left.equalTo(self.lineView.mas_right).offset(15);
    }];
    [self.taskName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flowStatusLabel.mas_bottom);
        make.left.equalTo(self.lineView.mas_right).offset(15);
        make.centerY.equalTo(self.lineView.mas_centerY);
    }];
    
    [self.predictTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(15);
        make.bottom.equalTo(self.lineView.mas_bottom);
    }];
    
    [self.userImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.taskName.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(-15);
        make.top.equalTo(15);
        make.bottom.equalTo(-15);
        make.width.equalTo(self.userImage.mas_height).multipliedBy(1);
    }];
    
    bgView.layer.cornerRadius = 5;
    bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:9/255.0 blue:25/255.0 alpha:0.1].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    bgView.layer.shadowOpacity = 1;
    bgView.layer.shadowRadius = 10;
}

#pragma mark - setter and getter
- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}
- (UILabel *)taskName{
    if (_taskName == nil) {
        _taskName = [[UILabel alloc] init];
        _taskName.textColor = [SZUtil colorWithHex:@"#333333"];
        _taskName.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:17.0f];
    }
    return _taskName;;
}
- (UILabel *)predictTime{
    if (_predictTime == nil) {
        _predictTime = [[UILabel alloc] init];
        _predictTime.textColor = [SZUtil colorWithHex:@"#666666"];
        _predictTime.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:13.0f];
    }
    return _predictTime;;
}

- (UILabel *)flowStatusLabel{
    if (_flowStatusLabel == nil) {
        _flowStatusLabel = [[UILabel alloc] init];
        _flowStatusLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:13.0f];
        //  #00CB69
        _flowStatusLabel.textColor = [SZUtil colorWithHex:@"#196BF8"];
        
    }
    return _flowStatusLabel;
}

- (UIImageView *)userImage{
    if (_userImage == nil) {
        _userImage = [[UIImageView alloc] init];
    }
    return _userImage;;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
