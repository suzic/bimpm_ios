//
//  ZHFormItem+CoreDataProperties.m
//  TTManager
//
//  Created by chao liu on 2021/1/24.
//
//

#import "ZHFormItem+CoreDataProperties.h"

@implementation ZHFormItem (CoreDataProperties)

+ (NSFetchRequest<ZHFormItem *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHFormItem"];
}

@dynamic d_name;
@dynamic enum_pool;
@dynamic ident;
@dynamic instance_value;
@dynamic length_max;
@dynamic length_min;
@dynamic name;
@dynamic not_null;
@dynamic order_index;
@dynamic type;
@dynamic uid_item;
@dynamic unique;
@dynamic unit_char;
@dynamic belongForm;

@end
