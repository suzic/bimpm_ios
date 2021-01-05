//
//  DataManager+Target.h
//  TTManager
//
//  Created by chao liu on 2021/1/4.
//

#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager (Target)

- (ZHTarget *)getTargetFromCoreDataById:(NSString *)uid_target;

- (NSMutableArray *)syncTargetWithInfo:(NSDictionary *)dic;

- (ZHTarget *)syncTargetWithInfoItem:(NSDictionary *)targetItem;

@end

NS_ASSUME_NONNULL_END
