//
//  ZHDepartment+CoreDataProperties.m
//  TTManager
//
//  Created by chao liu on 2021/1/6.
//
//

#import "ZHDepartment+CoreDataProperties.h"

@implementation ZHDepartment (CoreDataProperties)

+ (NSFetchRequest<ZHDepartment *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHDepartment"];
}

@dynamic fid_project;
@dynamic id_department;
@dynamic info;
@dynamic name;
@dynamic belongProject;
@dynamic hasUsers;

@end
