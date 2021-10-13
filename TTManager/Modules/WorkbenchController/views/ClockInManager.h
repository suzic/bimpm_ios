//
//  ClockInManager.h
//  TTManager
//
//  Created by chao liu on 2021/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClockInManager : NSObject
// 是否可以上班打卡
@property (nonatomic, assign) BOOL isWork;
@property (nonatomic, copy) NSString *time_check_in;
@property (nonatomic, copy) NSString *time_check_out;
/// 获取打卡类型 0 上班打卡 1 下班打卡
- (NSInteger)getClockInType;
/// 获取打卡提示文本 0 上班打卡 1 下班打卡
- (void)setWorkTime;
/// 上班打卡成功，不可再次上班打卡
- (void)goWorkClockInSuccess;

@end

NS_ASSUME_NONNULL_END
