//
//  ClockInView.m
//  TTManager
//
//  Created by chao liu on 2021/2/23.
//

#import "ClockInView.h"

@interface ClockInView ()
// 切换打卡类型
@property (nonatomic, strong) UISegmentedControl *clockInTypeView;

@property (nonatomic, strong) UIView *clokInInforView;
// 当前位置提醒
@property (nonatomic, strong) UILabel *locationLabel;
// 打卡类型提醒
@property (nonatomic, strong) UILabel *remindLabel;

// 打卡按钮
@property (nonatomic, strong) UIView *clockInBtnView;
@property (nonatomic, strong) UILabel *clockInTime;
@property (nonatomic, strong) UILabel *clockInTypeLabel;
@property (nonatomic, strong) UIButton *openLocationBtn;
@property (nonatomic, strong) NSTimer *timer;



@end

@implementation ClockInView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
        [self addTimer];
        [self initClockInType];
        [self addTapGestureRecognizer];
        [self changeClockInScope:3];
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    self.clockInBtnView.clipsToBounds = YES;
    self.clockInBtnView.layer.cornerRadius = self.clockInBtnView.frame.size.width/2;
    [self.clockInBtnView borderForColor:[UIColor lightGrayColor] borderWidth:12 borderType:UIBorderSideTypeAll];
}

- (void)addTimer{
    if (self.timer == nil) {
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)updateTime{
    self.clockInTime.text = [SZUtil getShortTimeString:[NSDate date]];
}

- (void)stopTimer{
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)initClockInType{
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:currentDate];
    NSInteger type = (components.hour < 12 ? 0 : 1);
    self.clockInTypeView.selectedSegmentIndex = type;
    [self setClockInViewType];
}

- (void)addTapGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clockAction:)];
    [self.clockInBtnView addGestureRecognizer:tap];
}

- (void)clockAction:(UITapGestureRecognizer *)tap{
    
    [self routerEventWithName:punch_card_action userInfo:@{@"type":[NSString stringWithFormat:@"%ld",self.clockInTypeView.selectedSegmentIndex]}];
}

- (void)changeType:(UISegmentedControl *)segmented{
    [self setClockInViewType];
}

- (void)setClockInViewType{
    if (self.clockInTypeView.selectedSegmentIndex == 0) {
        self.clockInTypeLabel.text = @"上班打卡";
        self.remindLabel.text = @"上班请在08:00之前打卡";
    }else if(self.clockInTypeView.selectedSegmentIndex == 1){
        self.clockInTypeLabel.text = @"下班打卡";
        self.remindLabel.text = @"下班请在18:00之后打卡";
    }
}

- (void)changeClockInScope:(NSInteger)type{
    if (type == 0) {
        self.locationLabel.text = @"在打卡范围之内";
        self.openLocationBtn.hidden = YES;
    }else if(type == 1){
        if ([SZUtil isAllowLocationService] == NO) {
            self.locationLabel.text = @"不在打卡范围之内(未开启定位服务)";
            self.openLocationBtn.hidden = NO;
        }else{
            self.locationLabel.text = @"不在打卡范围之内";
            self.openLocationBtn.hidden = YES;
        }
    }else{
        if ([SZUtil isAllowLocationService] == NO) {
            self.locationLabel.text = @"获取定位信息中(未开启定位服务)";
            self.openLocationBtn.hidden = NO;
        }else{
            self.locationLabel.text = @"获取定位信息中";
            self.openLocationBtn.hidden = YES;
        }
    }
}
- (void)openSetting:(UIButton *)button{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位,以便于获取打卡位置信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            }];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [[AppDelegate sharedDelegate].window.rootViewController presentViewController:alert animated:YES completion:nil];
}
#pragma mark - setter and getter

