//
//  ZHForm+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHForm+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHForm (CoreDataProperties)

+ (NSFetchRequest<ZHForm *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *buddy_file;
@property (nullable, nonatomic, copy) NSString *instance_ident;
@property (nullable, nonatomic, copy) NSString *instance_name;
@property (nullable, nonatomic, copy) NSString *instance_set;
@property (nullable, nonatomic, copy) NSString *key_pattern;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *uid_form;
@property (nullable, nonatomic, copy) NSString *uid_ident;
@property (nullable, nonatomic, copy) NSString *unique_check;
@property (nullable, nonatomic, copy) NSDate *update_date;
@property (nullable, nonatomic, copy) NSString *update_user;
@property (nullable, nonatomic, copy) NSString *url_alarm;
@property (nullable, nonatomic, copy) NSString *url_info;
@property (nullable, nonatomic, retain) ZHProject *belongProject;
@property (nullable, nonatomic, retain) ZHTarget *buddyFile;
@property (nullable, nonatomic, retain) NSSet<ZHFormItem *> *hasItems;
@property (nullable, nonatomic, retain) ZHUser *lastEditor;

@end

@interface ZHForm (CoreDataGeneratedAccessors)

- (void)addHasItemsObject:(ZHFormItem *)value;
- (void)removeHasItemsObject:(ZHFormItem *)value;
- (void)addHasItems:(NSSet<ZHFormItem *> *)values;
- (void)removeHasItems:(NSSet<ZHFormItem *> *)values;

@end

NS_ASSUME_NONNULL_END
