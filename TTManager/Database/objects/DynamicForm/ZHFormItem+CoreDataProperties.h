//
//  ZHFormItem+CoreDataProperties.h
//  TTManager
//
//  Created by chao liu on 2021/1/24.
//
//

#import "ZHFormItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHFormItem (CoreDataProperties)

+ (NSFetchRequest<ZHFormItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *d_name;
@property (nullable, nonatomic, copy) NSString *enum_pool;
@property (nullable, nonatomic, copy) NSString *ident;
@property (nullable, nonatomic, copy) NSString *instance_value;
@property (nonatomic) int32_t length_max;
@property (nonatomic) int32_t length_min;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) BOOL not_null;
@property (nonatomic) int32_t order_index;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *uid_item;
@property (nonatomic) BOOL unique;
@property (nullable, nonatomic, copy) NSString *unit_char;
@property (nullable, nonatomic, retain) ZHForm *belongForm;

@end

NS_ASSUME_NONNULL_END
