//
//  ZHProject+CoreDataProperties.h
//  TTManager
//
//  Created by chao liu on 2021/10/13.
//
//

#import "ZHProject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHProject (CoreDataProperties)

+ (NSFetchRequest<ZHProject *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) int64_t actual_storage;
@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSDate *build_date;
@property (nullable, nonatomic, copy) NSString *company;
@property (nullable, nonatomic, copy) NSString *current_manager;
@property (nonatomic) int64_t current_storage;
@property (nullable, nonatomic, copy) NSDate *enable_date;
@property (nonatomic) int32_t fid_parent;
@property (nonatomic) int32_t id_project;
@property (nullable, nonatomic, copy) NSString *info;
@property (nonatomic) BOOL is_pattern;
@property (nonatomic) int32_t kind;
@property (nullable, nonatomic, copy) NSString *kind_name;
@property (nonatomic) int32_t level;
@property (nonatomic) double location_lat;
@property (nonatomic) double location_long;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) float progress;
@property (nullable, nonatomic, copy) NSString *snap_image;
@property (nonatomic) int64_t total_storage;
@property (nonatomic) int64_t time_check_in;
@property (nonatomic) int64_t time_check_out;
@property (nullable, nonatomic, retain) ZHProjectMemo *assignMemo;
@property (nullable, nonatomic, retain) NSSet<ZHDepartment *> *hasDepartments;
@property (nullable, nonatomic, retain) NSSet<ZHFlow *> *hasFlows;
@property (nullable, nonatomic, retain) NSSet<ZHForm *> *hasForms;
@property (nullable, nonatomic, retain) NSSet<ZHRole *> *hasRoles;
@property (nullable, nonatomic, retain) NSSet<ZHTarget *> *hasTargets;
@property (nullable, nonatomic, retain) NSSet<ZHUserProject *> *hasUsers;
@property (nullable, nonatomic, retain) NSSet<ZHMessage *> *messages;

@end

@interface ZHProject (CoreDataGeneratedAccessors)

- (void)addHasDepartmentsObject:(ZHDepartment *)value;
- (void)removeHasDepartmentsObject:(ZHDepartment *)value;
- (void)addHasDepartments:(NSSet<ZHDepartment *> *)values;
- (void)removeHasDepartments:(NSSet<ZHDepartment *> *)values;

- (void)addHasFlowsObject:(ZHFlow *)value;
- (void)removeHasFlowsObject:(ZHFlow *)value;
- (void)addHasFlows:(NSSet<ZHFlow *> *)values;
- (void)removeHasFlows:(NSSet<ZHFlow *> *)values;

- (void)addHasFormsObject:(ZHForm *)value;
- (void)removeHasFormsObject:(ZHForm *)value;
- (void)addHasForms:(NSSet<ZHForm *> *)values;
- (void)removeHasForms:(NSSet<ZHForm *> *)values;

- (void)addHasRolesObject:(ZHRole *)value;
- (void)removeHasRolesObject:(ZHRole *)value;
- (void)addHasRoles:(NSSet<ZHRole *> *)values;
- (void)removeHasRoles:(NSSet<ZHRole *> *)values;

- (void)addHasTargetsObject:(ZHTarget *)value;
- (void)removeHasTargetsObject:(ZHTarget *)value;
- (void)addHasTargets:(NSSet<ZHTarget *> *)values;
- (void)removeHasTargets:(NSSet<ZHTarget *> *)values;

- (void)addHasUsersObject:(ZHUserProject *)value;
- (void)removeHasUsersObject:(ZHUserProject *)value;
- (void)addHasUsers:(NSSet<ZHUserProject *> *)values;
- (void)removeHasUsers:(NSSet<ZHUserProject *> *)values;

- (void)addMessagesObject:(ZHMessage *)value;
- (void)removeMessagesObject:(ZHMessage *)value;
- (void)addMessages:(NSSet<ZHMessage *> *)values;
- (void)removeMessages:(NSSet<ZHMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
