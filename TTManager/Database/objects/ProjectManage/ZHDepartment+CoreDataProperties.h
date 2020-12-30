//
//  ZHDepartment+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHDepartment+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHDepartment (CoreDataProperties)

+ (NSFetchRequest<ZHDepartment *> *)fetchRequest;

@property (nonatomic) int32_t fid_project;
@property (nonatomic) int32_t id_department;
@property (nullable, nonatomic, copy) NSString *info;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) ZHProject *belongProject;
@property (nullable, nonatomic, retain) NSSet<ZHDepartmentUser *> *hasUsers;

@end

@interface ZHDepartment (CoreDataGeneratedAccessors)

- (void)addHasUsersObject:(ZHDepartmentUser *)value;
- (void)removeHasUsersObject:(ZHDepartmentUser *)value;
- (void)addHasUsers:(NSSet<ZHDepartmentUser *> *)values;
- (void)removeHasUsers:(NSSet<ZHDepartmentUser *> *)values;

@end

NS_ASSUME_NONNULL_END
