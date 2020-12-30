//
//  ZHUserProject+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHUserProject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHUserProject (CoreDataProperties)

+ (NSFetchRequest<ZHUserProject *> *)fetchRequest;

@property (nonatomic) BOOL enable;
@property (nullable, nonatomic, copy) NSDate *enter_date;
@property (nonatomic) int32_t id_user_project;
@property (nonatomic) BOOL in_apply;
@property (nonatomic) BOOL in_invite;
@property (nonatomic) BOOL in_manager_invite;
@property (nullable, nonatomic, copy) NSString *info;
@property (nullable, nonatomic, copy) NSString *invite_user;
@property (nonatomic) BOOL is_default;
@property (nonatomic) int32_t order_index;
@property (nonatomic) int32_t user_task_count;
@property (nullable, nonatomic, retain) NSSet<ZHDepartmentUser *> *inDepartments;
@property (nullable, nonatomic, retain) ZHRole *assignRole;
@property (nullable, nonatomic, retain) ZHProject *belongProject;
@property (nullable, nonatomic, retain) ZHUser *belongUser;

@end

@interface ZHUserProject (CoreDataGeneratedAccessors)

- (void)addInDepartmentsObject:(ZHDepartmentUser *)value;
- (void)removeInDepartmentsObject:(ZHDepartmentUser *)value;
- (void)addInDepartments:(NSSet<ZHDepartmentUser *> *)values;
- (void)removeInDepartments:(NSSet<ZHDepartmentUser *> *)values;

@end

NS_ASSUME_NONNULL_END
