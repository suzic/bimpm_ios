//
//  ZHDepartmentUser+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHDepartmentUser+CoreDataProperties.h"

@implementation ZHDepartmentUser (CoreDataProperties)

+ (NSFetchRequest<ZHDepartmentUser *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHDepartmentUser"];
}

@dynamic is_leader;
@dynamic order_index;
@dynamic assignUser;
@dynamic belongDepartment;

@end
