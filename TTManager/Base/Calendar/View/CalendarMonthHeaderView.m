//
//  ETIMonthHeaderView.m
//  CalendarIOS7
//
//  Created by Jerome Morissard on 3/3/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarMonthHeaderView.h"

@interface CalendarMonthHeaderView ()

@end

#define CATDayLabelWidth  40.0f
#define CATDayLabelHeight 20.0f

@implementation CalendarMonthHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //月份
    UILabel *masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30.f)];
//    [masterLabel setBackgroundColor:RGB_COLOR(32, 33, 35)];
    [masterLabel setTextAlignment:NSTextAlignmentCenter];
    [masterLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    self.masterLabel = masterLabel;
    self.masterLabel.textColor = [SZUtil colorWithHex:@"#333333"];
    [self addSubview:self.masterLabel];

    CGFloat yOffset = 40.0f;
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0 ; i < weekArray.count; i++){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*kScreenWidth/7, yOffset, kScreenWidth/7, CATDayLabelHeight)];
//        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [SZUtil colorWithHex:@"#333333"];
        label.text = weekArray[i];
        [self addSubview:label];
    }
}

@end
