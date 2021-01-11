//
//  PickerView.m
//  TTManager
//
//  Created by chao liu on 2021/1/11.
//

#import "PickerView.h"
#import "ZHCalendarHeaderView.h"

@interface PickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, copy) NSString *hourString;
@property (nonatomic, copy) NSString *minuteString;
@property (nonatomic, strong) ZHCalendarHeaderView *headerView;
@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, assign) NSInteger minHourIndex;
@property (nonatomic, assign) NSInteger minminuteIndex;
@property (nonatomic, assign) NSInteger currentHourIndex;
@end

@implementation PickerView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hourString = @"";
        self.minuteString = @"";
        [self addUI];
        [self normalSelectedDate];
        self.backgroundColor = RGBA_COLOR(0, 0, 0, 0.3);
    }
    return self;
}
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    [self.headerView addCornerRadiu];
}
- (void)normalSelectedDate{
    NSDate *date = [NSDate date];
    NSTimeInterval secondsInEightHours = 60 * 60;
    date = [date dateByAddingTimeInterval:secondsInEightHours];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|
            NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute
                                         fromDate:date];
    NSLog(@"当前时间的小时: %ld 分钟%ld",dateComps.hour,dateComps.minute);
    self.minHourIndex = dateComps.hour;
    self.minminuteIndex = dateComps.minute;
    self.currentHourIndex = dateComps.hour-1;
    [self.picker selectRow:self.currentHourIndex inComponent:0 animated:YES];
    [self.picker selectRow:dateComps.minute -1 inComponent:1 animated:YES];
}
- (NSString *)getCurrentSelectedTime{
    NSString *selecTime = [NSString stringWithFormat:@"%@:%@",self.hourString,self.minuteString];
    NSLog(@"当前选中的时间 %@",selecTime);
    return selecTime;
}
- (void)addUI{
    UIView *bgView = [[UIView alloc] init];
//    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    [bgView addSubview:self.headerView];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(self).multipliedBy(0.4);
    }];
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    [bgView addSubview:self.picker];
    [self.picker makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.bottom.right.equalTo(0);
    }];

    __weak typeof(self) weakSelf = self;
    self.headerView.closeBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.closeBlock();
    };
    self.headerView.sureBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
//        strongSelf.sureBlock();
        [strongSelf getCurrentSelectedTime];
    };
}
#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 24;
    }else{
        return 60;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%02ld",(row+1)];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (row < self.minHourIndex -1) {
            self.currentHourIndex =  self.minminuteIndex-1;
            [self.picker selectRow:self.currentHourIndex inComponent:0 animated:NO];
        }else{
            self.currentHourIndex =  row;
        }
        self.hourString = [NSString stringWithFormat:@"%02ld",(row+1)];
        
    }else{
        if (self.currentHourIndex == self.minHourIndex-1) {
            if (row < self.minminuteIndex -1) {
                [self.picker selectRow:self.minminuteIndex-1 inComponent:1 animated:NO];
            }
        }
        self.minuteString = [NSString stringWithFormat:@"%02ld",(row+1)];
    }
}

- (UIPickerView *)picker{
    if (_picker == nil) {
        _picker = [[UIPickerView alloc] init];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.backgroundColor = [UIColor whiteColor];
    }
    return _picker;;
}
- (ZHCalendarHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[ZHCalendarHeaderView alloc] init];
    }
    return _headerView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
