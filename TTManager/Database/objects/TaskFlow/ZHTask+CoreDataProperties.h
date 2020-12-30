//
//  ZHTask+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHTask+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHTask (CoreDataProperties)

+ (NSFetchRequest<ZHTask *> *)fetchRequest;

@property (nonatomic) int16_t category;
@property (nullable, nonatomic, copy) NSDate *end_date;
@property (nonatomic) int32_t fid_project;
@property (nullable, nonatomic, copy) NSString *fid_step;
@property (nullable, nonatomic, copy) NSString *fid_user;
@property (nullable, nonatomic, copy) NSString *info;
@property (nullable, nonatomic, copy) NSDate *interrupt_date;
@property (nullable, nonatomic, copy) NSString *memo;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t priority;
@property (nullable, nonatomic, copy) NSDate *start_date;
@property (nonatomic) int32_t type;
@property (nullable, nonatomic, copy) NSString *uid_task;
@property (nullable, nonatomic, retain) ZHStep *assignStep;
@property (nullable, nonatomic, retain) ZHFlow *belongFlow;
@property (nullable, nonatomic, retain) NSSet<ZHUser *> *currentUsers;
@property (nullable, nonatomic, retain) ZHUser *endUser;
@property (nullable, nonatomic, retain) ZHTarget *firstTarget;
@property (nullable, nonatomic, retain) NSSet<ZHMessage *> *inMessages;
@property (nullable, nonatomic, retain) ZHUser *responseUser;
@property (nullable, nonatomic, retain) ZHUser *startUser;

@end

@interface ZHTask (CoreDataGeneratedAccessors)

- (void)addCurrentUsersObject:(ZHUser *)value;
- (void)removeCurrentUsersObject:(ZHUser *)value;
- (void)addCurrentUsers:(NSSet<ZHUser *> *)values;
- (void)removeCurrentUsers:(NSSet<ZHUser *> *)values;

- (void)addInMessagesObject:(ZHMessage *)value;
- (void)removeInMessagesObject:(ZHMessage *)value;
- (void)addInMessages:(NSSet<ZHMessage *> *)values;
- (void)removeInMessages:(NSSet<ZHMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
