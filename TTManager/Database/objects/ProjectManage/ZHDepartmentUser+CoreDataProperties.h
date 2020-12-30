//
//  ZHDepartmentUser+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
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
