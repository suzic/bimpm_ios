//
//  ZHRole+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHRole+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHRole (CoreDataProperties)

+ (NSFetchRequest<ZHRole *> *)fetchRequest;

@property (nonatomic) int32_t fid_project;
@property (nonatomic) int32_t id_role;
@property (nullable, nonatomic, copy) NSString *info;
@property (nonatomic) int16_t is_base;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) ZHRole *baseRole;
@property (nullable, nonatomic, retain) ZHProject *belongProject;
@property (nullable, nonatomic, retain) NSSet<ZHRole *> *extendRoles;
@property (nullable, nonatomic, retain) NSSet<ZHModule *> *hasModules;
@property (nullable, nonatomic, retain) NSSet<ZHUserProject *> *actUsers;

@end

@interface ZHRole (CoreDataGeneratedAccessors)

- (void)addExtendRolesObject:(ZHRole *)value;
- (void)removeExtendRolesObject:(ZHRole *)value;
- (void)addExtendRoles:(NSSet<ZHRole *> *)values;
- (void)removeExtendRoles:(NSSet<ZHRole *> *)values;

- (void)addHasModulesObject:(ZHModule *)value;
- (void)removeHasModulesObject:(ZHModule *)value;
- (void)addHasModules:(NSSet<ZHModule *> *)values;
- (void)removeHasModules:(NSSet<ZHModule *> *)values;

- (void)addActUsersObject:(ZHUserProject *)value;
- (void)removeActUsersObject:(ZHUserProject *)value;
- (void)addActUsers:(NSSet<ZHUserProject *> *)values;
- (void)removeActUsers:(NSSet<ZHUserProject *> *)values;

@end

NS_ASSUME_NONNULL_END
