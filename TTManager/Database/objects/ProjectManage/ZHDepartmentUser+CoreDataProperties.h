//
//  ZHDepartmentUser+CoreDataProperties.h
//  TTManager
//
//  Created by chao liu on 2021/1/6.
//
//

#import "ZHDepartmentUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHDepartmentUser (CoreDataProperties)

+ (NSFetchRequest<ZHDepartmentUser *> *)fetchRequest;

@property (nonatomic) BOOL is_leader;
@property (nonatomic) int32_t order_index;
@property (nullable, nonatomic, retain) ZHUserProject *assignUser;
@property (nullable, nonatomic, retain) ZHDepartment *belongDepartment;

@end

NS_ASSUME_NONNULL_END
