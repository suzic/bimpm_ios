//
//  ZHModule+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHModule+CoreDataProperties.h"

@implementation ZHModule (CoreDataProperties)

+ (NSFetchRequest<ZHModule *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHModule"];
}

@dynamic id_module;
@dynamic is_public;
@dynamic name;
@dynamic online;
@dynamic operation;
@dynamic order_index;
@dynamic route;
@dynamic belongRoles;

@end
