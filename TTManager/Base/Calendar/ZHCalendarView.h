//
//  ZHCalendarView.h
//  TTManager
//
//  Created by chao liu on 2021/1/7.
//

#import <UIKit/UIKit.h>
#import "CalendarDayModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZHCalendarViewDelegate <NSObject>

- (void)ZHCalendarViewDidSelectedDate:(CalendarDayModel *)start end:(CalendarDayModel *)end totalDays:(NSInteger)totalDay;

@end;

@interface ZHCalendarView : UIView

@property (nonatomic, weak) id<ZHCalendarViewDelegate>delegate;

// 日历显示几个月
- (void)needMonth:(NSUInteger)month;

- (void)showCalendarView:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