- (UISegmentedControl *)clockInTypeView{
    if (_clockInTypeView == nil) {
        _clockInTypeView = [[UISegmentedControl alloc] initWithItems:@[@"上班打卡",@"下班打卡"]];
        _clockInTypeView.selectedSegmentIndex = 0;
        _clockInTypeView.tintColor = [UIColor whiteColor];
        _clockInTypeView.backgroundColor = [UIColor clearColor];
        [_clockInTypeView addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
    }
    return _clockInTypeView;
}
- (UIView *)clokInInforView{
    if (_clokInInforView == nil) {
        _clokInInforView = [[UIView alloc] init];
        _clokInInforView.backgroundColor = [UIColor whiteColor];
    }
    return _clokInInforView;
}

- (UILabel *)locationLabel{
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.numberOfLines = 0;
        _locationLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _locationLabel;
}
- (UILabel *)remindLabel{
    if (_remindLabel == nil) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.numberOfLines = 0;
        _remindLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _remindLabel;
}

- (UIView *)clockInBtnView{
    if (_clockInBtnView == nil) {
        _clockInBtnView = [[UIView alloc] init];
    }
    return _clockInBtnView;
}

- (UILabel *)clockInTime{
    if (_clockInTime == nil) {
        _clockInTime = [[UILabel alloc] init];
        _clockInTime.textAlignment = NSTextAlignmentCenter;
        [_clockInTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:28]];
    }
    return _clockInTime;
}

- (UILabel *)clockInTypeLabel{
    if (_clockInTypeLabel == nil) {
        _clockInTypeLabel = [[UILabel alloc] init];
        _clockInTypeLabel.textAlignment = NSTextAlignmentCenter;
        [_clockInTypeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        _clockInTypeLabel.textColor = [UIColor redColor];
    }
    return _clockInTypeLabel;
}
- (UIButton *)openLocationBtn{
    if (_openLocationBtn == nil) {
        _openLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openLocationBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_openLocationBtn setTitle:@"打开定位服务" forState:UIControlStateNormal];
        [_openLocationBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_openLocationBtn addTarget:self action:@selector(openSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openLocationBtn;
}
#pragma mark - UI

- (void)addUI{
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *typeBgView = [[UIView alloc] init];
    typeBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:typeBgView];
    
    [typeBgView addSubview:self.clockInTypeView];
    [self addSubview:self.clokInInforView];
    
    [self.clokInInforView addSubview:self.locationLabel];
    [self.clokInInforView addSubview:self.openLocationBtn];
    self.openLocationBtn.hidden = YES;
    
    [self addSubview:self.remindLabel];
    
    [self addSubview:self.clockInBtnView];
    
    
    [typeBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    [self.clockInTypeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
    
    [self.clokInInforView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clockInTypeView.mas_bottom).offset(16);
        make.left.right.bottom.equalTo(0);
    }];
    
    [self.locationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(16);
        make.height.equalTo(30);
    }];
    [self.openLocationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationLabel.mas_right);
        make.top.equalTo(16);
        make.right.equalTo(0);
        make.height.equalTo(30);
    }];
    
    [self.remindLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-16);
        make.left.right.equalTo(0);
        make.height.equalTo(30);
    }];
    
    [self.clockInBtnView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationLabel.mas_bottom).offset(8);
        make.bottom.equalTo(self.remindLabel.mas_top).offset(-8);
        make.width.equalTo(self.clockInBtnView.mas_height);
        make.centerX.equalTo(self);
    }];
    
    [self addClockBtnView];
}

- (void)addClockBtnView{
    UIView *bgView = [[UIView alloc] init];
    [self.clockInBtnView addSubview:bgView];
    
    [bgView addSubview:self.clockInTime];
    [bgView addSubview:self.clockInTypeLabel];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.clockInBtnView);
        make.centerY.equalTo(self.clockInBtnView);
        make.width.equalTo(self.clockInBtnView.mas_width);
        make.height.equalTo(self.clockInBtnView.mas_height).multipliedBy(0.5);
    }];
    [self.clockInTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(bgView.mas_height).multipliedBy(0.5);
    }];
    
    [self.clockInTypeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clockInTime.mas_bottom);
        make.left.right.equalTo(0);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
