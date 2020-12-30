//
//  ZHFlow+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHFlow+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHFlow (CoreDataProperties)

+ (NSFetchRequest<ZHFlow *> *)fetchRequest;

@property (nonatomic) BOOL dynamic;
@property (nullable, nonatomic, copy) NSString *info;
@property (nullable, nonatomic, copy) NSString *memo;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t priority;
@property (nonatomic) int32_t state;
@property (nullable, nonatomic, copy) NSString *uid_flow;
@property (nullable, nonatomic, retain) ZHProject *belongProject;
@property (nullable, nonatomic, retain) ZHUser *createUser;
@property (nullable, nonatomic, retain) NSSet<ZHTask *> *hasTasks;
@property (nullable, nonatomic, retain) NSSet<ZHStep *> *stepCurrent;
@property (nullable, nonatomic, retain) ZHStep *stepFirst;
@property (nullable, nonatomic, retain) ZHStep *stepLast;

@end

@interface ZHFlow (CoreDataGeneratedAccessors)

- (void)addHasTasksObject:(ZHTask *)value;
- (void)removeHasTasksObject:(ZHTask *)value;
- (void)addHasTasks:(NSSet<ZHTask *> *)values;
- (void)removeHasTasks:(NSSet<ZHTask *> *)values;

- (void)addStepCurrentObject:(ZHStep *)value;
- (void)removeStepCurrentObject:(ZHStep *)value;
- (void)addStepCurrent:(NSSet<ZHStep *> *)values;
- (void)removeStepCurrent:(NSSet<ZHStep *> *)values;

@end

NS_ASSUME_NONNULL_END
