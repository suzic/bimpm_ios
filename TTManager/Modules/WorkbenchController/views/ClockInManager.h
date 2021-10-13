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

/// 上班打卡成功，不可再次上班打卡
- (void)goWorkClockInSuccess;

@end

NS_ASSUME_NONNULL_END
