//
//  ZHStep+CoreDataProperties.h
//  TTManager
//
//  Created by chao liu on 2021/2/24.
//
//

#import "ZHStep+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHStep (CoreDataProperties)

+ (NSFetchRequest<ZHStep *> *)fetchRequest;

@property (nonatomic) int32_t days_waiting;
@property (nonatomic) int32_t decision;
@property (nullable, nonatomic, copy) NSDate *end_date;
@property (nullable, nonatomic, copy) NSString *fid_clone_step;
@property (nonatomic) BOOL in_waiting;
@property (nullable, nonatomic, copy) NSString *info;
@property (nullable, nonatomic, copy) NSDate *interrupt_date;
@property (nullable, nonatomic, copy) NSString *memo;
@property (nonatomic) BOOL memo_uid_doc_fixed;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *plan_end;
@property (nullable, nonatomic, copy) NSDate *plan_start;
@property (nonatomic) int32_t process_type;
@property (nonatomic) BOOL response_user_fixed;
@property (nullable, nonatomic, copy) NSDate *start_date;
@property (nonatomic) int32_t state;
@property (nullable, nonatomic, copy) NSString *uid_step;
@property (nonatomic) BOOL memo_target_list_fixed;
@property (nullable, nonatomic, retain) ZHFlow *asCurrent;
@property (nullable, nonatomic, retain) ZHFlow *asFirst;
@property (nullable, nonatomic, retain) ZHFlow *asLast;
@property (nullable, nonatomic, retain) ZHTask *assignTask;
@property (nullable, nonatomic, retain) NSSet<ZHStep *> *hasNext;
@property (nullable, nonatomic, retain) NSSet<ZHStep *> *hasPrevs;
@property (nullable, nonatomic, retain) NSSet<ZHTarget *> *memoDocs;
@property (nullable, nonatomic, retain) ZHUser *responseUser;

@end

@interface ZHStep (CoreDataGeneratedAccessors)

- (void)addHasNextObject:(ZHStep *)value;
- (void)removeHasNextObject:(ZHStep *)value;
- (void)addHasNext:(NSSet<ZHStep *> *)values;
- (void)removeHasNext:(NSSet<ZHStep *> *)values;

- (void)addHasPrevsObject:(ZHStep *)value;
- (void)removeHasPrevsObject:(ZHStep *)value;
- (void)addHasPrevs:(NSSet<ZHStep *> *)values;
- (void)removeHasPrevs:(NSSet<ZHStep *> *)values;

- (void)addMemoDocsObject:(ZHTarget *)value;
- (void)removeMemoDocsObject:(ZHTarget *)value;
- (void)addMemoDocs:(NSSet<ZHTarget *> *)values;
- (void)removeMemoDocs:(NSSet<ZHTarget *> *)values;

@end

NS_ASSUME_NONNULL_END
