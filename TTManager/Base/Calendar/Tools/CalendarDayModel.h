//
//  WQCalendarDay.h
//  WQCalendar
//
//  Created by Jason Lee on 14-3-4.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com


#define CAN_SHOW 1    //可以被点击
#define CANNOT_SHOW 0//不能被点击


#import <Foundation/Foundation.h>
#import "NSDate+WQCalendarLogic.h"



typedef NS_ENUM(NSInteger, CollectionViewCellDayType) {
    CellDayTypeEmpty,   //不显示
    CellDayTypePast,    //过去的日期
    CellDayTypeFutur,   //将来的日期
    CellDayTypeWeek,    //周末
    CellDayTypeClick    //被点击的日期

};

@interface CalendarDayModel : NSObject

@property (assign, nonatomic) CollectionViewCellDayType style;//显示的样式

@property (nonatomic, assign) NSUInteger day;//天
@property (nonatomic, assign) NSUInteger month;//月
@property (nonatomic, assign) NSUInteger year;//年
@property (nonatomic, assign) NSUInteger week;//周
@property (nonatomic, assign) NSInteger selectedType;
@property (nonatomic, assign) BOOL currentClick;

+ (CalendarDayModel *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
- (NSDate *)date;//返回当前天的NSDate对象
- (NSString *)toString;//返回当前天的NSString对象
- (NSString *)getWeek; //返回星期
+ (NSInteger)getMaxDate:(CalendarDayModel *)date nextDate:(CalendarDayModel *)nextData;// 对比两个时间的大小返回较大的日期
+ (NSInteger)getDateInterval:(CalendarDayModel *)start end:(CalendarDayModel *)end;

// 标记当前选中的时间区域
- (BOOL)isEqualTo:(CalendarDayModel *)day;//判断是不是同一天

- (BOOL)currentModelIsToday:(CalendarDayModel *)model;

@end
