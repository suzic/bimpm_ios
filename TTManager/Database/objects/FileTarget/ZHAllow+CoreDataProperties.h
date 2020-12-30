//
//  ZHAllow+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHAllow+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHAllow (CoreDataProperties)

+ (NSFetchRequest<ZHAllow *> *)fetchRequest;

@property (nonatomic) int32_t allow_level;
@property (nullable, nonatomic, copy) NSString *uid_target;
@property (nullable, nonatomic, retain) ZHTarget *belongTarget;
@property (nullable, nonatomic, retain) ZHUser *belongUser;

@end

NS_ASSUME_NONNULL_END
