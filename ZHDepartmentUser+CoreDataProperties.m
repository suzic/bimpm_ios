//
//  ZHDepartmentUser+CoreDataProperties.m
//  TTManager
//
//  Created by chao liu on 2021/1/6.
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
@dynamic assignDepartment;
@dynamic belongUserProject;

@end
