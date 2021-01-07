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

- (void)ZHCalendarViewDidSelectedDate:(CalendarDayModel *)selectedDate;

@end;

@interface ZHCalendarView : UIView

@property (nonatomic, weak) id<ZHCalendarViewDelegate>delegate;

// 第一次调用日历 有默认值时候赋值 会自动更改 当前日历的lastSelectedIndexPath
@property (nonatomic, strong) NSString *defaultSelectedDate;
// 日历显示几个月
- (void)needMonth:(NSUInteger)month;

- (void)showCalendarView:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
