//
//  ZHFormItem+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
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
@dynamic belongForm;

@end
