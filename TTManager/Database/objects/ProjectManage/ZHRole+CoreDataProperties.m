//
//  ZHRole+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHRole+CoreDataProperties.h"

@implementation ZHRole (CoreDataProperties)

+ (NSFetchRequest<ZHRole *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHRole"];
}

@dynamic fid_project;
@dynamic id_role;
@dynamic info;
@dynamic is_base;
@dynamic name;
@dynamic baseRole;
@dynamic belongProject;
@dynamic extendRoles;
@dynamic hasModules;
@dynamic actUsers;

@end
