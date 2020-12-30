//
//  ZHTarget+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHTarget+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHTarget (CoreDataProperties)

+ (NSFetchRequest<ZHTarget *> *)fetchRequest;

@property (nonatomic) int32_t access_mode;
@property (nonatomic) int64_t check_sum;
@property (nullable, nonatomic, copy) NSString *fid_parent;
@property (nonatomic) int64_t history_size;
@property (nonatomic) int32_t id_module;
@property (nonatomic) BOOL is_file;
@property (nullable, nonatomic, copy) NSString *link;
@property (nonatomic) int32_t multi_editable;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *pass_md5;
@property (nullable, nonatomic, copy) NSString *password;
@property (nonatomic) int64_t size;
@property (nonatomic) int32_t sub_file_count;
@property (nonatomic) int32_t sub_folder_count;
@property (nonatomic) int32_t tag;
@property (nonatomic) int32_t type;
@property (nullable, nonatomic, copy) NSString *uid_target;
@property (nonatomic) int32_t version;
@property (nullable, nonatomic, retain) ZHForm *asFormBuddy;
@property (nullable, nonatomic, retain) NSSet<ZHTask *> *asTaskFirst;
@property (nullable, nonatomic, retain) ZHProject *belongProject;
@property (nullable, nonatomic, retain) NSSet<ZHAllow *> *hasAllows;
@property (nullable, nonatomic, retain) NSSet<ZHMessage *> *inMessages;
@property (nullable, nonatomic, retain) NSSet<ZHStep *> *inSteps;
@property (nullable, nonatomic, retain) ZHUser *owner;

@end

@interface ZHTarget (CoreDataGeneratedAccessors)

- (void)addAsTaskFirstObject:(ZHTask *)value;
- (void)removeAsTaskFirstObject:(ZHTask *)value;
- (void)addAsTaskFirst:(NSSet<ZHTask *> *)values;
- (void)removeAsTaskFirst:(NSSet<ZHTask *> *)values;

- (void)addHasAllowsObject:(ZHAllow *)value;
- (void)removeHasAllowsObject:(ZHAllow *)value;
- (void)addHasAllows:(NSSet<ZHAllow *> *)values;
- (void)removeHasAllows:(NSSet<ZHAllow *> *)values;

- (void)addInMessagesObject:(ZHMessage *)value;
- (void)removeInMessagesObject:(ZHMessage *)value;
- (void)addInMessages:(NSSet<ZHMessage *> *)values;
- (void)removeInMessages:(NSSet<ZHMessage *> *)values;

- (void)addInStepsObject:(ZHStep *)value;
- (void)removeInStepsObject:(ZHStep *)value;
- (void)addInSteps:(NSSet<ZHStep *> *)values;
- (void)removeInSteps:(NSSet<ZHStep *> *)values;

@end

NS_ASSUME_NONNULL_END
