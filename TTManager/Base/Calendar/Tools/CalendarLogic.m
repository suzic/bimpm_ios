//
//  CalendarLogic1.m
//  Calendar
//
//  Created by 张凡 on 14-7-3.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarLogic.h"

@interface CalendarLogic ()
{
    NSDate *today;//今天的日期
    NSDate *before;//之后的日期
}

@end


@implementation CalendarLogic

//计算当前日期之前几天或者是之后的几天（负数是之前几天，正数是之后的几天）
- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectDate:(NSDate *)selectdate needDays:(NSInteger)days_number
{
//    //如果为空就从当天的日期开始
//    if(date == nil)
//        date = [NSDate date];
//
//    //默认选择中的时间
//    if (selectdate == nil)
//        selectdate = date;

    today = [NSDate date];//起始日期
    
    before = [today dayInTheFollowingDay:days_number-1];//计算它days天以后的时间
    
//    select = date;//选择的日期
//    tomorrow = selectdate;
    NSDateComponents *todayDC= [today YMDComponents];
    
    NSDateComponents *beforeDC= [before YMDComponents];
    
    NSInteger todayYear = todayDC.year;
    
    NSInteger todayMonth = todayDC.month;
    
    NSInteger beforeYear = beforeDC.year;
    
    NSInteger beforeMonth = beforeDC.month;
    
    NSInteger months = (beforeYear-todayYear) * 12 + (beforeMonth - todayMonth);
    
    NSMutableArray *calendarMonth = [[NSMutableArray alloc]init];//每个月的dayModel数组
    
    for (int i = 0; i <= months; i++)
    {
        NSDate *month = [today dayInTheFollowingMonth:i];
        NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
        [self calculateDaysInPreviousMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInCurrentMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInFollowingMonthWithDate:month andArray:calendarDays];
        [calendarMonth insertObject:calendarDays atIndex:i];
    }
    
    return calendarMonth;
    
}

- (NSMutableArray *)reloadCalendarView:(NSDate *)startDate needMonth:(NSInteger)month
{
    //如果为空就从当天的日期开始
    today = startDate == nil ? [NSDate date] : startDate;

    before = [today dayInTheFollowingMonth:month];//计算几个月以后的时间

    NSDateComponents *todayDC= [today YMDComponents];

    NSDateComponents *beforeDC= [before YMDComponents];

    NSInteger todayYear = todayDC.year;

    NSInteger todayMonth = todayDC.month;

    NSInteger beforeYear = beforeDC.year;

    NSInteger beforeMonth = beforeDC.month;

    NSInteger months = (beforeYear-todayYear) * 12 + (beforeMonth - todayMonth);

    NSMutableArray *calendarMonth = [[NSMutableArray alloc]init];//每个月的dayModel数组

    for (int i = 0; i <= months; i++)
    {
        NSDate *month = [today dayInTheFollowingMonth:i];
        NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
        [self calculateDaysInPreviousMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInCurrentMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInFollowingMonthWithDate:month andArray:calendarDays];
        [calendarMonth insertObject:calendarDays atIndex:i];
    }

    return calendarMonth;
}

#pragma mark - 日历上+当前+下月份的天数

//计算上月份的天数

- (NSMutableArray *)calculateDaysInPreviousMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];//计算这个的第一天是礼拜几,并转为int型
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];//上一个月的NSDate对象
    NSUInteger daysCount = [dayInThePreviousMonth numberOfDaysInCurrentMonth];//计算上个月有多少天
    NSUInteger partialDaysCount = weeklyOrdinality - 1;//获取上月在这个月的日历上显示的天数
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];//获取年月日对象
    
    for (NSInteger i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        
        CalendarDayModel *calendarDay = [CalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;//不显示
        [array addObject:calendarDay];
    }
    
    return NULL;
}

//计算下月份的天数
- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    for (int i = 1; i < partialDaysCount + 1; ++i)
    {
        CalendarDayModel *calendarDay = [CalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;
        [array addObject:calendarDay];
    }
}

//计算当月的天数
- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];//计算这个月有多少天
    NSDateComponents *components = [date YMDComponents];//今天日期的年月日
    
    for (int i = 1; i < daysCount + 1; ++i) {
        CalendarDayModel *calendarDay = [CalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        
//        calendarDay.Chinese_calendar = [self LunarForSolarYear:components.year Month:components.month Day:i];
        
        calendarDay.week = [[calendarDay date]getWeekIntValueWithDate];
        [self changStyle:calendarDay];
        [array addObject:calendarDay];
    }
}

- (void)changStyle:(CalendarDayModel *)calendarDay
{
    NSDateComponents *calendarToDay  = [today YMDComponents];//今天
    NSDateComponents *calendarbefore = [before YMDComponents];//最后一天
//    NSDateComponents *calendarSelect = [select YMDComponents];//默认选择的那一天
//    NSDateComponents *calendarTomorrow = [tomorrow YMDComponents];
//
//    //被点击选中
//    if(calendarSelect.year == calendarDay.year &
//       calendarSelect.month == calendarDay.month &
//       calendarSelect.day == calendarDay.day)
//    {
//        calendarDay.currentClick = YES;
//        selectcalendarDay = calendarDay;
//    }
//    else if (calendarTomorrow.year == calendarDay.year &
//              calendarTomorrow.month == calendarDay.month &
//              calendarTomorrow.day == calendarDay.day)
//    {
//        calendarDay.currentClick = YES;
//        tomorrowcalendarDay = calendarDay;
//    }

    //昨天乃至过去的时间设置一个灰度
    if (calendarToDay.year >= calendarDay.year &
        calendarToDay.month >= calendarDay.month &
        calendarToDay.day > calendarDay.day)
    {
        calendarDay.style = CellDayTypePast;
    }
    //之后的时间时间段
    else if (calendarbefore.year <= calendarDay.year &
              calendarbefore.month <= calendarDay.month &
              calendarbefore.day < calendarDay.day)
    {
        calendarDay.style = CellDayTypePast;
    }
    //需要正常显示的时间段
    else
    {
        //周末
        if (calendarDay.week == 1 || calendarDay.week == 7)
        {
            calendarDay.style = CellDayTypeWeek;
        }
        //工作日
        else
        {
            calendarDay.style = CellDayTypeFutur;
        }
    }
}

- (void)selectLogic:(CalendarDayModel *)day
{
    if (day.currentClick == YES)
        return;
    day.currentClick = YES;
}

@end
