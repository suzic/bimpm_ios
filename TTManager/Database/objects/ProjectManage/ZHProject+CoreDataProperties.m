//
//  ZHProject+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHProject+CoreDataProperties.h"

@implementation ZHProject (CoreDataProperties)

+ (NSFetchRequest<ZHProject *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHProject"];
}

@dynamic actual_storage;
@dynamic address;
@dynamic build_date;
@dynamic company;
@dynamic current_manager;
@dynamic current_storage;
@dynamic enable_date;
@dynamic fid_parent;
@dynamic id_project;
@dynamic info;
@dynamic is_pattern;
@dynamic kind;
@dynamic kind_name;
@dynamic level;
@dynamic location_lat;
@dynamic location_long;
@dynamic name;
@dynamic progress;
@dynamic snap_image;
@dynamic total_storage;
@dynamic assignMemo;
@dynamic hasDepartments;
@dynamic hasFlows;
@dynamic hasForms;
@dynamic hasRoles;
@dynamic hasTargets;
@dynamic hasUsers;
@dynamic messages;

@end
