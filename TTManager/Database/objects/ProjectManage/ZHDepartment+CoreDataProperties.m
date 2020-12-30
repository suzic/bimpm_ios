//
//  ZHDepartment+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
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
