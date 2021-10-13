//
//  ZHProject+CoreDataProperties.m
//  TTManager
//
//  Created by chao liu on 2021/10/13.
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
@dynamic time_check_in;
@dynamic time_check_out;
@dynamic assignMemo;
@dynamic hasDepartments;
@dynamic hasFlows;
@dynamic hasForms;
@dynamic hasRoles;
@dynamic hasTargets;
@dynamic hasUsers;
@dynamic messages;

@end
